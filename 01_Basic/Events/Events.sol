// SPDX-License-Identifier: MIT
// Specifies the license for the contract code. The MIT license allows anyone to reuse the code with minimal restrictions.

pragma solidity ^0.8.26;

// Specifies the Solidity compiler version. The code is compatible with version 0.8.26 and higher minor versions but not breaking changes (e.g., 0.9.0).

contract Event {
    // Declare the first event named `Log` with two parameters:
    // - `sender`: Indexed, allows filtering logs by the sender's address.
    // - `message`: A string that carries additional information.
    event Log(address indexed sender, string message);

    // Declare the second event named `AnotherLog` with no parameters.
    // This event can be used as a simple signal without additional data.
    event AnotherLog();

    // Define a function named `test` that demonstrates emitting events.
    function test() public {
        // Emit the `Log` event with:
        // - The caller's address (`msg.sender`) as the sender.
        // - The string "Hello World!" as the message.
        emit Log(msg.sender, "Hello World!");

        // Emit another `Log` event with:
        // - The caller's address (`msg.sender`) as the sender.
        // - The string "Hello EVM!" as the message.
        emit Log(msg.sender, "Hello EVM!");

        // Emit the `AnotherLog` event.
        // No parameters are passed since the event does not require any data.
        emit AnotherLog();
    }
}
