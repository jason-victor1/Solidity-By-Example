// SPDX-License-Identifier: MIT
// Specifies the license for the code, making it open source under the MIT license.

pragma solidity ^0.8.26;

/// @title 📐 View vs Pure Functions in Solidity
/// @author ✍️
/// @notice Demonstrates the difference between `view` and `pure` functions using simple addition.
/// @dev A teaching contract to show how function mutability affects blockchain state access.

contract ViewAndPure {
    /// @notice 📦 A state variable stored permanently on the blockchain.
    /// @dev This is like a locked safe containing a number. You can check it, but modifying it requires a transaction.
    uint256 public x = 1;

    /// @notice 🔍 A `view` function that reads from the blockchain but doesn't change it.
    /// @dev Like looking at the scoreboard without touching it.
    /// @param y A number to be added to the current value of `x`.
    /// @return The result of `x + y`.
    function addToX(uint256 y) public view returns (uint256) {
        return x + y;
    }

    /// @notice 📏 A `pure` function that doesn't read or write to the blockchain.
    /// @dev Think of it like solving a math problem on paper without opening the safe.
    /// @param i First number to add.
    /// @param j Second number to add.
    /// @return The sum of `i + j`.
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        return i + j;
    }
}