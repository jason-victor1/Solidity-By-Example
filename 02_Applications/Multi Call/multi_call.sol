// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title MultiCall
 * @notice Batch multiple read-only (static) calls into a single on-chain request and get all results back in order.
 * @dev
 * ☎️ Real-World Analogy:
 * Think of this as a **concierge** making several **phone inquiries** for you:
 * - You hand the concierge a list of **phone numbers** (contract addresses) and **scripts** (ABI-encoded call data).
 * - The concierge calls each number **just to ask** (read-only), writes down the answers verbatim, and returns the stack of transcripts.
 * - If any number fails to connect, the whole errand is aborted (revert) and you’re told it failed.
 *
 * 🔒 Notes:
 * - Uses `staticcall`, so targets cannot modify state during these calls.
 * - The i-th `targets[i]` must match the i-th `data[i]` (same length).
 */
contract MultiCall {
    /**
     * @notice Execute multiple read-only calls and return their ABI-encoded results.
     * @dev
     * Requirements:
     * - `targets.length == data.length`
     * Effects:
     * - Performs a `staticcall` to each `targets[i]` with `data[i]`.
     * - Reverts if any individual call fails.
     *
     * 📦 Analogy:
     * For each **phone number** and **script**, the concierge makes a call, records the exact **answer tape** (bytes),
     * and files it in the same order for pickup.
     *
     * @param targets List of contract addresses to call.
     * @param data    ABI-encoded calldata for each call (function selector + args).
     * @return results Array of ABI-encoded return data, index-aligned with inputs.
     */
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory results)
    {
        require(targets.length == data.length, "target length != data length");

        results = new bytes[](data.length);

        for (uint256 i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result; // Store verbatim transcript
        }
    }
}

/**
 * @title TestMultiCall
 * @notice Tiny helper showcasing how to build call data and a trivial target to be batch-called.
 * @dev
 * 🧪 Real-World Analogy:
 * - `test` is a **practice hotline** that simply echoes your number back (useful to verify wiring).
 * - `getData` is a **script factory** that prints the exact phone menu code (selector) + your number (argument).
 */
contract TestMultiCall {
    /**
     * @notice Example pure function to be called via `MultiCall`.
     * @dev
     * 🔁 Analogy: The hotline **repeats back** the number you told it.
     * @param _i The number to echo.
     * @return Echoes `_i` unchanged.
     */
    function test(uint256 _i) external pure returns (uint256) {
        return _i;
    }

    /**
     * @notice Build ABI-encoded calldata to call {TestMultiCall.test} with `_i`.
     * @dev
     * 🧰 Analogy: Create a ready-to-dial **call script**: the button code (selector) plus the spoken number (arg).
     * Uses `this.test.selector` to fetch the function selector for `test(uint256)`.
     *
     * @param _i Argument to pass to `test(uint256)`.
     * @return payload ABI-encoded selector + `_i`, suitable for `staticcall`.
     */
    function getData(uint256 _i) external pure returns (bytes memory payload) {
        payload = abi.encodeWithSelector(this.test.selector, _i);
    }
}
