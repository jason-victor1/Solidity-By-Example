                 send Ether
                      |
           msg.data is empty?
                /           \
            yes             no
             |                |
    receive() exists?     fallback()
        /        \
     yes          no
      |            |
  receive()     fallback()

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Contract demonstrating the behavior of fallback and receive functions
contract Fallback {
    // Event to log which function was called and the remaining gas
    event Log(string func, uint256 gas);

    // Fallback function - triggered when:
    // 1. The contract is called with non-empty msg.data.
    // 2. The receive() function does not exist.
    // It must be marked as external and can optionally be payable.
    fallback() external payable {
        // Log the function name "fallback" and the remaining gas
        emit Log("fallback", gasleft());
    }

    // Receive function - triggered when:
    // 1. Ether is sent to the contract with empty msg.data.
    // If msg.data is non-empty, this function will not be called.
    receive() external payable {
        // Log the function name "receive" and the remaining gas
        emit Log("receive", gasleft());
    }

    // Helper function to check the Ether balance of this contract
    // Public view function that returns the contract's current balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// Contract demonstrating how to send Ether to another contract
contract SendToFallback {
    // Function to send Ether using transfer
    // Sends msg.value Ether to the _to address
    // Forwards 2300 gas to the receiving contract
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value); // Transfer Ether to the recipient
    }

    // Function to send Ether using call
    // Sends msg.value Ether to the _to address
    // Forwards all available gas to the receiving contract
    function callFallback(address payable _to) public payable {
        (bool sent,) = _to.call{value: msg.value}(""); // Send Ether using call
        require(sent, "Failed to send Ether"); // Ensure the call was successful
    }
}

