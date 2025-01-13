// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// This contract manages a simple to-do list.
contract Todos {
    // Define a struct to represent a to-do item
    struct Todo {
        string text; // The description of the to-do item
        bool completed; // Tracks whether the to-do item is completed
    }

    // An array of 'Todo' structs to store the to-do list
    Todo[] public todos;

    // Function to create and add a new to-do item
    function create(string calldata _text) public {
        // Adds a single 'Todo' struct to the array with 'completed' set to false
        todos.push(Todo(_text, false));

        // The following methods are commented out for reference and won't execute:
        // 2. Adds another struct using key-value mapping
        // todos.push(Todo({text: _text, completed: false}));

        // 3. Adds a third struct using an empty struct, updated manually
        // Todo memory todo;
        // todo.text = _text; // 'todo.completed' is false by default
        // todos.push(todo);
    }

    // Function to retrieve a specific to-do item by its index
    function get(
        uint256 _index
    ) public view returns (string memory text, bool completed) {
        // Access the to-do item in storage
        Todo storage todo = todos[_index];
        // Return its text and completion status
        return (todo.text, todo.completed);
    }

    // Function to update the text of a specific to-do item by index
    function updateText(uint256 _index, string calldata _text) public {
        // Access the to-do item in storage
        Todo storage todo = todos[_index];
        // Update its text
        todo.text = _text;
    }

    // Function to toggle the completion status of a specific to-do item by index
    function toggleCompleted(uint256 _index) public {
        // Access the to-do item in storage
        Todo storage todo = todos[_index];
        // Flip the 'completed' status (true becomes false, and vice versa)
        todo.completed = !todo.completed;
    }

    // Function to get the total number of to-do items in the list
    function getTodosLength() public view returns (uint256) {
        // Return the length of the 'todos' array
        return todos.length;
    }
}
