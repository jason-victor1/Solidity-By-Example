// SPDX-License-Identifier: MIT              // License identifier indicating open-source status.
pragma solidity ^0.8.26;                     // Specifies the Solidity compiler version.

contract ArrayRemoveByShifting {
    // Explanation of the removal process with shifting:
    // For an array like [1, 2, 3]:
    // - Removing the element at index 1 (value 2) shifts subsequent elements:
    //   [1, 2, 3] becomes [1, 3, 3] after shifting,
    //   then pop() removes the duplicate last element, resulting in [1, 3].
    //
    // Additional examples:
    // [1, 2, 3, 4, 5, 6] -- remove(2) (element 3) -->
    //     Shift: [1, 2, 4, 5, 6, 6] then pop() --> [1, 2, 4, 5, 6]
    // [1, 2, 3, 4, 5, 6] -- remove(0) (element 1) -->
    //     Shift: [2, 3, 4, 5, 6, 6] then pop() --> [2, 3, 4, 5, 6]
    // [1] -- remove(0) -->
    //     Shifting is trivial and pop() then leaves an empty array.

    // Dynamic array 'arr' that stores unsigned integers.
    uint256[] public arr;

    // Function to remove an element from the array at the given index by shifting elements.
    function remove(uint256 _index) public {
        // Check that the index is within the array bounds.
        require(_index < arr.length, "index out of bounds");

        // Loop from the index to the second-to-last element.
        // For each index, copy the value from the next index to the current index.
        for (uint256 i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        // Remove the last element which is now a duplicate after shifting.
        arr.pop();
    }

    // Test function to demonstrate and verify the removal functionality.
    function test() external {
        // Initialize the array with sample values.
        arr = [1, 2, 3, 4, 5];
        // Remove element at index 2 (which is the value 3)
        remove(2);
        // Expected array now is [1, 2, 4, 5]
        assert(arr[0] == 1);      // Verify first element is 1
        assert(arr[1] == 2);      // Verify second element is 2
        assert(arr[2] == 4);      // Verify third element is 4 (originally at index 3)
        assert(arr[3] == 5);      // Verify fourth element is 5 (originally at index 4)
        assert(arr.length == 4);  // Verify the array length is now 4

        // Test case for an array with a single element.
        arr = [1];
        // Remove the element at index 0.
        remove(0);
        // Expected array is now empty.
        assert(arr.length == 0);
    }
}
