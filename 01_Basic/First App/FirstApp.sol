// SPDX-License-Identifier: MIT
// 🪪 This is like your contract’s legal license plate.
// The MIT license allows others to use, modify, and share the code freely.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the builder's toolkit (Solidity compiler) to use.
// Version 0.8.26 ensures safety features like automatic underflow protection.

/// @title Simple Scoreboard Counter
/// @notice A digital scoreboard where anyone can increase or decrease the count
/// @dev Demonstrates public state access and basic arithmetic with overflow protection
contract Counter {
    /// @notice The current score on the public digital scoreboard
    /// @dev Acts like a wall-mounted counter visible to everyone
    uint256 public count;

    /// @notice Lets you peek at the current number on the scoreboard
    /// @dev A read-only function that shows the current value without changing it
    /// @return The number currently stored in the counter
    function get() public view returns (uint256) {
        return count;
        // 🪟 This is like looking through a transparent window to see the scoreboard.
    }

    /// @notice Increases the scoreboard number by 1
    /// @dev This function increments the `count` variable with overflow safety (from Solidity 0.8+)
    function inc() public {
        count += 1;
        // 🔼 Like pressing an "UP" button to increase the score on a tally counter.
    }

    /// @notice Decreases the scoreboard number by 1
    /// @dev Decrements the `count`, ensuring no underflow (count can’t go below 0 in Solidity 0.8+)
    function dec() public {
        count -= 1;
        // 🔽 Like pressing a "DOWN" button to reduce the count—no negative scores allowed.
    }
}
