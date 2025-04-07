// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Define the `Callee` contract
contract Callee {
    // Public state variable to store an unsigned integer value
    uint256 public x;

    // Public state variable to store the Ether value received
    uint256 public value;

    // Function to set the value of `x` and return the updated value
    function setX(uint256 _x) public returns (uint256) {
        x = _x; // Update the state variable `x` with the provided value
        return x; // Return the updated value of `x`
    }

    // Function to set `x` and record Ether sent to the contract
    function setXandSendEther(
        uint256 _x // Allows the function to accept Ether
    ) public payable returns (uint256, uint256) {
        x = _x; // Update the state variable `x`
        value = msg.value; // Store the Ether sent with the transaction in `value`

        // Return the updated `x` and the received Ether value
        return (x, value);
    }
}

// Define the `Caller` contract
contract Caller {
    // Function to call the `setX` function of a `Callee` contract instance
    function setX(Callee _callee, uint256 _x) public {
        // Call the `setX` function of the provided `Callee` instance and update `x`
        uint256 x = _callee.setX(_x);

        // Note: The value of `x` is stored locally and not used further
    }

    // Function to call `setX` using the address of a `Callee` contract
    function setXFromAddress(address _addr, uint256 _x) public {
        // Convert the address into a `Callee` contract instance
        Callee callee = Callee(_addr);

        // Call the `setX` function of the `Callee` contract
        callee.setX(_x);
    }

    // Function to call `setXandSendEther` of a `Callee` contract instance
    // and send Ether to it
    function setXandSendEther(Callee _callee, uint256 _x) public payable {
        // Call the `setXandSendEther` function of the provided `Callee` instance
        // `{value: msg.value}` sends the Ether sent with this transaction
        (uint256 x, uint256 value) = _callee.setXandSendEther{value: msg.value}(
            _x
        );

        // Note: The returned values (`x` and `value`) are stored locally and not used further
    }
}
