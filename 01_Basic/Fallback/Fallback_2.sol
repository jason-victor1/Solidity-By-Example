// SPDX-License-Identifier: MIT
// 🪪 Open-source license tag—this contract is shared under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Solidity compiler version lock—ensures consistent behavior across deployments.

/**
 * @title FallbackInputOutput
 * @dev Forwards any function call (and Ether) to a target contract and returns the result.
 * 🏢 Analogy: This is like a **concierge desk** in a big office building.
 *      - You give the concierge your request (calldata) and optional payment (Ether).
 *      - The concierge delivers it to the right office (the target contract).
 *      - Whatever response the office gives, the concierge brings it back to you exactly.
 */
contract FallbackInputOutput {
    /// @notice Address of the target contract that will handle all forwarded calls.
    address immutable target;

    /**
     * @param _target The address of the contract to which all calls should be forwarded.
     * 📦 Analogy: Telling the concierge which office to always deliver requests to.
     */
    constructor(address _target) {
        target = _target;
    }

    /**
     * @notice Fallback function that captures any call with unknown function signatures
     *         and forwards it (along with Ether) to the target contract.
     * @param data Encoded function call data for the target contract.
     * @return res The raw return data from the target contract.
     * 📨 Analogy: You hand the concierge a sealed envelope (function data) with or without cash,
     *      and they deliver it to the office without changing anything.
     */
    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory res) = target.call{value: msg.value}(data);
        require(ok, "call failed");
        return res;
    }
}

/**
 * @title Counter
 * @dev Simple counter contract with getter and increment functions.
 * 🔢 Analogy: A scoreboard with:
 *      - One button to check the score.
 *      - One button to increase the score by 1.
 */
contract Counter {
    /// @notice The current count.
    uint256 public count;

    /**
     * @notice Get the current count.
     * @return The current count value.
     * 👀 Analogy: Looking at the scoreboard to see the current score.
     */
    function get() external view returns (uint256) {
        return count;
    }

    /**
     * @notice Increase the count by 1.
     * @return The updated count after incrementing.
     * 🔼 Analogy: Pressing the "plus one" button on the scoreboard.
     */
    function inc() external returns (uint256) {
        count += 1;
        return count;
    }
}

/**
 * @title TestFallbackInputOutput
 * @dev Contract to test calls to FallbackInputOutput, including encoding call data.
 * 🧪 Analogy: This is like a **remote control** that can send commands to the concierge desk.
 */
contract TestFallbackInputOutput {
    /// @notice Logs the raw return data from a fallback call.
    event Log(bytes res);

    /**
     * @notice Sends arbitrary call data to a FallbackInputOutput contract.
     * @param _fallback The address of the FallbackInputOutput contract.
     * @param data The encoded function call data to send.
     * 📨 Analogy: Sending a custom instruction to the concierge and recording their reply.
     */
    function test(address _fallback, bytes calldata data) external {
        (bool ok, bytes memory res) = _fallback.call(data);
        require(ok, "call failed");
        emit Log(res);
    }

    /**
     * @notice Provides example call data for Counter's get() and inc() functions.
     * @return getData Encoded data for Counter.get().
     * @return incData Encoded data for Counter.inc().
     * 🛠 Analogy: A cheat sheet with ready-made envelopes you can hand to the concierge.
     */
    function getTestData() external pure returns (bytes memory getData, bytes memory incData) {
        return (
            abi.encodeCall(Counter.get, ()),
            abi.encodeCall(Counter.inc, ())
        );
    }
}