// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @title ERC20 (Solmate-style) with EIP-2612 Permit
/// @author Solmate (base) + Uniswap (inspiration) + your friendly annotator
/// @notice Modern and gas-efficient ERC20 that supports gasless approvals (`permit`).
/// @dev Do not set balances manually without updating totalSupply. Balances must sum to totalSupply.
///
/// 🧭 Big Picture Analogy:
/// Think of this contract as a **bank core**:
/// - Accounts (addresses) hold balances (their cash drawers).
/// - Transfers move cash between drawers.
/// - Approvals are **debit-card limits** letting a spender draw from your drawer.
/// - `permit` is a **signed letter** you write at home (off-chain) to set that card limit
///   without visiting the bank (no on-chain `approve` tx from you).
abstract contract ERC20 {
    /**
     * @notice Emitted when tokens move from `from` to `to`.
     * @param from Debited account (zero for mint).
     * @param to Credited account (zero for burn).
     * @param amount Amount transferred.
     *
     * 📣 Analogy: A loudspeaker announcement — “X coins moved from A to B.”
     */
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /**
     * @notice Emitted when `owner` sets `spender`’s allowance to `amount`.
     * @param owner The account granting permission.
     * @param spender The account allowed to spend.
     * @param amount The card limit set.
     *
     * 🧾 Analogy: A public notice on the bank board — “Owner set Spender’s card limit to N.”
     */
    event Approval(
        address indexed owner, address indexed spender, uint256 amount
    );

    /// @notice Token name (branding on the bank sign).
    string public name;

    /// @notice Token symbol (ticker printed on receipts).
    string public symbol;

    /// @notice Smallest unit precision (like “cents” per dollar).
    /// @dev Immutable to save gas — set once at construction.
    uint8 public immutable decimals;

    /// @notice Total tokens currently in circulation (printed money).
    uint256 public totalSupply;

    /// @notice Per-account balances (each drawer’s cash).
    mapping(address => uint256) public balanceOf;

    /// @notice Per-owner → spender card limits (allowances).
    mapping(address => mapping(address => uint256)) public allowance;

    /// @dev EIP-712 domain versioning: pin initial chain id & domain separator to prevent replay.
    uint256 internal immutable INITIAL_CHAIN_ID;
    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;

    /// @notice Per-owner nonce used by `permit` to prevent signature replay.
    /// @dev Increments on every successful `permit` for that owner.
    mapping(address => uint256) public nonces;

    /**
     * @notice Initialize token identity and EIP-712 domain.
     * @param _name Token name.
     * @param _symbol Token symbol.
     * @param _decimals Token decimals (e.g., 18).
     *
     * 🏗️ Analogy:
     * The bank opens its doors, puts up its sign (name/symbol), declares its denomination (decimals),
     * and notarizes its identity with a **domain seal** (EIP-712 domain separator).
     */
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        INITIAL_CHAIN_ID = block.chainid;
        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
    }

    /**
     * @notice Approve `spender` to spend up to `amount` from caller’s balance.
     * @param spender The address allowed to spend.
     * @param amount The maximum amount they can draw.
     * @return success Always true if it didn’t revert.
     *
     * 🖊️ Analogy: Setting a **debit-card limit** for someone on your account.
     */
    function approve(address spender, uint256 amount)
        public
        virtual
        returns (bool success)
    {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Transfer `amount` tokens from caller to `to`.
     * @param to Recipient address.
     * @param amount Amount to send.
     * @return success Always true if it didn’t revert.
     *
     * 🤝 Analogy: Handing cash directly to another person — your drawer goes down, theirs goes up.
     */
    function transfer(address to, uint256 amount)
        public
        virtual
        returns (bool success)
    {
        // Solidity 0.8+: underflow reverts automatically if insufficient funds.
        balanceOf[msg.sender] -= amount;

        unchecked {
            // Gas save: addition can’t overflow since total tokens are tracked by totalSupply.
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @notice Transfer `amount` tokens from `from` to `to`, using caller’s allowance.
     * @param from The account to debit.
     * @param to The account to credit.
     * @param amount Amount to transfer.
     * @return success Always true if it didn’t revert.
     *
     * 🔄 Analogy:
     * Paying a merchant with a **debit card**:
     * - The bank reduces the card limit (unless it’s “infinite”),
     * - Debits the owner’s drawer,
     * - Credits the recipient’s drawer.
     */
    function transferFrom(address from, address to, uint256 amount)
        public
        virtual
        returns (bool success)
    {
        uint256 allowed = allowance[from][msg.sender]; // gas-saving cache

        // If not infinite approval, decrease allowance by `amount`.
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
        }

        // Will revert on insufficient balance.
        balanceOf[from] -= amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);
        return true;
    }

    /**
     * @notice EIP-2612 gasless approval by signature.
     * @param owner Token owner granting the allowance.
     * @param spender Allowed spender.
     * @param value Allowance to set.
     * @param deadline Last valid timestamp for this signed approval.
     * @param v Signature recovery id.
     * @param r Signature parameter r.
     * @param s Signature parameter s.
     *
     * 📨 Analogy:
     * A **signed letter** from the owner:
     * - Dated (deadline),
     * - Numbered (nonce),
     * - Bearing the bank’s notary seal (domain separator).
     * The bank verifies the handwriting and updates the card limit — no in-person visit needed.
     *
     * 🛡️ Security:
     * - Checks `deadline` (no expired letters),
     * - Consumes and increments `nonces[owner]` (no replay),
     * - Binds to chain & contract via `DOMAIN_SEPARATOR()` (no cross-domain reuse).
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");

        unchecked {
            // EIP-712 typed data hash for Permit(owner,spender,value,nonce,deadline).
            address recoveredAddress = ecrecover(
                keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        DOMAIN_SEPARATOR(),
                        keccak256(
                            abi.encode(
                                keccak256(
                                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                                ),
                                owner,
                                spender,
                                value,
                                nonces[owner]++, // consume & increment
                                deadline
                            )
                        )
                    )
                ),
                v, r, s
            );

            require(
                recoveredAddress != address(0) && recoveredAddress == owner,
                "INVALID_SIGNER"
            );

            allowance[recoveredAddress][spender] = value;
        }

        emit Approval(owner, spender, value);
    }

    /**
     * @notice Current EIP-712 domain separator for this contract on this chain.
     * @return domainSeparator The domain separator bytes32.
     *
     * 🪪 Analogy:
     * The bank’s **notary seal** — ties signatures to a specific chain & branch.
     * If the chain changes, the seal updates.
     */
    function DOMAIN_SEPARATOR() public view virtual returns (bytes32 domainSeparator) {
        return block.chainid == INITIAL_CHAIN_ID
            ? INITIAL_DOMAIN_SEPARATOR
            : computeDomainSeparator();
    }

    /**
     * @notice Compute the domain separator with current chain id & this address.
     * @return separator The computed EIP-712 domain separator.
     *
     * 🧰 Analogy: Printing a fresh notary stamp that encodes
     * name, version “1”, chain id, and the verifying contract address.
     */
    function computeDomainSeparator() internal view virtual returns (bytes32 separator) {
        return keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name)),
                keccak256("1"),
                block.chainid,
                address(this)
            )
        );
    }

    /**
     * @notice Create `amount` new tokens and assign to `to`.
     * @param to Recipient of the newly minted tokens.
     * @param amount Amount to mint.
     *
     * 🖨️ Analogy: Printing new money and depositing it into an account.
     * Emits `Transfer(0 → to, amount)` as the mint log.
     */
    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    /**
     * @notice Destroy `amount` tokens from `from`.
     * @param from Account to debit and burn from.
     * @param amount Amount to burn.
     *
     * 🔥 Analogy: Shredding money from a drawer and reducing total supply.
     * Emits `Transfer(from → 0, amount)` as the burn log.
     */
    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

/**
 * @title ERC20Permit (Concrete)
 * @notice Thin wrapper exposing a public `mint` over the abstract ERC20 base.
 *
 * 🧪 Analogy:
 * A small public branch that lets anyone press the **print** button (demo only).
 * In production, protect `mint` with access control!
 */
contract ERC20Permit is ERC20 {
    /**
     * @notice Initialize the token with name/symbol/decimals.
     */
    constructor(string memory _name, string memory _symbol, uint8 _decimals)
        ERC20(_name, _symbol, _decimals)
    {}

    /**
     * @notice Mint `amount` tokens to `to`. (Demo: no access control)
     * @param to Recipient address.
     * @param amount Amount to mint.
     *
     * 🚨 Production Tip:
     * Restrict this with Ownable/AccessControl in real deployments.
     */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
