// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Ensures the contract uses Solidity version 0.8.26 or higher for safety and compatibility.

contract Todos {
    // 📋 Define the format of a task card using a struct.
    // Each task (Todo) is a sticky note with a message and a checkbox.
    struct Todo {
        string text;      // 📝 Task message or description (e.g., "Buy groceries")
        bool completed;   // ✅ Checkbox: true if done, false if still pending
    }

    // 📚 A stack (array) of task cards, representing the full to-do list.
    // Public visibility auto-generates a getter for individual tasks by index.
    Todo[] public todos;

    // 🆕 Add a new task to the board.
    // The caller provides the text, and the checkbox starts unchecked (false).
    function create(string calldata _text) public {
        // ✍️ Method 1: Create a task directly with message and checkbox value.
        todos.push(Todo(_text, false));

        // 🧾 Method 2: Same as above but more explicit with field names.
        todos.push(Todo({text: _text, completed: false}));

        // 🛠️ Method 3: Create a blank task, write the text, leave checkbox as default (false).
        Todo memory todo;
        todo.text = _text;
        // `completed` is automatically false.
        todos.push(todo);
    }

    // 🔍 View details of a specific task on the board.
    // Though not necessary (public array gives access), this shows how to return multiple fields.
    function get(uint256 _index)
        public
        view
        returns (string memory text, bool completed)
    {
        // 📦 Retrieve the task card from the board using its index.
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // ✏️ Update the message on a task card.
    function updateText(uint256 _index, string calldata _text) public {
        // Access the target task on the board.
        Todo storage todo = todos[_index];
        // Rewrite the note with new content.
        todo.text = _text;
    }

    // ✅ Toggle the checkbox status for a task.
    function toggleCompleted(uint256 _index) public {
        // Access the task card.
        Todo storage todo = todos[_index];
        // Flip the checkbox: if it’s checked, uncheck it, and vice versa.
        todo.completed = !todo.completed;
    }
}

