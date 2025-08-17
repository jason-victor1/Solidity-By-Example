// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version to ensure consistency.

contract FunctionSelector {
    /**
     * @title Function Selector Calculator
     * @dev Demonstrates how to compute the **function selector** for a given function signature.
     *
     * 🏷️ What is a Function Selector?
     * - In Solidity, every function has a unique "ID card" called a **selector**.
     * - It’s the first 4 bytes of the keccak256 hash of the function signature string.
     * - Example:
     *   - `"transfer(address,uint256)"` → `0xa9059cbb`
     *   - `"transferFrom(address,address,uint256)"` → `0x23b872dd`
     *
     * 🔑 Analogy:
     * Imagine Ethereum contracts as a giant office building with many doors (functions).
     * Each door has a digital lock.
     * - The **function signature string** is like the lock’s full blueprint.
     * - The **selector** is the actual tiny key you cut from that blueprint.
     * - Whenever you knock (make a transaction), you must bring the exact 4-byte key
     *   so the contract knows which door to open.
     */

    /**
     * @notice Computes the selector (4-byte identifier) for a given function signature.
     * @dev 
     * - Takes the signature string, converts it to bytes, hashes it with `keccak256`,
     *   and slices the first 4 bytes.
     * - This is how the EVM decides which function to run when a transaction arrives.
     *
     * 🧩 Analogy:
     * - Write down the door’s blueprint (`"transfer(address,uint256)"`).
     * - Put it into a hashing machine (`keccak256`), which spits out a long code.
     * - Cut off the first 4 bytes—that’s the actual key used at runtime.
     *
     * @param _func The function signature as a string (e.g., `"approve(address,uint256)"`).
     * @return The 4-byte selector (the "door key").
     */
    function getSelector(string calldata _func)
        external
        pure
        returns (bytes4)
    {
        return bytes4(keccak256(bytes(_func))); // 🔐 Generate the "door key".
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * - Function Signature → `"name(type1,type2,...)"` (no spaces).
 * - Hashing → `keccak256(bytes(signature))` → 32-byte digest.
 * - Selector → first 4 bytes of that hash.
 *
 * Example:
 * - `"transfer(address,uint256)"` → hash starts `0xa9059cbb...` → selector = `0xa9059cbb`.
 *
 * 🚪 Real-World Analogy:
 * Think of each contract function as a locked door in a digital building.
 * - Full signature = the lock’s design drawing.
 * - Selector = the small unique key that fits just that lock.
 * Without the exact 4-byte key, the EVM won’t even try to open the door.
 */
