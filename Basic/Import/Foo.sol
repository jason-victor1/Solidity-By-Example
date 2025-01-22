// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26; // Specifies the Solidity version and licensing for the contract

// Define a struct named `Point`
// A struct is a custom data type used to group related variables
struct Point {
    uint256 x; // Represents the x-coordinate (unsigned integer)
    uint256 y; // Represents the y-coordinate (unsigned integer)
}

// Define a custom error named `Unauthorized`
// Custom errors are cheaper than string-based revert messages
// Parameters:
// - `caller`: The address of the unauthorized caller
error Unauthorized(address caller);

// Define a free function named `add`
// Free functions are not part of any contract and can be called independently
// Parameters:
// - `x`: The first unsigned integer
// - `y`: The second unsigned integer
// Returns:
// - The sum of `x` and `y`
function add(uint256 x, uint256 y) pure returns (uint256) {
    return x + y; // Adds `x` and `y` and returns the result
}

// Define a contract named `Foo`
contract Foo {
    // Declare a public state variable `name` of type `string`
    // The `public` keyword automatically generates a getter function for `name`
    string public name = "Foo"; // Initializes `name` with the value "Foo"
}
