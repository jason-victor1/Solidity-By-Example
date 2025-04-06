// SPDX-License-Identifier: MIT
// 🪪 Declares this smart contract is open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 to compile this contract.

// 📦 This contract is a digital package tracker.
// It attaches status tags to shipments and allows reading or updating those tags.
contract Enum {
    // 🏷️ Define a tag menu (enum) called 'Status' with five possible labels for a package.
    enum Status {
        Pending,   // 🕓 0: Package is waiting to be shipped
        Shipped,   // 📦 1: Package is on its way
        Accepted,  // ✅ 2: Package was received
        Rejected,  // ❌ 3: Delivery was refused
        Canceled   // 🚫 4: Shipment was canceled
    }

    // 🏷️ This variable holds the current tag for the package.
    // It's public, so anyone can check the status.
    // By default, this tag is set to 'Pending' (index 0).
    Status public status;

    // 🪟 Lets you peek at the current tag on the package.
    // Although enums return names, under the hood they map to numbers (0–4).
    function get() public view returns (Status) {
        return status;
    }

    // ✍️ This function allows you to change the tag by picking a new one from the menu.
    // You provide a new tag (`_status`) and it replaces the current one.
    function set(Status _status) public {
        status = _status;
    }

    // 🚫 A shortcut function that tags the package as 'Canceled'—no input needed.
    function cancel() public {
        status = Status.Canceled;
    }

    // 🔄 This function removes the current tag and resets it to the default ('Pending').
    // It's like wiping off a sticker and reapplying the "Waiting to Ship" label.
    function reset() public {
        delete status;
    }
}
