// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ReceiveEther
 * @dev Demonstrates how contracts handle incoming Ether through `receive()` and `fallback()` functions.
 * 🏦 Analogy: Imagine a building with two doors:
 *   - **receive()** is the main front door for regular deliveries (Ether without extra instructions).
 *   - **fallback()** is the side door for unexpected packages (Ether with data or no matching function).
 */
contract ReceiveEther {
    /*
    Logic for deciding which function is called:

           Send Ether
               |
         Is msg.data empty?  (msg.data = extra info sent with transaction)
              / \
            yes  no
            /     \
    Does receive() exist?  --->  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    /**
     * @notice Handles incoming Ether when no data is sent.
     * @dev Called automatically when `msg.data` is empty.
     * 📦 Analogy: A delivery truck drops off a package at the front door with no note.
     */
    receive() external payable {}

    /**
     * @notice Handles calls with data or unknown function selectors.
     * @dev Can also receive Ether if marked `payable`.
     * 📦 Analogy: A package arrives at the side door with unusual instructions or unknown delivery details.
     */
    fallback() external payable {}

    /**
     * @notice Returns the current Ether balance of this contract.
     * @return The balance in wei.
     * 💰 Analogy: Checking how much money is inside the safe.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

/**
 * @title SendEther
 * @dev Shows different methods to send Ether to another address.
 * 📦 Analogy: Different ways to send money to a friend — bank transfer, check, or cash in hand.
 */
contract SendEther {
    /**
     * @notice Sends Ether using `.transfer()`.
     * @param _to The recipient's payable address.
     * @dev No longer recommended because it forwards only 2300 gas.
     * 📬 Analogy: Sending a small envelope of cash — very restrictive.
     */
    function sendViaTransfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    /**
     * @notice Sends Ether using `.send()`.
     * @param _to The recipient's payable address.
     * @dev Returns `true` or `false`, so must check success manually. Not recommended.
     * 📬 Analogy: Sending cash via courier and calling to confirm delivery.
     */
    function sendViaSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    /**
     * @notice Sends Ether using `.call()` (recommended method).
     * @param _to The recipient's payable address.
     * @dev Returns success status and any returned data.
     * 📬 Analogy: Sending money with full flexibility — like an online bank transfer that can carry extra instructions.
     */
    function sendViaCall(address payable _to) public payable {
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}