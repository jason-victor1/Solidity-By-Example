// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {MerkleProof} from "./MerkleProof.sol";

/**
 * @title IToken (Mintable)
 * @notice Minimal interface for a token that supports minting.
 * @dev
 * 🪙 Real-World Analogy:
 * Think of this as the **ticket printer** at the venue—given a name and a count,
 * it prints fresh tickets (tokens) on demand.
 */
interface IToken {
    function mint(address to, uint256 amount) external;
}

/**
 * @title Airdrop (Merkle-Based)
 * @notice Gas-efficient claim contract where eligible recipients prove inclusion
 *         in a Merkle tree and receive freshly minted tokens exactly once.
 * @dev
 * 🌳 Real-World Analogy:
 * - **Merkle Root** = the **sealed master guest list** at the venue entrance.
 * - **Leaf** (`keccak(to, amount)`) = your **personalized ticket stub** (who you are + how many tickets).
 * - **Merkle Proof** = the **chain of checkpoints** that shows your stub appears on the sealed list.
 * - **claimed[leaf]** = the **hand stamp** preventing you from redeeming twice.
 * - **token.mint(to, amount)** = the **ticket printer** dispensing your tickets once verified.
 *
 * Security & UX Notes:
 * - Leaf uniqueness: each `(to, amount)` pair must appear **at most once** in the tree
 *   (duplicate entries would share the same leaf hash and would be blocked by `claimed`).
 * - Off-chain list construction determines distribution; this contract only verifies and dispenses.
 */
contract Airdrop {
    /// @notice Emitted when `to` successfully claims `amount` tokens.
    /// @dev 📣 Analogy: “Announcing: Alice has redeemed 5 tickets!”
    event Claim(address to, uint256 amount);

    /// @notice Token contract used for minting rewards.
    /// @dev 🖨️ Analogy: The **ticket printer** reference.
    IToken public immutable token;

    /// @notice Merkle root committing to all eligible `(to, amount)` pairs.
    /// @dev 🧾 Analogy: The **sealed master guest list** hash at the door.
    bytes32 public immutable root;

    /// @notice Tracks whether a specific leaf `(to, amount)` has already been claimed.
    /// @dev ✋ Analogy: A **wrist stamp** keyed by the leaf hash; once stamped, no re-entry.
    mapping(bytes32 => bool) public claimed;

    /**
     * @notice Initialize the airdrop with the token printer and the sealed guest list root.
     * @dev
     * 🏁 Analogy: Set the venue’s **ticket printer** and hang the **sealed guest list** by the door.
     * @param _token Address of the token contract that supports `mint`.
     * @param _root  Merkle root for `(to, amount)` entries.
     */
    constructor(address _token, bytes32 _root) {
        token = IToken(_token);
        root = _root;
    }

    /**
     * @notice Compute the canonical leaf hash for a `(to, amount)` entry.
     * @dev
     * 🔖 Analogy: Make the **ticket stub** by hashing the name and the promised ticket count.
     * Uses `abi.encode` (not `encodePacked`) to avoid ambiguity in composite values.
     * @param to     Recipient address.
     * @param amount Token amount allocated to the recipient.
     * @return The leaf hash `keccak256(abi.encode(to, amount))`.
     */
    function getLeafHash(address to, uint256 amount)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(to, amount));
    }

    /**
     * @notice Claim your airdropped tokens by presenting a valid Merkle proof.
     * @dev
     * Flow:
     * 1) Build leaf from `(to, amount)`.
     * 2) Check not already claimed (wrist stamp).
     * 3) Verify proof against `root`.
     * 4) Stamp as claimed and **mint** tokens to `to`.
     *
     * 🧭 Analogy:
     * Show the **chain of checkpoints** (Merkle proof) proving your **ticket stub** is on the
     * **sealed guest list**. If valid and not stamped yet, the **ticket printer** dispenses your tickets,
     * and you get a **stamp** so you can’t claim again.
     *
     * @param proof  Array of sibling hashes from your leaf up to the root (in correct order).
     * @param to     Recipient to receive the minted tokens.
     * @param amount Exact token amount allocated in the tree for `to`.
     *
     * Reverts:
     * - "airdrop already claimed" if this leaf was previously redeemed.
     * - "invalid merkle proof" if `proof` does not reconstruct `root` with the provided leaf.
     *
     * Emits:
     * - {Claim} on success.
     */
    function claim(bytes32[] memory proof, address to, uint256 amount)
        external
    {
        // Build the ticket stub (leaf) for the recipient and amount.
        bytes32 leaf = getLeafHash(to, amount);

        // Prevent double redemption using the wrist-stamp map.
        require(!claimed[leaf], "airdrop already claimed");

        // Validate the presented path up to the sealed guest list.
        require(MerkleProof.verify(proof, root, leaf), "invalid merkle proof");

        // Stamp now to prevent re-use even if mint hooks revert later elsewhere.
        claimed[leaf] = true;

        // Dispense the tickets (mint tokens) to the rightful recipient.
        token.mint(to, amount);

        emit Claim(to, amount);
    }
}
