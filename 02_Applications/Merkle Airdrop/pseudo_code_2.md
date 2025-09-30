### 📝 Pseudo Code (Step-by-Step with Analogies)

/** Setup phase **/

- When contract is created:

  - Set the **name**, **symbol**, and **decimals** of the token.
  - Give the **deployer** the role of “authorized minter.”
  - 🎟️ _Analogy: The founder of the currency sets up the money system, names it, and gives themselves the only printing license at the start._

---

**Function: `setAuthorized(address, bool)`**

- Only addresses that already have printing rights can grant or revoke authorization.
- Update the `authorized` mapping.
- 🏦 _Analogy: The central bank governor can issue new money-printing licenses or revoke them from other branches._

---

**Function: `transfer(recipient, amount)`**

- Deduct `amount` from sender’s balance.
- Add `amount` to recipient’s balance.
- Emit `Transfer` event.
- 💸 _Analogy: You move money from your wallet to a friend’s wallet, and the system announces: “Alice paid Bob 10 tokens.”_

---

**Function: `approve(spender, amount)`**

- Allow another account (a spender) to spend up to `amount` on your behalf.
- Record this in `allowance`.
- Emit `Approval`.
- 🧾 _Analogy: You sign a slip giving a shop permission to charge your card up to $100._

---

**Function: `transferFrom(sender, recipient, amount)`**

- Deduct allowance from spender’s balance.
- Subtract `amount` from sender’s balance.
- Add `amount` to recipient’s balance.
- Emit `Transfer`.
- 🏪 _Analogy: A shop uses the slip you signed earlier to charge your card and deliver goods to you._

---

**Function: `_mint(to, amount)`**

- Increase `totalSupply` by `amount`.
- Increase recipient’s balance by `amount`.
- Emit `Transfer` event (from address `0x0`).
- 🖨️ _Analogy: The printing press creates new banknotes and credits them into someone’s wallet._

---

**Function: `mint(to, amount)`**

- Only authorized addresses can call this.
- Calls internal `_mint` function.
- 🔑 _Analogy: Only officially licensed printers (authorized addresses) can actually print new banknotes._

---

### 🔍 Real-World Summary

- **`authorized` list** = licensed printing presses (only they can mint).
- **`transfer`** = sending money between wallets.
- **`approve` + `transferFrom`** = signing and redeeming spending authorizations.
- **`_mint` + `mint`** = central bank printing fresh money and injecting it into circulation.
- **`events`** = public ledger announcements of transactions.
