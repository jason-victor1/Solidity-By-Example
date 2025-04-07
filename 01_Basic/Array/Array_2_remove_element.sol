// SPDX-License-Identifier: MIT
// 🪪 Declares the code is open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or higher.

// 🏢 This contract simulates a shelf with boxes (array).
// When a box is removed, all boxes to the right slide left to fill the empty spot.
contract ArrayRemoveByShifting {
    // 📦 Dynamic array of unsigned integers—represents a row of boxes.
    uint256[] public arr;

    // ❌ Removes a box at a given position by shifting all boxes after it one step to the left.
    function remove(uint256 _index) public {
        // 🧯 Check if the index is valid. You can't remove a box that doesn't exist.
        require(_index < arr.length, "index out of bounds");

        // 🔁 Slide each box to the left, starting at the index to remove.
        for (uint256 i = _index; i < arr.length - 1; i++) {
            // 🧳 Each box takes the label/value of the one to its right.
            arr[i] = arr[i + 1];
        }

        // 🧹 Cut off the last box (now duplicated) to keep the shelf clean.
        arr.pop();
    }

    // 🧪 Demo function to showcase how the shifting removal works in real scenarios.
    function test() external {
        // 🧰 Start with boxes labeled [1, 2, 3, 4, 5]
        arr = [1, 2, 3, 4, 5];

        // ❌ Remove the box at index 2 (which has value 3)
        remove(2); // Shelf becomes [1, 2, 4, 5]

        // ✅ Confirm each box is correctly relabeled:
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4); // One box removed

        // 🧰 Now test with only one box on the shelf
        arr = [1];
        // ❌ Remove the only box
        remove(0); // Shelf becomes empty
        assert(arr.length == 0);
    }
}
