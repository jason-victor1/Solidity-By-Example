// SPDX-License-Identifier: MIT
// 🪪 Open-source license that allows reuse under MIT terms

pragma solidity ^0.8.26;
// 🛠️ Solidity version 0.8.26 or newer

/// @title Assembly Error Handling Contract
/// @author ChatGPT
/// @notice Demonstrates how to use low-level `revert` in Yul assembly.
/// @dev Uses inline assembly (`Yul`) to simulate a simple condition-based transaction failure.
contract AssemblyError {

    /// @notice This function reverts if the input number is greater than 10.
    /// @dev Uses the `revert(0, 0)` opcode in Yul to halt execution without any error message.
    /// @param x The number to check.
    /// 
    /// @custom:analogy Imagine a cookie oven where the safe temperature is 10 degrees.
    /// If someone sets the oven above 10, we immediately shut down the oven without baking—no message, no cookies!
    function yul_revert(uint256 x) public pure {
        assembly {
            /// ⚠️ `revert(p, s)` is like hitting an emergency stop button.
            /// It undoes everything and sends no explanation (0 data, 0 size).
            if gt(x, 10) {
                revert(0, 0)
            }
        }
    }
}
