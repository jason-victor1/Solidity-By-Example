// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version to ensure consistency.

// 📦 Utility contract to calculate function selectors based on function signatures.
contract FunctionSelector {
    /*
    🧾 Example function signatures and their 4-byte selectors:
    "transfer(address,uint256)"      → 0xa9059cbb
    "transferFrom(address,address,uint256)" → 0x23b872dd
    */

    function getSelector(string calldata _func)
        external
        pure
        returns (bytes4)
    {
        // 🔍 Converts the input string (e.g., "transfer(address,uint256)")
        // into a 4-byte function selector used in low-level calls.

        return bytes4(keccak256(bytes(_func)));
        // 🔐 Applies keccak256 hashing to the string, then slices the first 4 bytes.
        // 📤 Returns the resulting selector.
    }
}