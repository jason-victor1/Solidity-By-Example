// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Multiple Inheritance Example with Constructors
/// @notice Demonstrates how to pass parameters to base contracts and the order in which constructors are called.

// Base contract X
contract X {
    /// @notice Public variable to hold the name passed to the constructor
    string public name;

    /// @param _name The name to assign to this contract
    constructor(string memory _name) {
        name = _name;
    }
}

// Base contract Y
contract Y {
    /// @notice Public variable to hold the text passed to the constructor
    string public text;

    /// @param _text The text to assign to this contract
    constructor(string memory _text) {
        text = _text;
    }
}

/// @dev Demonstrates inheritance with inline parameter passing to parent constructors
/// @notice This contract inherits from X and Y, passing hardcoded values directly
contract B is X("Input to X"), Y("Input to Y") {}

/// @dev Demonstrates inheritance using constructor parameters
/// @notice This contract passes parameters via its own constructor
contract C is X, Y {
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

/// @dev Demonstrates constructor call order
/// @notice Constructor call order is based on inheritance order: X -> Y -> D
contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

/// @dev Even if constructor order is changed, base constructors are called in declaration order
/// @notice Constructor call order is still: X -> Y -> E
contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}
