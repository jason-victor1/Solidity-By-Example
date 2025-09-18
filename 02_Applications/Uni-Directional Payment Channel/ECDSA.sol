// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ECDSA
 * @notice Utilities for verifying ECDSA signatures and recovering signer addresses.
 * @dev
 * 🧪 Real-World Analogy:
 * Think of this library as a **forensics lab** for signed letters.
 * - The letter: a 32-byte `hash` (often already Ethereum-prefixed).
 * - The envelope: the **signature** (classic `(r,s,v)` or compact EIP-2098 `(r,vs)`).
 * - The lab: checks the envelope format, validates tamper-evidence (low-`s`, proper `v`),
 *   then runs a “DNA test” (`ecrecover`) to identify the author (address).
 *
 * 💡 Tips:
 * - Use {toEthSignedMessageHash} if the message was signed with `personal_sign`/wallets.
 * - Enforce **low-s** to prevent malleability (two different signatures validating the same message).
 * - Expect `v ∈ {27,28}`; EIP-2098 helpers derive `v` from the compact form automatically.
 */
library ECDSA {
    /**
     * @notice Enumerates signature recovery outcomes.
     * @dev
     * 🧾 Analogy: Stamp codes in the lab report that say exactly what went wrong.
     */
    enum RecoverError {
        NoError,                 // ✅ Everything checks out
        InvalidSignature,        // ❌ ecrecover returned address(0)
        InvalidSignatureLength,  // ❌ Not 65 (r,s,v) nor 64 (r,vs)
        InvalidSignatureS,       // ❌ s not in lower half-order (malleable)
        InvalidSignatureV        // ❌ v not 27 or 28
    }

    /**
     * @dev Revert with a human-readable message for a given {RecoverError}.
     * 🧾 Analogy: Convert a lab error code into a clear written explanation.
     */
    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return;
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        } else if (error == RecoverError.InvalidSignatureV) {
            revert("ECDSA: invalid signature 'v' value");
        }
    }

    /**
     * @notice Attempt to recover the signer from a standard or compact signature.
     * @dev
     * - Accepts 65-byte `(r,s,v)` or 64-byte `(r,vs)` (EIP-2098).
     * - Returns `(signer, error)`, where `signer = address(0)` on failure.
     *
     * 📦 Analogy:
     * Open the envelope; if it’s the classic **three-piece kit** (r,s,v), use it;
     * if it’s the **compact** two-piece kit (r,vs), decode it; otherwise reject.
     *
     * @param hash The 32-byte message digest that was signed (often Ethereum-prefixed already).
     * @param signature The signature bytes.
     * @return signer The recovered address or `address(0)` on failure.
     * @return error A {RecoverError} explaining the outcome.
     */
    function tryRecover(bytes32 hash, bytes memory signature)
        internal
        pure
        returns (address signer, RecoverError error)
    {
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // Parse (r, s, v)
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else if (signature.length == 64) {
            bytes32 r;
            bytes32 vs;
            // Parse (r, vs) per EIP-2098
            assembly {
                r := mload(add(signature, 0x20))
                vs := mload(add(signature, 0x40))
            }
            return tryRecover(hash, r, vs);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    /**
     * @notice Recover the signer from a signature; reverts on error.
     * @dev Wrapper around {tryRecover(bytes32,bytes)} that throws on failure.
     *
     * 🧾 Analogy: Ask the lab for the author only—if anything’s off, they reject with a clear reason.
     *
     * @param hash The signed digest.
     * @param signature The signature bytes.
     * @return signer The recovered address (never zero on success).
     */
    function recover(bytes32 hash, bytes memory signature)
        internal
        pure
        returns (address signer)
    {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    /**
     * @notice Attempt to recover signer from compact EIP-2098 signature `(r,vs)`.
     * @dev
     * - Extracts `s` (lower 255 bits) and `v` (top bit → 27/28) from `vs`.
     * - Forwards to the `(v,r,s)` validator.
     *
     * 🔎 Analogy: Use a **magnifying glass** to separate the hidden `v` flag from `vs`.
     *
     * @param hash The signed digest.
     * @param r The r component.
     * @param vs The combined s + v-highbit (EIP-2098).
     * @return signer The recovered address or zero.
     * @return error A {RecoverError} code.
     */
    function tryRecover(bytes32 hash, bytes32 r, bytes32 vs)
        internal
        pure
        returns (address signer, RecoverError error)
    {
        bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        uint8 v = uint8((uint256(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }

    /**
     * @notice Recover signer from compact EIP-2098 signature `(r,vs)`; reverts on error.
     * @dev Wrapper around {tryRecover(bytes32,bytes32,bytes32)} that throws on failure.
     * @param hash The signed digest.
     * @param r The r component.
     * @param vs The combined s + v-highbit.
     * @return signer The recovered address (never zero on success).
     */
    function recover(bytes32 hash, bytes32 r, bytes32 vs)
        internal
        pure
        returns (address signer)
    {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    /**
     * @notice Core validator: attempt to recover signer from `(v,r,s)`.
     * @dev
     * - Enforces **low-s** (EIP-2) to prevent malleability.
     * - Accepts only `v ∈ {27, 28}`.
     * - Returns `(address(0), InvalidSignature)` if `ecrecover` fails.
     *
     * 🧷 Analogy:
     * Two entry gates before the DNA test:
     *  1) The **S squiggle** must be in the lower half (not tamper-susceptible).
     *  2) The **V stamp** must be 27 or 28 (proper envelope type).
     * If both pass, run the **DNA test** (`ecrecover`) to identify the author.
     *
     * @param hash The signed digest.
     * @param v The recovery id (27 or 28).
     * @param r The r component.
     * @param s The s component (must be low-s).
     * @return signer The recovered address or zero.
     * @return error A {RecoverError} code.
     */
    function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (address signer, RecoverError error)
    {
        // secp256k1n/2
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }
        if (v != 27 && v != 28) {
            return (address(0), RecoverError.InvalidSignatureV);
        }

        address recovered = ecrecover(hash, v, r, s);
        if (recovered == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }
        return (recovered, RecoverError.NoError);
    }

    /**
     * @notice Recover signer from `(v,r,s)`; reverts on error.
     * @dev Wrapper around {tryRecover(bytes32,uint8,bytes32,bytes32)} that throws on failure.
     * @param hash The signed digest.
     * @param v The recovery id (27 or 28).
     * @param r The r component.
     * @param s The s component (low-s).
     * @return signer The recovered address (never zero on success).
     */
    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (address signer)
    {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    /**
     * @notice Convert a raw 32-byte hash into the Ethereum Signed Message format.
     * @dev Returns `keccak256("\x19Ethereum Signed Message:\n32" || hash)`.
     *
     * 📜 Analogy:
     * Print the note on **official Ethereum letterhead** (“32-byte message”) so wallets know exactly
     * what they’re signing and verifiers can reproduce the same digest on-chain.
     *
     * @param hash Raw 32-byte message digest.
     * @return ethHash Prefixed hash expected by `personal_sign` and friends.
     */
    function toEthSignedMessageHash(bytes32 hash)
        internal
        pure
        returns (bytes32 ethHash)
    {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}
