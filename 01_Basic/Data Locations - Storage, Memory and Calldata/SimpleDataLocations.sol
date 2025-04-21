// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or later.

// 🧠 This contract teaches the difference between Solidity's data locations:
// - storage = permanent, shared memory (filing cabinet)
// - memory = temporary, modifiable workspace (whiteboard)
// - calldata = read-only input from the user (clipboard)
contract DataLocations {
    // 🗃️ A public list of numbers stored permanently in the contract (filing cabinet)
    uint256[] public arr;

    // 🗺️ A mapping of numbers to Ethereum addresses, also stored in storage
    mapping(uint256 => address) map;

    // 📦 A container to group related data (like a folder with a single note inside)
    struct MyStruct {
        uint256 foo; // 📝 The note in the folder – a single unsigned number
    }

    // 📁 Each folder is stored by ID (uint key) and lives in storage
    mapping(uint256 => MyStruct) myStructs;

    // 🔧 Demonstrates how to interact with storage and memory
    function f() public {
        // 🧩 Pass references to permanent data (from the filing cabinet) to an internal function
        _f(arr, map, myStructs[1]);

        // 📂 Create a local pointer to a specific folder in the cabinet
        MyStruct storage myStruct = myStructs[1];

        // 🧽 Create a temporary version of that folder on a whiteboard to play with or modify locally
        MyStruct memory myMemStruct = MyStruct(0);
    }

    // 🔧 Internal-only function that receives references to storage data
    function _f(
        uint256[] storage _arr,                      // 📚 Reference to the permanent number list
        mapping(uint256 => address) storage _map,    // 🗺️ Reference to the permanent address map
        MyStruct storage _myStruct                   // 📁 Reference to one folder
    ) internal {
        // 🧰 Could update or inspect the contents directly on-chain
        // (No implementation provided here)
    }

    // 🧪 Function accepts a fresh copy of a number list for temporary use
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // 🧽 This is like writing on a whiteboard – temporary and can be changed
        // (Implementation left out)
    }

    // 📬 External function that accepts a read-only input
    function h(uint256[] calldata _arr) external {
        // 📄 This is a clipboard handout – you can read it but can’t change it
        // Efficient for external calls (no copying to memory)
        // (Implementation left out)
    }
}
