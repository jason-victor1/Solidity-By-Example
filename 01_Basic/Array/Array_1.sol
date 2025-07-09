// SPDX-License-Identifier: MIT
// 🪪 Declares this contract is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity version used to compile the contract.

/// @title Array Examples
/// @notice Demonstrates how to use dynamic, fixed-size, and memory arrays in Solidity
/// @dev 🗃️ Think of arrays like rows of boxes where you can store, remove, or peek at items
contract Array {
    /// @notice A dynamic array of unsigned integers
    /// @dev 📦 A flexible row of boxes that grows and shrinks as needed
    uint256[] public arr;

    /// @notice A dynamic array initialized with three numbers
    /// @dev 📦📦📦 Pre-filled row of boxes with [1, 2, 3]
    uint256[] public arr2 = [1, 2, 3];

    /// @notice A fixed-size array of length 10
    /// @dev 📏 Row of exactly 10 boxes, all starting at 0 and cannot grow/shrink
    uint256[10] public myFixedSizeArr;

    /// @notice Get the value at a specific index in `arr`
    /// @param i The position in the array
    /// @return The value stored at that position
    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    /// @notice Get the entire `arr` array
    /// @return The full dynamic array
    /// @dev ⚠️ Be cautious: returning large arrays can use a lot of gas
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    /// @notice Add a new value to the end of `arr`
    /// @param i The number to add
    /// @dev ➕ Adds a new box at the end and puts the number in it
    function push(uint256 i) public {
        arr.push(i);
    }

    /// @notice Remove the last value from `arr`
    /// @dev ➖ Takes away the last box from the row
    function pop() public {
        arr.pop();
    }

    /// @notice Get the current number of elements in `arr`
    /// @return The length of the array
    function getLength() public view returns (uint256) {
        return arr.length;
    }

    /// @notice Reset the value at a specific index to its default (0)
    /// @param index The position in the array to reset
    /// @dev 🧽 Clears the box but keeps the row the same length
    function remove(uint256 index) public {
        delete arr[index];
    }

    /// @notice Examples of creating arrays in memory
    /// @dev 📝 Memory arrays are like scratch paper — temporary and gone after use
    function examples() external pure {
        // 📝 Create a memory array with 5 boxes
        uint256 ;

        // 📝 Create a nested memory array (like two rows of boxes with 3 boxes each)
        uint256 ;
        for (uint256 i = 0; i < b.length; i++) {
            b ;
        }

        // 📋 Fill the boxes with values
        b[0][0] = 1;
        b[0][1] = 2;
        b[0][2] = 3;
        b[1][0] = 4;
        b[1][1] = 5;
        b[1][2] = 6;
    }
}
