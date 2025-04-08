// SPDX-License-Identifier: MIT
// 🪪 Declares the contract is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or newer to ensure compatibility and safety.

// 📥 Import the Todo struct definition from a shared declarations file.
// This is like importing a reusable "task template" to use in this contract.
import "./StructDeclaration.sol";

// 🗂️ This contract manages a dynamic list of to-do items using the imported Todo struct.
contract Todos {
    // 🧾 A public list of task cards.
    // Each element is a 'Todo' struct, which includes a description and a completion status.
    // Think of this as a digital stack of sticky notes where each note has:
    // - a message (text)
    // - a checkbox (completed)
    Todo[] public todos;
}

