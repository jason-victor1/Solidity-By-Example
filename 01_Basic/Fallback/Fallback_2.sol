// SPDX-License-Identifier: MIT
// 🪪 Open-source license tag—this contract is shared under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Solidity compiler version lock—ensures consistent behavior across deployments.

// TestFallbackInputOutput -> FallbackInputOutput -> Counter
// 🔁 Contract chain showing interaction flow: test → fallback → target (Counter)

contract FallbackInputOutput {
// 🏢 Acts like a forwarding proxy that passes all calls to a target contract.

    address immutable target;
    // 🎯 Destination address that all fallback calls are routed to—set once during deployment.

    constructor(address _target) {
        target = _target;
        // 🏷️ Stores the target contract address in the `target` variable.
    }

    fallback(bytes calldata data) external payable returns (bytes memory) {
        // 📥 Fallback function—catches any calls that don’t match a defined function.

        (bool ok, bytes memory res) = target.call{value: msg.value}(data);
        // 📨 Forwards the call and any Ether sent to the target contract using low-level `call`.

        require(ok, "call failed");
        // ❌ Reverts the transaction if the call was unsuccessful.

        return res;
        // 📤 Returns the raw data output from the target contract.
    }
}

contract Counter {
// 🔢 Simple counter contract with get and increment functionality.

    uint256 public count;
    // 🧮 Public state variable that tracks the current count.

    function get() external view returns (uint256) {
        return count;
        // 🪟 View function that returns the current count value.
    }

    function inc() external returns (uint256) {
        count += 1;
        // ➕ Increments the count by 1.

        return count;
        // 🔁 Returns the updated count.
    }
}

contract TestFallbackInputOutput {
// 🧪 Test contract to simulate low-level calls through a fallback-enabled contract.

    event Log(bytes res);
    // 📣 Emits the raw response from the fallback call.

    function test(address _fallback, bytes calldata data) external {
        // 🧪 Sends a low-level call to a fallback-enabled contract with arbitrary data.

        (bool ok, bytes memory res) = _fallback.call(data);
        // 🛰️ Calls the fallback contract directly with encoded data.

        require(ok, "call failed");
        // ❌ Ensures the call was successful.

        emit Log(res);
        // 📢 Emits the returned result as a `Log` event.
    }

    function getTestData() external pure returns (bytes memory, bytes memory) {
        // 🛠️ Prepares ABI-encoded call data for use in `test()`.

        return
            (abi.encodeCall(Counter.get, ()), abi.encodeCall(Counter.inc, ()));
        // 🧬 Returns encoded data for calling `Counter.get()` and `Counter.inc()`.
    }
}

