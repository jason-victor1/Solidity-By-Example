// SPDX-License-Identifier: MIT
// 🪪 This is the license plate for the contract—open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Sets the Solidity version for building this contract.

// 🏭 This contract is like a loop simulation lab where machines (loops) run test cycles.
contract Loop {
    // ⚙️ The "loop" function simulates logic flows without touching the blockchain.
    // It’s a dry run—no storage changes, just behavior demonstrations.
    function loop() public pure {
        // -----------------------------
        // 🔁 FOR LOOP - like a robot doing 10 passes
        // -----------------------------
        // Start with i = 0 (first shift), and run while i < 10 (max 10 shifts).
        // Increase i by 1 after every pass.
        for (uint256 i = 0; i < 10; i++) {
            // 🧍 If it’s shift #3 (i == 3), skip it.
            // This is like saying: "Worker #3 is off-duty—skip this shift."
            if (i == 3) {
                continue;
            }

            // 🛑 If it’s shift #5 (i == 5), stop the loop entirely.
            // Like hitting the emergency stop button on the conveyor belt.
            if (i == 5) {
                break;
            }
        }

        // -----------------------------
        // 🔁 WHILE LOOP - another style of repeating task
        // -----------------------------
        // Start with j = 0 (task count).
        uint256 j;

        // As long as j is under 10, keep looping.
        // This is like a machine repeating a task until it hits 10.
        while (j < 10) {
            // ⏫ Count the task after it's done.
            j++;
        }
    }
}
