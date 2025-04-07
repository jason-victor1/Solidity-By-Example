// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// A contract to handle Ether deposits, withdrawals, and transfers
// The contract has an owner and can store Ether
contract Payable {
    // State variable to store the owner of the contract
    // 'payable' allows the owner to receive Ether
    address payable public owner;

    // Constructor function that runs only once during deployment
    // Marks the constructor as payable to accept Ether during contract deployment
    constructor() payable {
        // Assign the deployer's address as the owner of the contract
        // Example: If account 0x5B3...eddC4 deploys the contract,
        // it becomes the owner and is stored in the `owner` variable.
        owner = payable(msg.sender);
    }

    // Function to deposit Ether into this contract
    // The 'payable' modifier allows this function to accept Ether
    // No additional logic is required; the contract balance updates automatically
    // Example: Ether sent via this function is stored at the contract's address
    // (e.g., 0x9D4...6254) and increases its balance.
    function deposit() public payable {}

    // Function that does not accept Ether
    // If Ether is sent along with this function call, the transaction will fail
    function notPayable() public {}

    // Function to withdraw all Ether stored in this contract to the owner's address
    function withdraw() public {
        // Retrieve the current balance of the contract
        uint256 amount = address(this).balance;

        // Use a low-level call to send the entire balance to the owner's address
        // '(bool success,)' captures whether the transfer was successful
        // Example: All Ether stored at the contract's address (e.g., 0x9D4...6254)
        // is transferred to the owner's address (e.g., 0x5B3...eddC4).
        (bool success, ) = owner.call{value: amount}("");

        // Revert the transaction if the transfer fails
        require(success, "Failed to send Ether");
    }

    // Function to transfer a specified amount of Ether from this contract to another address
    // Parameters:
    //  - _to: the recipient's address (must be payable to accept Ether)
    //  - _amount: the amount of Ether to send (in wei)
    // Example: Ether is sent from the contract's address (e.g., 0x9D4...6254) to the `_to` address.
    function transfer(address payable _to, uint256 _amount) public {
        // Perform a low-level call to send the specified amount of Ether to the recipient
        (bool success, ) = _to.call{value: _amount}("");

        // Revert the transaction if the transfer fails
        require(success, "Failed to send Ether");
    }
}
