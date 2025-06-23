// SPDX-License-Identifier: MIT
// 🪪 This is like a business license—"MIT" means the code is open-source and can be reused with minimal restrictions.

pragma solidity ^0.8.26;
// 🛠️ Tells the builder (compiler) which tools to use.
// Solidity version 0.8.26 ensures we're using a version that avoids bugs and supports new features.

/// @title HelloWorld Smart Contract
/// @author [Your Name]
/// @notice A basic smart contract that stores and exposes a greeting message
/// @dev Think of this as a digital building with a welcome sign that everyone can read, but no one can change.
contract HelloWorld {
    /// @notice A publicly visible greeting message stored on the blockchain
    /// @dev Acts like a permanent welcome sign on the front door that says "Hello World!"
    string public greet = "Hello World!";
}
