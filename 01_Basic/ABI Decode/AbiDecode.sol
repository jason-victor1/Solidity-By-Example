// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title AbiDecode - Demonstrates ABI encoding and decoding of structured data
contract AbiDecode {
    
    /// 🧱 Custom struct used for encoding/decoding
    /// Represents a point of data with a name and fixed-size array
    struct MyStruct {
        string name;           // A descriptive label or identifier
        uint256[2] nums;       // A fixed-length array of two unsigned integers
    }

    /// 🔐 Encodes various parameters into a single `bytes` object
    /// @param x A simple uint256 value
    /// @param addr An Ethereum address
    /// @param arr A dynamic array of unsigned integers
    /// @param myStruct A user-defined struct with a string and array
    /// @return Encoded bytes payload using ABI rules
    function encode(
        uint256 x,
        address addr,
        uint256[] calldata arr,
        MyStruct calldata myStruct
    ) external pure returns (bytes memory) {
        // ABI-encode all the values into a single byte array
        return abi.encode(x, addr, arr, myStruct);
    }

    /// 🔍 Decodes a byte-encoded payload back into original components
    /// @param data The `bytes` payload to decode (must match format of `encode`)
    /// @return x A uint256
    /// @return addr An Ethereum address
    /// @return arr A dynamic array of uint256
    /// @return myStruct The decoded MyStruct object
    function decode(bytes calldata data)
        external
        pure
        returns (
            uint256 x,
            address addr,
            uint256[] memory arr,
            MyStruct memory myStruct
        )
    {
        // Decode data assuming the exact order and types as used in encoding
        (x, addr, arr, myStruct) =
            abi.decode(data, (uint256, address, uint256[], MyStruct));
    }
}
