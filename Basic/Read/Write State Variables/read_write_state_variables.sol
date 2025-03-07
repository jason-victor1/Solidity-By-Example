// SPDX-License-Identifier: MIT           // License identifier indicating the code is open-source.
pragma solidity ^0.8.26;                  // Specifies the Solidity version required to compile this contract.

contract SimpleStorage {
    // State variable 'num' is declared as a public unsigned integer (uint256).
    // This variable is stored on the blockchain and holds a numeric value.
    uint256 public num;

    // The 'set' function allows anyone to change the value of 'num'.
    // Since writing to the blockchain (i.e., modifying state) requires a transaction,
    // you must send a transaction to call this function.
    function set(uint256 _num) public {
        // The input parameter '_num' is assigned to the state variable 'num',
        // updating the stored value.
        num = _num;
    }

    // The 'get' function allows anyone to read the current value of 'num'.
    // It is marked as 'view' because it does not modify the state and only reads from it.
    // Calling this function does not require a transaction (and thus no gas cost).
    function get() public view returns (uint256) {
        // Returns the current value of the state variable 'num'.
        return num;
    }
}
