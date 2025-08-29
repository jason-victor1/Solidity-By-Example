// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IERC20.sol";

/**
 * @title TokenSwap
 * @dev Trust-minimized swap between two ERC-20 holders using allowances.
 *
 * 🧭 Big Picture Analogy:
 * Think of this contract as a **neutral barter mediator** (escrow clerk):
 *  - It writes down the trade terms up front (who gives what and how much).
 *  - Each trader hands the clerk a key (ERC-20 allowance) to access their goods.
 *  - When either trader says “go”, the clerk performs both moves atomically:
 *      Alice’s tokens → Bob, and Bob’s tokens → Alice.
 *  - If any step fails, the whole trade is canceled — no one ends up short-changed.
 */
contract TokenSwap {
    /// @notice First token being swapped (e.g., AliceCoin).
    /// 🧰 Analogy: Box of apples registered with the mediator.
    IERC20 public token1;

    /// @notice Owner of `token1` who must approve this contract.
    /// 👤 Analogy: Alice, who owns the apples.
    address public owner1;

    /// @notice Amount of `token1` to deliver from `owner1` to `owner2`.
    /// 📦 Analogy: Number of apples Alice will trade.
    uint256 public amount1;

    /// @notice Second token being swapped (e.g., BobCoin).
    /// 🧰 Analogy: Box of oranges registered with the mediator.
    IERC20 public token2;

    /// @notice Owner of `token2` who must approve this contract.
    /// 👤 Analogy: Bob, who owns the oranges.
    address public owner2;

    /// @notice Amount of `token2` to deliver from `owner2` to `owner1`.
    /// 📦 Analogy: Number of oranges Bob will trade.
    uint256 public amount2;

    /**
     * @notice Set the swap terms once at deployment.
     * @dev Stores token addresses, owners, and required amounts.
     *
     * 📝 Analogy:
     * The mediator writes the deal on paper:
     *  - “Alice gives `amount1` of `token1` to Bob,”
     *  - “Bob gives `amount2` of `token2` to Alice.”
     *
     * @param _token1 Address of the first ERC-20 token (AliceCoin).
     * @param _owner1 Address of the first participant (Alice).
     * @param _amount1 Amount of token1 Alice must provide.
     * @param _token2 Address of the second ERC-20 token (BobCoin).
     * @param _owner2 Address of the second participant (Bob).
     * @param _amount2 Amount of token2 Bob must provide.
     */
    constructor(
        address _token1,
        address _owner1,
        uint256 _amount1,
        address _token2,
        address _owner2,
        uint256 _amount2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        amount1 = _amount1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
        amount2 = _amount2;
    }

    /**
     * @notice Execute the swap if both parties have granted sufficient allowance.
     * @dev Callable by either participant. Reverts if allowances are insufficient.
     *
     * ✅ Flow:
     *  1) Authorization: only `owner1` or `owner2` can trigger.
     *  2) Check approvals: token1 allowance from `owner1` to this contract ≥ `amount1`,
     *                      token2 allowance from `owner2` to this contract ≥ `amount2`.
     *  3) Perform atomic transfers: token1 (Alice → Bob), then token2 (Bob → Alice).
     *
     * 🧮 Analogy:
     * - Only Alice or Bob can tell the mediator, “Proceed.”
     * - The mediator checks each has handed over a key that unlocks enough goods.
     * - The mediator simultaneously hands apples to Bob and oranges to Alice.
     * - If any step fails, the whole trade is canceled — no partial barters.
     */
    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );

        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    /**
     * @notice Internal helper to pull tokens using `transferFrom` and ensure success.
     * @dev Reverts if `transferFrom` returns false.
     *
     * 🧪 Analogy:
     * The mediator physically moves a package from the sender’s shelf to the recipient’s shelf.
     * If the move can’t be completed (wrong key, empty box, etc.), the process is aborted.
     *
     * @param token The ERC-20 token to move.
     * @param sender The current holder of the tokens.
     * @param recipient The destination address.
     * @param amount The amount to transfer.
     */
    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Roles & Terms:
 * - `token1`, `owner1`, `amount1` → Alice’s side of the deal (apples).
 * - `token2`, `owner2`, `amount2` → Bob’s side of the deal (oranges).
 *
 * Preconditions:
 * - `owner1` sets `approve(TokenSwap, amount1)` on `token1`.
 * - `owner2` sets `approve(TokenSwap, amount2)` on `token2`.
 *
 * Action:
 * - `swap()` (by Alice or Bob) → verifies allowances → moves both sides atomically.
 *
 * Safety:
 * - Only Alice or Bob can call `swap`.
 * - If any allowance/transfer check fails, the whole swap reverts (no partial trades).
 *
 * Real-World Analogy:
 * - Token approvals = handing the mediator a key to your goods.
 * - `swap()` = mediator performs a fair barter: apples ↔ oranges, all-or-nothing.
 */
