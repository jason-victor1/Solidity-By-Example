// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// This is a simple Counter contract that allows users to view, increment, and decrement a counter.

contract Counter {
    // State variable to store the current count
    uint256 public count;

    // Function to get the current value of the count
    // This is a view function that does not modify the state.
    // @return uint256 - The current value of the count.
    function get() public view returns (uint256) {
        return count;
    }

    // Function to increment the count by 1
    // This modifies the state by increasing the count variable.
    function inc() public {
        count += 1;
    }

    // Function to decrement the count by 1
    // This modifies the state by decreasing the count variable.
    // Note: This could potentially underflow in earlier Solidity versions,
    // but underflow is prevented in Solidity >= 0.8.0.
    function dec() public {
        count -= 1;
    }
}
