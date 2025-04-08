// SPDX-License-Identifier: MIT
// 🪪 Declares the file is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version used to compile this contract or struct.

// 🗂️ This struct defines a template for a to-do item.
// Think of it like a digital checklist form for a task.
struct Todo {
    string text;       // 📝 The description or label of the task (e.g., "Write proposal")
    bool completed;    // ✅ Whether the task has been finished or not (true/false)
}

