// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title AssemblyLoop - A contract demonstrating low-level Yul loops
/// @notice Shows how to use basic `for` and `while` loop logic in Yul (Solidity assembly)
/// @dev Think of this contract as a manual counting machine that mimics looping behavior
contract AssemblyLoop {

    /// @notice Demonstrates a `for` loop using Yul (assembly)
    /// @dev This loop runs 10 times, incrementing `z` by 1 in each iteration
    /// @return z The final count after completing the loop (should return 10)
    /// @custom:analogy Like a child counting from 0 to 9 and adding one candy 🍬 to a jar each time
    function yul_for_loop() public pure returns (uint256 z) {
        assembly {
            // Initialize a local counter variable i = 0
            // Continue looping while i < 10
            // In each loop: increment i by 1 and increment z by 1
            for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
                z := add(z, 1)
            }
        }
    }

    /// @notice Demonstrates a `while`-like loop using Yul (assembly)
    /// @dev This loop increments a counter and z until the counter reaches 5
    /// @return z The final count after completing the loop (should return 5)
    /// @custom:analogy Like stirring a pot 5 times — each stir increases the stir-count (`z`) 🥄
    function yul_while_loop() public pure returns (uint256 z) {
        assembly {
            // Set initial counter i = 0
            let i := 0

            // Loop with no explicit init/post actions in for syntax
            // Run while i < 5
            for {} lt(i, 5) {} {
                i := add(i, 1)   // increment counter
                z := add(z, 1)   // increment result
            }
        }
    }
}
