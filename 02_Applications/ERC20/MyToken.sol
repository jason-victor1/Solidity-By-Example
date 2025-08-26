// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ERC20.sol";

/**
 * @title MyToken
 * @dev Thin wrapper around a minimal ERC-20 implementation.
 *      Sets token identity (name, symbol, decimals) and mints an initial supply
 *      of 100 whole tokens to the deployer.
 *
 * 🧭 Big Picture Analogy:
 * Think of `MyToken` as opening a **new bank branch** that uses the existing
 * ERC-20 banking core:
 *  - The parent `ERC20` is the banking system (accounts, transfers, approvals).
 *  - This contract puts up the branch sign (name, symbol, decimals)
 *    and prints the **first 100 bills** for the founder’s wallet.
 */
contract MyToken is ERC20 {
    /**
     * @notice Deploy a new token with chosen identity and 100 initial tokens.
     * @dev Calls the parent ERC20 constructor, then mints `100 * 10**decimals`
     *      to `msg.sender` (the deployer).
     *
     * 🏷️ Parameters:
     * @param name The human-readable token name (e.g., "GoldCoin").
     * @param symbol The shorthand ticker (e.g., "GLD").
     * @param decimals How many decimal places the token uses (e.g., 18).
     *
     * 💡 Analogy:
     * - Putting up the branch sign: `name`, `symbol`, `decimals`.
     * - Printing the opening cash drawer: 100 full tokens into the founder’s account.
     *   Like “$1 = 100 cents”, here “1 token = 10**decimals” base units.
     *
     * 🛑 Note:
     * This demo mints to the deployer and exposes mint/burn in the parent without
     * access control. In production, restrict mint/burn (e.g., Ownable/AccessControl).
     */
    constructor(string memory name, string memory symbol, uint8 decimals)
        ERC20(name, symbol, decimals)
    {
        // Mint 100 whole tokens to the deployer in base units:
        // 1 token = 10**decimals subunits → 100 tokens = 100 * 10**decimals.
        _mint(msg.sender, 100 * 10 ** uint256(decimals)); // 🖨️ Founder’s seed supply.
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * - Inherits ERC20:
 *   - `transfer`, `approve`, `transferFrom`, `mint`, `burn`, `balanceOf`, `totalSupply`.
 * - Constructor:
 *   - Sets identity via parent: name/symbol/decimals.
 *   - Mints 100 tokens to deployer using base units (`10**decimals`).
 *
 * 🏦 Analogy Recap:
 * - ERC20 = the core banking system.
 * - MyToken = a new branch that customizes the sign and loads the opening till
 *   with 100 bills for the founder.
 *
 * 🔐 Production Tips:
 * - Add access control to mint/burn in the parent or override here.
 * - Consider fixed initial supply with no public mint for predictable tokenomics.
 */
