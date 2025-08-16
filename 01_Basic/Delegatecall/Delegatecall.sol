// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version lock to ensure consistent compilation and behavior.

// NOTE: Deploy this contract first
contract B {
    /**
     * @title Logic Module B (for delegatecall demos)
     * @dev Contains the function logic that can be executed either:
     *      - directly via `.call` (affecting B's own storage), or
     *      - inside another contract's storage via `.delegatecall`.
     *
     * 🧩 Analogy:
     * Think of B like a travelling technician with a toolbox (the code).
     * - If you invite the tech to *their* own workshop (direct `.call`), they use their own shelves (B's storage).
     * - If the tech comes to *your* house but brings their own tools (`delegatecall`), they install
     *   everything into *your* shelves instead (caller’s storage).
     *
     * ⚠️ Storage Layout Rule:
     * For safe delegatecall, the caller (e.g., A) must have the same shelf order and sizes
     * (same variable types and order) as B. Otherwise, the tech will put items in the wrong places.
     */

    /// @notice Slot 0: the number value to store.
    /// @dev Like a labeled drawer for a numeric setting.
    uint256 public num;

    /// @notice Slot 1: who interacted last.
    /// @dev Like a sticky note with the last visitor’s address.
    address public sender;

    /// @notice Slot 2: how much ether was attached last time (in wei).
    /// @dev Like a cash ledger entry for the last visit.
    uint256 public value;

    /**
     * @notice Store a number and record who sent the call and how much ether came with it.
     * @dev Works both when called directly and when invoked via `delegatecall` from another contract.
     *
     * 🛠️ Analogy:
     * The technician writes three things on your house clipboard:
     *  - the new number (`num = _num`),
     *  - the name of the visitor (`sender = msg.sender`),
     *  - and the cash they brought (`value = msg.value`).
     *
     * - Direct `.call` to B: fills B’s clipboard.
     * - `.delegatecall` from A: fills A’s clipboard (same fields, same order).
     *
     * @param _num The new number to store.
     */
    function setVars(uint256 _num) public payable {
        num = _num;               // 🔢 Write the number in the first drawer.
        sender = msg.sender;      // 🏷️ Note who delivered the request (differs for call vs delegatecall).
        value = msg.value;        // 💵 Record the cash that arrived with the call.
    }
}

contract A {
    /**
     * @title Caller/Proxy A (demonstrates call vs delegatecall)
     * @dev Mirrors B’s storage layout so B’s logic can safely run "in A’s house" via `delegatecall`.
     *
     * 🏠 Analogy:
     * A is a house with the same three labeled drawers as B. When A uses `delegatecall` to B,
     * it’s like inviting B’s technician to install values into A’s drawers using B’s tools.
     */

    /// @notice Must match B: slot 0.
    uint256 public num;     // 🗃️ A's "number" drawer.

    /// @notice Must match B: slot 1.
    address public sender;  // 🗃️ A's "last visitor" sticky note.

    /// @notice Must match B: slot 2.
    uint256 public value;   // 🗃️ A's cash ledger entry.

    /// @notice Outcome of a delegatecall attempt (executed in A's context).
    /// @param success Whether the delegatecall succeeded.
    /// @param data Return data from the invoked logic (often empty if no return).
    event DelegateResponse(bool success, bytes data);

    /// @notice Outcome of a normal call attempt (executed in B's context).
    /// @param success Whether the call succeeded.
    /// @param data Return data from the invoked function.
    event CallResponse(bool success, bytes data);

    /**
     * @notice Use `delegatecall` to execute B.setVars(_num) but write into A’s storage.
     * @dev
     * - A’s storage is modified; B’s storage remains untouched.
     * - `msg.sender` inside B’s code becomes *the original external caller*, not A.
     * - `msg.value` inside B’s code equals the ether sent to this function (since this is `payable`).
     *
     * 🧳 Analogy:
     * You let B’s technician into A’s house. They bring their tools (B’s code) but use *your* shelves:
     *  - The number goes into A.num,
     *  - The visitor sticky note becomes the original caller’s address (not A),
     *  - The cash logged is what the visitor handed to A at the door.
     *
     * ⚠️ Safety Tip:
     * - Matching storage layout is critical.
     * - Delegatecalling untrusted logic is like handing your house keys to a stranger with a power drill.
     *
     * @param _contract Address of the logic contract B.
     * @param _num The number to set.
     */
    function setVarsDelegateCall(address _contract, uint256 _num)
        public
        payable
    {
        // A's storage is set; B's storage is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num) // ✍️ "Please run setVars with this number."
        );

        emit DelegateResponse(success, data); // 📨 Report the outcome of the in-house installation.
    }

    /**
     * @notice Use a normal `.call` to execute B.setVars(_num) and modify B’s storage.
     * @dev
     * - B’s storage is modified; A’s storage stays the same.
     * - Inside B’s code:
     *    - `msg.sender` will be **A** (because A is calling B).
     *    - `msg.value` will be whatever A forwards via `{value: msg.value}`.
     *
     * 🧳 Analogy:
     * You send a package to B’s own workshop with:
     *  - the number to store,
     *  - and the cash inside the envelope (`{value: msg.value}`).
     * B writes the info on *their* clipboard (B.num, B.sender = A, B.value = forwarded ether).
     *
     * @param _contract Address of the target contract B.
     * @param _num The number to set in B.
     */
    function setVarsCall(address _contract, uint256 _num) public payable {
        // B's storage is set; A's storage is not modified.
        (bool success, bytes memory data) = _contract.call{value: msg.value}(
            abi.encodeWithSignature("setVars(uint256)", _num) // 📦 "Dear B, please set this number."
        );

        emit CallResponse(success, data); // 📬 Delivery report from the external workshop.
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Storage Layout (A ↔ B):
 * - Must match exactly for safe `delegatecall`. Same types, same order. Think identical shelf blueprints.
 *
 * delegatecall (A → B.setVars):
 * - Code runs with B’s logic but writes to A’s storage. 🏠
 * - Inside logic:
 *   - `msg.sender` = original external caller (the person at A’s door). 👤
 *   - `msg.value` = ether sent to A’s function (since it’s payable). 💵
 * - Use cases: upgradeable patterns, shared logic libraries.
 * - Risk: untrusted logic can rewrite A’s drawers.
 *
 * call (A → B.setVars):
 * - Code runs in B, writes to B’s storage. 🏭
 * - Inside B:
 *   - `msg.sender` = A (the courier). 📮
 *   - `msg.value` = what A forwards via `{value: ...}`. 💸
 *
 * Common Pitfalls & Tips:
 * - ✅ Keep layouts aligned for delegatecall.
 * - ✅ Be explicit about ether forwarding in `.call`.
 * - ✅ Log outcomes (events) and always check the `success` boolean.
 * - ⚠️ Never delegatecall into unknown or untrusted code.
 * - 🧪 Test both paths to see differences in `sender` and `value`.
 */