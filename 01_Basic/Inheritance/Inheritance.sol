// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 
Graph of inheritance
    A
   / \
  B   C
 / \ /
F  D,E
This graph shows the inheritance hierarchy where:
- A is the base contract.
- B and C inherit from A.
- D inherits from B and C.
- E inherits from C and B (different order from D).
- F inherits from A and B.
*/

/**
 * @title Contract A
 * @dev Base contract with a virtual function `foo`.
 * 🏛️ Think of this as a grandparent with a default message.
 */
contract A {
    /// @notice Returns the name of the contract as a string
    /// @return The string "A"
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

/**
 * @title Contract B
 * @dev Inherits from A and overrides `foo`.
 * 👨‍👦 B is a child of A and modifies the inherited behavior.
 */
contract B is A {
    /// @inheritdoc A
    /// @return The string "B"
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

/**
 * @title Contract C
 * @dev Inherits from A and overrides `foo`.
 * 👩‍👧 Another child of A, changing the message to "C".
 */
contract C is A {
    /// @inheritdoc A
    /// @return The string "C"
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

/**
 * @title Contract D
 * @dev Inherits from B and C. Uses the version of `foo()` from the right-most parent, C.
 * 🧬 Demonstrates Solidity's right-to-left and depth-first inheritance resolution.
 */
contract D is B, C {
    /// @notice Returns the overridden version of foo from C.
    /// @inheritdoc B
    /// @inheritdoc C
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo(); // Returns "C"
    }
}

/**
 * @title Contract E
 * @dev Inherits from C and B. Uses the version of `foo()` from the right-most parent, B.
 * 🔁 Same as D but switches the order to show how inheritance order matters.
 */
contract E is C, B {
    /// @notice Returns the overridden version of foo from B.
    /// @inheritdoc C
    /// @inheritdoc B
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo(); // Returns "B"
    }
}

/**
 * @title Contract F
 * @dev Demonstrates the correct inheritance order: most base-like to most derived.
 * ❗ Reversing the order would cause a compilation error.
 */
contract F is A, B {
    /// @inheritdoc A
    /// @inheritdoc B
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo(); // Returns "B"
    }
}