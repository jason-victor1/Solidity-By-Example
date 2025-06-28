// SPDX-License-Identifier: MIT
// 🪪 This is like the open-source license plate for your building.
// The MIT license says: "Feel free to use, copy, and remix this legally."

pragma solidity ^0.8.26;
// 🛠️ Tells the builder (compiler) to use version 0.8.26 of the Solidity toolkit.
// This ensures compatibility and includes safety features.

/// @title Constants Example
/// @notice Demonstrates how to define fixed values in Solidity that never change
/// @dev Think of constants like engraved plaques or locked safes — once set, they cannot be changed
contract Constants {
    /// @notice A constant Ethereum address, hard-coded and unchangeable
    /// @dev 🪪 Think of this like a government-issued ID number that’s permanently stamped into the contract
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;

    /// @notice A constant number value
    /// @dev 🔒 Like a sign in a store window that always says "Open at 9 AM" — it never changes, no matter what
    uint256 public constant MY_UINT = 123;
}
