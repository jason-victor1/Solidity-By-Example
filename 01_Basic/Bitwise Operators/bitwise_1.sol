// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title BitwiseOps
/// @notice Demonstrates low-level bitwise operations for educational or cryptographic purposes.
contract BitwiseOps {
    
    /// @notice Perform a bitwise AND operation between two unsigned integers.
    /// @dev Each bit in the result is 1 only if both corresponding bits in x and y are 1.
    /// @param x First operand.
    /// @param y Second operand.
    /// @return Result of x & y.
    function and(uint256 x, uint256 y) external pure returns (uint256) {
        return x & y;
    }

    /// @notice Perform a bitwise OR operation between two unsigned integers.
    /// @dev Each bit in the result is 1 if at least one of the corresponding bits in x or y is 1.
    /// @param x First operand.
    /// @param y Second operand.
    /// @return Result of x | y.
    function or(uint256 x, uint256 y) external pure returns (uint256) {
        return x | y;
    }

    /// @notice Perform a bitwise XOR operation between two unsigned integers.
    /// @dev Each bit in the result is 1 only if the corresponding bits in x and y are different.
    /// @param x First operand.
    /// @param y Second operand.
    /// @return Result of x ^ y.
    function xor(uint256 x, uint256 y) external pure returns (uint256) {
        return x ^ y;
    }

    /// @notice Perform a bitwise NOT operation on an 8-bit unsigned integer.
    /// @dev Flips all bits (i.e., 1 becomes 0, 0 becomes 1).
    /// @param x Operand.
    /// @return Result of ~x.
    function not(uint8 x) external pure returns (uint8) {
        return ~x;
    }

    /// @notice Left-shift a number by a specified number of bits.
    /// @dev Equivalent to multiplying the number by 2^bits.
    /// @param x The value to shift.
    /// @param bits Number of bits to shift to the left.
    /// @return The shifted result.
    function shiftLeft(uint256 x, uint256 bits)
        external
        pure
        returns (uint256)
    {
        return x << bits;
    }

    /// @notice Right-shift a number by a specified number of bits.
    /// @dev Equivalent to dividing the number by 2^bits, discarding remainders.
    /// @param x The value to shift.
    /// @param bits Number of bits to shift to the right.
    /// @return The shifted result.
    function shiftRight(uint256 x, uint256 bits)
        external
        pure
        returns (uint256)
    {
        return x >> bits;
    }

    /// @notice Extract the last (least significant) n bits from an integer.
    /// @dev Uses a bitmask of n 1’s to isolate the desired bits.
    /// @param x The number to extract from.
    /// @param n Number of bits to extract.
    /// @return The isolated n least significant bits.
    function getLastNBits(uint256 x, uint256 n)
        external
        pure
        returns (uint256)
    {
        uint256 mask = (1 << n) - 1;
        return x & mask;
    }

    /// @notice Extract the last n bits using the modulus operator.
    /// @dev Equivalent to x % 2^n.
    /// @param x The number to extract from.
    /// @param n Number of bits to extract.
    /// @return The isolated n least significant bits.
    function getLastNBitsUsingMod(uint256 x, uint256 n)
        external
        pure
        returns (uint256)
    {
        return x % (1 << n);
    }

    /// @notice Find the index of the most significant bit set to 1.
    /// @dev Returns 0 for input 0. Otherwise returns the 0-based position.
    /// @param x Input number.
    /// @return Index of most significant bit.
    function mostSignificantBit(uint256 x) external pure returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            ++i;
        }
        return i;
    }

    /// @notice Extract the first n most significant bits from x.
    /// @dev Requires the bit-length of x to be passed as len.
    /// @param x Number to extract from.
    /// @param n Number of most significant bits to keep.
    /// @param len Total number of bits in x.
    /// @return Result containing only the n most significant bits of x.
    function getFirstNBits(uint256 x, uint256 n, uint256 len)
        external
        pure
        returns (uint256)
    {
        uint256 mask = ((1 << n) - 1) << (len - n);
        return x & mask;
    }
}
