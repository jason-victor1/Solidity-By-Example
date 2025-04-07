// SPDX-License-Identifier: MIT
// 🪪 This is like giving your smart contract a license to operate under open-source rules.
// The MIT license allows others to use and remix your code freely.

pragma solidity ^0.8.26;
// 🛠️ This sets the version of the toolbox we’re using to build this contract—v0.8.26 includes safety features and bug fixes.

// 🏢 This contract is like a digital room named "Variables" that holds permanent signs and temporary notes.
contract Variables {
    // 🪧 State variables = permanent signs on the wall of this room (stored on the blockchain)
    // These remain unchanged unless someone actively updates them.

    // 📝 A visible message board that always says "Hello"
    string public text = "Hello";

    // 🔢 A public number display that starts at 123
    uint256 public num = 123;

    // 🛎️ This function is like a guest interaction desk.
    // It doesn't change anything in the room—it just checks or uses information temporarily during a visitor's session.
    function doSomething() public view {
        // 🧾 This is like scribbling a quick note during a meeting—it disappears afterward.
        uint256 i = 456;

        // 🌍 Now we use global tools—Solidity’s built-in information sources.

        // 🕒 "timestamp" is like stamping the guest's check-in time at the front desk.
        uint256 timestamp = block.timestamp;

        // 👤 "sender" is like writing down who the visitor is (their wallet address).
        address sender = msg.sender;
    }
}

