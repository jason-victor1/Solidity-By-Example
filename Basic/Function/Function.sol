// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Define a contract named Function
contract Function {
    // Function to return multiple values
    // This function returns a tuple containing a uint256, a bool, and another uint256
    function returnMany() public pure returns (uint256, bool, uint256) {
        return (1, true, 2); // Returns fixed values
    }

    // Function to return named values
    // The return variables are named (x, b, y) for better readability
    function named() public pure returns (uint256 x, bool b, uint256 y) {
        return (1, true, 2); // Assigns values to the named variables and returns them
    }

    // Function with assigned return values
    // Return variables are assigned values directly and the `return` statement is omitted
    function assigned() public pure returns (uint256 x, bool b, uint256 y) {
        x = 1; // Assign value to x
        b = true; // Assign value to b
        y = 2; // Assign value to y
        // No explicit return statement is needed
    }

    // Function demonstrating destructuring assignment
    // This function calls another function and extracts the returned values into local variables
    function destructuringAssignments()
        public
        pure
        returns (uint256, bool, uint256, uint256, uint256)
    {
        // Call the `returnMany` function and destructure its return values into i, b, and j
        (uint256 i, bool b, uint256 j) = returnMany();

        // Destructure values from a tuple, ignoring the middle value
        (uint256 x, , uint256 y) = (4, 5, 6);

        return (i, b, j, x, y); // Return all the extracted and newly assigned values
    }

    // Function to accept a dynamic array as input
    // Stores the input array `_arr` in the state variable `arr`
    function arrayInput(uint256[] memory _arr) public {
        arr = _arr; // Assign the input array to the storage variable
    }

    // State variable to store a dynamic array
    uint256[] public arr;

    // Function to return the stored array
    // This function returns the state variable `arr` as a memory array
    function arrayOutput() public view returns (uint256[] memory) {
        return arr; // Return the stored array
    }
}

// Define a contract named XYZ
contract XYZ {
    // Function with multiple inputs
    // Accepts various input types and returns the sum of the first three inputs
    function someFuncWithManyInputs(
        uint256 x, // First unsigned integer input
        uint256 y, // Second unsigned integer input
        uint256 z, // Third unsigned integer input
        address a, // Address input
        bool b, // Boolean input
        string memory c // String input
    ) public pure returns (uint256) {
        return x + y + z; // Return the sum of x, y, and z
    }

    // Function to call `someFuncWithManyInputs` with positional arguments
    function callFunc() external pure returns (uint256) {
        return someFuncWithManyInputs(1, 2, 3, address(0), true, "c"); // Call with fixed values
    }

    // Function to call `someFuncWithManyInputs` with key-value arguments
    function callFuncWithKeyValue() external pure returns (uint256) {
        return
            someFuncWithManyInputs({
                x: 1, // Assign 1 to x
                y: 2, // Assign 2 to y
                z: 3, // Assign 3 to z
                a: address(0), // Assign zero address to a
                b: true, // Assign true to b
                c: "c" // Assign "c" to c
            });
    }
}
