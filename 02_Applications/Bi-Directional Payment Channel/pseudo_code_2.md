### 🧠 Pseudo Code with Real-World Analogies: `ECDSA`

---

1. **START**

2. **DEFINE** a library called `ECDSA`

   - Purpose: **verify who signed a message** and return the signer’s address.
   - Analogy: a **forensics lab** for sealed letters: it checks the envelope and signature, then runs a “DNA test” to identify the author.

3. **ENUM** `RecoverError`

   - `NoError` → all good
   - `InvalidSignature` → DNA test failed (no author)
   - `InvalidSignatureLength` → envelope has the wrong size
   - `InvalidSignatureS` → the “S squiggle” is in the forbidden zone (malleable)
   - `InvalidSignatureV` → the “V stamp” isn’t one of the two valid types (27/28)
   - Analogy: standardized **rejection stamps** the lab uses on reports.

4. **FUNCTION** `_throwError(error)`

   - If error is not `NoError`, **revert** with a human-readable reason.
   - Analogy: translate a **stamp code** into a clear note on the lab report.

5. **FUNCTION** `tryRecover(hash, signature) -> (signer, error)`

   - If `signature.length == 65`: parse `(r, s, v)` (classic kit).
   - Else if `signature.length == 64`: parse `(r, vs)` (EIP-2098 compact kit), then delegate to the compact path.
   - Else: return `(0, InvalidSignatureLength)`.
   - Analogy: open the envelope; accept either the **3-piece classic** or **2-piece compact** kit. Reject other shapes.

6. **FUNCTION** `recover(hash, signature) -> signer`

   - Calls `tryRecover` and **throws** if there’s an error.
   - Analogy: “Just tell me who signed it; if anything’s off, give me a clear exception.”

7. **FUNCTION** `tryRecover(hash, r, vs) -> (signer, error)` (compact path)

   - Extract:

     - `s` = low 255 bits of `vs`
     - `v` = high bit of `vs` mapped to {27,28}

   - Forward to `(hash, v, r, s)` validator.
   - Analogy: use a **magnifying glass** to split the combined piece (`vs`) into the **S squiggle** and the **V stamp**.

8. **FUNCTION** `recover(hash, r, vs) -> signer`

   - Same as above but **throws** on error.
   - Analogy: “Give me the author or fail loudly.”

9. **FUNCTION** `tryRecover(hash, v, r, s) -> (signer, error)` (core validator)

   - Enforce **low-s** rule (EIP-2): `s` must be ≤ secp256k1n/2 → else `InvalidSignatureS`.
   - Enforce `v ∈ {27, 28}` → else `InvalidSignatureV`.
   - Run `ecrecover(hash, v, r, s)` → if zero, `InvalidSignature`; else `(signer, NoError)`.
   - Analogy: two **security gates** (S and V) before the final **DNA test**; if all pass, you get the author.

10. **FUNCTION** `recover(hash, v, r, s) -> signer`

    - Wraps the core validator and **throws** on error.
    - Analogy: same DNA test, but you want a definitive author or a clear failure message.

11. **FUNCTION** `toEthSignedMessageHash(hash) -> ethHash`

    - Returns `keccak256("\x19Ethereum Signed Message:\n32" || hash)`.
    - Analogy: print the note on **official Ethereum letterhead** so wallets and verifiers agree on the exact document being signed.

12. **USAGE FLOW (Story Time)**

    - **Signing (off-chain):**

      1. Compute some `hash` of your data.
      2. Convert to Ethereum format: `ethHash = toEthSignedMessageHash(hash)`.
      3. Wallet signs `ethHash` → you get a signature (classic 65B or compact 64B).

    - **Verifying (on-chain):**

      1. Call `ECDSA.recover(ethHash, signature)` (or the appropriate overload).
      2. Compare returned address with expected signer (e.g., `owner`).
      3. Accept if they match; otherwise reject.

13. **SECURITY NOTES**

    - **Prefixing matters**: if your wallet used `personal_sign`, **always** use `toEthSignedMessageHash` before recovering.
    - **Low-s** prevents **malleability** (two signatures validating the same message).
    - **v normalization**: some libs output `0/1`; this code expects `27/28` (EIP-2098 handles the mapping via `vs`).
    - **Correct preimage**: ensure you hash **exactly** the same bytes that were signed (no silent encoding differences).
    - **Context binding**: to prevent **replay** across contracts/systems, include identifiers (e.g., contract address, chain id, purpose) in the preimage _before_ signing.

14. **END**

---

### 🔎 Quick Reference (Cheat Sheet)

- **Classic sig**: 65B = `(r, s, v)`
- **Compact (EIP-2098)**: 64B = `(r, vs)` where

  - `s = vs & 0x7…7` (clear top bit)
  - `v = ((uint256(vs) >> 255) + 27)`

- **Low-s** enforced (EIP-2)
- **Valid v**: `27` or `28`
- **Recover**: `ECDSA.recover(ethHash, sig)` → `address`
- **Prefix**: `toEthSignedMessageHash(hash)` = Ethereum letterhead

**Analogy Recap:**

- Library = **forensics lab**
- Signature = **envelope with evidence** (classic or compact)
- `toEthSignedMessageHash` = **official letterhead**
- `ecrecover` = **DNA test** confirming the author.
