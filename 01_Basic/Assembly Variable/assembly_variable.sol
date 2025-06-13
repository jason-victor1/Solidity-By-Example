// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Assembly Variable Demo
/// @notice Demonstrates the use of Yul (inline assembly) to define local variables in Solidity.
/// @dev This contract uses Yul for educational purposes. It introduces `let` for defining temporary variables in low-level code.
contract AssemblyVariable {

    /// @notice Executes a Yul assembly block to demonstrate how to define local variables.
    /// @dev Inside the assembly block, a variable `x` is defined and discarded, while `z` is returned.
    /// @return z The number 456, demonstrating how to assign values in Yul.
    ///
    /// 📦 Analogy:
    /// Imagine you're in a workshop (assembly) doing quick calculations with sticky notes.
    /// - You write "123" on one sticky note (named `x`) just to see how it feels. You throw it away.
    /// - You write "456" on another note (`z`) and hand it back as your final answer.
    function yul_let() public pure returns (uint256 z) {
        assembly {
            // 🛠️ Yul is Ethereum's low-level language for advanced operations
            // 📝 `let x := 123` creates a temporary note named x with the number 123
            let x := 123
            // 📤 `z := 456` prepares the return value with 456
            z := 456
        }
    }
}

