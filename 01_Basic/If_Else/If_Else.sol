// SPDX-License-Identifier: MIT
// 🪪 This license plate declares the contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ This specifies which version of the Solidity builder toolkit to use—v0.8.26 or compatible updates.

/// @title If/Else and Ternary Example
/// @notice Demonstrates conditional logic using if/else and ternary operator
/// @dev 🤔 Think of this like deciding what to wear based on the weather — with both long and short versions
contract IfElse {
    /// @notice Determines a value based on the input using if/else
    /// @dev 🪧 Like reading a signpost with three directions depending on `x`
    /// @param x The input number to evaluate
    /// @return The result:
    ///         - 0 if `x` is less than 10
    ///         - 1 if `x` is between 10 and 19
    ///         - 2 if `x` is 20 or more
    function foo(uint256 x) public pure returns (uint256) {
        if (x < 10) {
            // 📍 Path 1: If `x` is less than 10
            return 0;
        } else if (x < 20) {
            // 📍 Path 2: If `x` is between 10 and 19
            return 1;
        } else {
            // 📍 Path 3: If `x` is 20 or more
            return 2;
        }
    }

    /// @notice Determines a value using a shorter if/else (ternary operator)
    /// @dev ⚡ Like flipping a coin — one quick check
    /// @param _x The input number to evaluate
    /// @return The result:
    ///         - 1 if `_x` is less than 10
    ///         - 2 otherwise
    function ternary(uint256 _x) public pure returns (uint256) {
        // 🤏 Short-hand version of if/else using the `?` operator
        return _x < 10 ? 1 : 2;
    }
}