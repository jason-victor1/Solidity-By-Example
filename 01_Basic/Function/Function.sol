// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title 📋 Functions & Return Values in Solidity
/// @author ✍️
/// @notice Demonstrates how to write functions that return multiple values, use named returns, destructuring, and arrays.
/// @dev Useful as a reference for Solidity developers to see common patterns and best practices.

contract Function {
    /// @notice 🪙 Function that returns three values at once.
    /// @return First number, a boolean flag, and second number.
    function returnMany() public pure returns (uint256, bool, uint256) {
        return (1, true, 2);
    }

    /// @notice 📛 Function with *named* return values.
    /// @return x First number.
    /// @return b A boolean flag.
    /// @return y Second number.
    function named() public pure returns (uint256 x, bool b, uint256 y) {
        return (1, true, 2);
    }

    /// @notice 📝 Function with named & *assigned* return values.
    /// @dev Since values are assigned directly, `return` is optional.
    function assigned() public pure returns (uint256 x, bool b, uint256 y) {
        x = 1;  // like filling out a form field
        b = true;
        y = 2;
    }

    /// @notice 🔀 Shows how to use destructuring assignment when receiving multiple return values.
    /// @return i From `returnMany`
    /// @return b From `returnMany`
    /// @return j From `returnMany`
    /// @return x Locally defined
    /// @return y Locally defined
    function destructuringAssignments()
        public
        pure
        returns (uint256 i, bool b, uint256 j, uint256 x, uint256 y)
    {
        (i, b, j) = returnMany(); // Like unpacking a parcel with 3 items.

        // Values can be ignored with commas `_`.
        (x,, y) = (4, 5, 6); // Take first and third item from this package.

        // Return everything
    }

    /// @notice 📥 Accepts an array as input.
    /// @param _arr Array of numbers.
    function arrayInput(uint256[] memory _arr) public {
        // Like passing a shopping list.
    }

    /// @notice 📤 Returns an array.
    /// @return Array of stored numbers.
    uint256[] public arr;

    function arrayOutput() public view returns (uint256[] memory) {
        return arr; // Hand back the shopping list.
    }
}

/// @title 🎛️ Calling Functions With Many Parameters
/// @author ✍️
/// @notice Demonstrates calling functions with many parameters, including key-value syntax.
contract XYZ {
    /// @notice 🧾 Function with many parameters.
    /// @dev Demonstrates how to pass many arguments clearly.
    /// @param x First number.
    /// @param y Second number.
    /// @param z Third number.
    /// @param a An address.
    /// @param b Boolean flag.
    /// @param c A string.
    /// @return Placeholder return value.
    function someFuncWithManyInputs(
        uint256 x,
        uint256 y,
        uint256 z,
        address a,
        bool b,
        string memory c
    ) public pure returns (uint256) {
        // This is just a template — no actual logic.
    }

    /// @notice 🚀 Call `someFuncWithManyInputs` using ordered arguments.
    /// @return Return value from `someFuncWithManyInputs`.
    function callFunc() external pure returns (uint256) {
        return someFuncWithManyInputs(1, 2, 3, address(0), true, "c");
    }

    /// @notice 🔑 Call `someFuncWithManyInputs` using key-value syntax for clarity.
    /// @return Return value from `someFuncWithManyInputs`.
    function callFuncWithKeyValue() external pure returns (uint256) {
        return someFuncWithManyInputs({
            a: address(0),
            b: true,
            c: "c",
            x: 1,
            y: 2,
            z: 3
        });
    }
}