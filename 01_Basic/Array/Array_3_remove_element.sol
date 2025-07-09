// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the Solidity compiler to ensure compatibility and security.

/// @title Array Replace From End
/// @notice Demonstrates a compact way to remove an element from an array by replacing it with the last element
/// @dev 📦 Imagine a row of boxes on a shelf. To remove a box without sliding everything, you pick up the last box and put it in the removed box's spot — then throw away the now-empty last box.
contract ArrayReplaceFromEnd {
    /// @notice 📦 A dynamic row of boxes (array) where each box holds a number
    uint256[] public arr;

    /// @notice Removes the item at `index` by replacing it with the last box and then removing the last box
    /// @param index The position of the box to remove
    /// @dev 🪄 This method is more gas-efficient than shifting because it avoids moving all boxes to the left
    function remove(uint256 index) public {
        /// 🔄 Move the last box into the spot of the box to remove
        arr[index] = arr[arr.length - 1];
        /// 🗑️ Remove the now-duplicate last box
        arr.pop();
    }

    /// @notice Test function that runs example scenarios and checks results
    /// @dev 📋 Runs two scenarios: removing elements while keeping array compact
    function test() public {
        /// 🪜 Scenario 1: start with 4 boxes and remove the 2nd one
        arr = [1, 2, 3, 4];

        remove(1); 
        // Replaces `2` with `4`, expected array: [1, 4, 3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        /// 🪜 Scenario 2: remove the 3rd box (which is currently `3`)
        remove(2);
        // Replaces `3` with itself (`3` was last), expected array: [1, 4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}
