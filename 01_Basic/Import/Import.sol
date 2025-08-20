// SPDX-License-Identifier: MIT
// 🪪 Open-source license declaration under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version for consistent behavior.


// import Foo.sol from current directory
import "./Foo.sol";

// import {symbol1 as alias, symbol2} from "filename";
import {Unauthorized, add as func, Point} from "./Foo.sol";

contract Import {
    /**
     * @title Import Example
     * @dev Demonstrates how to bring in external Solidity files and symbols using `import`.
     *
     * 📦 Analogy:
     * Imagine you’re running a workshop:
     * - Instead of reinventing the hammer every time, you **import tools** from the toolbox (`Foo.sol`).
     * - You can also rename tools as nicknames (`add` → `func`) to avoid confusion or for convenience.
     */

    /// @notice An instance of the imported `Foo` contract.
    /// 🏪 Analogy: Like building a branch office of Foo right inside this workshop.
    Foo public foo = new Foo();

    /**
     * @notice Returns the `name` stored in the Foo contract.
     * @dev Just calls Foo’s `name()` function.
     *
     * 🏷️ Analogy:
     * Imagine walking into the Foo branch office and asking:
     * “Hey, what’s written on your shop sign?”
     * The branch replies: `"Foo"`.
     *
     * @return The name string from Foo (`"Foo"`).
     */
    function getFooName() public view returns (string memory) {
        return foo.name();
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Imports:
 * - `import "./Foo.sol";` → Brings everything from Foo.sol into scope.
 * - `import {Unauthorized, add as func, Point} from "./Foo.sol";`
 *     - `Unauthorized`: Custom error (rejection stamp).
 *     - `add` → renamed as `func`: Global calculator function.
 *     - `Point`: Coordinate struct.
 *
 * Contract `Import`:
 * - Deploys its own copy of `Foo` (`foo = new Foo()`).
 * - Exposes `getFooName()` to read Foo’s name.
 *
 * 🚪 Real-World Analogy:
 * - `import`: Borrowing tools from another workshop instead of remaking them.
 * - Aliasing (`add as func`): Giving a tool a nickname so workers know exactly which one you mean.
 * - `Foo public foo`: Building a Foo shop branch inside your own building.
 * - `getFooName()`: Asking the Foo branch what its shop sign says.
 */
