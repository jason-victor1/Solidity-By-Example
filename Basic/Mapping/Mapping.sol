// SPDX-License-Identifier: MIT
// Specifies the license type for the contract. This is a mandatory header for modern Solidity versions.

pragma solidity ^0.8.26;

// Specifies the Solidity compiler version. This contract is compatible with Solidity version 0.8.26 or later (with no breaking changes).

contract Mapping {
    // Declares a contract named 'Mapping'.

    // Mapping from an address to an unsigned integer (uint256).
    // This creates a key-value store where keys are Ethereum addresses and values are uint256.
    mapping(address => uint256) public myMap;

    // Function to retrieve the value associated with a specific address.
    // If the address has no value set, it will return the default value (0 for uint256).
    function get(address _addr) public view returns (uint256) {
        // Accesses the value stored for the provided address in the mapping.
        return myMap[_addr];
    }

    // Function to update or set a value in the mapping.
    // Takes an address (_addr) as the key and a uint256 (_i) as the value.
    function set(address _addr, uint256 _i) public {
        // Updates the mapping so that the provided address maps to the provided value.
        myMap[_addr] = _i;
    }

    // Function to remove a value from the mapping by resetting it to its default value.
    // The mapping key (_addr) will still exist but will return the default value (0).
    function remove(address _addr) public {
        // Deletes the value associated with the address, resetting it to 0 (default for uint256).
        delete myMap[_addr];
    }
}

contract NestedMapping {
    // Declares a contract named 'NestedMapping'.

    // Nested mapping: Maps an address to another mapping.
    // The inner mapping maps a uint256 key to a boolean value.
    // Useful for storing multiple levels of data.
    mapping(address => mapping(uint256 => bool)) public nested;

    // Function to retrieve a boolean value from the nested mapping.
    // Takes two inputs: an address (_addr1) and a uint256 key (_i).
    // If no value is set, the function will return the default value (false for bool).
    function get(address _addr1, uint256 _i) public view returns (bool) {
        // Accesses the boolean value stored in the nested mapping for the given address and key.
        return nested[_addr1][_i];
    }

    // Function to set a boolean value in the nested mapping.
    // Takes three inputs: an address (_addr1), a uint256 key (_i), and a boolean value (_boo).
    function set(address _addr1, uint256 _i, bool _boo) public {
        // Updates the nested mapping with the provided boolean value for the given address and key.
        nested[_addr1][_i] = _boo;
    }

    // Function to remove a value from the nested mapping.
    // Resets the boolean value at the given address and key to the default value (false).
    function remove(address _addr1, uint256 _i) public {
        // Deletes the value associated with the given address and key in the nested mapping.
        delete nested[_addr1][_i];
    }
}
