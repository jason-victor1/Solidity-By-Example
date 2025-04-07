// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the Solidity compiler to ensure compatibility and security.

// 🏢 This contract is a smart storage room where you can quickly remove boxes from shelves by replacing them with the last one.
contract ArrayReplaceFromEnd {
    // 📦 Dynamic shelf (array) holding numbered boxes (uint256).
    uint256[] public arr;

    // ❌ This function removes a box at a given position by replacing it with the last box on the shelf.
    // 💡 It's faster than shifting everything left—ideal when order doesn't matter.
    function remove(uint256 index) public {
        // 🔄 Take the last box and use it to overwrite the one at 'index'.
        arr[index] = arr[arr.length - 1];

        // ✂️ Remove the last (now duplicated) box to keep the shelf clean.
        arr.pop();
    }

    // 🧪 A demo to show and test how this removal method works in practice.
    function test() public {
        // 🧰 Start with a shelf of 4 boxes labeled: [1, 2, 3, 4]
        arr = [1, 2, 3, 4];

        // ❌ Remove the box at index 1 (value 2).
        // 📦 Replace it with the last box (4), so it becomes: [1, 4, 3, 4]
        // ✂️ Then cut off the duplicate last box → [1, 4, 3]
        remove(1);
        assert(arr.length == 3);  // Confirm one box was removed
        assert(arr[0] == 1);      // Original first box still in place
        assert(arr[1] == 4);      // Index 1 now holds what used to be at the end
        assert(arr[2] == 3);      // Index 2 still has original value

        // ❌ Remove box at index 2 (which currently holds 3)
        // Last box is also 3, so replacement makes no visible change
        // ✂️ pop() trims the last item → shelf becomes: [1, 4]
        remove(2);
        assert(arr.length == 2);  // Confirm another box was removed
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}
