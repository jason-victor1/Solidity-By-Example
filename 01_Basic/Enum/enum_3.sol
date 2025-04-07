// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or later for compatibility and safety.

// 📥 Import the shared "Status" enum from another file.
// This is like grabbing a universal status label guide from a central folder.
import "./EnumDeclaration.sol";

// 🏢 This contract uses the imported set of status labels to tag or track its internal state.
contract Enum {
    // 🏷️ A public variable to store the current tag/status using the imported "Status" enum.
    // Initially defaults to the first value in the list: Status.Pending (0).
    Status public status;
}

