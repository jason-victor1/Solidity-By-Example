// SPDX-License-Identifier: MIT
// 🪪 Open-source license

pragma solidity ^0.8.26;
// 🛠️ Solidity version with support for transient storage (requires Cancun upgrade)

// 🧠 KEY CONCEPTS:
// Storage: 🗃️ Permanent file cabinet on the blockchain
// Memory: 🧽 Dry-erase whiteboard — erased after every function call
// Transient storage: ⚡ Temporary sticky note — erased after the transaction ends

// 📡 An interface shared between contracts for calling test/val functions
interface ITest {
    function val() external view returns (uint256);
    function test() external;
}

contract Callback {
    uint256 public val; // 🗃️ Permanent variable to store the returned value

    // 🔔 Fallback function: triggered when this contract receives a call with unknown function
    fallback() external {
        // 📞 Ask the caller (msg.sender) for their value, and save it here
        val = ITest(msg.sender).val();
    }

    // 🧪 Function to call `test()` on another contract
    function test(address target) external {
        // 🔁 Calls the test function on another contract (could be TestStorage or TestTransientStorage)
        ITest(target).test();
    }
}

contract TestStorage {
    uint256 public val; // 🗃️ Permanent storage value

    function test() public {
        val = 123; // 🖊️ Write 123 into the storage (won’t disappear after transaction ends)

        bytes memory b = ""; // 📨 Prepare an empty call (used to trigger fallback on msg.sender)
        msg.sender.call(b); // 🔔 Call back to sender (e.g., Callback), triggering its fallback()
    }
}

contract TestTransientStorage {
    bytes32 constant SLOT = 0; // 🧮 Defines a fixed location to write in transient storage

    function test() public {
        assembly {
            tstore(SLOT, 321) // ⚡ Write 321 into transient storage at slot 0
        }

        bytes memory b = ""; // 📨 Trigger empty call
        msg.sender.call(b);  // 🔔 Call sender (e.g., Callback)
    }

    function val() public view returns (uint256 v) {
        assembly {
            v := tload(SLOT) // ⚡ Read from transient slot 0 (only valid within the same transaction)
        }
    }
}

contract MaliciousCallback {
    uint256 public count = 0;

    fallback() external {
        // 🔁 Attack! When fallback is triggered, call back into the sender
        ITest(msg.sender).test(); // 💥 Try to reenter into `test()` — dangerous!
    }

    function attack(address _target) external {
        // 🎯 Start the attack by calling test() on a target contract
        ITest(_target).test(); // 💣 Begins first entry point into reentrant loop
    }
}

contract ReentrancyGuard {
    bool private locked; // 🔒 A door lock to prevent multiple entries at once

    modifier lock() {
        require(!locked, "Already in use!"); // 🚪 Must be unlocked to enter
        locked = true; // 🔐 Lock the door
        _;
        locked = false; // 🔓 Unlock after done
    }

    function test() public lock {
        // 🧪 Try to call back the sender (may trigger fallback or reentrancy)
        bytes memory b = "";
        msg.sender.call(b);
        // 💡 This version uses more gas (~27,587) because it's using storage
    }
}

contract ReentrancyGuardTransient {
    bytes32 constant SLOT = 0; // 🧮 Fixed slot in transient space

    modifier lock() {
        assembly {
            if tload(SLOT) { revert(0, 0) } // 🚫 If slot already set, revert (locked)
            tstore(SLOT, 1) // ✅ Set slot to locked
        }
        _; // 🔁 Run the protected function
        assembly {
            tstore(SLOT, 0) // 🔓 Clear lock after function finishes
        }
    }

    function test() external lock {
        // 🧪 Try to reenter through fallback (if caller is malicious)
        bytes memory b = "";
        msg.sender.call(b);
        // 💡 Uses transient lock = cheaper (~4,909 gas)
    }
}


