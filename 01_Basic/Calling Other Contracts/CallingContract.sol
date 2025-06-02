// SPDX-License-Identifier: MIT
// 🪪 License declaration—this contract is released under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version declaration to ensure compatibility and consistent behavior.

contract Callee {
// 🧾 Contract that receives function calls and optionally stores ETH sent with the transaction.

    uint256 public x;
    // 🧮 Public state variable to store a number.

    uint256 public value;
    // 💰 Public state variable to store the ETH value received.

    function setX(uint256 _x) public returns (uint256) {
        // 🔧 Sets the value of `x` and returns it.

        x = _x;
        // ✍️ Updates the stored number.

        return x;
        // 🔁 Returns the updated value.
    }

    function setXandSendEther(uint256 _x)
        public
        payable
        returns (uint256, uint256)
    {
        // 🔧 Sets the value of `x`, stores ETH sent, and returns both values.

        x = _x;
        // ✍️ Updates the stored number.

        value = msg.value;
        // 💰 Records the amount of ETH sent with the transaction.

        return (x, value);
        // 🔁 Returns both the updated number and the received ETH value.
    }
}

contract Caller {
// 📞 Contract that makes external calls to the Callee contract.

    function setX(Callee _callee, uint256 _x) public {
        // 🔁 Calls the `setX` function on the given Callee contract instance.

        uint256 x = _callee.setX(_x);
        // 📥 Passes `_x` and stores the returned result (not used here).
    }

    function setXFromAddress(address _addr, uint256 _x) public {
        // 🧭 Converts a raw address into a Callee contract reference and calls `setX`.

        Callee callee = Callee(_addr);
        // 🔄 Typecasts the address into a Callee contract instance.

        callee.setX(_x);
        // 📥 Calls the function using the casted instance.
    }

    function setXandSendEther(Callee _callee, uint256 _x) public payable {
        // 💸 Calls `setXandSendEther` on Callee and sends ETH with the call.

        (uint256 x, uint256 value) =
            _callee.setXandSendEther{value: msg.value}(_x);
        // 🔁 Passes `_x` and forwards ETH—stores both returned values (not used here).
    }
}