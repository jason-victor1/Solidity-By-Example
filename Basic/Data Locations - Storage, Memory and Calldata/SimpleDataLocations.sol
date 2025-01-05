// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// A contract to demonstrate different data locations: storage, memory, and calldata
contract DataLocations {
    uint256[] public arr; // A dynamic array stored in storage, publicly accessible
    mapping(uint256 => address) map; // A mapping from uint256 to address stored in storage

    // A struct to hold a single uint256 value
    struct MyStruct {
        uint256 foo; // An integer property in the struct
    }

    // A mapping of uint256 to MyStruct, stored in storage
    mapping(uint256 => MyStruct) myStructs;

    // A public function demonstrating usage of storage, memory, and mappings
    function f() public {
        // Call the internal function `_f` with state variables (`arr`, `map`, and `myStructs[1]`)
        _f(arr, map, myStructs[1]);

        // Access a struct from the `myStructs` mapping in storage
        MyStruct storage myStruct = myStructs[1];

        // Create a new instance of `MyStruct` in memory with `foo` initialized to 0
        MyStruct memory myMemStruct = MyStruct(0);
    }

    // An internal function that takes references to storage variables as arguments
    function _f(
        uint256[] storage _arr, // A reference to a storage array
        mapping(uint256 => address) storage _map, // A reference to a storage mapping
        MyStruct storage _myStruct // A reference to a storage struct
    ) internal {
        // Perform operations with the storage variables (implementation not provided)
    }

    // A public function that accepts an array in memory and returns a modified memory array
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // Perform operations with the memory array (implementation not provided)
    }

    // An external function that accepts an array in calldata (read-only, gas-efficient)
    function h(uint256[] calldata _arr) external {
        // Perform operations with the calldata array (implementation not provided)
    }
}
