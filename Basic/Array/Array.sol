// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Declare a contract named `Array`
contract Array {
    // Declare a dynamic array of uint256, accessible publicly
    uint256[] public arr;

    // Declare and initialize a dynamic array with three elements [1, 2, 3]
    uint256[] public arr2 = [1, 2, 3];

    // Declare a fixed-size array of length 10, where all elements are initialized to 0
    uint256[10] public myFixedSizeArr;

    // Function to get the value at a specific index in the `arr` array
    // Inputs:
    // - `i`: The index of the element to retrieve
    // Outputs:
    // - Returns the value at the specified index
    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    // Function to return the entire `arr` array
    // Note: Returning large arrays is not recommended for performance reasons, especially if the array grows indefinitely
    // Outputs:
    // - Returns the entire dynamic array `arr` as a memory array
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    // Function to add an element to the end of the `arr` array
    // Inputs:
    // - `i`: The value to append to the array
    // Behavior:
    // - Appends the value `i` to the end of the array
    // - Increases the length of the array by 1
    function push(uint256 i) public {
        arr.push(i);
    }

    // Function to remove the last element from the `arr` array
    // Behavior:
    // - Removes the last element
    // - Decreases the length of the array by 1
    function pop() public {
        arr.pop();
    }

    // Function to get the current length of the `arr` array
    // Outputs:
    // - Returns the length of the dynamic array `arr`
    function getLength() public view returns (uint256) {
        return arr.length;
    }

    // Function to reset the value at a specific index in the `arr` array to its default value
    // Inputs:
    // - `index`: The index of the element to reset
    // Behavior:
    // - Sets the value at the specified index to its default value (0 for `uint256`)
    // - Does not change the length of the array
    function remove(uint256 index) public {
        delete arr[index];
    }

    // Function to demonstrate creating a fixed-size array in memory
    // Note: Memory arrays are temporary and only exist during function execution
    function examples() external pure {
        // Create a fixed-size memory array of length 5
        // All elements are initialized to 0
        uint256n of Changes:
1. Added **descriptive comments** to each section of the code to clarify what the function or variable does.
2. Explained the **input parameters** and **outputs** for functions.
3. Provided additional **context** where necessary, such as recommendations against returning large arrays (`getArr`) or the behavior of `delete`. 

