// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Define the FunctionModifier contract
contract FunctionModifier {
    // State variables:
    // `owner` stores the address of the contract owner.
    address public owner;
    // `x` is a public variable initialized to 10, used for demonstration purposes.
    uint256 public x = 10;
    // `locked` is a boolean variable used to prevent reentrant function calls.
    bool public locked;

    // Constructor is executed once when the contract is deployed.
    constructor() {
        // Assign the address of the contract deployer to the `owner` variable.
        owner = msg.sender;
    }

    // Modifier: Ensures that only the contract owner can call certain functions.
    modifier onlyOwner() {
        // Require statement checks if the caller is the owner.
        require(msg.sender == owner, "Not owner");
        // `_` indicates where the modified function's code will be executed.
        _;
    }

    // Modifier: Validates that the given address is not the zero address.
    modifier validAddress(address _addr) {
        // Ensure `_addr` is not the zero address.
        require(_addr != address(0), "Not valid address");
        _;
    }

    // Function: Allows the owner to change ownership of the contract.
    // This function uses both `onlyOwner` and `validAddress` modifiers.
    function changeOwner(
        address _newOwner
    ) public onlyOwner validAddress(_newOwner) {
        // Update the `owner` variable with the new owner address.
        owner = _newOwner;
    }

    // Modifier: Prevents reentrant calls to functions.
    modifier noReentrancy() {
        // Check if the `locked` flag is false; if not, revert with an error.
        require(!locked, "No reentrancy");

        // Set the `locked` flag to true before executing the function.
        locked = true;
        _;
        // Reset the `locked` flag to false after the function has executed.
        locked = false;
    }

    // Function: Recursively decrements the value of `x`.
    // This function uses the `noReentrancy` modifier to prevent reentrant calls.
    function decrement(uint256 i) public noReentrancy {
        // Subtract `i` from `x`.
        x -= i;

        // If `i` is greater than 1, recursively call `decrement` with `i - 1`.
        if (i > 1) {
            decrement(i - 1);
        }
    }
}
