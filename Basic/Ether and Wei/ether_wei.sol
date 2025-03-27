// SPDX-License-Identifier: MIT
// 🪪 This is the license plate that says this contract is open-source under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Declares the version of the toolkit used to build this contract (Solidity v0.8.26).

// 🏢 This contract is like a digital currency measurement booth, showcasing Ether units and verifying their values.
contract EtherUnits {
    // 🪙 "oneWei" is like pinning the tiniest coin on the wall, representing the smallest Ethereum unit.
    // It's public, so anyone can come by and see what 1 wei looks like.
    uint256 public oneWei = 1 wei;

    // ✅ This is like a checklist right next to the tiny coin:
    // "Does it really equal 1?" Yes—this returns true.
    bool public isOneWei = (oneWei == 1);

    // 💰 "oneGwei" is a larger coin on display—1 Gwei is 1 billion wei (10^9).
    uint256 public oneGwei = 1 gwei;

    // ✅ Another checklist asking:
    // "Is this big coin really worth 1,000,000,000 wei?" This confirms it by returning true.
    bool public isOneGwei = (oneGwei == 1e9);

    // 🏦 "oneEther" is like a gold bar in a glass case—1 Ether equals 10^18 wei.
    uint256 public oneEther = 1 ether;

    // ✅ Final checklist to confirm:
    // "Does this gold bar weigh exactly 1,000,000,000,000,000,000 wei?" Verified true.
    bool public isOneEther = (oneEther == 1e18);
}

//check logic file