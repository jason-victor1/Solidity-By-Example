// SPDX-License-Identifier: MIT
// 🪪 License plate declaring the contract open-source under MIT.

pragma solidity ^0.8.26;
// 🛠️ Compiler version tag—makes sure everyone builds with the same tools.

contract A {
// 🏷️ Base kiosk called “A” that shows its own name.

    string public name = "Contract A";
// 📛 Public signboard starting at “Contract A”.

    function getName() public view returns (string memory) {
// 🪟 Glass window to read the current sign without changing it.
        return name; // 🔁 Hands back the plaque text.
    }
}

// ⚠️ Example of illegal variable shadowing in Solidity 0.6 and below.
// Shadowing is disallowed in Solidity 0.6
// This will not compile
// contract B is A {
//     string public name = "Contract B";
// }

contract C is A {
// 🏢 New kiosk built on A but re-labels itself.

    // 🔄 Proper way to overwrite inherited sign during construction.
    constructor() {
// ✍️ Rewrites the inherited plaque to read “Contract C”.
        name = "Contract C";
    }

    // 🔍 Inherits getName(), which now returns “Contract C”.
}
