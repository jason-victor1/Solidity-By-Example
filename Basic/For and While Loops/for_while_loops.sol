// SPDX-License-Identifier: MIT              // License identifier indicating the code is open-source.
pragma solidity ^0.8.26;                     // Specifies the Solidity compiler version to be used.

contract Loop {
    // A public function 'loop' marked as pure, meaning it doesn't modify or read state.
    function loop() public pure {
        // -----------------------------
        // FOR LOOP
        // -----------------------------
        // Initiate a for loop with an unsigned integer 'i' starting from 0, 
        // running until 'i' is less than 10, and incrementing 'i' after each iteration.
        for (uint256 i = 0; i < 10; i++) {
            // Check if 'i' is equal to 3.
            if (i == 3) {
                // 'continue' skips the rest of the current loop iteration when 'i' equals 3.
                continue;
            }
            // Check if 'i' is equal to 5.
            if (i == 5) {
                // 'break' exits the loop entirely when 'i' equals 5.
                break;
            }
        }

        // -----------------------------
        // WHILE LOOP
        // -----------------------------
        // Declare an unsigned integer 'j' (automatically initialized to 0).
        uint256 j;
        // Continue looping while 'j' is less than 10.
        while (j < 10) {
            // Increment 'j' by 1 during each iteration.
            j++;
        }
    }
}
