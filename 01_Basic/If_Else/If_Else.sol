// SPDX-License-Identifier: MIT
// 🪪 This license plate declares the contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ This specifies which version of the Solidity builder toolkit to use—v0.8.26 or compatible updates.

// 🧠 You're setting up a decision-making booth called "IfElse"
// It gives different responses based on the number visitors bring.
contract IfElse {

    // 🛎️ This is like a series of decision gates.
    // The "foo" function checks your input and returns a specific number as a result.
    // It's "pure" because it doesn’t touch or change anything outside—like a sealed testing chamber.
    function foo(uint256 x) public pure returns (uint256) {
        // 🧪 Step 1: Is the input less than 10? If so, return 0.
        if (x < 10) {
            return 0;
        } 
        // 🧪 Step 2: If not, is it under 20? If so, return 1.
        else if (x < 20) {
            return 1;
        } 
        // 🧪 Step 3: If it's 20 or more, return 2.
        else {
            return 2;
        }
    }

    // ⚡ A more compact switchboard version of the same logic.
    // "ternary" function is a quick check—like flipping a toggle switch.
    function ternary(uint256 _x) public pure returns (uint256) {
        // 🧮 The ternary operator is a shortcut: 
        // If `_x` is under 10, return 1. Otherwise, return 2.
        return _x < 10 ? 1 : 2;
    }
}

