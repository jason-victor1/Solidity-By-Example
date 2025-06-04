// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version specification for compatibility and safety.

// External contract used for try / catch examples
contract Foo {
// 📦 A contract with strict constructor requirements and a testable function for error handling demos.

    address public owner;
    // 👤 Public variable to store the address of the owner.

    constructor(address _owner) {
        // 🧱 Constructor that enforces input constraints before assigning ownership.

        require(_owner != address(0), "invalid address");
        // ⚠️ Validates that the owner is not the zero address (commonly used to represent 'null').

        assert(_owner != 0x0000000000000000000000000000000000000001);
        // 🧨 Fails hard if the owner is exactly the 0x01 address—used to demonstrate assert failure.

        owner = _owner;
        // ✅ Sets the valid owner.
    }

    function myFunc(uint256 x) public pure returns (string memory) {
        // 🛠️ Function that fails if input is zero, otherwise returns a success message.

        require(x != 0, "require failed");
        // ⚠️ Reverts if input value is zero—used to demonstrate try/catch with require.

        return "my func was called";
        // ✅ Returns confirmation string if the input was valid.
    }
}

contract Bar {
// 🧪 Contract that demonstrates try/catch with both function calls and contract creation.

    event Log(string message);
    // 📣 Event to log human-readable success or failure messages.

    event LogBytes(bytes data);
    // 📦 Event to log low-level error data (typically from failed asserts).

    Foo public foo;
    // 🔗 Public reference to an external Foo contract.

    constructor() {
        // 🧱 Deploys a Foo contract upon construction and assigns it to the `foo` variable.

        foo = new Foo(msg.sender);
        // 🚀 Initializes Foo with the sender's address to be used in try/catch examples.
    }

    // Example of try / catch with external call
    // tryCatchExternalCall(0) => Log("external call failed")
    // tryCatchExternalCall(1) => Log("my func was called")
    function tryCatchExternalCall(uint256 _i) public {
        // 🧪 Attempts to call Foo’s `myFunc` and catches errors if the call fails.

        try foo.myFunc(_i) returns (string memory result) {
            // 🔄 If the call succeeds, emit the returned message.
            emit Log(result);
        } catch {
            // ❌ If the call fails (e.g., require fails), emit a fallback error message.
            emit Log("external call failed");
        }
    }

    // Example of try / catch with contract creation
    // tryCatchNewContract(0x0000000000000000000000000000000000000000) => Log("invalid address")
    // tryCatchNewContract(0x0000000000000000000000000000000000000001) => LogBytes("")
    // tryCatchNewContract(0x0000000000000000000000000000000000000002) => Log("Foo created")
    function tryCatchNewContract(address _owner) public {
        // 🧪 Tries to deploy a new Foo contract and catches failures from require and assert.

        try new Foo(_owner) returns (Foo foo) {
            // ✅ If the contract is successfully deployed, log confirmation.
            emit Log("Foo created");
        } catch Error(string memory reason) {
            // ⚠️ Catches revert and require failures, emitting the reason as a string.
            emit Log(reason);
        } catch (bytes memory reason) {
            // 🧨 Catches assert failures or low-level reverts and emits raw bytes.
            emit LogBytes(reason);
        }
    }
}
