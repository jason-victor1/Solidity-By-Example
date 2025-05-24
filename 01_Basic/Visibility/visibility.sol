// SPDX-License-Identifier: MIT
// 🪪 License plate declaring the code open-source under MIT.

pragma solidity ^0.8.26;
// 🛠️ Compiler lock—everyone builds with the same tool version.

contract Base {
// 🏢 Training hall “Base” that demos four visibility levels.

    // 🔒 Private door—only this room can knock.
    // Private function can only be called
    // - inside this contract
    // Contracts that inherit this contract cannot call this function.
    function privateFunc() private pure returns (string memory) {
        return "private function called"; // 🪪 Whisper returned when the private door opens.
    }

    function testPrivateFunc() public pure returns (string memory) {
        return privateFunc(); // 🔁 Public window triggering the private door internally.
    }

    // 🔑 Internal door—this room and its children share the badge.
    // Internal function can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    function internalFunc() internal pure returns (string memory) {
        return "internal function called"; // 🪪 Whisper for internal badge swipe.
    }

    function testInternalFunc() public pure virtual returns (string memory) {
        return internalFunc(); // 🔁 Public window tapping the internal door.
    }

    // 🌐 Public entrance—anyone, anywhere, can walk through.
    // Public functions can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    // - by other contracts and accounts
    function publicFunc() public pure returns (string memory) {
        return "public function called"; // 🪪 Greeting for all visitors.
    }

    // 📫 External hatch—only outsiders can lift it.
    // External functions can only be called
    // - by other contracts and accounts
    function externalFunc() external pure returns (string memory) {
        return "external function called"; // 🪪 Message sent through the street hatch.
    }

    // 🚫 This sample shows why calling an external hatch from inside fails.
    // This function will not compile since we're trying to call
    // an external function here.
    // function testExternalFunc() public pure returns (string memory) {
    //     return externalFunc();
    // }

    // 📦 State drawers with different locks
    string private privateVar = "my private variable";   // 🔒 Drawer visible only inside Base.
    string internal internalVar = "my internal variable"; // 🔑 Drawer shared with children.
    string public publicVar = "my public variable";      // 🌐 Drawer label visible to everyone.
    // State variables cannot be external so this code won't compile.
    // string external externalVar = "my external variable";
}

contract Child is Base {
// 🌿 Child room extending Base—inherits most doors & drawers.

    // 🚫 Private doors from Base stay locked here.
    // Inherited contracts do not have access to private functions
    // and state variables.
    // function testPrivateFunc() public pure returns (string memory) {
    //     return privateFunc();
    // }

    // 🔑 Child can use internal badge-door.
    // Internal function can be called inside child contracts.
    function testInternalFunc() public pure override returns (string memory) {
        return internalFunc(); // 🔁 Demonstrates access to inherited internal door.
    }
}

