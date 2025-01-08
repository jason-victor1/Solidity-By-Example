// SPDX-License-Identifier: MIT
// Specifies the license type for the contract, required for open-source compliance.

pragma solidity ^0.8.26;

// Declares the Solidity compiler version required to compile this contract.
// ^0.8.26 means this contract is compatible with version 0.8.26 and later patch versions.

contract IfElse {
    // Defines a new contract named "IfElse".

    function foo(uint256 x) public pure returns (uint256) {
        // A public function named "foo" that takes an unsigned integer `x` as input
        // and returns an unsigned integer. It is marked as `pure` because it does not
        // read or modify the blockchain state.

        if (x < 10) {
            // If the input `x` is less than 10, return 0.
            return 0;
        } else if (x < 20) {
            // If the input `x` is between 10 (inclusive) and 20 (exclusive), return 1.
            return 1;
        } else {
            // If the input `x` is 20 or greater, return 2.
            return 2;
        }
    }

    function ternary(uint256 _x) public pure returns (uint256) {
        // A public function named "ternary" that takes an unsigned integer `_x` as input
        // and returns an unsigned integer. It is also marked as `pure`.

        // The below commented-out code is the standard if/else equivalent:
        // if (_x < 10) {
        //     return 1;
        // }
        // return 2;

        // Shorthand way to write the above if/else statement using the ternary operator.
        // The "?" operator is the ternary operator, which acts as a concise if/else.

        return _x < 10 ? 1 : 2;
        // If `_x` is less than 10, return 1. Otherwise, return 2.
    }
}
