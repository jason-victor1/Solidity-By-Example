// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Import the Foo.sol contract from the current directory
import "./Foo.sol";

// Import specific symbols from Foo.sol with optional aliasing
// - `Unauthorized` is imported directly.
// - `add` is imported with the alias `func`.
// - `Point` struct is imported without modification.
import {Unauthorized, add as func, Point} from "./Foo.sol";

// Define a contract named `Import`
contract Import {
    // Declare a public instance of the Foo contract
    // This initializes a new Foo contract when `Import` is deployed
    Foo public foo = new Foo();

    // Define a function to test the Foo contract
    // Purpose: Retrieve the `name` variable from the Foo contract
    function getFooName() public view returns (string memory) {
        return foo.name(); // Call the `name` getter from the Foo contract
    }
}
