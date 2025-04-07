// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Contract to demonstrate hashing with keccak256 and potential hash collisions
contract HashFunction {
    // Function to generate a hash from multiple inputs
    function hash(
        string memory _text,
        uint256 _num,
        address _addr
    ) public pure returns (bytes32) {
        // Combine the inputs into a single byte array using abi.encodePacked
        // and return the keccak256 hash of the combined data
        return keccak256(abi.encodePacked(_text, _num, _addr));
    }

    // Function to demonstrate hash collisions with abi.encodePacked
    // WARNING: Hash collision can occur when using multiple dynamic data types with abi.encodePacked
    function collision(
        string memory _text,
        string memory _anotherText
    ) public pure returns (bytes32) {
        // Example of collision:
        // encodePacked("AAA", "BBB") results in "AAABBB"
        // encodePacked("AA", "ABBB") also results in "AAABBB"
        // Both cases produce the same hash, leading to a collision
        return keccak256(abi.encodePacked(_text, _anotherText));
    }
}

// Contract to implement a guessing game using a precomputed hash
contract GuessTheMagicWord {
    // Precomputed hash of the magic word "Solidity"
    bytes32 public answer =
        0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

    // Function to guess the magic word
    function guess(string memory _word) public view returns (bool) {
        // Hash the user input and compare it to the precomputed hash
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}
