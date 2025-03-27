// SPDX-License-Identifier: MIT
// 🪪 License plate: this declares your code is open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the version of the Solidity compiler used for this contract.

// 🏭 This contract is like a demo lab designed to explore what happens when you run out of fuel (gas) in Ethereum.
contract Gas {
    // 🧮 This is a public wall-mounted counter.
    // It tracks how many times a certain action has been attempted.
    uint256 public i = 0;

    // 💥 This function demonstrates what happens when your machine (smart contract) runs non-stop without enough gas.
    // ⚠️ Important: Once all gas is consumed, the transaction fails,
    // all updates (like incrementing the counter) are rolled back,
    // and the fuel (gas) you paid is permanently gone.
    function forever() public {
        // 🌀 This is like turning on a machine that keeps spinning endlessly,
        // using up fuel (gas) until the engine stalls and shuts down.
        while (true) {
            // 🔁 Each spin, the counter increases by 1—
            // but none of these changes will stick if gas runs out mid-way.
            i += 1;
        }
    }
}

