// SPDX-License-Identifier: MIT
// 🪪 This contract is open-source and follows the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or newer for safety and compatibility.

/// @title Nested Mapping Example
/// @notice Demonstrates how to use a mapping of mappings in Solidity
/// @dev 📚 Think of this as a library with bookshelves — each address is a shelf, and each book (number) has a true/false bookmark
contract NestedMapping {
    /// @notice Maps an address → number → true/false flag
    /// @dev 📖 Each address has its own bookshelf of books (numbers), each book can be marked (true) or unmarked (false)
    mapping(address => mapping(uint256 => bool)) public nested;

    /// @notice Get the flag for a given address and number
    /// @param _addr1 The address (shelf) to check
    /// @param _i The number (book) to check
    /// @return Whether the book is marked (true) or not (false)
    function get(address _addr1, uint256 _i) public view returns (bool) {
        // 🔍 Even if no one has marked it yet, it returns default false
        return nested[_addr1][_i];
    }

    /// @notice Mark or unmark a book on a shelf
    /// @param _addr1 The address (shelf) to update
    /// @param _i The number (book) to update
    /// @param _boo True if marking it, false otherwise
    function set(address _addr1, uint256 _i, bool _boo) public {
        // 📝 Mark or unmark the book
        nested[_addr1][_i] = _boo;
    }

    /// @notice Reset a book’s mark to default (false)
    /// @param _addr1 The address (shelf) to reset
    /// @param _i The number (book) to reset
    function remove(address _addr1, uint256 _i) public {
        // 🗑️ Remove the mark (back to false)
        delete nested[_addr1][_i];
    }
}