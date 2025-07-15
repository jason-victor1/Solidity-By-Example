// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Ensures the contract uses Solidity version 0.8.26 or higher for safety and compatibility.

/// @title 📋 Todo List Manager
/// @author ✍️
/// @notice A simple contract to manage a list of to-do tasks on the blockchain.
/// @dev Demonstrates working with structs, arrays of structs, and updating data.
/// 📦 Think of this as a digital whiteboard with sticky notes you can add, edit, and check off.

contract Todos {
    /// @notice 📝 A single to-do item.
    /// @dev Struct combining a description (`text`) and its completion status (`completed`).
    struct Todo {
        string text;      /// 🗒️ Task description.
        bool completed;   /// ✅ Whether the task is done.
    }

    /// @notice 📋 List of all the to-do items.
    Todo[] public todos;

    /// @notice ✍️ Add a new task to the list.
    /// @dev Demonstrates 3 different ways to create and store a `Todo` struct.
    /// @param _text 🗒️ Description of the task.
    function create(string calldata _text) public {
        // 🔹 Method 1: Initialize struct by calling it like a function.
        todos.push(Todo(_text, false));

        // 🔹 Method 2: Use key-value style (more explicit).
        todos.push(Todo({text: _text, completed: false}));

        // 🔹 Method 3: Create an empty sticky note and fill it in.
        Todo memory todo;
        todo.text = _text;
        // `completed` defaults to false.
        todos.push(todo);
    }

    /// @notice 🔍 Read a specific task’s details.
    /// @dev Solidity already gives you a getter for `todos`, but here we customize the return.
    /// @param _index 📍 Index of the task in the list.
    /// @return text 🗒️ Task description.
    /// @return completed ✅ Whether the task is completed.
    function get(uint256 _index)
        public
        view
        returns (string memory text, bool completed)
    {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    /// @notice ✏️ Update the description of a task.
    /// @param _index 📍 Index of the task to update.
    /// @param _text 🗒️ New description text.
    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    /// @notice 🔄 Toggle the completion status of a task.
    /// @param _index 📍 Index of the task to toggle.
    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed; // Switch true ↔ false
    }
}