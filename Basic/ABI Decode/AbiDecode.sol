// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Define a contract named `AbiDecode`
contract AbiDecode {
    // Define a struct named `MyStruct` to group related data
    struct MyStruct {
        string name; // A string field to store a name
        uint256[2] nums; // A fixed-size array of two unsigned integers
    }

    // Define a function named `encode` to encode multiple inputs into a single `bytes` object
    function encode(
        uint256 x, // A uint256 value
        address addr, // An Ethereum address
        uint256[] calldata arr, // A dynamic array of uint256 values (calldata to save gas)
        MyStruct calldata myStruct // A struct of type `MyStruct` (calldata for efficiency)
    ) external pure returns (bytes memory) {
        // Use `abi.encode` to encode all inputs into a single `bytes` object
        return abi.encode(x, addr, arr, myStruct);
    }

    // Define a function named `decode` to decode a `bytes` object back into its original data types
    function decode(
        bytes calldata data
    )
        external
        pure
        returns (
            uint256 x, // A uint256 value
            address addr, // An Ethereum address
            uint256[] memory arr, // A dynamic array of uint256 values
            MyStruct memory myStruct // A struct of type `MyStruct`
        )
    {
        // Decode the `bytes` object into its original data types using `abi.decode`
        (x, addr, arr, myStruct) = abi.decode(
            data,
            (uint256, address, uint256[], MyStruct)
        );
    }
}
