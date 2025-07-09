// SPDX-License-Identifier: MIT
// 🪪 Declares the code is open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or higher.

/// @title Array Removal by Shifting
/// @notice Demonstrates how to remove an element from a dynamic array by shifting the boxes to the left
/// @dev 📦 Imagine a row of boxes on a shelf. If you remove a box in the middle, you slide all the boxes after it to the left to fill the gap.
contract ArrayRemoveByShifting {
    /// @notice 📦 A dynamic row of boxes (array) where each box holds a number
    uint256[] public arr;

    /// @notice Removes the item at `_index` by shifting all subsequent boxes to the left
    /// @param _index The position of the box to remove
    /// @dev 🛻 Slides boxes left starting at `_index`, then pops off the duplicate box at the end
    function remove(uint256 _index) public {
        require(_index < arr.length, "index out of bounds");

        /// 📦 Start at the box to remove and move each following box one spot to the left
        for (uint256 i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        /// 🗑️ Remove the last (now duplicated) box
        arr.pop();
    }

    /// @notice Test function that runs example scenarios and checks results
    /// @dev 📋 Runs two scenarios: one with multiple boxes, one with a single box
    function test() external {
        /// 🪜 Scenario 1: start with 5 boxes and remove the 3rd one
        arr = [1, 2, 3, 4, 5];
        remove(2); // removes `3`
        // Expected: [1, 2, 4, 5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        /// 🪜 Scenario 2: start with 1 box and remove it
        arr = [1];
        remove(0); // removes `1`
        // Expected: []
        assert(arr.length == 0);
    }
}
