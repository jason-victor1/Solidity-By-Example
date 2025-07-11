// SPDX-License-Identifier: MIT
// 🪪 Declares this contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or later for compatibility and safety.

import "./EnumDeclaration.sol"; 
/// @notice 📂 We import the enum definitions from `EnumDeclaration.sol`.
/// @dev This allows us to reuse the `Status` enum defined elsewhere,
/// saving space and making it easier to maintain.

/// @title Example Contract Using Status Enum
/// @notice 📝 This contract keeps track of the shipping status of a package.
/// @dev By default, the `status` is set to the first value of the enum (Pending).
contract Enum {
    /// @notice 📦 The current status of the package.
    /// @dev The `Status` type comes from `EnumDeclaration.sol`.
    /// Possible values are:
    /// - 0: Pending (📦 Waiting to ship)
    /// - 1: Shipped (🚚 On the way)
    /// - 2: Accepted (📬 Delivered and accepted)
    /// - 3: Rejected (❌ Delivered but refused)
    /// - 4: Canceled (🛑 Order was canceled)
    Status public status;
}
