// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ECDSA.sol";

/**
 * @title BiDirectionalPaymentChannel
 * @notice Two-party payment channel with off-chain co-signed states, on-chain challenge, and timed exit.
 * @dev
 * 🧭 Real-World Analogy:
 * Imagine a **shared bar tab** for two people (users[0], users[1]).
 * - They keep writing **new receipts** (off-chain balances) and both **sign** each one.
 * - If they disagree, either can bring the **latest co-signed receipt** to the cashier (contract) and start a **last-call timer** (challenge window).
 * - If no newer receipt arrives before the bell, each person **withdraws** their final share.
 *
 * 🔐 Safety Highlights:
 * - Each receipt is bound to **this contract address** to prevent replay elsewhere.
 * - **Nonce** strictly increases so only newer receipts supersede older ones.
 * - **Challenge period** resets on each valid update to give fair time to respond.
 * - Contract balance must always cover users’ declared balances.
 */
contract BiDirectionalPaymentChannel {
    using ECDSA for bytes32;

    /// @notice Emitted when a user submits a newer co-signed state and resets the challenge timer.
    /// @param sender The user who submitted the challenge.
    /// @param nonce  The state version now considered latest on-chain.
    event ChallengeExit(address indexed sender, uint256 nonce);

    /// @notice Emitted when a user withdraws their final share after the challenge period expires.
    /// @param to     The withdrawing user.
    /// @param amount The amount withdrawn.
    event Withdraw(address indexed to, uint256 amount);

    /// @notice The two channel participants.
    address payable[2] public users;

    /// @notice Quick membership map: true if an address is one of the two users.
    mapping(address => bool) public isUser;

    /// @notice Current agreed split for each user (as of the latest accepted state).
    mapping(address => uint256) public balances;

    /// @notice Length of the dispute window (seconds) that must pass without a newer state.
    uint256 public challengePeriod;

    /// @notice UNIX timestamp after which withdrawals are allowed (no newer state arrived in time).
    uint256 public expiresAt;

    /// @notice The version number of the latest accepted (co-signed) state.
    uint256 public nonce;

    /**
     * @dev Ensure the contract holds at least the sum of proposed balances.
     * 🧮 Analogy: The **cash box** must be able to cover the full receipt.
     * @param _balances The proposed per-user balances (length 2).
     */
    modifier checkBalances(uint256[2] memory _balances) {
        require(
            address(this).balance >= _balances[0] + _balances[1],
            "balance of contract must be >= to the total balance of users"
        );
        _;
    }

    /**
     * @notice Create the channel with initial participants, balances, expiration, and challenge window.
     * @dev
     * - Must be funded (typically by a multisig) so the cash box ≥ sum(balances).
     * - `_expiresAt` sets the initial “last call”; later updates will reset to `now + challengePeriod`.
     *
     * 🧾 Analogy:
     * Open a **joint tab** for two named people with an initial **co-signed receipt** and a **deadline**.
     *
     * @param _users           The two channel participants (must be unique, non-zero).
     * @param _balances        Initial per-user balances (must sum ≤ msg.value).
     * @param _expiresAt       Initial expiry timestamp (must be in the future).
     * @param _challengePeriod Challenge window length in seconds (> 0).
     */
    constructor(
        address payable[2] memory _users,
        uint256[2] memory _balances,
        uint256 _expiresAt,
        uint256 _challengePeriod
    ) payable checkBalances(_balances) {
        require(_expiresAt > block.timestamp, "Expiration must be > now");
        require(_challengePeriod > 0, "Challenge period must be > 0");

        for (uint256 i = 0; i < _users.length; i++) {
            address payable user = _users[i];
            require(user != address(0), "user = zero address");
            require(!isUser[user], "user must be unique");
            users[i] = user;
            isUser[user] = true;
            balances[user] = _balances[i];
        }

        expiresAt = _expiresAt;
        challengePeriod = _challengePeriod;
    }

    /**
     * @notice Verify that both signatures approve the same state (contract, balances, nonce).
     * @dev
     * - Message preimage: `keccak256(abi.encodePacked(_contract, _balances, _nonce))`
     * - Prefixed with `toEthSignedMessageHash()` and recovered must match `_signers[i]`.
     *
     * 🕵️ Analogy:
     * The cashier checks that **both diners** signed the **same receipt** for this **specific venue** (contract).
     *
     * @param _signatures Two signatures (one from each signer).
     * @param _contract   The address of the payment channel contract to bind signatures to.
     * @param _signers    The expected signers (must match channel users).
     * @param _balances   Proposed balances for the two users.
     * @param _nonce      Proposed state version (must be ≥ current, strictly greater when updating).
     * @return True if both signatures are valid for the given state.
     */
    function verify(
        bytes[2] memory _signatures,
        address _contract,
        address[2] memory _signers,
        uint256[2] memory _balances,
        uint256 _nonce
    ) public pure returns (bool) {
        for (uint256 i = 0; i < _signatures.length; i++) {
            // Bind signatures to this exact contract to prevent cross-contract replay.
            bool valid = _signers[i]
                == keccak256(abi.encodePacked(_contract, _balances, _nonce))
                    .toEthSignedMessageHash().recover(_signatures[i]);
            if (!valid) return false;
        }
        return true;
    }

    /**
     * @dev Require that provided signatures match the channel users and proposed state.
     * 🧾 Analogy: Before pinning a new receipt, the cashier confirms both signatures are real and consistent.
     * @param _signatures Two ECDSA signatures.
     * @param _balances   Proposed per-user balances.
     * @param _nonce      Proposed state version.
     */
    modifier checkSignatures(
        bytes[2] memory _signatures,
        uint256[2] memory _balances,
        uint256 _nonce
    ) {
        // Copy storage users into memory to pass as expected signers.
        address[2] memory signers;
        for (uint256 i = 0; i < users.length; i++) {
            signers[i] = users[i];
        }
        require(
            verify(_signatures, address(this), signers, _balances, _nonce),
            "Invalid signature"
        );
        _;
    }

    /**
     * @dev Restrict function to channel participants only.
     * 🚪 Analogy: Only the two names on the tab can update or withdraw.
     */
    modifier onlyUser() {
        require(isUser[msg.sender], "Not user");
        _;
    }

    /**
     * @notice Submit a newer co-signed state and reset the challenge timer.
     * @dev
     * Requirements:
     * - Caller must be a user.
     * - Both signatures must validate for the provided `(balances, nonce)`.
     * - Contract balance must cover the sum of balances.
     * - Must be called **before** current `expiresAt`.
     * - `_nonce` must be **strictly greater** than the current `nonce`.
     *
     * 🛎️ Analogy:
     * A diner brings a **newer receipt**; the cashier **resets last call** to `now + challengePeriod`
     * so the other diner can respond with an even newer one if needed.
     *
     * @param _balances   Proposed per-user balances (length 2).
     * @param _nonce      Newer state version number.
     * @param _signatures Two signatures (one from each user) over the proposed state.
     */
    function challengeExit(
        uint256[2] memory _balances,
        uint256 _nonce,
        bytes[2] memory _signatures
    )
        public
        onlyUser
        checkSignatures(_signatures, _balances, _nonce)
        checkBalances(_balances)
    {
        require(block.timestamp < expiresAt, "Expired challenge period");
        require(_nonce > nonce, "Nonce must be greater than the current nonce");

        // Update balances per the latest agreed state.
        for (uint256 i = 0; i < _balances.length; i++) {
            balances[users[i]] = _balances[i];
        }

        // Record the newest version and reset the timer.
        nonce = _nonce;
        expiresAt = block.timestamp + challengePeriod;

        emit ChallengeExit(msg.sender, nonce);
    }

    /**
     * @notice Withdraw your final share after the challenge period has elapsed with no newer state.
     * @dev
     * - Only channel users can withdraw.
     * - Each user withdraws their own share; balance is zeroed to prevent double-withdraw.
     *
     * 💰 Analogy:
     * After the bell rings and no newer receipt arrived, each diner collects their share from the cashier.
     */
    function withdraw() public onlyUser {
        require(
            block.timestamp >= expiresAt,
            "Challenge period has not expired yet"
        );

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        emit Withdraw(msg.sender, amount);
    }
}
