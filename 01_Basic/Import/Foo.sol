// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version for compatibility and safety.

struct Point {
    uint256 x;
    // 📍 The horizontal coordinate.

    uint256 y;
    // 📍 The vertical coordinate.
}
// 📐 A basic struct representing a 2D point with x and y coordinates.

error Unauthorized(address caller);
// 🚫 Custom error for access control—reverts when an unauthorized caller attempts an action.

function add(uint256 x, uint256 y) pure returns (uint256) {
    // ➕ A free function that returns the sum of two unsigned integers.

    return x + y;
    // 🔁 Returns the result of x + y.
}

contract Foo {
    string public name = "Foo";
    // 🏷️ Publicly accessible string variable that stores the name of the contract.
}
