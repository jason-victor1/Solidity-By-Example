// SPDX-License-Identifier: MIT
// 🪪 Declares this contract is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity version used to compile the contract.

// 🏢 This contract is a storage room filled with different kinds of shelves (arrays) for organizing numbers.
contract Array {
    // 📦 A dynamic shelf (array) named 'arr' that can expand or shrink.
    uint256[] public arr;

    // 📦 A pre-stocked dynamic shelf with three boxes: [1, 2, 3]
    uint256[] public arr2 = [1, 2, 3];

    // 🪵 A fixed-size shelf with 10 empty boxes (pre-built, can't grow or shrink)
    uint256[10] public myFixedSizeArr;

    // 🔍 Allows you to peek into the dynamic shelf and retrieve the box at position 'i'.
    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    // 📚 Returns a snapshot of the entire shelf `arr`—copied to memory.
    // Note: Can be gas-intensive if the shelf has many items.
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    // ➕ Adds a new box to the end of the shelf.
    function push(uint256 i) public {
        arr.push(i);
    }

    // ➖ Removes the last box from the shelf.
    function pop() public {
        arr.pop();
    }

    // 📏 Tells you how many boxes are currently on the shelf.
    function getLength() public view returns (uint256) {
        return arr.length;
    }

    // ❌ Empties a box at a specific spot but keeps the shelf the same size.
    // The slot at `index` is reset to zero (default value).
    function remove(uint256 index) public {
        delete arr[index];
    }

    // 🧪 A demonstration area showing temporary shelves and nested structures built in memory.
    function examples() external pure {
        // 🛠️ Create a temporary worktable with 5 slots.
        uint256 ;

        // 📦 Create a 2D temporary shelf: `b` holds 2 inner shelves.
        uint256 ;

        // 🧰 For each main slot in `b`, set up a sub-shelf with 3 boxes.
        for (uint256 i = 0; i < b.length; i++) {
            b ;
        }

        // 🧱 Fill first sub-shelf with [1, 2, 3]
        b[0][0] = 1;
        b[0][1] = 2;
        b[0][2] = 3;

        // 🧱 Fill second sub-shelf with [4, 5, 6]
        b[1][0] = 4;
        b[1][1] = 5;
        b[1][2] = 6;
    }
}
