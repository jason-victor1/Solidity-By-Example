// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//
// 📚 Math Library
//
library Math {
    /**
     * @title Math Library
     * @dev Provides utility math functions like square root.
     *
     * 🧮 Analogy:
     * Think of a library as a **toolbox** filled with reusable gadgets.
     * - Instead of rewriting the square root function everywhere,
     * - You grab the `sqrt` tool from the Math toolbox.
     */

    /**
     * @notice Calculates the integer square root of a number.
     * @dev Uses the Babylonian method (an iterative approach).
     *
     * 🏗️ Analogy:
     * Imagine guessing the square root of a number:
     * - Start with a rough guess (`y/2 + 1`).
     * - Refine it step by step until the guess stabilizes.
     * - Return the final “closest square root” without decimals.
     *
     * @param y The number to find the square root of.
     * @return z The integer square root result.
     */
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2; // 🔁 Refining guess iteratively.
            }
        } else if (y != 0) {
            z = 1; // For small numbers (1,2,3), sqrt = 1.
        }
        // else z = 0 (default value for y == 0).
    }
}

//
// 🏗️ Test Contract for Math
//
contract TestMath {
    /**
     * @notice Tests the `Math.sqrt` function.
     * @param x The number to compute the square root of.
     * @return The integer square root of `x`.
     *
     * 🎯 Analogy:
     * This contract is like a **workbench** where you take the `sqrt` tool
     * out of the toolbox and try it out on some number `x`.
     */
    function testSquareRoot(uint256 x) public pure returns (uint256) {
        return Math.sqrt(x);
    }
}

//
// 📚 Array Library
//
library Array {
    /**
     * @title Array Library
     * @dev Provides utility functions for arrays, like removing elements without gaps.
     *
     * 📦 Analogy:
     * Think of this as a **closet organizer**:
     * - If you remove a box from the middle,
     * - You slide the last box into the empty slot,
     * - And shrink the closet by one spot.
     */

    /**
     * @notice Removes an element at a given index from the array.
     * @dev Swaps the last element into the deleted slot, then pops the last.
     *
     * 🪣 Analogy:
     * Imagine an array as a row of buckets:
     * - If you remove bucket #2, don’t leave a gap.
     * - Instead, move the last bucket into #2’s position.
     * - Then remove the last bucket to shrink the row.
     *
     * @param arr The array to modify (storage).
     * @param index The index of the element to remove.
     */
    function remove(uint256[] storage arr, uint256 index) public {
        require(arr.length > 0, "Can't remove from empty array"); // 🚫 Must not be empty.
        arr[index] = arr[arr.length - 1]; // 🔄 Move last element to fill the gap.
        arr.pop();                        // ✂️ Remove the duplicate last element.
    }
}

//
// 🏗️ Test Contract for Array
//
contract TestArray {
    /**
     * @notice Attach the `Array` library’s functions to `uint256[]` arrays.
     * @dev This allows calling `arr.remove(index)` directly.
     */
    using Array for uint256[];

    /// @notice Example storage array for testing.
    uint256[] public arr;

    /**
     * @notice Demonstrates removing an element from an array with the library.
     * @dev Builds an array [0,1,2], removes index 1, leaving [0,2].
     *
     * 🛠️ Analogy:
     * - Start with 3 buckets labeled 0,1,2.
     * - Remove bucket #1 → move bucket #2 into its place.
     * - Result: only buckets [0,2] remain, no gaps.
     *
     * Assertions confirm the final state.
     */
    function testArrayRemove() public {
        for (uint256 i = 0; i < 3; i++) {
            arr.push(i); // Fill array with [0,1,2].
        }

        arr.remove(1); // Remove index 1 → arr becomes [0,2].

        assert(arr.length == 2); // ✅ Check size is 2.
        assert(arr[0] == 0);     // ✅ First element is 0.
        assert(arr[1] == 2);     // ✅ Second element is 2.
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Math Library:
 * - `sqrt(y)`: Integer square root using Babylonian method.
 *
 * TestMath:
 * - `testSquareRoot(x)`: Quick way to test `sqrt`.
 *
 * Array Library:
 * - `remove(arr, index)`: Removes element by swapping with last, no gaps left.
 *
 * TestArray:
 * - `testArrayRemove()`: Shows [0,1,2] → remove index 1 → [0,2].
 *
 * 🚪 Real-World Analogy:
 * - Math library = calculator toolbox (square root function).
 * - Array library = closet organizer (no empty slots after removing a box).
 * - Test contracts = workbenches where you try out the tools in real scenarios.
 */
