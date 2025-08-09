// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Payable
 * @dev Demonstrates how to send, receive, and withdraw Ether using payable functions and addresses.
 * 💰 Think of this contract like a digital piggy bank that can accept, store, and send Ether.
 */
contract Payable {
    /// @notice The owner of the contract who can receive withdrawals.
    /// @dev Must be a payable address so Ether can be sent to it.
    address payable public owner;

    /**
     * @notice Constructor that sets the owner and can receive Ether upon deployment.
     * @dev The `payable` keyword allows the contract to accept Ether during creation.
     * 🏠 Analogy: Building the piggy bank and deciding who owns the key.
     */
    constructor() payable {
        owner = payable(msg.sender);
    }

    /**
     * @notice Deposits Ether into the contract.
     * @dev The contract balance increases automatically.
     * 🏦 Analogy: Putting coins into the piggy bank.
     */
    function deposit() public payable {}

    /**
     * @notice A function that cannot accept Ether.
     * @dev If you try to send Ether here, the transaction will fail.
     * 🚫 Analogy: Trying to put money into a locked drawer — it won’t work.
     */
    function notPayable() public {}

    /**
     * @notice Withdraws all Ether stored in the contract to the owner.
     * @dev Uses a low-level `call` to send Ether, and reverts if the transfer fails.
     * 💸 Analogy: Emptying the piggy bank and giving all the money to the owner.
     */
    function withdraw() public {
        uint256 amount = address(this).balance;

        (bool success,) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    /**
     * @notice Transfers a specific amount of Ether from the contract to a given address.
     * @param _to The recipient address (must be payable).
     * @param _amount The amount of Ether to send (in wei).
     * 📦 Analogy: Taking coins from the piggy bank and handing them to someone specific.
     */
    function transfer(address payable _to, uint256 _amount) public {
        (bool success,) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}