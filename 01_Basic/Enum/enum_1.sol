// SPDX-License-Identifier: MIT
// 🪪 Declares this smart contract is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 to compile this contract.

/// @title Shipping Status Tracker
/// @notice 🚚 Keeps track of the status of a shipment using an Enum (like a dropdown menu)
/// @dev 📋 Internally, the enum is just a number: 0 = Pending, 1 = Shipped, etc.
contract Enum {
    /// @notice 📋 A list of possible shipment states, like labels on a package.
    enum Status {
        Pending,   // 📦 Waiting to ship (0)
        Shipped,   // 🚀 In transit (1)
        Accepted,  // 📬 Delivered and accepted (2)
        Rejected,  // ❌ Delivered but rejected (3)
        Canceled   // 🛑 Order canceled (4)
    }

    /// @notice 📝 The current status of the shipment.
    /// @dev Starts as `Pending` by default since it’s the first in the enum (0).
    Status public status;

    /// @notice 🔍 Check the current shipping status
    /// @return The current `Status` enum value (e.g., Pending, Shipped, etc.)
    function get() public view returns (Status) {
        return status;
    }

    /// @notice 📦 Update the shipping status manually
    /// @param _status The new `Status` value (use a number: 0=Pending, 1=Shipped, etc.)
    /// @dev 🪄 You pass the numeric value or enum name to update it
    function set(Status _status) public {
        status = _status;
    }

    /// @notice 🛑 Mark the shipment as canceled
    /// @dev Shortcut to set `status` directly to `Canceled` (4)
    function cancel() public {
        status = Status.Canceled;
    }

    /// @notice 🔄 Reset the shipment back to the default state (`Pending`)
    /// @dev Using `delete` resets the enum to its first value: 0
    function reset() public {
        delete status;
    }
}