/ SPDX-License-Identifier: MIT
// 🪪 License declaration—this contract is released under the permissive MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version lock to ensure compatibility and predictable behavior.

contract Receiver {
// 📥 Contract that listens for unknown calls and emits logs when called.

    event Received(address caller, uint256 amount, string message);
    // 📣 Event that logs the caller’s address, the amount of ETH sent, and a message string.

    fallback() external payable {
        // 🧲 Fallback function—triggered when no matching function is found.

        emit Received(msg.sender, msg.value, "Fallback was called");
        // 📢 Emits a log indicating the fallback function was triggered.
    }

    function foo(string memory _message, uint256 _x)
        public
        payable
        returns (uint256)
    {
        emit Received(msg.sender, msg.value, _message);
        // 📢 Emits a log with a custom message and ETH value.

        return _x + 1;
        // ➕ Returns the incremented value of `_x`.
    }
}

contract Caller {
// ☎️ Contract that makes low-level calls to external contracts.

    event Response(bool success, bytes data);
    // 📣 Event that logs whether the call succeeded and what data was returned.

    // Let's imagine that contract Caller does not have the source code for the
    // contract Receiver, but we do know the address of contract Receiver and the function to call.
    function testCallFoo(address payable _addr) public payable {
        // 🧪 Calls the `foo` function on the Receiver contract using low-level `call`.

        (bool success, bytes memory data) = _addr.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
        // 🛰️ Sends ETH and gas with ABI-encoded input to `foo(string,uint256)`.

        emit Response(success, data);
        // 📢 Logs whether the call succeeded and returns the raw data.
    }

    // Calling a function that does not exist triggers the fallback function.
    function testCallDoesNotExist(address payable _addr) public payable {
        // 🧪 Attempts to call a nonexistent function to trigger Receiver’s fallback.

        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );
        // 🚪 Low-level call with a signature that doesn't match any function.

        emit Response(success, data);
        // 📢 Logs fallback activation and any returned data.
    }
}
