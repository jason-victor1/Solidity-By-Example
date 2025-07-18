// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or later.

/// @title 📂 Data Locations Example
/// @author ✍️
/// @notice Demonstrates the difference between `storage`, `memory`, and `calldata` in Solidity.
/// @dev Think of these as where you keep your data:  
/// 🗃️ Storage = on the blockchain (permanent)  
/// 🗒️ Memory = temporary workspace for the current function call  
/// 📞 Calldata = read-only message that comes from the caller

contract DataLocations {
    /// @notice 🗃️ A dynamic array stored in storage — permanent & on-chain.
    uint256[] public arr;

    /// @notice 🗃️ A mapping from `uint256` to `address`, also stored in storage.
    mapping(uint256 => address) map;

    /// @notice Defines a simple struct with a single `foo` field.
    struct MyStruct {
        uint256 foo;
    }

    /// @notice 🗃️ A mapping from `uint256` to `MyStruct`, stored permanently.
    mapping(uint256 => MyStruct) myStructs;

    /// @notice Demonstrates how to access and pass around different data locations.
    /// @dev Calls internal `_f()` with storage references, then creates storage & memory structs.
    function f() public {
        _f(arr, map, myStructs[1]);

        /// 📋 Access a struct from storage (permanent record).
        MyStruct storage myStruct = myStructs[1];

        /// 📝 Create a struct in memory (scratch pad, goes away after function ends).
        MyStruct memory myMemStruct = MyStruct(0);
    }

    /// @notice Internal function receiving references to storage variables.
    /// @param _arr 📋 Storage array reference.
    /// @param _map 📋 Storage mapping reference.
    /// @param _myStruct 📋 Storage struct reference.
    function _f(
        uint256[] storage _arr,
        mapping(uint256 => address) storage _map,
        MyStruct storage _myStruct
    ) internal {
        // 🛠️ Do something with the storage variables.
    }

    /// @notice Demonstrates using and returning a memory array.
    /// @param _arr 📝 A memory array, like a scratch pad.
    /// @return The (possibly modified) memory array.
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // 🛠️ Work with memory array here.
    }

    /// @notice Demonstrates receiving a calldata array.
    /// @param _arr 📞 Calldata array — read-only and gas efficient.
    function h(uint256[] calldata _arr) external {
        // 🛠️ Work with calldata array here.
    }
}