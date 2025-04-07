// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint256 public num; // Public variable to store a number
    address public sender; // Public variable to store the sender's address
    uint256 public value; // Public variable to store the Ether value sent

    // Function to set the variables in contract B's storage
    function setVars(uint256 _num) public payable {
        num = _num; // Update `num` with the provided value
        sender = msg.sender; // Set `sender` to the caller's address
        value = msg.value; // Set `value` to the amount of Ether sent
    }
}

contract A {
    // Storage variables in contract A, same layout as in contract B
    uint256 public num; // Public variable to store a number
    address public sender; // Public variable to store the sender's address
    uint256 public value; // Public variable to store the Ether value sent

    // Event to log results of a delegatecall
    event DelegateResponse(bool success, bytes data);

    // Event to log results of a call
    event CallResponse(bool success, bytes data);

    // Function to modify A's storage using delegatecall
    function setVarsDelegateCall(
        address _contract,
        uint256 _num
    ) public payable {
        // Perform delegatecall to `setVars` in contract B.
        // A's storage will be modified, not B's.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        // Emit event to log the result of delegatecall
        emit DelegateResponse(success, data);
    }

    // Function to modify B's storage using call
    function setVarsCall(address _contract, uint256 _num) public payable {
        // Perform call to `setVars` in contract B.
        // B's storage will be modified, not A's.
        (bool success, bytes memory data) = _contract.call{value: msg.value}(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        // Emit event to log the result of call
        emit CallResponse(success, data);
    }
}
