// SPDX-License-Identifier: MIT
// 🪪 This is like giving your smart contract a license to operate under open-source rules.
// The MIT license allows others to use and remix your code freely.

pragma solidity ^0.8.26;
// 🛠️ This sets the version of the toolbox we’re using to build this contract—v0.8.26 includes safety features and bug fixes.

/// @title Demonstration of State, Local, and Global Variables
/// @notice Explains how different types of variables work in Solidity with real-world analogies
contract Variables {
    /// @notice A state variable representing a short text message
    /// @dev Like a permanent message written on a chalkboard visible to everyone
    string public text = "Hello";

    /// @notice A state variable holding a number
    /// @dev Imagine a counter posted on the wall of a public ledger; this one starts at 123
    uint256 public num = 123;

    /// @notice A function to demonstrate local and global variables
    /// @dev Think of this function like a one-time calculation you do on a piece of paper,
    /// where you reference both your personal notes and public clocks
    function doSomething() public view {
        // 📝 Local variable: Only used temporarily inside this function, not stored on the blockchain
        uint256 i = 456; // Like writing a temporary number on a sticky note while doing a quick calculation

        // ⏰ Global variable: Gives the current block's timestamp
        uint256 timestamp = block.timestamp; // Like checking the current time on the room's official wall clock

        // 🧑 Caller’s address: The wallet address of the person who called this function
        address sender = msg.sender; // Like asking “Who just knocked on the door?”
    }
}