// SPDX-License-Identifier: MIT
// 🪪 Open-source license plate: MIT lets anyone reuse this code.

pragma solidity ^0.8.26;
// 🛠️ Compiler version lock—keeps everyone on the same toolkit.

/* 🌳 Inheritance tree diagram
   A
 /  \
B   C
 \ /
  D
*/

/**
 * @title Contract A
 * @dev The grandparent contract that defines two basic functions and logs.
 * 🧓 Think of this like the family elder who sets the basic rules (functions) for everyone else.
 */
contract A {
    /// @notice Emitted when a function is called, for tracking in logs.
    event Log(string message);

    /**
     * @notice Basic function that logs when called.
     * 🪧 Think of this like saying "A.foo called" on a speaker.
     */
    function foo() public virtual {
        emit Log("A.foo called");
    }

    /**
     * @notice Another basic function that logs its invocation.
     */
    function bar() public virtual {
        emit Log("A.bar called");
    }
}

/**
 * @title Contract B
 * @dev Child of A. Overrides functions to extend or modify behavior.
 * 👨 Think of this as one child who adds their voice after calling the elder.
 */
contract B is A {
    /// @notice Overrides A's foo and adds its own message before calling A.
    function foo() public virtual override {
        emit Log("B.foo called");
        A.foo(); // Directly calls A
    }

    /// @notice Overrides A's bar and calls the parent function using `super`.
    function bar() public virtual override {
        emit Log("B.bar called");
        super.bar(); // Calls the next most base contract (in C3 linearization)
    }
}

/**
 * @title Contract C
 * @dev Another child of A with similar override behavior.
 * 👩 Another sibling who also speaks and then refers to the elder.
 */
contract C is A {
    function foo() public virtual override {
        emit Log("C.foo called");
        A.foo(); // Direct call
    }

    function bar() public virtual override {
        emit Log("C.bar called");
        super.bar(); // Uses inheritance path
    }
}

/**
 * @title Contract D
 * @dev Inherits from both B and C, demonstrating multiple inheritance.
 * 👨‍👩‍👧 Child of both B and C — learns rules from both parents.
 *
 * 🔍 Behavior:
 * - `D.foo()` will follow the path defined in Solidity's linearization:
 *   Since `super.foo()` is used, it looks at `C`, then `A`.
 *   So it will log:
 *     - "C.foo called"
 *     - "A.foo called"
 *
 * - `D.bar()` will log messages from `C`, then `B`, then `A` (without duplicates).
 */
contract D is B, C {
    /// @notice Overrides both B and C's foo and uses `super` to follow the inheritance path.
    function foo() public override(B, C) {
        super.foo(); // Follows C3 linearization: C -> A
    }

    /// @notice Demonstrates chained super calls with no duplication in logging.
    function bar() public override(B, C) {
        super.bar(); // Follows C -> B -> A
    }
}