// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title MostSignificantBitFunction
/// @notice Efficiently computes the index of the most significant bit (MSB) set to 1 using binary search.
/// @dev Uses a series of right shifts and bitwise comparisons to determine the MSB position in log₂(n) time.
contract MostSignificantBitFunction {

    /// @notice Returns the index of the most significant bit that is set to 1 in a given unsigned integer.
    /// @dev Performs a binary search via bit shifts to reduce the problem size quickly.
    /// @param x The unsigned integer to analyze.
    /// @return msb The 0-based index of the highest-order bit set to 1. If x is 0, returns 0.
    function mostSignificantBit(uint256 x)
        external
        pure
        returns (uint256 msb)
    {
        // Check if x >= 2^128. If true, shift right 128 bits and add 128 to the MSB index.
        if (x >= 0x100000000000000000000000000000000) {
            x >>= 128;
            msb += 128;
        }

        // Check if x >= 2^64. Shift and add accordingly.
        if (x >= 0x10000000000000000) {
            x >>= 64;
            msb += 64;
        }

        // Check if x >= 2^32. Shift and add accordingly.
        if (x >= 0x100000000) {
            x >>= 32;
            msb += 32;
        }

        // Check if x >= 2^16. Shift and add accordingly.
        if (x >= 0x10000) {
            x >>= 16;
            msb += 16;
        }

        // Check if x >= 2^8. Shift and add accordingly.
        if (x >= 0x100) {
            x >>= 8;
            msb += 8;
        }

        // Check if x >= 2^4. Shift and add accordingly.
        if (x >= 0x10) {
            x >>= 4;
            msb += 4;
        }

        // Check if x >= 2^2. Shift and add accordingly.
        if (x >= 0x4) {
            x >>= 2;
            msb += 2;
        }

        // Final check if x >= 2^1. Add 1 if true.
        if (x >= 0x2) {
            msb += 1;
        }

        // Note: if x == 0, msb remains 0.
    }
}
