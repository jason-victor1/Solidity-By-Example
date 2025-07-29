// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title 🛡️ Function Modifiers Example: Ownership, Input Validation, and Reentrancy Protection
/// @author ✍️
/// @notice Demonstrates how to restrict and control function access using modifiers in Solidity.
/// @dev Showcases custom access control, input checks, and reentrancy prevention using flags.

contract FunctionModifier {
    /// @notice 🧑‍💼 The current owner of the contract.
    address public owner;

    /// @notice 🔢 Example value used to test function modifiers.
    uint256 public x = 10;

    /// @notice 🔐 Lock flag to prevent reentrant calls.
    bool public locked;

    /// @notice 🏗️ Constructor sets the original owner of the contract.
    /// @dev Like giving the keys to the first tenant who deploys the contract.
    constructor() {
        owner = msg.sender;
    }

    /// @notice ✅ Ensures that only the contract owner can call certain functions.
    /// @dev Think of this as a keycard scanner that only lets the owner into certain rooms.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /// @notice 🛂 Validates that an input address is not the zero address.
    /// @dev Like checking that a delivery address isn’t empty before shipping a package.
    /// @param _addr The address to check.
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    /// @notice 🔄 Changes the owner of the contract to a new valid address.
    /// @dev Combines both `onlyOwner` and `validAddress` modifiers.
    /// @param _newOwner The new address to be assigned as the owner.
    function changeOwner(address _newOwner)
        public
        onlyOwner
        validAddress(_newOwner)
    {
        owner = _newOwner;
    }

    /// @notice 🚪 Prevents the function from being executed while it's already running.
    /// @dev Like locking a bathroom door when occupied to prevent others from walking in.
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;
        locked = false;
    }

    /// @notice 📉 Recursively reduces the value of `x` by `i`.
    /// @dev Shows how reentrancy can be avoided during recursive function calls.
    /// @param i The amount by which `x` is reduced each time.
    function decrement(uint256 i) public noReentrancy {
        x -= i;

        if (i > 1) {
            decrement(i - 1);
        }
    }
}