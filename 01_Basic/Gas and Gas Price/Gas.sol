// SPDX-License-Identifier: MIT
// 🪪 License plate: this declares your code is open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the Solidity compiler used for this contract.

/// @title Gas Burner Example
/// @notice Demonstrates what happens when a smart contract consumes all gas
/// @dev ⛽ This is like running your car engine nonstop until the fuel tank is completely empty and the car stops
contract Gas {
    /// @notice A counter that keeps increasing endlessly
    /// @dev 🧮 This is like a mechanical counter that keeps ticking up — forever
    uint256 public i = 0;

    /// @notice Function that runs forever until it runs out of gas
    /// @dev ⚠️ This is a "gas trap." It loops endlessly, increasing `i` until all gas is consumed
    ///      When that happens:
    ///      - 🚫 The transaction fails
    ///      - 🔄 All changes to state are reverted (like hitting undo)
    ///      - 💸 The gas you paid is still gone (not refunded)
    function forever() public {
        // 🌀 This loop never ends — it's like a robot in an infinite loop of counting
        while (true) {
            i += 1;
        }
    }
}