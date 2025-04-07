// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Contract to demonstrate receiving Ether and handling function calls
contract Receiver {
    // Event to log details of received calls
    event Received(address caller, uint256 amount, string message);

    // Fallback function - triggered when:
    // 1. Ether is sent with non-empty data and no matching function exists.
    // 2. A non-existent function is called.
    fallback() external payable {
        // Log the caller, amount of Ether sent, and a fallback-specific message
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    // Function that accepts a message and a number, and can receive Ether
    function foo(
        string memory _message,
        uint256 _x
    ) public payable returns (uint256) {
        // Log the caller, amount of Ether sent, and the custom message
        emit Received(msg.sender, msg.value, _message);

        // Return the input number incremented by 1
        return _x + 1;
    }
}

// Contract to demonstrate calling functions and sending Ether to another contract
contract Caller {
    // Event to log the success and data of a function call
    event Response(bool success, bytes data);

    // Function to call the `foo` function on the `Receiver` contract
    function testCallFoo(address payable _addr) public payable {
        // Perform a low-level call to `foo(string,uint256)` on the `Receiver` contract
        // Pass "call foo" as the string and 123 as the uint256
        (bool success, bytes memory data) = _addr.call{
            value: msg.value, // Send Ether from the Caller contract
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)); // Specify a custom gas limit

        // Log whether the call was successful and the returned data
        emit Response(success, data);
    }

    // Function to call a non-existent function on the `Receiver` contract
    function testCallDoesNotExist(address payable _addr) public payable {
        // Perform a low-level call to a non-existent function `doesNotExist()`
        // This triggers the fallback function on the `Receiver` contract
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        // Log whether the call was successful and the returned data
        emit Response(success, data);
    }
}
