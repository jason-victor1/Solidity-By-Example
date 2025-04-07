// SPDX-License-Identifier: MIT
// Specifies the license for the code, making it open source under the MIT license.

pragma solidity ^0.8.26;

// Specifies the Solidity compiler version to use. This code is compatible with version 0.8.26 or any later version in the 0.8.x series.

contract ViewAndPure {
    // Declares a new smart contract named "ViewAndPure".

    uint256 public x = 1;

    // Declares a state variable `x` of type uint256 (unsigned integer) with an initial value of 1.
    // The `public` keyword makes this variable accessible outside the contract,
    // and Solidity automatically creates a getter function for it.

    // This function adds a given value `y` to the state variable `x`.
    // It promises not to modify the state (read-only).
    function addToX(uint256 y) public view returns (uint256) {
        // The `view` modifier indicates that this function can only read the state, not modify it.
        return x + y; // Returns the sum of the state variable `x` and the input parameter `y`.
    }

    // This function adds two input parameters `i` and `j` together.
    // It promises not to modify or even read the state.
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        // The `pure` modifier indicates that this function does not read or modify the contract's state.
        return i + j; // Returns the sum of the two input parameters `i` and `j`.
    }
}
