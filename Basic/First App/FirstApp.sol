// SPDX-License-Identifier: MIT
// 🪪 This is like your contract’s legal license plate.
// The MIT license allows others to use, modify, and share the code freely.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the builder's toolkit (Solidity compiler) to use.
// Version 0.8.26 ensures safety features like automatic underflow protection.

contract Counter {
    // 🧮 This is like a public scoreboard placed on the wall of a digital room.
    // It keeps track of a number (like how many people entered or how many times something happened).
    uint256 public count;

    // 🪟 A public window anyone can look through to see the current score.
    // This function doesn’t change anything—it just returns the current value.
    function get() public view returns (uint256) {
        return count;
    }

    // 🔼 This button increases the number on the scoreboard by 1.
    // Anyone can press it to increment the counter.
    function inc() public {
        count += 1;
    }

    // 🔽 This button decreases the number on the scoreboard by 1.
    // Solidity 0.8+ ensures it won't break by going below zero (no negative scores allowed).
    function dec() public {
        count -= 1;
    }
}
