// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title UncheckedMath
/// @notice Demonstrates gas-efficient arithmetic using `unchecked` to bypass overflow/underflow checks
/// @dev Use `unchecked` only when inputs are guaranteed safe or overflow behavior is intentional
contract UncheckedMath {
    
    /// @notice Adds two unsigned integers without overflow protection
    /// @dev Saves gas by disabling Solidity's default overflow checks
    /// @param x The first operand
    /// @param y The second operand
    /// @return Sum of x and y (wrapping on overflow)
    function add(uint256 x, uint256 y) external pure returns (uint256) {
        // Gas cost with overflow check: ~22,291
        // Gas cost without overflow check: ~22,103
        unchecked {
            return x + y;
        }
    }

    /// @notice Subtracts y from x without underflow protection
    /// @dev Saves gas by disabling Solidity's default underflow checks
    /// @param x The minuend
    /// @param y The subtrahend
    /// @return Difference of x - y (wrapping on underflow)
    function sub(uint256 x, uint256 y) external pure returns (uint256) {
        // Gas cost with underflow check: ~22,329
        // Gas cost without underflow check: ~22,147
        unchecked {
            return x - y;
        }
    }

    /// @notice Calculates the sum of the cubes of x and y
    /// @dev Wraps multiple operations inside a single unchecked block for optimal gas
    /// @param x The first operand
    /// @param y The second operand
    /// @return Sum of x³ and y³ (may wrap on overflow)
    function sumOfCubes(uint256 x, uint256 y) external pure returns (uint256) {
        unchecked {
            uint256 x3 = x * x * x;
            uint256 y3 = y * y * y;

            return x3 + y3;
        }
    }
}
