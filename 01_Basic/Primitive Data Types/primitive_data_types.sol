// SPDX-License-Identifier: MIT
// The SPDX license identifier declares that this code is licensed under the MIT License.

pragma solidity ^0.8.26;
// Specifies that the Solidity compiler version must be 0.8.26 (or compatible versions).

/// @title Primitive Data Types Showcase
/// @notice Demonstrates how primitive Solidity types (bool, ints, uints, address, bytes) work
/// @dev Useful as a reference for default values, ranges, and basic type behavior
contract Primitives {
    /// @notice A boolean flag (true/false)
    /// @dev Think of it like a light switch that’s currently turned ON
    bool public boo = true;

    /// @notice An 8-bit unsigned integer (0 to 255)
    /// @dev Alias for small counters or flags; initialized to 1
    uint8 public u8 = 1;

    /// @notice A 256-bit unsigned integer (0 to 2²⁵⁶–1)
    /// @dev Large number container; initialized to 456
    uint256 public u256 = 456;

    /// @notice Default-size unsigned integer (alias for uint256)
    /// @dev Just another uint256 initialized to 123
    uint256 public u = 123;

    /// @notice An 8-bit signed integer (–128 to 127)
    /// @dev Small signed counter; initialized to –1 (think of a negative adjustment)
    int8 public i8 = -1;

    /// @notice A 256-bit signed integer
    /// @dev Signed range container; initialized to 456
    int256 public i256 = 456;

    /// @notice Default-size signed integer (alias for int256)
    /// @dev Large signed number; initialized to –123
    int256 public i = -123;

    /// @notice Minimum value for a signed 256-bit integer
    /// @dev Demonstrates Solidity’s lowest possible signed number
    int256 public minInt = type(int256).min;

    /// @notice Maximum value for a signed 256-bit integer
    /// @dev Demonstrates Solidity’s largest possible signed number
    int256 public maxInt = type(int256).max;

    /// @notice An Ethereum address
    /// @dev Like writing someone’s physical address on an envelope
    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    /// @notice A single byte of data
    /// @dev Stores tiny binary data (e.g. a small flag). Initialized to 0xb5.
    bytes1 public a = 0xb5;

    /// @notice Another single byte of data
    /// @dev Similar to above, initialized to 0x56
    bytes1 public b = 0x56;

    /// @notice Default values when types are declared but not initialized
    /// @dev Demonstrates Solidity’s zero-initialization behavior:
    /// - bool → false
    /// - uint/int → 0
    /// - address → 0x0 (empty address)
    bool public defaultBoo;
    uint256 public defaultUint;
    int256 public defaultInt;
    address public defaultAddr;
}
