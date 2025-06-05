// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

///////////////////////////////////////////////////////////
// 🔢 Math Library: Utility for mathematical operations //
///////////////////////////////////////////////////////////
library Math {
    // 🧮 Calculates the integer square root of a number using the Babylonian method
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            // 📌 Start with the original value as the initial guess
            z = y;

            // 📐 Initial approximation (average of y and 1)
            uint256 x = y / 2 + 1;

            // 🔁 Refine the guess until convergence
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            // 📌 For values 1, 2, or 3 — return 1 as the floor square root
            z = 1;
        }
        // 🚫 If y == 0, z remains 0 (default uint256 value)
    }
}

///////////////////////////////////////////////////////////
// 🧪 TestMath: Contract to test square root functionality //
///////////////////////////////////////////////////////////
contract TestMath {
    // 🔬 Public function to test the Math.sqrt() utility
    function testSquareRoot(uint256 x) public pure returns (uint256) {
        return Math.sqrt(x); // 🧪 Delegates to library and returns result
    }
}

///////////////////////////////////////////////////////////
// 📦 Array Library: Efficient dynamic array manipulation //
///////////////////////////////////////////////////////////
library Array {
    // 🧹 Removes an element from an array by index without leaving a gap
    function remove(uint256[] storage arr, uint256 index) public {
        // 🛑 Prevents removing from an empty array
        require(arr.length > 0, "Can't remove from empty array");

        // 🔁 Replace the element to delete with the last element
        arr[index] = arr[arr.length - 1];

        // ✂️ Shrinks the array by removing the last element (now duplicated)
        arr.pop();
    }
}

///////////////////////////////////////////////////////////
// 🧪 TestArray: Contract to validate array removal logic //
///////////////////////////////////////////////////////////
contract TestArray {
    // 🛠️ Enables Array library functions on uint256[] type
    using Array for uint256[];

    // 📂 Dynamic array storage for test operations
    uint256[] public arr;

    // 🔬 Function to test the remove() utility
    function testArrayRemove() public {
        // ➕ Populate array with [0, 1, 2]
        for (uint256 i = 0; i < 3; i++) {
            arr.push(i);
        }

        // 🧼 Remove element at index 1 → Resulting array should be [0, 2]
        arr.remove(1);

        // ✅ Post-condition checks
        assert(arr.length == 2);  // Ensure array length is correct
        assert(arr[0] == 0);      // Check element at index 0
        assert(arr[1] == 2);      // Check new element at index 1 (originally last)
    }
}
