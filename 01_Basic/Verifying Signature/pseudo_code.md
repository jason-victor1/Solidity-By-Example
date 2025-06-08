### 🏗️ SETUP: Signature Verification Smart Contract

1. 📦 Contract Name: `VerifySignature`

   - Purpose: Verifies that a message was signed by the correct private key holder.

---

### 🔁 Step 1: Get Message Hash

```solidity
function getMessageHash(address _to, uint256 _amount, string memory _message, uint256 _nonce)
```

2. 🧱 BUILD a raw message hash using `abi.encodePacked`

   - Inputs: `recipient address`, `amount`, `string message`, and `nonce`
   - ➡️ This is the raw message that will be signed off-chain.
   - ✅ Returns a **keccak256 hash** of the packed message.

---

### 🔐 Step 2: Get Ethereum-Signed Message Hash

```solidity
function getEthSignedMessageHash(bytes32 _messageHash)
```

3. 🔒 WRAP the hash to match Ethereum's expected signing format:

   - Format: `"\x19Ethereum Signed Message:\n32" + messageHash`
   - ✅ Returns the hash used for `ecrecover`.

---

### 🔍 Step 3: Verify Signature

```solidity
function verify(
    address _signer,
    address _to,
    uint256 _amount,
    string memory _message,
    uint256 _nonce,
    bytes memory signature
)
```

4. 🔁 RECREATE message hash → `getMessageHash(...)`

5. 🔁 WRAP into Ethereum-signed hash → `getEthSignedMessageHash(...)`

6. 🧠 RECOVER signer from signature → `recoverSigner(...)`

7. 🔁 COMPARE recovered address to claimed `_signer`

   - ✅ Returns `true` if they match, `false` otherwise.

---

### 🧠 Step 4: Recover Signer Address

```solidity
function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
```

8. 🪓 SPLIT the 65-byte signature into components: `r`, `s`, and `v`

9. 🔐 Call `ecrecover(...)` to extract the signer's address from:

   - The signed message hash
   - The signature parts

---

### ✂️ Step 5: Split Signature into r, s, v

```solidity
function splitSignature(bytes memory sig)
```

10. 🧪 ENSURE the signature is 65 bytes

11. 🧩 EXTRACT signature components using low-level `assembly`:

- `r` = first 32 bytes
- `s` = second 32 bytes
- `v` = first byte of the third 32-byte chunk

12. 🧲 RETURN (r, s, v)
