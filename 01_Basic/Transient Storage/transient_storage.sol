// SPDX-License-Identifier: MIT
// 🪪 Open-source license

pragma solidity ^0.8.26;
// 🛠️ Solidity version with support for transient storage (requires Cancun upgrade)

/// @title 📒 Storage, Transient Storage & Reentrancy Examples
/// @author ✍️
/// @notice Demonstrates differences between storage types (storage, transient), and how to protect against reentrancy.
/// @dev 🗃️ Storage = permanent ledger (on-chain)  
///      📝 Memory = temporary during function  
///      🪄 Transient = wiped after the transaction ends  
///      🔒 Reentrancy guard = door lock to prevent sneaky re-entry attacks

/// @notice Interface defining functions used in callbacks.
interface ITest {
    /// @notice Read a value from the caller.
    function val() external view returns (uint256);

    /// @notice Trigger a test action in the caller.
    function test() external;
}

/// @notice 📞 Demonstrates receiving a callback from another contract.
contract Callback {
    /// @notice 🗃️ Stores the value returned from the caller.
    uint256 public val;

    /// @notice Fallback function — called when data doesn’t match any function.
    /// @dev Think of it like a catch-all mail slot — caller leaves you a value.
    fallback() external {
        val = ITest(msg.sender).val();
    }

    /// @notice Calls `test()` on the target contract.
    /// @param target The contract to test.
    function test(address target) external {
        ITest(target).test();
    }
}

/// @notice 🗃️ Demonstrates writing to **persistent storage**.
contract TestStorage {
    /// @notice 🗃️ Permanent variable.
    uint256 public val;

    /// @notice Sets `val` and then calls back the sender.
    function test() public {
        val = 123;
        bytes memory b = "";
        msg.sender.call(b); // Simulates callback.
    }
}

/// @notice ✨ Demonstrates writing to **transient storage** (clears after transaction).
contract TestTransientStorage {
    /// @dev Fixed storage slot key for transient storage.
    bytes32 constant SLOT = 0;

    /// @notice Writes a transient value then calls back the sender.
    function test() public {
        assembly {
            tstore(SLOT, 321) // write to transient storage.
        }
        bytes memory b = "";
        msg.sender.call(b);
    }

    /// @notice Reads the transient value.
    /// @return v The value in transient storage.
    function val() public view returns (uint256 v) {
        assembly {
            v := tload(SLOT)
        }
    }
}

/// @notice 🦹 A malicious contract that tries to reenter another contract.
contract MaliciousCallback {
    /// @notice Counter for attack attempts.
    uint256 public count = 0;

    /// @notice Fallback that re-calls `test()` to simulate reentrancy.
    fallback() external {
        ITest(msg.sender).test();
    }

    /// @notice Starts the attack.
    /// @param _target The target contract to attack.
    function attack(address _target) external {
        ITest(_target).test();
    }
}

/// @notice 🔒 A contract that protects against reentrancy with a simple lock.
contract ReentrancyGuard {
    bool private locked;

    /// @notice Lock modifier to prevent reentrancy.
    modifier lock() {
        require(!locked, "Reentrancy detected!");
        locked = true;
        _;
        locked = false;
    }

    /// @notice Example function guarded by `lock`.
    /// @dev Takes ~27587 gas.
    function test() public lock {
        bytes memory b = "";
        msg.sender.call(b);
    }
}

/// @notice 🔒 A reentrancy guard using transient storage for efficiency.
contract ReentrancyGuardTransient {
    bytes32 constant SLOT = 0;

    /// @notice Lock modifier using transient storage.
    /// @dev Takes ~4909 gas, more efficient than `bool`.
    modifier lock() {
        assembly {
            if tload(SLOT) { revert(0, 0) } // If already locked, fail.
            tstore(SLOT, 1)                 // Lock it.
        }
        _;
        assembly {
            tstore(SLOT, 0)                 // Unlock it.
        }
    }

    /// @notice Example function guarded by transient lock.
    function test() external lock {
        bytes memory b = "";
        msg.sender.call(b);
    }
}
