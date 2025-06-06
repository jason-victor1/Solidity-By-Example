
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title HashFunction - Demonstrates how to hash data using keccak256 and illustrates potential pitfalls of abi.encodePacked
contract HashFunction {

    /// @notice Hashes a combination of a string, a uint256, and an address
    /// @param _text The input string
    /// @param _num A numeric value to include in the hash
    /// @param _addr The Ethereum address to include in the hash
    /// @return The resulting keccak256 hash of the packed parameters
    function hash(string memory _text, uint256 _num, address _addr)
        public
        pure
        returns (bytes32)
    {
        // Combines multiple input types using abi.encodePacked and hashes the result
        return keccak256(abi.encodePacked(_text, _num, _addr));
    }

    /// @notice Demonstrates a potential hash collision when using abi.encodePacked with two dynamic string types
    /// @dev When multiple dynamic types are packed, boundaries are not preserved, leading to collision risk
    /// @param _text First input string
    /// @param _anotherText Second input string
    /// @return The resulting keccak256 hash of the packed strings
    function collision(string memory _text, string memory _anotherText)
        public
        pure
        returns (bytes32)
    {
        // ⚠️ Example collision:
        // encodePacked("AAA", "BBB") → "AAABBB"
        // encodePacked("AA", "ABBB") → also "AAABBB"
        // Use abi.encode instead of abi.encodePacked to avoid this risk
        return keccak256(abi.encodePacked(_text, _anotherText));
    }
}

/// @title GuessTheMagicWord - A guessing game that uses hashing to verify a secret word
contract GuessTheMagicWord {

    /// @notice The keccak256 hash of the word "Solidity"
    bytes32 public answer =
        0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

    /// @notice Compares a user-supplied word to the correct hashed answer
    /// @dev Uses abi.encodePacked to match the original encoding of "Solidity"
    /// @param _word The guessed word
    /// @return True if the guessed word's hash matches the stored answer
    function guess(string memory _word) public view returns (bool) {
        // Compares the hash of the input word to the stored correct answer
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}
