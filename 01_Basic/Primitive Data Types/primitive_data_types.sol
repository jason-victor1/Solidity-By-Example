// SPDX-License-Identifier: MIT
// The SPDX license identifier declares that this code is licensed under the MIT License.

pragma solidity ^0.8.26;
// Specifies that the Solidity compiler version must be 0.8.26 (or compatible versions).

contract Primitives {
    // Contract named "Primitives" to demonstrate the use of basic data types in Solidity.

    // A boolean state variable, publicly accessible, initialized to true.
    bool public boo = true;

    /*
      Unsigned integers (uint) can only store non-negative values.
      Solidity supports various sizes; the most common are:
        uint8   ranges from 0 to 2 ** 8 - 1 (i.e., 0 to 255)
        uint16  ranges from 0 to 2 ** 16 - 1
        ...
        uint256 ranges from 0 to 2 ** 256 - 1
      By default, "uint" is an alias for "uint256".
    */
    // A uint8 variable, publicly accessible, initialized to 1.
    uint8 public u8 = 1;
    // A uint256 variable, publicly accessible, initialized to 456.
    uint256 public u256 = 456;
    // A uint variable (alias for uint256), publicly accessible, initialized to 123.
    uint256 public u = 123; // "uint" is the same as "uint256".

    /*
      Signed integers (int) can store both negative and positive numbers.
      Similar to uint, they come in different sizes:
        int8    ranges from -2 ** 7 to 2 ** 7 - 1 (i.e., -128 to 127)
        int256  ranges from -2 ** 255 to 2 ** 255 - 1
      By default, "int" is an alias for "int256".
    */
    // An int8 variable, publicly accessible, initialized to -1.
    int8 public i8 = -1;
    // An int256 variable, publicly accessible, initialized to 456.
    int256 public i256 = 456;
    // An int variable (alias for int256), publicly accessible, initialized to -123.
    int256 public i = -123; // "int" is the same as "int256".

    // Demonstrates how to get the minimum and maximum values for int256.
    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    // An address variable, publicly accessible, initialized to a specific Ethereum address.
    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    /*
      Bytes types represent a sequence of bytes.
      Solidity has two types of byte arrays:
         - Fixed-size byte arrays (e.g., bytes1, bytes2, ... bytes32)
         - Dynamically-sized byte arrays (represented by the type "bytes", which is shorthand for "byte[]")
      Here, we demonstrate fixed-size byte arrays with a length of 1 (bytes1).
    */
    // A bytes1 variable initialized with the hexadecimal value 0xb5.
    bytes1 a = 0xb5; // Binary: [10110101]
    // Another bytes1 variable initialized with the hexadecimal value 0x56.
    bytes1 b = 0x56; // Binary: [01010110]

    /*
      Default values for state variables:
      If you declare a state variable without initializing it, Solidity automatically assigns a default value.
        - bool defaults to false.
        - uint defaults to 0.
        - int defaults to 0.
        - address defaults to the zero address (0x0000000000000000000000000000000000000000).
    */
    // These variables show the default values when not explicitly initialized.
    bool public defaultBoo;       // Defaults to false.
    uint256 public defaultUint;   // Defaults to 0.
    int256 public defaultInt;     // Defaults to 0.
    address public defaultAddr;   // Defaults to 0x0000000000000000000000000000000000000000.
}
