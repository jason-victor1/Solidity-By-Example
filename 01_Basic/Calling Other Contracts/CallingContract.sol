// SPDX-License-Identifier: MIT
// 🪪 License declaration—this contract is released under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version declaration to ensure compatibility and consistent behavior.

contract Callee {
    /**
     * @title Callee Contract
     * @dev A simple contract that stores a number (`x`) and records ether sent with function calls.
     *
     * 🏠 Analogy:
     * Think of this as a small storage locker with two drawers:
     * - Drawer 1 (`x`): Stores a number you give it.
     * - Drawer 2 (`value`): Records how much cash (ether) you handed over last time.
     */

    /// @notice Drawer 1: The stored number.
    uint256 public x;

    /// @notice Drawer 2: The ether amount (in wei) from the last payable function call.
    uint256 public value;

    /**
     * @notice Set the number `x` and return it.
     * @dev No ether is accepted here (not payable).
     *
     * 📦 Analogy:
     * You hand the locker manager a new number (`_x`), they replace the sticky note in Drawer 1,
     * and then read the number back to you as confirmation.
     *
     * @param _x The new number to store.
     * @return The updated number.
     */
    function setX(uint256 _x) public returns (uint256) {
        x = _x;   // ✍️ Replace Drawer 1’s note with the new number.
        return x; // 📢 Read the note back to confirm.
    }

    /**
     * @notice Set the number `x` and also record how much ether was sent.
     * @dev Payable: this function can receive ether along with the call.
     *
     * 💰 Analogy:
     * Like giving the locker manager both:
     * - A number to write in Drawer 1 (`x`).
     * - Some cash to lock into Drawer 2 (`value`).
     *
     * They hand you back a receipt showing both.
     *
     * @param _x The new number to store.
     * @return The updated number and the amount of ether received.
     */
    function setXandSendEther(uint256 _x)
        public
        payable
        returns (uint256, uint256)
    {
        x = _x;             // ✍️ Update Drawer 1.
        value = msg.value;  // 💵 Record the ether delivered into Drawer 2.

        return (x, value);  // 🧾 Return both as a receipt.
    }
}

contract Caller {
    /**
     * @title Caller Contract
     * @dev Demonstrates different ways to interact with the Callee contract.
     *
     * 📞 Analogy:
     * Think of Caller as a person making phone calls to the Callee storage locker.
     * They can:
     * - Call directly using the Callee’s type (like speed-dialing with a saved contact).
     * - Call by first converting an address into a Callee type (like manually dialing a number).
     * - Call and send ether along with the request (like including cash in an envelope).
     */

    /**
     * @notice Call Callee’s `setX` using the contract type directly.
     * @dev Simple typed call; no ether is involved.
     *
     * ☎️ Analogy:
     * Caller dials Callee by name (`_callee`) and says:
     * “Please update Drawer 1 with this number.”
     *
     * @param _callee The Callee contract instance.
     * @param _x The number to set in Callee.
     */
    function setX(Callee _callee, uint256 _x) public {
        uint256 x = _callee.setX(_x); // 📬 Call and store the confirmation locally (not used further here).
    }

    /**
     * @notice Call Callee’s `setX` by first converting an address into a Callee instance.
     * @dev This shows how to work when you only know the contract address.
     *
     * ☎️ Analogy:
     * Caller only has Callee’s phone number (`_addr`).
     * They dial it manually, then request: “Update Drawer 1 with this number.”
     *
     * @param _addr The address of the deployed Callee contract.
     * @param _x The number to set in Callee.
     */
    function setXFromAddress(address _addr, uint256 _x) public {
        Callee callee = Callee(_addr); // 🔢 Convert raw address into a Callee “contact.”
        callee.setX(_x);               // 📬 Call like normal.
    }

    /**
     * @notice Call Callee’s `setXandSendEther` and forward ether along with the call.
     * @dev Requires `msg.value` to forward ether. Demonstrates payable calls.
     *
     * 💸 Analogy:
     * Caller dials Callee and says:
     * “Update Drawer 1 with this number, and here’s some cash for Drawer 2.”
     *
     * Callee then returns a receipt with both the new number and the cash logged.
     *
     * @param _callee The Callee contract instance.
     * @param _x The number to set.
     */
    function setXandSendEther(Callee _callee, uint256 _x) public payable {
        (uint256 x, uint256 value) =
            _callee.setXandSendEther{value: msg.value}(_x); // 🧾 Collects receipt but doesn’t store it here.
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Callee:
 * - `setX(uint256)`: Updates Drawer 1 (`x`). No ether accepted. Returns new number.
 * - `setXandSendEther(uint256) payable`: Updates Drawer 1 and records Drawer 2 (`value` = ether sent). Returns both.
 *
 * Caller:
 * - `setX(Callee, uint256)`: Directly call `setX` using a Callee instance (like speed-dial).
 * - `setXFromAddress(address, uint256)`: Convert raw address into Callee instance, then call (like manual dial).
 * - `setXandSendEther(Callee, uint256) payable`: Call payable function with ether attached (like mailing cash).
 *
 * 🚪 Real-World Analogy:
 * - Callee is the locker with two drawers: one for numbers, one for cash.
 * - Caller is the person interacting with the locker, sometimes sending just a number, sometimes a number + cash.
 */
