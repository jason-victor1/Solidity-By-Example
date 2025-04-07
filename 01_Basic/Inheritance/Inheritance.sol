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

contract A {
    // Base contract A with a virtual function `foo`
    function foo() public pure virtual returns (string memory) {
        return "A"; // Returns "A" when called
    }
}

// Contracts inherit other contracts by using the keyword 'is'.
contract B is A {
    // Overrides the foo() function of contract A
    function foo() public pure virtual override returns (string memory) {
        return "B"; // Returns "B" when called
    }
}

contract C is A {
    // Overrides the foo() function of contract A
    function foo() public pure virtual override returns (string memory) {
        return "C"; // Returns "C" when called
    }
}

// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times
// in different contracts, Solidity uses C3 Linearization to
// resolve the inheritance order.
// Parent contracts are searched from right to left and in a depth-first manner.

contract D is B, C {
    // Overrides the foo() function from both B and C
    // D.foo() resolves to C's implementation of foo()
    // because C is the rightmost parent in the inheritance list.
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo(); // Calls the foo() function of the most specific parent (C)
    }
}

contract E is C, B {
    // Overrides the foo() function from both C and B
    // E.foo() resolves to B's implementation of foo()
    // because B is the rightmost parent in the inheritance list.
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo(); // Calls the foo() function of the most specific parent (B)
    }
}

// Inheritance must be ordered from “most base-like” to “most derived”.
// If you swap the order of A and B in the inheritance list,
// it will throw a compilation error because A is the base contract.

contract F is A, B {
    // Overrides the foo() function from both A and B
    // F.foo() resolves to B's implementation of foo()
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo(); // Calls the foo() function of the most specific parent (B)
    }
}
