// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title MultiDelegatecall
 * @notice Batch multiple function invocations via `delegatecall` so they all run
 *         in the **caller contract's** storage/context, preserving `msg.sender` and `msg.value`.
 * @dev
 * 🛠️ Real-World Analogy:
 * Invite several **guest operators** into your own **control room**. Each guest
 * brings a sealed **instruction envelope** (bytes payload). They press buttons
 * on **your** dashboard (your storage), and all actions are logged as if **you**
 * pressed them (same `msg.sender` from the external caller).
 *
 * 🔒 Safety Notes:
 * - `delegatecall` writes to the caller’s storage. Be sure your storage layout
 *   and invariants tolerate all batched calls.
 * - Atomic: if any sub-call fails, the whole batch reverts.
 * - `msg.sender` and `msg.value` are preserved across all envelopes; design
 *   payable flows carefully to avoid double-counting.
 */
contract MultiDelegatecall {
    /// @notice Thrown when any sub-`delegatecall` fails.
    /// @dev 🚨 Analogy: The red alarm light in the control room—batch aborted.
    error DelegatecallFailed();

    /**
     * @notice Execute a batch of `delegatecall`s against the current contract.
     * @dev
     * - Each `data[i]` is an ABI-encoded function selector + arguments for a function
     *   defined in **this** contract (or inherited into it).
     * - Runs `address(this).delegatecall(data[i])` in order and collects raw return bytes.
     * - Reverts the entire batch on the first failure.
     *
     * ☎️ Analogy:
     * Hand the control room a stack of **instruction envelopes**; each guest
     * opens one, presses your buttons, and leaves a **receipt** (bytes) in the tray.
     *
     * @param data The list of ABI-encoded calls to execute via `delegatecall`.
     * @return results The ABI-encoded return data for each sub-call, index-aligned with `data`.
     */
    function multiDelegatecall(bytes[] memory data)
        external
        payable
        returns (bytes[] memory results)
    {
        results = new bytes[](data.length);

        for (uint256 i; i < data.length; i++) {
            (bool ok, bytes memory res) = address(this).delegatecall(data[i]);
            if (!ok) revert DelegatecallFailed();
            results[i] = res; // store each sub-call's raw return bytes
        }
    }
}

/**
 * @title TestMultiDelegatecall
 * @notice Demonstrates how batched `delegatecall` preserves `msg.sender` and shares storage.
 * @dev
 * 🧪 Real-World Analogy:
 * A demo control room with:
 * - Two **test buttons** (`func1`, `func2`) that log who pressed them.
 * - A **ledger drawer** (`balanceOf`) that can be updated.
 * - A **vending button** (`mint`) that credits deposits—⚠️ unsafe if pressed
 *   multiple times in one batch with the same coin (`msg.value`).
 */
contract TestMultiDelegatecall is MultiDelegatecall {
    /// @notice Emitted when a function is executed (directly or via multi-delegatecall).
    /// @param caller The observed `msg.sender` during execution (EOA when batched).
    /// @param func   The function label that was invoked.
    /// @param i      A value associated with the call (e.g., x+y or a constant).
    /// @dev 🧾 Analogy: A journal entry noting who pushed which button and the reading shown.
    event Log(address caller, string func, uint256 i);

    /**
     * @notice Example function that logs the sum of two numbers.
     * @dev
     * - Via multi-delegatecall, `msg.sender` will be the **original external caller**.
     * - Emits a journal entry with the computed sum.
     *
     * 🎛️ Analogy:
     * Press a button labeled "func1"; the monitor displays `x + y`, and the journal
     * records **who** pressed it.
     *
     * @param x First addend.
     * @param y Second addend.
     */
    function func1(uint256 x, uint256 y) external {
        // msg.sender is preserved through delegatecall (e.g., Alice)
        emit Log(msg.sender, "func1", x + y);
    }

    /**
     * @notice Example function that logs a constant and returns `111`.
     * @dev Emits a journal entry then returns a value (useful to test return packing).
     *
     * 🔘 Analogy:
     * Press a button labeled "func2"; the display shows `2`, and you receive
     * a printed receipt with `111`.
     *
     * @return Always returns `111`.
     */
    function func2() external returns (uint256) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }

    /// @notice Per-address balance ledger updated by `mint`.
    /// @dev 📚 Analogy: A drawer where the control room keeps each visitor’s credits.
    mapping(address => uint256) public balanceOf;

    /**
     * @notice Credit the caller’s balance by the ETH sent with the transaction.
     * @dev
     * ⚠️ WARNING (when used with multi-delegatecall):
     * - `msg.value` is shared across the **whole batch**. If a user includes
     *   multiple `mint()` envelopes in one `multiDelegatecall`, this function
     *   will credit `msg.value` **each time**, allowing multi-credit for a single deposit.
     * - To make this safe, design per-call charging (e.g., track remaining value),
     *   or forbid batching of payable actions.
     *
     * 💰 Analogy:
     * You drop **one coin** into the machine (txn value), but if you press
     * the **dispense button** multiple times in a single visit, it keeps adding
     * credits again and again.
     */
    function mint() external payable {
        balanceOf[msg.sender] += msg.value;
    }
}

/**
 * @title Helper
 * @notice Builds ABI-encoded payloads (envelopes) for batched delegatecalls.
 * @dev
 * ✉️ Real-World Analogy:
 * A small **print shop** that prepares precisely addressed envelopes:
 * - `getFunc1Data(x,y)` → envelope for pressing "func1" with (x,y)
 * - `getFunc2Data()`    → envelope for pressing "func2"
 * - `getMintData()`     → envelope for pressing "mint"
 */
contract Helper {
    /**
     * @notice Build calldata to invoke {TestMultiDelegatecall.func1}.
     * @dev Uses the function selector for `func1(uint256,uint256)`.
     * @param x First argument.
     * @param y Second argument.
     * @return payload ABI-encoded selector + args for delegatecalling `func1`.
     */
    function getFunc1Data(uint256 x, uint256 y)
        external
        pure
        returns (bytes memory payload)
    {
        payload = abi.encodeWithSelector(TestMultiDelegatecall.func1.selector, x, y);
    }

    /**
     * @notice Build calldata to invoke {TestMultiDelegatecall.func2}.
     * @dev Uses the function selector for `func2()`.
     * @return payload ABI-encoded selector for delegatecalling `func2`.
     */
    function getFunc2Data() external pure returns (bytes memory payload) {
        payload = abi.encodeWithSelector(TestMultiDelegatecall.func2.selector);
    }

    /**
     * @notice Build calldata to invoke {TestMultiDelegatecall.mint}.
     * @dev Uses the function selector for `mint()`.
     * @return payload ABI-encoded selector for delegatecalling `mint`.
     */
    function getMintData() external pure returns (bytes memory payload) {
        payload = abi.encodeWithSelector(TestMultiDelegatecall.mint.selector);
    }
}