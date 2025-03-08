// SPDX-License-Identifier: MIT              // License identifier indicating open-source status.
pragma solidity ^0.8.26;                     // Specifies the Solidity compiler version.

contract EtherUnits {
    // Declare a public state variable 'oneWei' and initialize it to 1 wei.
    // 'wei' is the smallest denomination of Ether.
    uint256 public oneWei = 1 wei;
    
    // Declare a boolean variable 'isOneWei' that checks if oneWei is equal to 1.
    // This will be true because 1 wei is exactly equal to 1.
    bool public isOneWei = (oneWei == 1);

    // Declare a public state variable 'oneGwei' and initialize it to 1 gwei.
    // 1 gwei is defined as 10^9 wei.
    uint256 public oneGwei = 1 gwei;
    
    // Declare a boolean variable 'isOneGwei' that checks if oneGwei is equal to 1e9 (10^9).
    // This comparison validates the conversion: 1 gwei equals 1,000,000,000 wei.
    bool public isOneGwei = (oneGwei == 1e9);

    // Declare a public state variable 'oneEther' and initialize it to 1 ether.
    // 1 ether is defined as 10^18 wei.
    uint256 public oneEther = 1 ether;
    
    // Declare a boolean variable 'isOneEther' that checks if oneEther is equal to 1e18 (10^18).
    // This comparison confirms that 1 ether equals 1,000,000,000,000,000,000 wei.
    bool public isOneEther = (oneEther == 1e18);
}
