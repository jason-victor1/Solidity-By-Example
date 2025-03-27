// SPDX-License-Identifier: MIT
// 🪪 This is your contract’s license plate—declares it open-source under MIT terms.

pragma solidity ^0.8.26;
// 🛠️ Sets the version of Solidity tools used to build this contract.
// Version 0.8.26 includes important safety features.


// 🏢 You're constructing a digital building named "Immutable".
// Some labels (immutable variables) are installed once during setup and locked in permanently.
contract Immutable {
    // 🧱 This is like installing a nameplate at the entrance—set during construction and never changed after.
    address public immutable myAddr;

    // 🏷️ This is like stamping a custom serial number into the foundation of the building.
    uint256 public immutable myUint;

    // 🛬 This constructor runs once when the building is first assembled (contract is deployed).
    // The deployer provides a number and becomes the permanent listed owner.
    constructor(uint256 _myUint) {
        // 👤 Assigns the deployer's address as the contract’s registered owner.
        myAddr = msg.sender;

        // 🔢 Records the custom number chosen at deployment and locks it in.
        myUint = _myUint;
    }
}
