// SPDX-License-Identifier: MIT
// 🪪 This is the license plate for the contract—open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Sets the Solidity version for building this contract.

/// @title Loop Examples
/// @notice Demonstrates how to use `for` and `while` loops in Solidity with control statements
/// @dev 🔄 Think of these loops as walking along a path, deciding at each step whether to keep going, skip ahead, or stop
contract Loop {
    /// @notice Runs examples of `for` and `while` loops with `continue` and `break`
    /// @dev 🧪 This function only demonstrates looping logic — it doesn’t change blockchain state
    function loop() public pure {
        /// @dev 🚶 `for` loop: walk a path from 0 to 9, checking at each step
        for (uint256 i = 0; i < 10; i++) {
            if (i == 3) {
                // 🔂 Skip this step and move to the next — like ignoring step #3
                continue;
            }
            if (i == 5) {
                // 🛑 Stop walking altogether — like reaching your destination at step #5
                break;
            }
            // 📋 Otherwise, keep walking normally
        }

        /// @dev ⏳ `while` loop: keep walking until a condition is no longer true
        uint256 j;
        while (j < 10) {
            j++; // ➕ Take one step forward
            // 🪜 Keep going until you’ve taken 10 steps
        }
    }
}