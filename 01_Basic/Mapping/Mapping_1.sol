// SPDX-License-Identifier: MIT
// 🪪 This is the contract’s license plate—declaring it open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the Solidity compiler—ensures compatibility and safety checks.

// 🗃️ This contract is like a digital filing cabinet called "Mapping" where addresses are drawers and values are stored inside.
contract Mapping {
    // 🗂️ myMap is the cabinet.
    // Each Ethereum address acts like a labeled drawer.
    // Inside each drawer is a number (uint256).
    mapping(address => uint256) public myMap;

    // 🔍 This function lets anyone peek into a drawer using an address key.
    // If nothing has been stored yet, it shows the default value—0.
    function get(address _addr) public view returns (uint256) {
        return myMap[_addr];
    }

    // ✍️ This function lets someone place a number inside a specific drawer.
    // It links the address to a new value, or updates an existing one.
    function set(address _addr, uint256 _i) public {
        myMap[_addr] = _i;
    }

    // 🧹 This function clears out the drawer (but doesn’t remove the drawer itself).
    // The address still exists as a label, but now holds the default value: 0.
    function remove(address _addr) public {
        delete myMap[_addr];
    }
}
