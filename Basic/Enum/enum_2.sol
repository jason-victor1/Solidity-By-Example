// SPDX-License-Identifier: MIT
// 🪪 This license declaration makes the file open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version required to work with this file.

// 📦 This file defines a reusable list of status tags using an enum.
// Enums are like a fixed menu of labels you can assign to things (like a status tracker).
// Each label gets a number behind the scenes (starting from 0).

enum Status {
    Pending,   // 🕓 0 – The default state, waiting for action
    Shipped,   // 📦 1 – Item is on the way
    Accepted,  // ✅ 2 – Item was received
    Rejected,  // ❌ 3 – Delivery was refused
    Canceled   // 🚫 4 – Process was aborted
}

