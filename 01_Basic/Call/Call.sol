/ SPDX-License-Identifier: MIT
// 🪪 License declaration—this contract is released under the permissive MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version lock to ensure compatibility and predictable behavior.

contract Receiver {
    /**
     * @title Low-Level Call Receiver
     * @dev Demonstrates how a contract can accept ether, react to unknown function calls via `fallback`,
     *      and expose a simple function (`foo`) that can be invoked with encoded call data.
     *
     * 🧭 Big Picture Analogy:
     * Think of this contract like a small shop with:
     *  - a front desk clerk (`foo`) who takes an order (message + number) and gives you a receipt (returns x+1),
     *  - and a mail slot (`fallback`) that accepts envelopes (ether + data) even when the clerk isn't available
     *    or the requested form doesn't exist. The shop records every visit on a guestbook (`event Received`).
     */

    /// @notice Emitted whenever this contract receives a call (through `foo` or the `fallback`).
    /// @dev Like signing the guestbook with who came, how much they paid, and what they said.
    /// @param caller The address of the visitor at the counter/mail slot.
    /// @param amount The amount of ether (in wei) attached to the visit.
    /// @param message Extra info left by the visitor (e.g., a note on the envelope).
    event Received(address caller, uint256 amount, string message);

    /**
     * @notice Handles calls that don't match any function, and can receive ether.
     * @dev Works like a secure mail slot: if someone asks for a non-existent service or
     *      just drops off money without proper paperwork, we still log the visit.
     *
     * 📮 Analogy:
     * If you ring the bell for a service we don't offer, the shop doesn't crash—
     * it just slips your note into the mail slot and writes "Fallback was called" in the guestbook.
     */
    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called"); // 📝 Guestbook entry for unknown requests.
    }

    /**
     * @notice Takes a message and a number, accepts optional ether, and returns the number plus one.
     * @dev Like asking the clerk to stamp your ticket: you give them a note and a number,
     *      they acknowledge your payment (if any), then hand back your number with a +1.
     * @param _message A note you want logged with your visit (e.g., "call foo").
     * @param _x The number you bring to the counter.
     * @return The next number after `_x`, i.e., `_x + 1`.
     *
     * 💡 Tip:
     * Using `payable` here means the counter can also accept cash (ether) while processing your request.
     */
    function foo(string memory _message, uint256 _x)
        public
        payable
        returns (uint256)
    {
        emit Received(msg.sender, msg.value, _message); // 🧾 Clerk writes your message and payment in the guestbook.
        return _x + 1;                                  // ➕ Hands back your number, incremented by one.
    }
}

contract Caller {
    /**
     * @title Low-Level Caller
     * @dev Shows how to talk to another shop (`Receiver`) even if you don't have its full brochure (ABI),
     *      by packing your own envelope (`abi.encodeWithSignature`) and using a generic courier (`.call`).
     *
     * 🚚 Courier Analogy:
     * `.call` is like sending a custom-addressed package with cash and a note, without needing the shop’s official form.
     * You also choose how much "effort" (gas) the courier brings for the delivery.
     */

    /// @notice Emitted after attempting a low-level call to the receiver.
    /// @dev The `success` flag is like the courier saying "delivery made" or "failed",
    ///      and `data` is the signed receipt or error note from the other shop.
    /// @param success Whether the call succeeded.
    /// @param data Raw bytes returned by the callee (could be a receipt or an error payload).
    event Response(bool success, bytes data);

    /**
     * @notice Calls `foo(string,uint256)` on a known receiver address, forwarding ether and setting a custom gas stipend.
     * @dev Pack the note yourself using `abi.encodeWithSignature` and send via `.call{value, gas}`.
     *
     * 🧳 Analogy:
     * You're mailing a form to the Receiver’s front desk clerk:
     *  - `value` is the cash in the envelope,
     *  - `gas: 5000` is telling the courier to bring only a tiny amount of energy—enough for simple tasks,
     *    but maybe not enough if the clerk needs to do more work.
     *  - The handwritten note says: “please run `foo` with ('call foo', 123)”.
     *
     * ⚠️ Important:
     * Low-level `.call` won’t revert for you automatically on failure; it returns `(success, data)`.
     * Always check `success` and handle errors. Keep gas stipends realistic, or the clerk may run out of breath.
     *
     * @param _addr The payable address of the Receiver shop.
     */
    function testCallFoo(address payable _addr) public payable {
        // You can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _addr.call{
            value: msg.value,  // 💵 Cash tucked in the envelope.
            gas: 5000          // ⛽ Tiny fuel budget for the recipient’s work.
        }(abi.encodeWithSignature(
            "foo(string,uint256)", // 📝 Addressing the exact clerk by name and form.
            "call foo",            // ✉️ The note/message for the guestbook.
            123                    // 🔢 The number to be stamped (+1).
        ));

        emit Response(success, data); // 📬 Report back whether delivery worked and attach the receipt/error.
    }

    /**
     * @notice Attempts to call a non-existent function on the receiver, which triggers its `fallback`.
     * @dev If the requested door doesn't exist, the mail slot (`fallback`) catches the envelope.
     *
     * 🚪 Analogy:
     * You ask for a door that isn’t in the building. The shop doesn’t implode;
     * the envelope slides into the universal mail slot, and the shop logs the visit as “Fallback was called”.
     *
     * @param _addr The payable address of the Receiver shop.
     */
    function testCallDoesNotExist(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()") // ❓ A door name that isn't real.
        );

        emit Response(success, data); // 📨 Outcome + any note the shop left in return.
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * - `event Received(...)`: 📓 Guestbook entry each time the shop is contacted.
 * - `fallback() external payable`: 📮 Mail slot for unknown requests; logs the visit; can accept cash.
 * - `foo(string,uint256) payable`: 🧾 Front desk clerk; logs your note and payment; returns `_x + 1`.
 * - `.call{value, gas}(bytes)`: 🚚 Generic courier delivery; you pack the envelope and choose the fuel.
 * - `abi.encodeWithSignature(sig, args...)`: ✍️ Handwritten form that matches the clerk’s exact name and fields.
 * - `(bool success, bytes data)`: ✅/❌ Delivery result + the returned receipt or error note.
 *
 * 🔐 Safety & Best Practices:
 * - Always check `success` when using low-level `.call`. It won’t revert for you.
 * - Be mindful with gas stipends; too little gas can cause surprising failures.
 * - Prefer typed interfaces when possible for safer calls; use low-level calls when you truly need flexibility.
 */

