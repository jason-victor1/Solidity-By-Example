// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Simple ABI Encoding Example Contract
/// @notice Demonstrates how to encode a function call using ABI encoding
/// @dev Provides a basic example of `abi.encodeWithSignature` and a simple state update
contract TestContract {
    /// @notice A public number that increases each time someone calls the contract
    /// @dev This is like a public counter on a billboard. Everyone can see it, and it goes up when someone calls `callMe`
    uint256 public i;

    /// @notice Adds the input value to the existing total
    /// @dev This function modifies the state by incrementing `i`
    /// @param j The amount to add to the current value of `i`
    function callMe(uint256 j) public {
        i += j;
        // 🧮 This is like saying "Add j coins into the donation box"
    }

    /// @notice Returns encoded data representing a call to `callMe(123)`
    /// @dev The returned bytes simulate a remote control button that would trigger `callMe(123)`
    /// @return ABI-encoded function signature and input: can be used to manually invoke `callMe(123)`
    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 123);
        // 🧳 This is like packing a message that says: "Please run `callMe` with value 123"
    }
}
