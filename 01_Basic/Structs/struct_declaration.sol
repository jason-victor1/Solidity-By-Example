// SPDX-License-Identifier: MIT
// 🪪 Declares the file is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version used to compile this contract or struct.

/// @title 📋 Todo Struct Declaration
/// @author ✍️
/// @notice This file defines a reusable `Todo` struct.
/// @dev Typically imported into other contracts to define a task.
/// 🗂️ Think of this as defining the shape of a sticky note that can be placed on a digital whiteboard.

/// @notice 📝 Represents a single task on a to-do list.
/// @dev Combines a text description of the task and its completion status.
struct Todo {
    string text;      /// 🗒️ The description of the task. Like the message written on a sticky note.
    bool completed;   /// ✅ Whether the task has been completed. Checked (true) or unchecked (false).
}