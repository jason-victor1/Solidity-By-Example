// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MerkleProof {
    /**
     * @title MerkleProof
     * @dev Verifies membership of a leaf in a Merkle Tree using a proof.
     *
     * 🌳 Analogy:
     * Think of a Merkle tree as a **family tree of receipts**:
     * - Each transaction (leaf) is like a receipt.
     * - Parents combine two child receipts into a new combined hash.
     * - The final ancestor at the top is the **Merkle root** (the ultimate signature of all transactions).
     *
     * To prove your receipt is in the tree:
     * - You present your receipt (leaf),
     * - Along with the "sibling receipts" (proof elements),
     * - Step by step, you rebuild the path upward,
     * - Until you get the Merkle root.
     *
     * If your computed root = the known root → ✅ proof valid.
     */

    /**
     * @notice Verify if a leaf is part of a Merkle tree.
     * @dev Iteratively combines the leaf with proof elements depending on index parity.
     *
     * 📦 Analogy:
     * - Start with your receipt (`leaf`).
     * - At each level:
     *   - If you were the left child (`index % 2 == 0`), stack your receipt on the left and sibling on right.
     *   - If you were the right child, stack sibling first then you.
     * - Hash them together to climb one level up the family tree.
     * - Repeat until you reach the root.
     *
     * @param proof Array of sibling hashes needed for verification.
     * @param root The Merkle root (final ancestor hash).
     * @param leaf The leaf hash (transaction to verify).
     * @param index Position of the leaf in the tree (used to order concatenation).
     * @return True if leaf is part of tree, false otherwise.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf,
        uint256 index
    ) public pure returns (bool) {
        bytes32 hash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (index % 2 == 0) {
                // Leaf is left child
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                // Leaf is right child
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }

            index = index / 2; // Move one level up.
        }

        return hash == root; // ✅ Match means leaf belongs to the tree.
    }
}

contract TestMerkleProof is MerkleProof {
    /**
     * @title TestMerkleProof
     * @dev Builds a small Merkle tree from sample transactions for testing.
     *
     * 🧪 Analogy:
     * Imagine you start with four transaction receipts:
     * - "alice -> bob"
     * - "bob -> dave"
     * - "carol -> alice"
     * - "dave -> bob"
     *
     * Step 1: Hash each receipt → leaves.
     * Step 2: Pair and hash them → parents.
     * Step 3: Repeat until one ancestor remains → root.
     */

    /// @notice Stores all hashes (leaves + intermediate + root).
    bytes32[] public hashes;

    constructor() {
        string[4] memory transactions =
            ["alice -> bob", "bob -> dave", "carol -> alice", "dave -> bob"];

        // Step 1: Hash leaves (transactions)
        for (uint256 i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint256 n = transactions.length;
        uint256 offset = 0;

        // Step 2 & 3: Iteratively compute parents until root.
        while (n > 0) {
            for (uint256 i = 0; i < n - 1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(
                            hashes[offset + i],
                            hashes[offset + i + 1]
                        )
                    )
                );
            }
            offset += n;
            n = n / 2;
        }
    }

    /**
     * @notice Returns the Merkle root of the built tree.
     * @dev Always the last element in the `hashes` array.
     *
     * 🌳 Analogy:
     * This is the "great-grandparent" at the very top of the family tree.
     *
     * @return The Merkle root.
     */
    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }

    /* 
     * Example: Verify membership of the 3rd leaf ("carol -> alice")
     *
     * leaf:
     *  0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b
     *
     * root:
     *  0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7
     *
     * index:
     *  2 (3rd position, since arrays are 0-based)
     *
     * proof (siblings needed to climb the tree):
     *  0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950
     *  0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433
     *
     * Verify by calling:
     *  verify(proof, root, leaf, 2) → true ✅
     */
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * MerkleProof:
 * - `verify(proof, root, leaf, index)`:
 *   → Climb the tree step by step, rebuild parent hashes, and check if final hash == root.
 *
 * TestMerkleProof:
 * - Builds a 4-leaf Merkle tree.
 * - `getRoot()` → returns Merkle root.
 * - Example given to verify 3rd leaf using its proof.
 *
 * 🌳 Real-World Analogy:
 * - Leaf = your individual receipt.
 * - Proof = the sibling receipts you need to climb up the tree.
 * - Root = the family’s notarized signature at the top.
 * - Verify = showing your receipt + sibling proofs to prove you belong to the official family tree.
 */
