// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title MostSignificantBitAssembly
/// @notice Efficiently computes the index of the most significant bit (MSB) set to 1 using inline Yul assembly.
/// @dev Uses binary search via right-shifting and bitwise logic to compress computation into a few instructions.
contract MostSignificantBitAssembly {
    
    /// @notice Finds the index of the most significant bit that is set in `x`.
    /// @dev This version is optimized using Yul assembly and bit manipulation logic.
    /// @param x The input number to inspect.
    /// @return msb The 0-based index of the most significant bit set to 1. Returns 0 if x is 0.
    function mostSignificantBit(uint256 x)
        external
        pure
        returns (uint256 msb)
    {
        // --- Stage 1: Check if highest 128 bits are set ---
        assembly {
            // If x > 2^128 - 1, set f = 128
            let f := shl(7, gt(x, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            // Shift x right by f (128 if applicable)
            x := shr(f, x)
            // Accumulate the shift into msb
            msb := or(msb, f)
        }

        // --- Stage 2: Check next 64 bits ---
        assembly {
            let f := shl(6, gt(x, 0xFFFFFFFFFFFFFFFF))
            x := shr(f, x)
            msb := or(msb, f)
        }

        // --- Stage 3: Check next 32 bits ---
        assembly {
            let f := shl(5, gt(x, 0xFFFFFFFF))
            x := shr(f, x)
            msb := or(msb, f)
        }

        // --- Stage 4: Check next 16 bits ---
        assembly {
            let f := shl(4, gt(x, 0xFFFF))
            x := shr(f, x)
            msb := or(msb, f)
        }

        // --- Stage 5: Check next 8 bits ---
        assembly {
            let f := shl(3, gt(x, 0xFF))
            x := shr(f, x)
            msb := or(msb, f)
        }

        // --- Stage 6: Check next 4 bits ---
        assembly {
            let f := shl(2, gt(x, 0xF))
            x := shr(f, x)
            msb := or(msb, f)
        }

        // --- Stage 7: Check next 2 bits ---
        assembly {
            let f := shl(1, gt(x, 0x3))
            x := shr(f, x)
            msb := or(msb, f)
        }

        // --- Stage 8: Final bit check (x >= 2) ---
        assembly {
            let f := gt(x, 0x1)
            msb := or(msb, f)
        }
    }
}
