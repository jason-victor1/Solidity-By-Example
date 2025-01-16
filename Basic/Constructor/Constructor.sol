// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Base contract X
contract X {
    string public name; // Public variable to store a name

    // Constructor to initialize the 'name' variable
    constructor(string memory _name) {
        name = _name; // Assign the passed value to the 'name' variable
    }
}

// Base contract Y
contract Y {
    string public text; // Public variable to store a text

    // Constructor to initialize the 'text' variable
    constructor(string memory _text) {
        text = _text; // Assign the passed value to the 'text' variable
    }
}

// There are 2 ways to initialize parent contracts with parameters.

// Method 1: Pass the parameters directly in the inheritance list.
contract B is X("Input to X"), Y("Input to Y") {
    // In this case, the parameters for X and Y are set during inheritance
    // and cannot be modified later.
}

// Method 2: Pass the parameters in the child contract's constructor.
contract C is X, Y {
    // Constructor of the child contract that takes parameters
    // and passes them to the parent constructors explicitly.
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
    // This allows for more dynamic initialization at deployment.
}

// Note: Parent constructors are always executed in the order of inheritance.
// The order in which you list parent contracts in the child's constructor
// does not change this behavior.

// Example: Parent constructors are called in the following order:
// 1. X
// 2. Y
// 3. D
contract D is X, Y {
    // Constructor of the child contract initializes the parent contracts.
    constructor() X("X was called") Y("Y was called") {}
    // Even though the parameters for X and Y are set here, the order
    // of execution is determined by inheritance order (X, then Y).
}

// Example: Changing the order in the constructor does NOT change the execution order.
// Parent constructors are still called in the order of inheritance:
// 1. X
// 2. Y
// 3. E
contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
    // Despite Y being listed before X in this constructor,
    // X's constructor will always be executed first due to inheritance order.
}
