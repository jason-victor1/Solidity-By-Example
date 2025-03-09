// SPDX-License-Identifier: MIT                  // License identifier indicating that this code is open-source.
pragma solidity ^0.8.26;                         // Specifies the Solidity compiler version to be used.

contract Array {
    // Declaration of dynamic array 'arr'. 
    // Dynamic arrays can change in length (grow or shrink) at runtime.
    uint256[] public arr;

    // Declaration and initialization of dynamic array 'arr2' with preset values [1, 2, 3].
    // The compiler infers the size based on the number of elements provided.
    uint256[] public arr2 = [1, 2, 3];

    // Declaration of a fixed-size array 'myFixedSizeArr' with 10 elements.
    // All elements are automatically initialized to 0.
    uint256[10] public myFixedSizeArr;

    // Function to get a specific element from the dynamic array 'arr' using an index.
    // This function is declared as view because it does not modify the state.
    function get(uint256 i) public view returns (uint256) {
        // Returns the element at index 'i' from array 'arr'.
        return arr[i];
    }

    // Function to return the entire dynamic array 'arr'.
    // Caution: Returning the whole array can be expensive in terms of gas if the array is large.
    // The function returns the array in memory.
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    // Function to add (push) an element to the end of the dynamic array 'arr'.
    // This operation increases the array's length by 1.
    function push(uint256 i) public {
        arr.push(i);
    }

    // Function to remove (pop) the last element from the dynamic array 'arr'.
    // This operation decreases the array's length by 1.
    function pop() public {
        arr.pop();
    }

    // Function to get the current length of the dynamic array 'arr'.
    // Useful for knowing how many elements are stored.
    function getLength() public view returns (uint256) {
        return arr.length;
    }

    // Function to remove an element from the dynamic array 'arr' at a specific index.
    // Note: The 'delete' operation resets the element at the given index to its default value (0 for uint256),
    // but it does not change the array length.
    function remove(uint256 index) public {
        delete arr[index];
    }

    // Function demonstrating examples of how to work with arrays in memory.
    // This function is declared as pure because it does not read or modify the contract's state.
    function examples() external pure {
        // Create a new dynamic array in memory with a fixed size of 5.
        // Memory arrays must have a fixed size.
        uint256[] memory a = new uint256[](5);

        // Create a nested dynamic array (2D array) in memory.
        // First, initialize an array 'b' that will contain 2 arrays.
        uint256[][] memory b = new uint256[][](2);
        // For each element of 'b', allocate a new dynamic array of size 3.
        for (uint256 i = 0; i < b.length; i++) {
            b[i] = new uint256[](3);
        }
        // Set the elements of the first inner array to [1, 2, 3].
        b[0][0] = 1;
        b[0][1] = 2;
        b[0][2] = 3;
        // Set the elements of the second inner array to [4, 5, 6].
        b[1][0] = 4;
        b[1][1] = 5;
        b[1][2] = 6;
    }
}
