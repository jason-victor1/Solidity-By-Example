// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title AssemblyMath - A contract demonstrating low-level arithmetic using Yul assembly
/// @author
/// @notice This contract shows how to safely perform addition, multiplication, and fixed-point rounding with basic overflow protection using assembly.
/// @dev Useful for understanding how the EVM handles arithmetic at a low level
contract AssemblyMath {

    /// @notice Adds two numbers with overflow check
    /// @dev Uses Yul to perform addition and checks if result overflows by comparing with one of the inputs
    /// @param x The first number to add
    /// @param y The second number to add
    /// @return z The sum of x and y, reverts if overflow occurs
    /// @custom:analogy Think of stacking two block towers. If the total height looks shorter than the taller one, something went wrong!
    function yul_add(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            z := add(x, y)
            if lt(z, x) { revert(0, 0) } // If result is less than x, overflow occurred
        }
    }

    /// @notice Multiplies two numbers with overflow check
    /// @dev Uses Yul to perform multiplication and validates the result using inverse division
    /// @param x The first number to multiply
    /// @param y The second number to multiply
    /// @return z The product of x and y, reverts if overflow occurs
    /// @custom:analogy Think of stacking boxes. If you multiply but can't divide back to the original count, you miscounted!
    function yul_mul(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            switch x
            case 0 {
                z := 0
            }
            default {
                z := mul(x, y)
                if iszero(eq(div(z, x), y)) { revert(0, 0) } // Validate no overflow
            }
        }
    }

    /// @notice Rounds a value to the nearest multiple of a base value
    /// @dev Adds half the base before rounding down to nearest multiple using division and multiplication
    /// @param x The value to round
    /// @param b The base to round to the nearest multiple of
    /// @return z The rounded result
    /// @custom:analogy Like rounding $90 to the nearest $100 by adding $50 first, ensuring it goes up to $100
    function yul_fixed_point_round(uint256 x, uint256 b) public pure returns (uint256 z) {
        assembly {
            let half := div(b, 2)           // Half of base, e.g. 50 for 100
            z := add(x, half)              // Add half to x, e.g. 90 + 50 = 140
            z := mul(div(z, b), b)         // Round by truncating then multiplying, 140/100 = 1 -> 1*100 = 100
        }
    }
}
