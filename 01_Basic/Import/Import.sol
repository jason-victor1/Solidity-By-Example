// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version for consistent behavior.

// import Foo.sol from current directory
import "./Foo.sol";
// 📥 Imports the full Foo contract and all its accessible components.

// import {symbol1 as alias, symbol2} from "filename";
import {Unauthorized, add as func, Point} from "./Foo.sol";
// 📥 Selectively imports:
// 🚫 `Unauthorized` error for access control,
// ➕ `add` function (renamed as `func`),
// 📐 `Point` struct — all from Foo.sol

contract Import {
// 🧩 A contract that demonstrates usage of imported symbols from another file.

    Foo public foo = new Foo();
    // 🔗 Instantiates the imported `Foo` contract and makes it publicly accessible.

    function getFooName() public view returns (string memory) {
        // 🪟 View function that returns the name stored in the `Foo` contract.

        return foo.name();
        // 📤 Reads and returns the public `name` variable from `Foo`.
    }
}
