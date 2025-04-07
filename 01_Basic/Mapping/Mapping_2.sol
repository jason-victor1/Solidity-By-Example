// SPDX-License-Identifier: MIT
// 🪪 This contract is open-source and follows the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or newer for safety and compatibility.

// 🗃️ You're building a double-level filing cabinet called "NestedMapping".
// Each address owns its own cabinet, and inside are drawers labeled with numbers that hold switches (true/false).
contract NestedMapping {
    // 🗂️ This nested mapping structure allows:
    // 1. Each address to have its own private cabinet.
    // 2. Inside that cabinet, each uint256 key points to a switch (boolean).
    mapping(address => mapping(uint256 => bool)) public nested;

    // 🔍 This function lets you check the switch (true/false) stored inside a specific drawer.
    // You need both the cabinet owner's address and the key to the drawer.
    // If the drawer hasn't been used yet, it returns the default value (false).
    function get(address _addr1, uint256 _i) public view returns (bool) {
        return nested[_addr1][_i];
    }

    // ✍️ This function flips the switch on or off in a specific drawer inside a cabinet.
    // Provide the cabinet (address), the drawer (uint256), and the switch state (bool).
    function set(address _addr1, uint256 _i, bool _boo) public {
        nested[_addr1][_i] = _boo;
    }

    // 🧹 This function clears out a switch setting—like resetting the toggle back to default (false).
    // It doesn’t remove the drawer, just resets the switch inside it.
    function remove(address _addr1, uint256 _i) public {
        delete nested[_addr1][_i];
    }
}
