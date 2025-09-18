// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ECDSA.sol";

/**
 * @title ReentrancyGuard
 * @notice Lightweight mutex to prevent re-entrant calls.
 * @dev
 * 🚪 Real-World Analogy:
 * A single-occupancy restroom with an **occupied sign**.
 * - Before entering (running the function), you flip the sign to **occupied**.
 * - After leaving, you flip it back to **vacant**.
 * - Anyone trying to barge in while it's occupied is rejected.
 */
contract ReentrancyGuard {
    /// @dev Internal latch; true while a guarded function is executing.
    bool private locked;

    /**
     * @dev Protect a function from re-entrancy.
     *      Reverts if already inside a `guard`-protected call.
     *
     * 🧩 Analogy:
     * - Check the **occupied sign** (must be off),
     * - Turn it **on** while you're inside,
     * - Turn it **off** when you exit.
     */
    modifier guard() {
        require(!locked, "REENTRANCY");
        locked = true;
        _;
        locked = false;
    }
}

/**
 * @title UniDirectionalPaymentChannel
 * @notice One-shot, unidirectional payment channel funded by `sender` and redeemable by `receiver` using an ECDSA signature.
 * @dev
 * 🧭 Real-World Analogy:
 * A **prepaid voucher**:
 * - The buyer (`sender`) loads money into a voucher that expires in 7 days.
 * - The recipient (`receiver`) can **redeem once** with a signed chit from the buyer.
 * - On redemption, the recipient is paid and the voucher is shredded (contract self-destructs).
 * - If unused by the deadline, the buyer can reclaim remaining funds and shred the voucher.
 *
 * 🔐 Security Highlights:
 * - Includes the **contract address** in the signed hash to prevent **replay** in other channels.
 * - Uses `toEthSignedMessageHash()` so wallet-signed messages verify correctly.
 * - Guarded by a simple **reentrancy lock** during payout + self-destruct.
 */
contract UniDirectionalPaymentChannel is ReentrancyGuard {
    using ECDSA for bytes32;

    /// @notice The funder who opened the channel and whose signature authorizes payouts.
    address payable public sender;

    /// @notice The designated recipient who can redeem with a valid signature.
    address payable public receiver;

    /// @notice Fixed channel duration (7 days).
    uint256 private constant DURATION = 7 * 24 * 60 * 60;

    /// @notice UNIX timestamp when the channel expires and can be canceled by the sender.
    uint256 public expiresAt;

    /**
     * @notice Open a channel for `_receiver` and start the 7-day timer.
     * @dev Payable: ETH sent funds the channel.
     *
     * 🧾 Analogy:
     * The buyer prepays a **voucher** addressed to `_receiver`, valid for **7 days**.
     * The amount of ETH sent here is the **balance** of that voucher.
     *
     * @param _receiver The address allowed to redeem this channel.
     */
    constructor(address payable _receiver) payable {
        require(_receiver != address(0), "receiver = zero address");
        sender = payable(msg.sender);
        receiver = _receiver;
        expiresAt = block.timestamp + DURATION;
    }

    /**
     * @dev Build the raw message hash bound to this channel and the `_amount`.
     *
     * 🧠 Analogy:
     * A **chit** that reads: “Voucher #<this contract> promises up to `<amount>`.”
     * Binding the contract address prevents using the same chit at a different kiosk.
     *
     * @param _amount Amount the receiver will claim.
     * @return The keccak256 hash of (this contract address, amount).
     */
    function _getHash(uint256 _amount) private view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), _amount));
    }

    /**
     * @notice Public helper: get the raw hash for `_amount` (pre-prefix).
     * @param _amount Amount to be signed.
     * @return Raw hash (without the Ethereum signed message prefix).
     */
    function getHash(uint256 _amount) external view returns (bytes32) {
        return _getHash(_amount);
    }

    /**
     * @dev Wrap the raw hash with the standard Ethereum prefix.
     *
     * 📜 Analogy:
     * Print the chit on **official letterhead** so wallets know what they’re signing.
     *
     * @param _amount Amount being authorized.
     * @return Prefixed hash used for ECDSA signing and recovery.
     */
    function _getEthSignedHash(uint256 _amount)
        private
        view
        returns (bytes32)
    {
        return _getHash(_amount).toEthSignedMessageHash();
    }

    /**
     * @notice Public helper: get the prefixed (wallet-ready) hash for `_amount`.
     * @param _amount Amount to be signed.
     * @return Ethereum signed message hash.
     */
    function getEthSignedHash(uint256 _amount)
        external
        view
        returns (bytes32)
    {
        return _getEthSignedHash(_amount);
    }

    /**
     * @dev Verify that `_sig` is a valid signature by `sender` over `_amount`.
     *
     * 🕵️ Analogy:
     * Use a **signature detective kit** to confirm the handwriting matches the buyer.
     *
     * @param _amount Claimed amount.
     * @param _sig Signature produced by `sender` over the prefixed hash.
     * @return True if the recovered signer equals `sender`.
     */
    function _verify(uint256 _amount, bytes memory _sig)
        private
        view
        returns (bool)
    {
        return _getEthSignedHash(_amount).recover(_sig) == sender;
    }

    /**
     * @notice Public helper to check a signature off-chain / from UIs.
     * @param _amount Claimed amount.
     * @param _sig Signature bytes.
     * @return True if valid and signed by `sender`.
     */
    function verify(uint256 _amount, bytes memory _sig)
        external
        view
        returns (bool)
    {
        return _verify(_amount, _sig);
    }

    /**
     * @notice Receiver redeems the channel with a valid signature for `_amount`.
     * @dev
     * Flow:
     * 1) Ensure caller is the designated `receiver`.
     * 2) Verify the signature was produced by `sender` for this channel and `_amount`.
     * 3) Pay `_amount` to `receiver`.
     * 4) `selfdestruct(sender)` — refund any remainder to `sender` and close forever.
     *
     * 🔒 Reentrancy:
     * Protected by {guard}: while paying and self-destructing, no re-entrance is allowed.
     *
     * 🧾 Analogy:
     * The recipient presents the **largest signed chit**.
     * The cashier pays that amount, then **shreds the voucher**, returning leftover change to the buyer.
     *
     * @param _amount The amount authorized by the sender’s signature.
     * @param _sig The ECDSA signature from the sender.
     */
    function close(uint256 _amount, bytes memory _sig) external guard {
        require(msg.sender == receiver, "!receiver");
        require(_verify(_amount, _sig), "invalid sig");

        (bool sent, ) = receiver.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        // Destroy the channel and send any leftover funds back to the sender.
        selfdestruct(sender);
    }

    /**
     * @notice Sender cancels the channel after expiry and recovers remaining funds.
     * @dev Reverts if called before `expiresAt` or by a non-sender.
     *
     * 🕰️ Analogy:
     * If the recipient never redeems before the deadline, the buyer reclaims the voucher’s balance
     * and the voucher is **shredded**.
     */
    function cancel() external {
        require(msg.sender == sender, "!sender");
        require(block.timestamp >= expiresAt, "!expired");
        selfdestruct(sender);
    }
}
