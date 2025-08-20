// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version for compatibility and safety.

// 🌍 Global Scope Elements
//

/**
 * @title Point Struct
 * @dev A simple data structure representing a 2D coordinate with `x` and `y`.
 *
 * 📐 Analogy:
 * Imagine a "Point" as a dot on graph paper:
 * - `x` is how far right the dot is,
 * - `y` is how far up the dot is.
 */
struct Point {
    uint256 x; // ➡️ Horizontal position.
    uint256 y; // ⬆️ Vertical position.
}

/**
 * @title Unauthorized Custom Error
 * @dev Used to save gas compared to string-based `require` messages.
 *
 * 🚨 Analogy:
 * Think of this as a **special rejection stamp** in an office.
 * - Instead of writing a long note like "You are not authorized",
 * - The clerk stamps your file with `Unauthorized(caller)`.
 *
 * This is cheaper (less storage/less text), but still crystal clear when read by tools.
 *
 * @param caller The address that attempted an unauthorized action.
 */
error Unauthorized(address caller);

/**
 * @title Add Function (Global)
 * @dev A pure, free function (not inside a contract) that adds two numbers.
 *
 * ➕ Analogy:
 * This is like a calculator left in the lobby. Anyone can walk by and use it,
 * without needing a receptionist (contract).
 *
 * @param x First number.
 * @param y Second number.
 * @return The sum of `x` and `y`.
 */
function add(uint256 x, uint256 y) pure returns (uint256) {
    return x + y; // 🧮 Adds the two numbers.
}

//
// 🏛️ Contract
//

contract Foo {
    /**
     * @title Foo Contract
     * @dev A very simple contract with a single state variable `name`.
     *
     * 🏷️ Analogy:
     * Think of this as a storefront with a sign out front.
     * The sign always says `"Foo"`.
     */

    /// @notice The name of this contract, always `"Foo"`.
    string public name = "Foo"; // 🪧 Permanent signboard outside the shop.
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * - `struct Point`: A dot on graph paper with `x` and `y` coordinates.
 * - `error Unauthorized(address caller)`: Gas-efficient rejection stamp for unauthorized access.
 * - `function add(uint256, uint256)`: A public calculator anyone can use (free function, not tied to a contract).
 * - `contract Foo`: A tiny shop with one signboard: `"Foo"`.
 *
 * 🚪 Real-World Analogy:
 * - Point = a plotted coordinate on graph paper.
 * - Unauthorized = a stamp saying "You don’t belong here".
 * - add() = lobby calculator anyone can press.
 * - Foo = shop with a permanent nameplate.
 */
