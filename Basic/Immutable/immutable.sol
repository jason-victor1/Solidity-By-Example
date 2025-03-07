// SPDX-License-Identifier: MIT          // License identifier for open-source compliance.
pragma solidity ^0.8.26;                  // Specifies that the source code is written for Solidity version 0.8.26.

// Define a contract named "Immutable"
contract Immutable {
    // Declare an immutable public variable of type address.
    // 'immutable' means that the value can be set only once during the contract's construction.
    address public immutable myAddr;
    
    // Declare an immutable public variable of type uint256.
    // This variable is also only set during contract construction.
    uint256 public immutable myUint;
    
    // Constructor function: runs once when the contract is deployed.
    // It accepts a uint256 value which is used to initialize myUint.
    constructor(uint256 _myUint) {
        // Set myAddr to the address that deploys the contract (msg.sender).
        myAddr = msg.sender;
        
        // Set myUint to the value provided as an argument to the constructor.
        myUint = _myUint;
    }
}
