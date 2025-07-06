// SPDX-License-Identifier: MIT
// 🪪 This is the contract’s license plate—declaring it open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the Solidity compiler—ensures compatibility and safety checks.

/// @title Mapping Examples
/// @notice Demonstrates how to use a simple mapping and a nested mapping in Solidity
/// @dev 📓 Think of a mapping like a giant filing cabinet — you look up a key (like an address) to find its value
contract Mapping {
    /// @notice Maps an Ethereum address to a number
    /// @dev 📁 Each address has its own folder where you can store a number
    mapping(address => uint256) public myMap;

    /// @notice Get the number stored for a given address
    /// @param _addr The address to look up
    /// @return The number stored, or 0 if never set
    function get(address _addr) public view returns (uint256) {
        // 📬 If no value was written yet, it returns the default (like finding an empty folder → 0)
        return myMap[_addr];
    }

    /// @notice Set a number for a given address
    /// @param _addr The address to update
    /// @param _i The number to store
    function set(address _addr, uint256 _i) public {
        // ✍️ Write a number into the folder for this address
        myMap[_addr] = _i;
    }

    /// @notice Remove the number for a given address
    /// @param _addr The address to reset
    function remove(address _addr) public {
        // 🗑️ Reset the folder for this address to default (0)
        delete myMap[_addr];
    }
}