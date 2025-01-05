// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// This contract demonstrates the usage of state variables, local variables, and global variables.

contract Variables {
    // State variables are stored on the blockchain and persist across function calls.

    // A public state variable to store a string.
    // The value is accessible to anyone and can be read externally.
    string public text = "Hello";

    // A public state variable to store an unsigned integer.
    uint256 public num = 123;

    // Function to demonstrate the use of local and global variables.
    function doSomething() public view {
        // Local variables are declared inside functions and are not saved to the blockchain.
        uint256 i = 456; // A local variable storing an unsigned integer.

        // Global variables are special variables provided by Solidity that contain information about the blockchain.

        uint256 timestamp = block.timestamp; // Stores the current block's timestamp.
        address sender = msg.sender; // Stores the address of the caller of this function.
    }
}
