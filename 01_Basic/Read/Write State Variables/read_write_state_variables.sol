// SPDX-License-Identifier: MIT
// 🪪 This is the license plate for the contract—declares it open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Specifies the builder toolkit version (Solidity v0.8.26) to ensure compatibility and safety.

// 🏢 This contract is like a digital storage booth named "SimpleStorage" where visitors can update and check a number.
contract SimpleStorage {
    // 🧮 This is a number board displayed outside the booth.
    // It's a public variable, so anyone can read it.
    uint256 public num;

    // 🛎️ This is like a request counter that lets visitors update the number on the board.
    // Since changing something in the building costs effort (gas), this action requires a transaction.
    function set(uint256 _num) public {
        // ✍️ The visitor hands in a number (_num), and the clerk updates the public display with it.
        num = _num;
    }

    // 🪟 This is a read-only viewing window—visitors can look at the number without changing anything.
    // No gas is needed to peek through this window.
    function get() public view returns (uint256) {
        // 🧾 The clerk simply reads out the number currently displayed on the board.
        return num;
    }
}
