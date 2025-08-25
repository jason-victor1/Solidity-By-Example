// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IERC20.sol";

/**
 * @title ERC20
 * @dev A minimal ERC-20 token implementation that follows the IERC20 rulebook:
 *      balances, allowances, direct transfers, delegated transfers, minting, and burning.
 *
 * 🧭 Big Picture Analogy:
 * Think of this contract as a **bank branch** for your token:
 *  - Accounts = addresses with balances,
 *  - Transfers = handing cash between customers,
 *  - Approvals = giving someone a debit-card limit on your account,
 *  - transferFrom = that person spending from your account using the approved limit,
 *  - Mint/Burn = the central bank printing or shredding notes.
 */
contract ERC20 is IERC20 {
    /**
     * @notice Emitted when tokens move from one account to another.
     * @dev Required by the ERC-20 spec. Use to track money flows off-chain.
     * @param from The account debited.
     * @param to The account credited.
     * @param value The amount transferred.
     *
     * 📣 Analogy: A loudspeaker announcement: “X coins moved from Alice to Bob.”
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @notice Emitted when an account sets a spending allowance for a spender.
     * @dev Required by the ERC-20 spec. Wallets/exchanges listen to this to know limits.
     * @param owner The account granting the allowance.
     * @param spender The account receiving the spending permission.
     * @param value The maximum amount the spender may spend.
     *
     * 🧾 Analogy: A posted notice: “Alice authorizes Bob to spend up to N coins.”
     */
    event Approval(
        address indexed owner, address indexed spender, uint256 value
    );

    /// @notice Total tokens in circulation.
    /// @dev Increases on mint; decreases on burn.
    /// 🧮 Analogy: Central ledger’s “total printed money”.
    uint256 public totalSupply;

    /// @notice Balance of each account.
    /// @dev Mapping: account → coins.
    /// 👛 Analogy: Each customer’s current bank balance.
    mapping(address => uint256) public balanceOf;

    /// @notice Allowances from owners to spenders.
    /// @dev Mapping: owner → (spender → remaining limit).
    /// 💳 Analogy: Debit-card limits set by account owners for designated spenders.
    mapping(address => mapping(address => uint256)) public allowance;

    /// @notice Friendly token name (e.g., "MyToken").
    /// 🏷️ Analogy: The bank’s brand name on the sign.
    string public name;

    /// @notice Token symbol (e.g., "MTK").
    /// 🪪 Analogy: The ticker printed on receipts.
    string public symbol;

    /// @notice Number of decimals the token uses (usually 18).
    /// 🔢 Analogy: How many “cents” each coin can split into.
    uint8 public decimals;

    /**
     * @notice Set immutable metadata for the token.
     * @param _name Token name.
     * @param _symbol Token symbol.
     * @param _decimals Token decimals.
     *
     * 🏗️ Analogy: When the bank branch opens, it puts up its sign (name & symbol)
     * and declares how fine-grained its currency is (decimals).
     */
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    /**
     * @notice Transfer tokens from the caller to `recipient`.
     * @dev Reverts on insufficient balance (Solidity 0.8+ checks underflow).
     * @param recipient The address to credit.
     * @param amount The amount to send.
     * @return success Always true if it didn’t revert.
     *
     * 🤝 Analogy: You hand cash directly to Bob; the teller subtracts from you and adds to Bob.
     * The loudspeaker announces the transfer.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        balanceOf[msg.sender] -= amount;     // 💥 Reverts if not enough balance.
        balanceOf[recipient]   += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @notice Set `spender`’s allowance to `amount` from the caller’s balance.
     * @dev Overwrites any previous allowance value.
     * @param spender The address allowed to spend.
     * @param amount The new allowance.
     * @return success True on success.
     *
     * 🖊️ Analogy: Alice tells the bank: “I authorize Bob to spend up to N coins from my account.”
     *
     * ⚠️ Common Gotcha:
     * The classic ERC-20 “approval race” pattern suggests setting allowance to 0 before setting a new value,
     * to avoid unexpected double-spend scenarios in certain off-chain flows.
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount; // ✍️ Set/replace the card limit.
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Transfer tokens from `sender` to `recipient` using caller’s allowance.
     * @dev Deducts from allowance and sender’s balance. Reverts on insufficient allowance/balance.
     * @param sender The account whose coins are moved.
     * @param recipient The account to receive coins.
     * @param amount The amount to move.
     * @return success True on success.
     *
     * 🔄 Analogy: Bob uses Alice’s approved debit card to pay Carol.
     * The bank reduces Alice’s balance and lowers Bob’s remaining card limit.
     */
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool)
    {
        allowance[sender][msg.sender] -= amount; // 💥 Reverts if limit insufficient.
        balanceOf[sender]             -= amount; // 💥 Reverts if balance insufficient.
        balanceOf[recipient]          += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @notice Create new tokens and assign them to `to`.
     * @dev Internal; use `mint` externally to expose it. Increases totalSupply.
     * @param to Recipient of freshly minted tokens.
     * @param amount Amount to mint.
     *
     * 🖨️ Analogy: Central bank prints new notes and deposits them into an account.
     * The loudspeaker announces a transfer from “the void” (address(0)) to `to`.
     */
    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply   += amount;
        emit Transfer(address(0), to, amount);
    }

    /**
     * @notice Destroy tokens from `from`.
     * @dev Internal; use `burn` externally to expose it. Decreases totalSupply.
     * @param from Account to burn from.
     * @param amount Amount to burn.
     *
     * 🔥 Analogy: Notes are shredded; supply shrinks. Announcement says money went to the void.
     */
    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount; // 💥 Reverts if balance insufficient.
        totalSupply     -= amount;
        emit Transfer(from, address(0), amount);
    }

    /**
     * @notice Public minting entry point (no access control in this demo).
     * @dev Calls internal `_mint`.
     * @param to Recipient of minted tokens.
     * @param amount Amount to mint.
     *
     * 🚨 Analogy: Anyone pressing the print button! (Demo only.)
     * In production, protect this with access control (e.g., onlyOwner).
     */
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /**
     * @notice Public burning entry point (no access control in this demo).
     * @dev Calls internal `_burn`.
     * @param from Account to burn from.
     * @param amount Amount to burn.
     *
     * 🧯 Analogy: Anyone shredding notes from anyone’s account! (Demo only.)
     * In production, restrict who can burn and from which accounts.
     */
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * State:
 * - `totalSupply` 🧮 total printed money
 * - `balanceOf[acct]` 👛 account balance
 * - `allowance[owner][spender]` 💳 remaining debit-card limit
 *
 * Flows:
 * - `transfer(to, amt)` 🤝 self-pay: your balance ↓, recipient ↑
 * - `approve(spender, amt)` 🖊️ set spender’s limit on your account
 * - `transferFrom(owner, to, amt)` 🔄 spender pays from owner using allowance
 * - `mint(to, amt)` 🖨️ print money → supply ↑, to ↑
 * - `burn(from, amt)` 🔥 shred money → supply ↓, from ↓
 *
 * Events:
 * - `Transfer(from, to, value)` 📣 movement log (includes mint/burn via address(0))
 * - `Approval(owner, spender, value)` 🧾 allowance log
 *
 * ⚙️ Production Notes:
 * - Add access control to `mint`/`burn`.
 * - Consider safe allowance patterns (set to 0 before non-zero).
 * - This minimal demo relies on Solidity 0.8+ checked arithmetic to revert on under/overflow.
 */
