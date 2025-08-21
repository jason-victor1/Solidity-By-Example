// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 
 * ✍️ Signature Verification Walkthrough
 *
 * How to Sign and Verify
 * -----------------------
 * # Signing (done off-chain, e.g., with MetaMask or web3):
 *  1. Create message to sign.
 *  2. Hash the message.
 *  3. Sign the hash with your private key (keep private key secret!).
 *
 * # Verification (done on-chain):
 *  1. Recreate the hash from the original message.
 *  2. Prefix and re-hash in Ethereum’s format.
 *  3. Recover signer address from the signature and hash.
 *  4. Compare recovered signer to the claimed signer.
 */

contract VerifySignature {
    /**
     * @notice Create a keccak256 hash from inputs (the raw message).
     * @dev Combines `_to`, `_amount`, `_message`, `_nonce` into a packed hash.
     *
     * 📦 Analogy:
     * Imagine sealing a letter:
     * - Write down recipient, payment amount, message, and a nonce (unique serial).
     * - Compress them into a single sealed envelope (`keccak256` hash).
     *
     * @param _to Recipient address.
     * @param _amount Amount involved.
     * @param _message Text message included.
     * @param _nonce Unique number to prevent replay attacks.
     * @return The raw message hash.
     */
    function getMessageHash(
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /**
     * @notice Convert a raw message hash into an Ethereum signed message hash.
     * @dev Follows the Ethereum signing standard:
     *      `"\x19Ethereum Signed Message:\n32" + hash`
     *
     * 🔑 Analogy:
     * This is like stamping your sealed envelope with Ethereum’s official postmark
     * so everyone knows it’s an Ethereum message.
     *
     * @param _messageHash The raw keccak256 message hash.
     * @return The Ethereum signed message hash.
     */
    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
        );
    }

    /**
     * @notice Verify a signature against claimed signer and original data.
     * @dev Recomputes hashes, recovers signer, and compares with `_signer`.
     *
     * ✅ Analogy:
     * - Take the sealed and stamped envelope,
     * - Extract the signer’s handwriting (recover signer),
     * - Compare it to the claimed person.
     *
     * @param _signer Claimed signer address.
     * @param _to Recipient address.
     * @param _amount Amount value.
     * @param _message Message string.
     * @param _nonce Nonce value.
     * @param signature The digital signature bytes.
     * @return True if signature matches signer, false otherwise.
     */
    function verify(
        address _signer,
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    /**
     * @notice Recover the signer address from a signed message hash + signature.
     * @dev Uses `ecrecover` with (r, s, v) values from the signature.
     *
     * ✉️ Analogy:
     * Imagine analyzing the signature ink strokes to determine whose hand signed it.
     *
     * @param _ethSignedMessageHash The Ethereum signed message hash.
     * @param _signature The digital signature.
     * @return The recovered signer address.
     */
    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    /**
     * @notice Splits a 65-byte signature into r, s, v components.
     * @dev Standard Ethereum signature format is:
     *      - r (32 bytes)
     *      - s (32 bytes)
     *      - v (1 byte)
     *
     * 🔍 Analogy:
     * Think of the signature as a sandwich:
     * - First big chunk = r,
     * - Second big chunk = s,
     * - Last small bite = v.
     *
     * @param sig The signature bytes.
     * @return r First 32 bytes.
     * @return s Second 32 bytes.
     * @return v Recovery id (27 or 28 usually).
     */
    function splitSignature(bytes memory sig)
        public
        pure
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            // r = bytes 0..31 after length prefix
            r := mload(add(sig, 32))
            // s = bytes 32..63
            s := mload(add(sig, 64))
            // v = byte 64 (first byte of next word)
            v := byte(0, mload(add(sig, 96)))
        }
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * - `getMessageHash(to, amount, msg, nonce)`:
 *   → Raw keccak256 hash of message data.
 *
 * - `getEthSignedMessageHash(hash)`:
 *   → Ethereum postmark added (prefix + hash).
 *
 * - `verify(signer, ...)`:
 *   → Checks that the provided signature really came from signer.
 *
 * - `recoverSigner(hash, sig)`:
 *   → Uses `ecrecover` to pull out the signer’s address.
 *
 * - `splitSignature(sig)`:
 *   → Splits the digital signature into its r, s, v parts.
 *
 * 🏷️ Real-World Analogy:
 * - Message hash = sealed envelope of the message.
 * - Ethereum signed message hash = envelope stamped with Ethereum’s seal.
 * - Signature = handwritten autograph on the envelope.
 * - ecrecover = handwriting expert that identifies who signed.
 * - Verify = comparing the expert’s opinion with the claimed signer.
 */
