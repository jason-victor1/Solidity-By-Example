// SPDX-License-Identifier: MIT
// 🪪 License plate declaring the contract open-source under MIT.

pragma solidity ^0.8.26;
// 🛠️ Compiler version tag—makes sure everyone builds with the same tools.

/**
 * @title Contract A
 * @dev Base contract with a public state variable and a getter.
 * 🏠 Imagine this contract as a parent with a nameplate on its door: "Contract A".
 */
contract A {
    /// @notice The name of the contract.
    string public name = "Contract A";

    /**
     * @notice Returns the current nameplate of the contract.
     * @return The name string stored in the contract.
     */
    function getName() public view returns (string memory) {
        return name;
    }
}

/**
 * @dev In Solidity >=0.6.0, state variable shadowing is disallowed.
 * ❌ Attempting to declare a new variable with the same name (`name`) in a child contract causes a compilation error.
 *
 * Example:
 * ```solidity
 * contract B is A {
 *     string public name = "Contract B"; // ❌ This won't compile
 * }
 * ```
 */

/**
 * @title Contract C
 * @dev Properly overrides the inherited `name` variable using the constructor.
 * 🧱 Think of this as a child who moves into the house and **replaces the parent's nameplate**.
 */
contract C is A {
    /// @notice Constructor that changes the inherited nameplate to "Contract C".
    constructor() {
        name = "Contract C";
    }

    // C.getName() returns "Contract C"
}