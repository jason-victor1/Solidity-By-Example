// SPDX-License-Identifier: MIT
// This specifies the license under which the contract is published.

pragma solidity ^0.8.26;
// This line tells the compiler which version of Solidity to use (version 0.8.26).

contract Constants {
    // This contract demonstrates how to declare constant variables in Solidity.
    
    // The following variable is an address constant.
    // Constants are variables that cannot be changed after they are declared.
    // By convention, constant variable names are written in uppercase.
    address public constant MY_ADDRESS =
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    // MY_ADDRESS holds a fixed Ethereum address that is publicly accessible.

    // This is a constant unsigned integer.
    // The value of MY_UINT is set to 123 and cannot be altered.
    uint256 public constant MY_UINT = 123;
    // MY_UINT is publicly accessible and will always be 123.
}
// This contract demonstrates how to declare constant variables in Solidity.