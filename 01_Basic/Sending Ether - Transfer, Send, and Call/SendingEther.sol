// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Contract to demonstrate receiving Ether and the behavior of receive() and fallback() functions
contract ReceiveEther {
    /*
    Explanation of receive() and fallback() function logic:
    
           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
    receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()

    - If `msg.data` is empty and `receive()` exists, `receive()` is called.
    - If `msg.data` is empty but no `receive()` exists, `fallback()` is called.
    - If `msg.data` is not empty, `fallback()` is always called.
    */

    // Function to receive Ether. Automatically called when msg.data is empty.
    // `payable` modifier allows this function to accept Ether.
    receive() external payable {}

    // Fallback function is triggered when msg.data is not empty
    // or if no receive() function exists to handle Ether transfer.
    // `payable` modifier allows this function to accept Ether.
    fallback() external payable {}

    // Function to get the balance of Ether held by the contract.
    // `view` modifier ensures this function does not modify the state.
    function getBalance() public view returns (uint256) {
        // Returns the contract's current Ether balance.
        return address(this).balance;
    }
}

// Contract to demonstrate various ways of sending Ether to another address.
contract SendEther {
    // Function to send Ether using transfer (2300 gas limit, throws error on failure).
    function sendViaTransfer(address payable _to) public payable {
        // Transfer sends `msg.value` Ether to the recipient (`_to` address).
        // This method is no longer recommended as it enforces a strict gas limit of 2300,
        // which may not be sufficient for some recipient contracts.
        _to.transfer(msg.value);
    }

    // Function to send Ether using send (2300 gas limit, returns a boolean on failure).
    function sendViaSend(address payable _to) public payable {
        // Send sends `msg.value` Ether to the recipient (`_to` address).
        // Returns `true` if successful, `false` otherwise.
        // This method is also not recommended as it does not revert automatically on failure.
        bool sent = _to.send(msg.value);
        // Use `require` to revert the transaction if the send operation fails.
        require(sent, "Failed to send Ether");
    }

    // Function to send Ether using call (forwards all available gas or a custom gas amount).
    function sendViaCall(address payable _to) public payable {
        // Call sends `msg.value` Ether to the recipient (`_to` address).
        // Forwards all available gas (or a specified gas amount if set).
        // Returns a boolean (`sent`) indicating success or failure, and additional return data (`data`).
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        // Use `require` to revert the transaction if the call operation fails.
        require(sent, "Failed to send Ether");
    }
}
