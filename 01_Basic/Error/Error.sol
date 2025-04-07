// SPDX-License-Identifier: MIT
// Specifies the license under which the code is released. The MIT license is a permissive license.

// Declares the Solidity compiler version. The `^0.8.26` means this code is compatible with compiler version 0.8.26 and above, but below 0.9.0.
pragma solidity ^0.8.26;

// Define the contract named `Error`.
contract Error {
    // Function to demonstrate the use of `require` for input validation.
    function testRequire(uint256 _i) public pure {
        // `require` validates that `_i` is greater than 10.
        // It reverts the transaction and provides an error message if the condition is false.
        // `require` is typically used to:
        // - Check user inputs (like here).
        // - Ensure preconditions are met before executing a function.
        // - Validate return values from external calls.
        require(_i > 10, "Input must be greater than 10");
    }

    // Function to demonstrate the use of `revert` for custom error handling.
    function testRevert(uint256 _i) public pure {
        // `revert` is useful for complex conditions that may require more than a simple `require`.
        // In this case, it performs the same check as `testRequire`.
        if (_i <= 10) {
            // `revert` stops execution and returns an error message.
            revert("Input must be greater than 10");
        }
    }

    // Public state variable of type `uint256` with a default value of 0.
    // The `public` keyword automatically creates a getter function for this variable.
    uint256 public num;

    // Function to demonstrate the use of `assert` to check for internal invariants.
    function testAssert() public view {
        // `assert` is used to check for conditions that should never fail.
        // Failing an `assert` indicates a bug in the contract, not an expected user error.
        // Here, we check that `num` is always 0, which is guaranteed because `num` is never modified.
        assert(num == 0);
    }

    // Define a custom error to demonstrate gas-efficient error handling.
    // Custom errors are used instead of strings in `require` or `revert` for lower gas costs.
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    // Function to demonstrate the use of a custom error.
    function testCustomError(uint256 _withdrawAmount) public view {
        // Get the balance of the contract.
        uint256 bal = address(this).balance;
        // Check if the withdrawal amount exceeds the contract's balance.
        if (bal < _withdrawAmount) {
            // `revert` with a custom error for gas-efficient error reporting.
            revert InsufficientBalance({
                balance: bal, // Current contract balance.
                withdrawAmount: _withdrawAmount // Amount requested for withdrawal.
            });
        }
    }
}
