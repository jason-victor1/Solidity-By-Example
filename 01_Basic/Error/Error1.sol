// SPDX-License-Identifier: MIT
// Specifies the license under which the code is released. The MIT license is a permissive license.

// Declares the Solidity compiler version. The `^0.8.26` means this code is compatible with compiler version 0.8.26 and above, but below 0.9.0.
pragma solidity ^0.8.26;

/// @title 🚨 Error Handling in Solidity
/// @author ✍️
/// @notice Demonstrates the use of `require`, `revert`, `assert`, and custom errors.
/// @dev Use appropriate error types to validate inputs, maintain invariants, and handle execution logic.

contract Error {
    /// @notice 🧪 Validates that `_i` is greater than 10 using `require`.
    /// @dev Think of `require` like a security checkpoint — if input is invalid, the door slams shut.
    /// @param _i The input number to validate.
    function testRequire(uint256 _i) public pure {
        require(_i > 10, "Input must be greater than 10");
    }

    /// @notice 🔄 Validates `_i` using a manual check and `revert`.
    /// @dev Use `revert` for complex logic. It's like a manual override to abort if things don’t look right.
    /// @param _i The input number to validate.
    function testRevert(uint256 _i) public pure {
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }

    /// @notice 🔐 A state variable that should remain unchanged (default = 0).
    uint256 public num;

    /// @notice 🧯 Uses `assert` to confirm an internal condition never breaks.
    /// @dev `assert` is like a fire alarm: it should *never* trigger under normal operation.
    /// @dev Here we assume `num` should always stay 0; change would signal a critical bug.
    function testAssert() public view {
        assert(num == 0);
    }

    /// @notice ❗ Custom error to save gas and provide clarity.
    /// @dev Acts like a printed receipt showing what went wrong.
    /// @param balance The current balance.
    /// @param withdrawAmount The attempted withdrawal amount.
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    /// @notice ❌ Checks for insufficient balance using a custom error.
    /// @dev Cheaper than using `require` with a long string.
    /// @param _withdrawAmount Amount the caller wants to withdraw.
    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }
}