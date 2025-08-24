// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title IERC20 (Interface)
 * @dev ERC-20 Token Standard interface — a universal rulebook for fungible tokens.
 *
 * 🧭 Big Picture Analogy:
 * Think of ERC-20 like a **banking protocol** all wallets and exchanges agree on.
 * If your token follows this rulebook, any wallet/exchange knows how to:
 *  - Check balances (like asking the bank teller),
 *  - Send coins (like handing cash),
 *  - Set spending permissions (like a debit card limit),
 *  - Spend on someone’s behalf (like auto-billing with a preset limit).
 *
 * 📘 Note:
 * This is an *interface* — a blueprint only. No storage, no implementation, just the
 * function signatures everyone must implement so the ecosystem speaks the same language.
 */
interface IERC20 {
    /**
     * @notice Total number of tokens in existence.
     * @dev Read-only; does not modify state.
     * @return The total minted supply currently in circulation.
     *
     * 🏦 Analogy: The mint’s ledger telling you how many coins exist overall.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice Token balance of a specific account.
     * @dev Read-only; does not modify state.
     * @param account The wallet address to query.
     * @return The amount of tokens held by `account`.
     *
     * 👛 Analogy: Asking the bank teller, “How many coins are in Alice’s account?”
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @notice Transfer tokens from caller to another address.
     * @dev Implementations typically revert on failure and return true on success.
     * @param recipient The address to receive tokens.
     * @param amount The number of tokens to send.
     * @return success True if the transfer succeeds.
     *
     * 🤝 Analogy: Handing cash directly to Bob from your own wallet.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @notice Remaining number of tokens that `spender` is allowed to spend on behalf of `owner`.
     * @dev Read-only; reflects the current allowance set via {approve}.
     * @param owner The token holder who granted permission.
     * @param spender The authorized spender.
     * @return remaining The unspent portion of the allowance.
     *
     * 💳 Analogy: Checking the **card limit** Bob can charge on Alice’s account.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @notice Approve `spender` to spend up to `amount` from caller’s balance.
     * @dev Common pattern: set to 0 before setting a new non-zero amount to mitigate race conditions.
     * @param spender The address allowed to spend on caller’s behalf.
     * @param amount The maximum tokens `spender` can spend.
     * @return success True if approval is recorded.
     *
     * 🖊️ Analogy: Alice signs a form at the bank: “I authorize Bob to spend up to 100 coins.”
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @notice Transfer tokens from `sender` to `recipient` using `spender`’s allowance.
     * @dev Decreases the allowance of `sender` → `msg.sender` by `amount` upon success.
     * @param sender The token owner whose balance will be debited.
     * @param recipient The address receiving the tokens.
     * @param amount The number of tokens to move.
     * @return success True if the transfer succeeds.
     *
     * 🔄 Analogy: Bob uses Alice’s pre-approved card to pay Carol; the system
     * deducts from Alice’s account and lowers Bob’s remaining card limit.
     */
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * - `totalSupply()` → 🏦 How many coins exist in total.
 * - `balanceOf(account)` → 👛 How many coins an account holds.
 * - `transfer(to, amount)` → 🤝 Send your coins directly to someone.
 * - `allowance(owner, spender)` → 💳 Check spender’s remaining card limit on owner’s account.
 * - `approve(spender, amount)` → 🖊️ Set/refresh the card limit for a spender.
 * - `transferFrom(sender, recipient, amount)` → 🔄 Spender pays on behalf of owner using that limit.
 *
 * 🏷️ Real-World Flow:
 * 1) Alice calls `approve(Bob, 100)` → Bob gets a 100-coin spending limit.
 * 2) Bob calls `transferFrom(Alice, Carol, 60)` → Carol receives 60; Bob’s limit now 40.
 * 3) Anyone can check `allowance(Alice, Bob)` to see the remaining limit.
 */