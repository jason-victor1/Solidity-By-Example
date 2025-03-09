// SPDX-License-Identifier: MIT              // License identifier indicating open-source status.
pragma solidity ^0.8.26;                     // Specifies the Solidity compiler version to be used.

contract ArrayReplaceFromEnd {
    // Dynamic array 'arr' of unsigned integers.
    uint256[] public arr;

    // Function to remove an element at a specific index by replacing it with the last element.
    // This technique keeps the array compact without leaving a gap.
    function remove(uint256 index) public {
        // Replace the element at the given index with the last element in the array.
        // This effectively "overwrites" the element to be removed.
        arr[index] = arr[arr.length - 1];

        // Remove the last element of the array, which is now a duplicate.
        // The pop() function reduces the array length by 1.
        arr.pop();
    }

    // Test function to demonstrate and verify the removal logic.
    function test() public {
        // Initialize the array with four elements.
        arr = [1, 2, 3, 4];

        // Remove the element at index 1 (value 2).
        // The last element (4) is moved to index 1, resulting in the array: [1, 4, 3, 4]
        // Then, pop() removes the last element, yielding: [1, 4, 3]
        remove(1);
        // Check that the array length is now 3.
        assert(arr.length == 3);
        // Verify the updated array values.
        assert(arr[0] == 1);   // First element remains unchanged.
        assert(arr[1] == 4);   // Second element is replaced by the former last element.
        assert(arr[2] == 3);   // Third element remains unchanged.

        // Remove the element at index 2 (value 3) from the current array [1, 4, 3].
        // The last element (3) is moved to index 2, but since it's already there, the array remains [1, 4, 3],
        // and then pop() removes the last element, resulting in: [1, 4]
        remove(2);
        // Check that the array length is now 2.
        assert(arr.length == 2);
        // Verify the updated array values.
        assert(arr[0] == 1);   // First element remains unchanged.
        assert(arr[1] == 4);   // Second element remains unchanged.
    }
}
