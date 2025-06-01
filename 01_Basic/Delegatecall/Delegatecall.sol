// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version lock to ensure consistent compilation and behavior.

// NOTE: Deploy this contract first
contract B {
// 🧱 Logic contract intended to be used with delegatecall.
// ⚠️ Storage layout must exactly match contract A to avoid corruption.

    uint256 public num;
    // 🧮 Stores a number passed into the setVars function.

    address public sender;
    // 🧾 Stores the address of the function caller.

    uint256 public value;
    // 💰 Stores the amount of Ether sent with the transaction.

    function setVars(uint256 _num) public payable {
        // 🛠️ Function to modify contract state—meant to be called via delegatecall or call.

        num = _num;
        // ✍️ Saves the input number to storage.

        sender = msg.sender;
        // 🧾 Records who sent the transaction.

        value = msg.value;
        // 💰 Captures how much ETH was sent.
    }
}

contract A {
// 🧪 Contract used to test and demonstrate `delegatecall` and `call`.

    uint256 public num;
    // 🧮 Same storage slot as in B to match layout for delegatecall.

    address public sender;
    // 🧾 Matches B’s `sender` storage variable.

    uint256 public value;
    // 💰 Matches B’s `value` slot to hold ETH-related input.

    event DelegateResponse(bool success, bytes data);
    // 📣 Emits the result of a delegatecall—logs success and return data.

    event CallResponse(bool success, bytes data);
    // 📣 Emits the result of a call—logs success and return data.

    // Function using delegatecall
    function setVarsDelegateCall(address _contract, uint256 _num)
        public
        payable
    {
        // 🪞 Executes the logic of B but writes to A's storage.
        // B's storage is not affected.

        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        // 🛰️ Performs delegatecall with encoded input—runs in context of A.

        emit DelegateResponse(success, data);
        // 📢 Logs whether the delegatecall succeeded and any returned data.
    }

    // Function using call
    function setVarsCall(address _contract, uint256 _num) public payable {
        // 📞 Calls B normally—writes to B's storage, not A's.

        (bool success, bytes memory data) = _contract.call{value: msg.value}(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        // 🛰️ Performs a standard external call with ETH and encoded input.

        emit CallResponse(success, data);
        // 📢 Logs whether the call succeeded and any return data.
    }
}