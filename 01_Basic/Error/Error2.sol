// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title 💰 Simple Bank Account with Overflow and Underflow Protections
/// @author ✍️
/// @notice Simulates depositing and withdrawing from a secure account while preventing numerical errors.
/// @dev Uses `require`, `revert`, and `assert` to guard against overflow/underflow issues.

contract Account {
    /// @notice 📦 The current balance of the account.
    uint256 public balance;

    /// @notice 🧱 Represents the largest possible number a uint256 can hold.
    /// @dev This acts like the weight limit of an elevator—you can’t exceed it.
    uint256 public constant MAX_UINT = 2 ** 256 - 1;

    /// @notice ➕ Deposits an amount into the account.
    /// @dev Think of this like adding coins to a jar. We ensure the jar doesn't explode from overflow.
    /// @param _amount The number of tokens to deposit.
    function deposit(uint256 _amount) public {
        uint256 oldBalance = balance;
        uint256 newBalance = balance + _amount;

        /// 🛑 Make sure the new balance doesn’t wrap around due to overflow.
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;

        /// 🧯 Double-check to ensure our accounting is safe.
        assert(balance >= oldBalance);
    }

    /// @notice ➖ Withdraws an amount from the account.
    /// @dev Like taking coins out of your piggy bank—you can’t withdraw more than you have.
    /// @param _amount The number of tokens to withdraw.
    function withdraw(uint256 _amount) public {
        uint256 oldBalance = balance;

        /// ✅ Validate the user has enough balance before subtracting.
        require(balance >= _amount, "Underflow");

        /// 🔁 Extra safeguard using `revert`—might be used if a more complex check was needed.
        if (balance < _amount) {
            revert("Underflow");
        }

        balance -= _amount;

        /// 🔍 Make sure we didn’t subtract incorrectly.
        assert(balance <= oldBalance);
    }
}
