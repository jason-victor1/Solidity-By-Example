// SPDX-License-Identifier: MIT
// 🪪 This is like the open-source license plate for your building.
// The MIT license says: "Feel free to use, copy, and remix this legally."

pragma solidity ^0.8.26;
// 🛠️ Tells the builder (compiler) to use version 0.8.26 of the Solidity toolkit.
// This ensures compatibility and includes safety features.

// 🏢 You're now creating a digital building called "Constants" that has fixed plaques on its walls.
contract Constants {
    // 🔒 Constants = permanent plaques that are carved into the walls of the contract.
    // They can never be changed once set. Saves gas and improves clarity.

    // 🪧 This is like an engraved sign showing a specific Ethereum address.
    // It's public, always visible, and locked forever—like a dedication plaque.
    address public constant MY_ADDRESS =
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;

    // 🔢 This is another permanent sign, showing a fixed number.
    // Think of it like a commemorative number etched into the building.
    uint256 public constant MY_UINT = 123;
}
