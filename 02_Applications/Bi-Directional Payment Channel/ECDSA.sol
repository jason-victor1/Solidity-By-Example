// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ECDSA
 * @notice Utilities for verifying ECDSA signatures and recovering signer addresses.
 * @dev
 * 🧪 Real-World Analogy:
 * Think of this library as a **forensics lab for signed letters**.
 * - The *letter* is a 32-byte `hash`.
 * - The *envelope* is the **signature** (either classic `(r,s,v)` or compact EIP-2098 `(r,vs)`).
 * - The *lab* validates the envelope (length, `v`, low-`s`) and then runs a **DNA test** (`ecrecover`)
 *   to identify the author (Ethereum address).
 *
 * ✅ Tips:
 * - Use {toEthSignedMessageHash} when verifying signatures created by wallets via `personal_sign`.
 * - Enforce **low-`s`** (EIP-2) to prevent malleable signatures.
 * - Accept only `v ∈ {27, 28}` (EIP-2098 path derives this automatically from `vs`).
 */
library ECDSA {
    /**
     * @notice Standardized error codes for signature recovery.
     * @dev
     * 🧾 Analogy: The lab’s **stamp codes** explaining exactly what went wrong.
     */
    enum RecoverError {
        NoError,                 // ✅ Everything checks out
        InvalidSignature,        // ❌ ecrecover returned address(0)
        InvalidSignatureLength,  // ❌ Not 65 (r,s,v) nor 64 (r,vs)
        InvalidSignatureS,       // ❌ s not in lower half-order (malleable)
        InvalidSignatureV        // ❌ v not 27 or 28
    }

    /**
     * @notice Convert an error code into a readable revert reason.
     * @dev
     * 🧾 Analogy: Turn the lab’s **stamp code** into a plain-language report.
     * @param error The recovery outcome to translate.
     */
    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // do nothing
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
     * @notice Attempt to recover the signer from a signature (classic 65B or compact 64B).
     * @dev
     * - 65 bytes → parse `(r,s,v)` (classic kit) and validate.
     * - 64 bytes → parse `(r,vs)` (EIP-2098 compact kit), derive `(s,v)`, then validate.
     *
     * 📦 Analogy: Open the **envelope**; accept either the classic **3-piece** or **2-piece** compact kit.
     *
     * @param hash The 32-byte message digest that was signed (often already Ethereum-prefixed).
     * @param signature The signature bytes (65 or 64 long).
     * @return signer Recovered address or `address(0)` on failure.
     * @return error  A {RecoverError} describing the outcome.
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
            // Parse (r, s, v) from the byte array.
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else if (signature.length == 64) {
            bytes32 r;
            bytes32 vs;
            // Parse (r, vs) per EIP-2098 (v is the top bit of vs).
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
     * @dev Wrapper around {tryRecover(bytes32,bytes)} that throws with readable errors.
     *
     * 🧾 Analogy: Ask the lab to give **only the author**. If anything is off, it returns a clear rejection.
     *
     * @param hash The signed digest (often from {toEthSignedMessageHash}).
     * @param signature The signature bytes (65 or 64).
     * @return signer The recovered, non-zero address.
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
     * @notice Attempt to recover the signer from a compact EIP-2098 signature `(r,vs)`.
     * @dev
     * - `s = vs & 0x7..7` (lower 255 bits)
     * - `v = (vs >> 255) + 27` (top bit maps to 27/28)
     * Then validate via the `(v,r,s)` path.
     *
     * 🔎 Analogy: Use a **magnifying glass** to separate the **S squiggle** and **V stamp** hidden inside `vs`.
     *
     * @param hash The signed digest.
     * @param r The r component.
     * @param vs The combined s + v-highbit per EIP-2098.
     * @return signer Recovered address or zero.
     * @return error  Recovery status code.
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
     * @notice Recover signer from compact EIP-2098 `(r,vs)`; reverts on error.
     * @dev Wrapper around {tryRecover(bytes32,bytes32,bytes32)}.
     * @param hash The signed digest.
     * @param r The r component.
     * @param vs The combined s + v-highbit.
     * @return signer The recovered, non-zero address.
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
     * - Enforces **low-`s`** (EIP-2) to prevent signature malleability.
     * - Accepts only `v ∈ {27, 28}`.
     * - Returns `(address(0), InvalidSignature)` if `ecrecover` fails.
     *
     * 🧷 Analogy: Two **security gates** before the DNA test:
     *  1) The **S squiggle** must be in the lower half (not tamper-susceptible).
     *  2) The **V stamp** must be one of two valid types (27/28).
     * If both pass, the lab runs the **DNA test** (`ecrecover`) to identify the author.
     *
     * @param hash The signed digest.
     * @param v The recovery id (27 or 28).
     * @param r The r component.
     * @param s The s component (must be low-`s`).
     * @return signer Recovered address or zero.
     * @return error  Recovery status code.
     */
    function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (address signer, RecoverError error)
    {
        // secp256k1n/2 → upper bound for low-s
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
     * @dev Wrapper around {tryRecover(bytes32,uint8,bytes32,bytes32)}.
     * @param hash The signed digest.
     * @param v The recovery id (27 or 28).
     * @param r The r component.
     * @param s The s component (low-`s`).
     * @return signer The recovered, non-zero address.
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
     * @dev Equivalent to `keccak256("\x19Ethereum Signed Message:\n32" || hash)`.
     *
     * 📜 Analogy: Print the note on **official Ethereum letterhead** so wallets and verifiers
     * agree on the exact document being signed.
     *
     * @param hash Raw 32-byte message digest.
     * @return ethHash Prefixed hash expected by `personal_sign` and compatible wallets.
     */
    function toEthSignedMessageHash(bytes32 hash)
        internal
        pure
        returns (bytes32 ethHash)
    {
        // 32 is the length of `hash` in bytes (enforced by the type)
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}
