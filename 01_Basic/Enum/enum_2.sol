// SPDX-License-Identifier: MIT
// 🪪 This license declaration makes the file open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version required to work with this file.

/// @title Enum Declaration for Shipping Statuses
/// @notice 📋 Defines a set of possible shipment statuses.
/// @dev This enum can be imported and used in other contracts to track shipment states.
/// @custom:example Usage in another contract:
/// ```solidity
/// import "./EnumDeclaration.sol";
/// Status public status = Status.Pending;
/// ```

/// @notice 📦 A dropdown list of possible package states.
/// @dev Starts at `Pending` by default if used as a variable.
enum Status {
    Pending,   // 📦 Waiting in warehouse (0)
    Shipped,   // 🚚 On the way to recipient (1)
    Accepted,  // 📬 Delivered and accepted (2)
    Rejected,  // ❌ Delivered but refused (3)
    Canceled   // 🛑 Order was canceled (4)
}
