// SPDX-License-Identifier: MIT
// Specifies the license for the contract code. The MIT license allows anyone to reuse the code with minimal restrictions.

pragma solidity ^0.8.26;

/// @title 📣 Event Emission Example in Solidity
/// @author ✍️
/// @notice Demonstrates how to use events for logging data on the blockchain.
/// @dev Events are like public announcements recorded in a logbook that smart contracts can’t read, but external systems can.

contract Event {
    /// @notice 📢 Announces a message from a sender.
    /// @dev This event logs who sent it and what message they included. 
    /// Indexed parameters (like `sender`) can be searched efficiently by external systems like The Graph or Etherscan.
    /// @param sender 👤 The address of the user sending the message.
    /// @param message 📝 A string message that describes what happened.
    event Log(address indexed sender, string message);

    /// @notice 🔔 A simple signal with no data.
    /// @dev Can be used to indicate that something happened, like a light being turned on.
    event AnotherLog();

    /// @notice 🧪 Demonstrates emitting various events.
    /// @dev Think of this as a person shouting different announcements that get written down in a public log.
    function test() public {
        emit Log(msg.sender, "Hello World!");  // Like saying "Hi from me!"
        emit Log(msg.sender, "Hello EVM!");    // Another message from the same sender
        emit AnotherLog();                     // A generic bell ring saying "something happened"
    }
}