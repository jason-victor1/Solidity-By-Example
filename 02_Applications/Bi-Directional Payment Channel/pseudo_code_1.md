### 🧠 Pseudo Code with Real-World Analogies: `BiDirectionalPaymentChannel`

---

1. **START**

2. **IMPORT** `ECDSA`

   - Analogy: a **signature detective kit** that can verify handwritten IOUs (wallet signatures).

3. **DEFINE** contract `BiDirectionalPaymentChannel`

   - **EVENT** `ChallengeExit(sender, nonce)` → someone submitted a new “latest IOU” and restarted the timer.
   - **EVENT** `Withdraw(to, amount)` → a party took their funds after the timer ran out.
   - **STATE**

     - `users[2]` → the two parties (like two names on a joint tab).
     - `isUser[address]` → quick membership check (“Are you on this tab?”).
     - `balances[address]` → the current split of the tab (who gets how much).
     - `challengePeriod` → **how long** the dispute window lasts (e.g., 1 day).
     - `expiresAt` → **when** the current dispute window ends.
     - `nonce` → version number of the latest signed state (higher = newer).

   - Analogy: think of a **shared bar tab** with two people. They can keep updating the split off-chain by co-signing new receipts. On-chain only the most recent **co-signed receipt** counts, and there’s a **last-call timer** during disputes.

4. **MODIFIER** `checkBalances(_balances)`

   - Ensure contract’s ETH ≥ sum of both balances.
   - Analogy: the cash box must have **at least** the total owed on the receipt.

5. **CONSTRUCTOR** `(users[2], balances[2], expiresAtInit, challengePeriod)` **payable**

   - **REQUIRE** `expiresAtInit > now` and `challengePeriod > 0`.
   - Record the two unique users and their starting balances.
   - Set `expiresAt = expiresAtInit` and `challengePeriod`.
   - ETH sent at deployment funds the channel (comes from a multisig in the intended flow).
   - Analogy: open the **joint tab** with an initial signed receipt and a **deadline**. Deposit enough cash in the box to cover the split.

6. **FUNCTION** `verify(signatures[2], contractAddr, signers[2], balances[2], nonce)` **pure → bool**

   - For each signer:

     - Recreate message: `keccak256(contractAddr, balances, nonce)`
     - Prefix (`toEthSignedMessageHash`) and `recover(signature)` → must equal the expected signer.

   - Return `true` only if both signatures match.
   - Analogy: check that **both diners** signed the **same receipt** (same contract, same split, same version). Binding the **contract address** prevents **reusing** the same receipt at a different restaurant.

7. **MODIFIER** `checkSignatures(signatures[2], balances[2], nonce)`

   - Copy `users` into `signers` and call `verify(...)`.
   - Revert if invalid.
   - Analogy: before accepting a receipt, the cashier confirms **both signatures** are real and match **this venue** and **this version**.

8. **MODIFIER** `onlyUser()`

   - Caller must be one of the two users.
   - Analogy: only the two people on the tab can submit updates or withdraw.

9. **FUNCTION** `challengeExit(balances[2], nonceNew, signatures[2])`

   - **onlyUser**, **checkSignatures**, **checkBalances**
   - **REQUIRE** now < `expiresAt` (you can only challenge while the window is open).
   - **REQUIRE** `nonceNew > nonce` (newer receipt beats older).
   - Update on-chain `balances` to the new split and set `nonce = nonceNew`.
   - Reset timer: `expiresAt = now + challengePeriod`.
   - Emit `ChallengeExit(msg.sender, nonce)`.
   - Analogy: one diner submits a **newer co-signed receipt**, the cashier **resets the last-call timer** so the other diner has a chance to counter with an **even newer** one if needed.

10. **FUNCTION** `withdraw()`

    - **onlyUser**
    - **REQUIRE** now ≥ `expiresAt` (dispute window over).
    - Read caller’s amount, set it to 0, send ETH, emit `Withdraw`.
    - Analogy: once last call passes with **no newer receipts**, each diner comes to the cashier, collects their final split, and the cashier marks that diner as **paid out**.

11. **OFF-CHAIN WORKFLOW (the intended dance)**

    - **Opening:**

      1. Alice & Bob fund a **multisig** wallet together.
      2. They **precompute** the payment channel address (counterfactual).
      3. They **co-sign** the initial balances (the first receipt).
      4. The multisig can deploy the channel if needed (or keep the deploy txn ready).

    - **Updating balances:**

      1. Repeat co-signing for new splits as their off-chain activity changes.
      2. The multisig updates its queued txns: cancel the old channel deployment, queue a new one matching the **latest** balances.

    - **Closing on agreement:**

      - Multisig simply sends final payouts to Alice and Bob and **removes** the pending channel deployment (no on-chain dispute needed).

    - **Closing on disagreement:**

      1. Deploy the channel from the multisig.
      2. Call `challengeExit` with the **latest** co-signed balances & higher nonce.
      3. After the **challenge window** expires with no newer state submitted, both parties can `withdraw()` their amounts.

12. **SECURITY & DESIGN NOTES**

    - **Two signatures** always required to move the on-chain state forward (`checkSignatures`).
    - **Nonce monotonicity** prevents going back to an older, worse split.
    - **Timer reset** on each valid challenge ensures fair time to respond with an **even newer** state.
    - **Balance check** guarantees the box holds enough ETH for the declared split.
    - **Contract address** in the signed preimage prevents **cross-contract replay**.
    - **Edge case**: if a user withdraws, their balance is zeroed to prevent double-spend.

13. **END**

---

### 🔎 Quick Reference (Cheat Sheet)

- **State = (balances, nonce, expiresAt)**
- **verify**: both signatures must match `keccak256(address(this), balances, nonce)` (Ethereum-prefixed).
- **challengeExit**: only users, valid sigs, newer nonce, resets `expiresAt` = now + challengePeriod.
- **withdraw**: only after `expiresAt`, pays caller their recorded amount and zeroes it.
- **Why ECDSA?** Authenticates co-signed receipts **off-chain**, saving gas until needed.
