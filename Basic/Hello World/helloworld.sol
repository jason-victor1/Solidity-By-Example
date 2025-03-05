// SPDX-License-Identifier: MIT
// This line specifies the software license under which the contract is released.
// "MIT" is a permissive open source license.

pragma solidity ^0.8.26;
// This line specifies that the Solidity compiler version must be 0.8.26 or compatible versions that do not introduce breaking changes.

contract HelloWorld {
    // This declares a new contract named "HelloWorld".

    string public greet = "Hello World!";
    // This declares a public state variable of type string named "greet".
    // The keyword 'public' automatically creates a getter function for this variable,
    // allowing external users to read its value. The variable is initialized with the value "Hello World!".
}
