// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Assembly Conditionals in Yul
/// @author Your Name
/// @notice Demonstrates conditional logic (`if` and `switch`) using Yul assembly language
/// @dev This contract is intended for educational purposes to understand low-level conditionals in the EVM
contract AssemblyIf {

    /// @notice Checks if the input is less than 10 and sets output to 99 if true
    /// @dev Uses inline assembly (`Yul`) to evaluate a basic conditional with no `else`
    /// @param x A number to compare against the threshold (10)
    /// @return z Returns 99 if x < 10, otherwise returns 0 (default)
    ///
    /// 🔍 Analogy:
    /// Think of this like a children's amusement park rule:
    /// - "If your age is less than 10, you get a free balloon 🎈 (99 points)"
    /// - "If you're older, you get nothing 🎈"
    function yul_if(uint256 x) public pure returns (uint256 z) {
        assembly {
            // If x is less than 10, assign 99 to z
            // lt stands for "less than"
            if lt(x, 10) { z := 99 }
        }
    }

    /// @notice Returns a specific number based on the input using a `switch-case` logic
    /// @dev Demonstrates Yul’s version of switch-case with default fallback
    /// @param x The input value to evaluate
    /// @return z Returns 10 if x is 1, 20 if x is 2, otherwise returns 0
    ///
    /// 🎮 Analogy:
    /// Think of this like pressing a button on a vending machine:
    /// - Press 1 → Get Soda 🥤 (10)
    /// - Press 2 → Get Juice 🧃 (20)
    /// - Press any other key → Get Water 💧 (0)
    function yul_switch(uint256 x) public pure returns (uint256 z) {
        assembly {
            switch x
            case 1 { z := 10 }
            case 2 { z := 20 }
            default { z := 0 }
        }
    }
}
