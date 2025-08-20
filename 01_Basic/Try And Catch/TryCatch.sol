// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version specification for compatibility and safety.

// External contract used for try / catch examples
contract Foo {
    /**
     * @title Foo
     * @dev A simple contract with constructor checks and a function that may fail.
     *
     * 🏷️ Analogy:
     * Think of Foo as a **strict office receptionist**:
     * - They refuse to onboard an owner if the address is invalid.
     * - They refuse to process requests with missing or broken input.
     */

    /// @notice The recorded owner of this Foo contract.
    address public owner;

    /**
     * @notice Sets the owner of Foo during deployment.
     * @dev Throws errors if owner address is invalid.
     *
     * 🚪 Analogy:
     * The receptionist will only accept an owner if:
     * - The address is not `0x0` (`require` check).
     * - The address is not the forbidden "bad address" (`assert` check).
     *
     * @param _owner The intended owner’s address.
     */
    constructor(address _owner) {
        require(_owner != address(0), "invalid address"); // ❌ No zero address allowed.
        assert(_owner != 0x0000000000000000000000000000000000000001); // 🚫 Forbidden test address.
        owner = _owner; // ✅ Owner is set if checks pass.
    }

    /**
     * @notice Demonstration function that returns a success message unless `x` is zero.
     * @dev Uses `require` to validate the input.
     *
     * 📦 Analogy:
     * The receptionist checks if the input form (`x`) is valid.
     * - If `x == 0`, the form is rejected ("require failed").
     * - Otherwise, the receptionist happily says: "my func was called".
     *
     * @param x Input value.
     * @return A success message string.
     */
    function myFunc(uint256 x) public pure returns (string memory) {
        require(x != 0, "require failed"); // 🚫 Rejects empty forms.
        return "my func was called";       // ✅ Accepts valid ones.
    }
}

contract Bar {
    /**
     * @title Bar
     * @dev Demonstrates Solidity’s `try / catch` for external calls and contract creation.
     *
     * 🛠️ Analogy:
     * Think of Bar as a **test lab**:
     * - It makes requests to Foo’s receptionist (`myFunc`) and logs whether the request succeeded or failed.
     * - It also tries to create new Foo receptionists, catching errors along the way.
     */

    /// @notice Emitted with a message string (success or failure reason).
    event Log(string message);

    /// @notice Emitted when capturing raw bytes data from a failure.
    event LogBytes(bytes data);

    /// @notice A Foo instance created when Bar is deployed.
    Foo public foo;

    /**
     * @notice Deploys a Foo contract with the sender as owner.
     * @dev This Foo is used for external call try/catch demonstrations.
     */
    constructor() {
        // This Foo contract is used for example of try catch with external call
        foo = new Foo(msg.sender);
    }

    /**
     * @notice Demonstrates try/catch with an external call to Foo.myFunc.
     * @dev 
     * - If Foo.myFunc succeeds, log the returned string.
     * - If it fails (e.g., require fails), log "external call failed".
     *
     * 🧪 Analogy:
     * Bar calls Foo’s receptionist with a form (`_i`):
     * - If `_i == 0`, the receptionist rejects it → Bar logs "external call failed".
     * - If `_i != 0`, receptionist accepts → Bar logs "my func was called".
     *
     * @param _i Input number passed to Foo.myFunc.
     */
    function tryCatchExternalCall(uint256 _i) public {
        try foo.myFunc(_i) returns (string memory result) {
            emit Log(result); // ✅ Success message.
        } catch {
            emit Log("external call failed"); // ❌ Failure logged.
        }
    }

    /**
     * @notice Demonstrates try/catch with contract creation.
     * @dev Handles both `require`/`revert` errors and `assert` errors.
     *
     * 🏗️ Analogy:
     * Bar tries to hire a new Foo receptionist (`new Foo(_owner)`):
     * - If `_owner == 0x0` → require fails → logs "invalid address".
     * - If `_owner == 0x1` → assert fails → logs raw bytes (empty message).
     * - Otherwise → Foo created successfully → logs "Foo created".
     *
     * @param _owner The address to assign as owner in the new Foo contract.
     */
    function tryCatchNewContract(address _owner) public {
        try new Foo(_owner) returns (Foo foo) {
            // you can use variable foo here
            emit Log("Foo created"); // ✅ Success.
        } catch Error(string memory reason) {
            // catch failing revert() and require()
            emit Log(reason); // ❌ Logs reason like "invalid address".
        } catch (bytes memory reason) {
            // catch failing assert()
            emit LogBytes(reason); // ⚠️ Logs raw error data.
        }
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Foo:
 * - Constructor:
 *   - `require(_owner != 0)` → revert with message if bad.
 *   - `assert(_owner != 0x1)` → revert with no message if forbidden.
 * - `myFunc(x)`:
 *   - Fails if `x == 0` ("require failed").
 *   - Otherwise returns "my func was called".
 *
 * Bar:
 * - `tryCatchExternalCall(_i)`:
 *   - Calls Foo.myFunc.
 *   - Logs success message if okay.
 *   - Logs "external call failed" if require fails.
 *
 * - `tryCatchNewContract(_owner)`:
 *   - Success: "Foo created".
 *   - Require failure: reason logged (string).
 *   - Assert failure: raw bytes logged (empty).
 *
 * 🎭 Real-World Analogy:
 * - Foo = strict receptionist with rules for onboarding and form validation.
 * - Bar = lab manager testing interactions:
 *   - Sometimes submits bad forms to Foo (external call).
 *   - Sometimes hires new Foo receptionists with invalid credentials (contract creation).
 * - `try / catch` = safety net to log the outcome instead of crashing the entire system.
 */
