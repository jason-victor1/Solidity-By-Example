// SPDX-License-Identifier: MIT
// 🪪 Declares the contract is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or newer to ensure compatibility and safety.

/// @title 🗂️ Todos Contract
/// @author ✍️
/// @notice This contract maintains a list of tasks (`Todo`) using the `Todo` struct.
/// @dev Imports the `Todo` definition from `StructDeclaration.sol`.
/// 📝 Think of this as a digital whiteboard where you can pin multiple sticky notes.

import "./StructDeclaration.sol";

contract Todos {
    /// @notice 📋 Array of `Todo` structs, each representing a task.
    /// @dev The list grows as new tasks are added. Like a stack of sticky notes on the whiteboard.
    Todo[] public todos;
}

