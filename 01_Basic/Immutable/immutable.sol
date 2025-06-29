// SPDX-License-Identifier: MIT
// 🪪 This is your contract’s license plate—declares it open-source under MIT terms.

pragma solidity ^0.8.26;
// 🛠️ Sets the version of Solidity tools used to build this contract.
// Version 0.8.26 includes important safety features.

/// @title Immutable Variables Example
/// @notice Demonstrates how to use `immutable` in Solidity for values that are set once and never change afterward
/// @dev 📌 Think of `immutable` like filling in your name on a form — once submitted, it's locked forever, but you can choose it initially
contract Immutable {
    /// @notice Stores the address of the contract creator
    /// @dev 🏷️ Like tagging a package with the sender's address — fixed when the box is sealed (constructor) and cannot be changed after
    address public immutable myAddr;

    /// @notice Stores a number provided during contract deployment
    /// @dev 🔐 Similar to setting the lock combination once at setup — it can’t be changed later
    uint256 public immutable myUint;

    /// @notice Constructor to initialize the immutable variables
    /// @param _myUint The number to be saved as a permanent value
    constructor(uint256 _myUint) {
        // 🧑 The deployer’s address is stored permanently
        myAddr = msg.sender;

        // 🔢 The input value is recorded like setting the launch time for a rocket — no turning back after it's set
        myUint = _myUint;
    }
}