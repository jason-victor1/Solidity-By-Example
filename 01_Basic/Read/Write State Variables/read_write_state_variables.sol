// SPDX-License-Identifier: MIT
// 🪪 This is the license plate for the contract—declares it open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the builder toolkit version (Solidity v0.8.26) to ensure compatibility and safety.

/// @title Simple Storage
/// @notice This contract lets you save and retrieve a number from the blockchain
/// @dev 🧳 Think of this as a digital locker where you can put a number in and look it up later
contract SimpleStorage {
    /// @notice Stores a number permanently on the blockchain
    /// @dev 🧮 Like a notepad in a vault — once you write something in, it's saved until you change it again
    uint256 public num;

    /// @notice Set a new value to be stored
    /// @dev ✍️ Just like updating the number written on your locker — this action requires effort (gas)
    /// @param _num The new number to store
    function set(uint256 _num) public {
        num = _num;
    }

    /// @notice Get the stored number
    /// @dev 👀 Like peeking through a window at the locker to see what number is written — free to check!
    /// @return The number currently stored
    function get() public view returns (uint256) {
        return num;
    }
}