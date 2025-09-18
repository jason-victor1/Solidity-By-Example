### 🧠 Pseudo Code with Real-World Analogies: `UniDirectionalPaymentChannel`

---

1. **START**

---

2. **IMPORT** the `ECDSA` library

   - Purpose: provide helpers for **Ethereum-style signed messages** and **signature recovery**.
   - Analogy: a **signature detective kit** that can check if a note was truly signed by a particular person.

---

3. **DEFINE** `ReentrancyGuard`

   - State: `locked` (boolean)
   - Modifier: `guard`

     - **CHECK**: `locked` must be false
     - **SET**: `locked = true`
     - Run the function
     - **SET**: `locked = false`

   - Analogy: a **bathroom occupied sign** — flip it when you go in so no one else barges in (prevents re-entrancy attacks).

---

4. **DEFINE** `UniDirectionalPaymentChannel` **(is ReentrancyGuard)**

   - Uses `ECDSA` for hashing and signature recovery.
   - Parties:

     - `sender` (payer, funds the channel)
     - `receiver` (payee, can cash out with a valid signature)

   - Constants and state:

     - `DURATION` = 7 days
     - `expiresAt` = **creation time + 7 days**

   - Analogy: a **gift card** that one person (sender) preloads with money and another person (receiver) can redeem within **7 days**.

---

5. **CONSTRUCTOR(receiver)** **payable**

   - **REQUIRE**: `receiver != 0`
   - `sender = msg.sender` (the one funding the channel)
   - `receiver = _receiver`
   - `expiresAt = now + 7 days`
   - Ether sent with deployment becomes the **channel’s balance**.
   - Analogy: sender buys a **one-use prepaid voucher** for the receiver, valid for a week.

---

6. **DEFINE** `_getHash(amount)` **private view** → `bytes32`

   - Compute `keccak256( address(this), amount )`
   - Analogy: a **chit** that says “This voucher (by serial number = contract address) promises up to **amount** tokens.”
   - Why include `address(this)`?

     - Prevent **replay** on other similar channels: the chit is **bound** to this exact voucher.

---

7. **DEFINE** `getHash(amount)` **external view** → `bytes32`

   - Returns `_getHash(amount)` for convenience (off-chain signing helpers).
   - Analogy: show the **exact text** the sender is supposed to sign.

---

8. **DEFINE** `_getEthSignedHash(amount)` **private view** → `bytes32`

   - Take `_getHash(amount)` and wrap with `toEthSignedMessageHash()` (adds the standard Ethereum prefix).
   - Analogy: stamp the chit with the **official Ethereum letterhead** so wallets know what they’re signing.

---

9. **DEFINE** `getEthSignedHash(amount)` **external view** → `bytes32`

   - Returns `_getEthSignedHash(amount)` (frontend convenience).
   - Analogy: “This is exactly what your wallet will sign.”

---

10. **DEFINE** `_verify(amount, sig)` **private view** → `bool`

    - Recover the signer from `_getEthSignedHash(amount).recover(sig)`
    - **CHECK**: signer == `sender`
    - Analogy: the detective kit checks the handwriting on the chit; it must match the **sender** who funded the voucher.

---

11. **DEFINE** `verify(amount, sig)` **external view** → `bool`

    - Returns `_verify(amount, sig)` for off-chain testing / UI.
    - Analogy: a quick **authenticity checker** for the signed chit.

---

12. **DEFINE** `close(amount, sig)` **external** **guard**

    - **Role**: called by **receiver** to cash out.
    - **REQUIRE**: `msg.sender == receiver` (only payee can redeem)
    - **REQUIRE**: `_verify(amount, sig)` (signature must be from sender)
    - **PAY**: send `amount` Ether to `receiver`
    - **SELFDESTRUCT**: `selfdestruct(sender)` → sends remaining balance (change) back to `sender` and **closes channel forever**
    - Analogy: receiver presents the **signed chit** at the desk; cashier pays out the specified amount, then the **voucher is shredded** and leftover funds go back to the buyer.
    - Reentrancy safety: protected by the **bathroom sign** (`guard`) while paying out and self-destructing.

---

13. **DEFINE** `cancel()` **external**

    - **Role**: called by **sender** to reclaim funds after expiry.
    - **REQUIRE**: `msg.sender == sender`
    - **REQUIRE**: `now >= expiresAt`
    - **SELFDESTRUCT**: send everything back to `sender`
    - Analogy: if the receiver **never redeemed** within a week, the buyer returns to the store with the voucher and gets a refund; the voucher is **shredded**.

---

14. **OFF-CHAIN FLOW (How it’s used in practice)**

    - Step A: **Open** — Sender deploys the channel and funds it (the voucher gets money loaded).
    - Step B: **Sign IOUs** — As work progresses, sender **off-chain signs** increasing amounts (e.g., 1 ETH, then 2 ETH, etc.) and sends the signatures to receiver.

      - Analogy: sender writes progressively larger **promissory notes** but **does not** spend gas on-chain each time.

    - Step C: **Redeem** — Receiver submits the **highest-value signed chit** to `close(amount, sig)`.

      - Gets `amount`; leftover is refunded to sender; channel self-destructs.
      - Analogy: hand in the **largest chit** you have; the voucher is used once and destroyed.

---

15. **SECURITY & DESIGN NOTES**

    - **Re-entrancy**: `guard` prevents nested calls during payout + self-destruct.
    - **Replay protection**: including `address(this)` in the hash binds signatures to this channel instance.
    - **Prefixing**: `toEthSignedMessageHash()` ensures wallet-signed messages are verified correctly.
    - **Monotonic amounts**: receiver should always prefer the **largest** signed amount; sender needn’t track nonces because the channel self-destructs on first close (single redemption).
    - **Expiry**: protects sender if receiver disappears (can reclaim after `expiresAt`).
    - **Funding**: ensure `amount` ≤ channel balance when redeeming (the example sends `amount` then selfdestructs to return the rest; if `amount` exceeds balance, the send will fail and revert).

---

16. **END**

---

### 🔎 Quick Reference (Cheat Sheet)

- **Hash to sign**: `keccak256( address(this), amount )` → **prefix** → sign → `sig`
- **Close** (receiver-only): verify sig → pay `amount` → `selfdestruct(sender)`
- **Cancel** (sender-only after expiry): `selfdestruct(sender)`
- **Guard pattern**: **bathroom occupied sign** during `close`
- **One-shot channel**: channel ends on first successful close or on cancel after timeout.
