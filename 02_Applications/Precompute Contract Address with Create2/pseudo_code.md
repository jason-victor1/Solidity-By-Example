### 🧠 Pseudo Code with Real-World Analogies: `Factory` + `FactoryAssembly` (CREATE2) + `TestContract`

---

1. **START**

---

2. **DEFINE** a simple `TestContract`

   - **STATE**

     - `owner` → who “owns” this deployed instance

       - Analogy: the **name on a safe**.

     - `foo` → a custom number stored at deployment

       - Analogy: the safe’s **model number**.

   - **CONSTRUCTOR(\_owner, \_foo)**

     - Sets `owner = _owner` and `foo = _foo`.
     - Accepts Ether at deployment (payable).
     - Analogy: when you **install** a safe, you engrave the owner’s name and model number on it; you can also put some cash inside during installation.

   - **getBalance()**

     - Returns the Ether sitting in this contract.
     - Analogy: peek inside the safe to **count the cash**.

---

3. **DEFINE** `Factory` (modern, no assembly)

   - **deploy(\_owner, \_foo, \_salt) -> address**

     - Uses Solidity’s **salted creation syntax**:
       `new TestContract{ salt: _salt }(_owner, _foo)`
     - Returns the **address** of the new instance.
     - Analogy: a **vending machine** that prints safes. You insert a special **salt token**; the machine fabricates a safe with the owner’s name and model number. The salt determines the **exact locker location** where that safe appears.

   - **CREATE2 Concept (high level)**

     - With a given factory address, bytecode, constructor args, and **salt**, the resulting contract **address is predetermined**.
     - Analogy: think “**deterministic lockers**.” Given the same recipe card (bytecode+args) and the same salt, your locker **always** ends up in the same aisle and slot.

---

4. **DEFINE** `FactoryAssembly` (classic, with assembly)

   - **EVENT** `Deployed(addr, salt)`

     - Announces where the new safe (contract) ended up and which salt was used.
     - Analogy: a receipt with the **locker number** and the **token** used.

   - **getBytecode(\_owner, \_foo) -> bytes**

     - Fetch `TestContract`’s **creationCode** (the blueprint without constructor args).
     - Append the ABI-encoded constructor args (`_owner`, `_foo`) to that blueprint.
     - Return the full **deployable bytecode** (creation code + args).
     - Analogy: take the **assembly manual** for the safe, then staple a sheet that says:
       “Engrave **this name** and **this model**.”

   - **getAddress(bytecode, \_salt) -> address**

     - Computes the **future contract address** deterministically:
       `address = last_20_bytes( keccak256( 0xff ++ factory_address ++ salt ++ keccak256(bytecode) ) )`
     - Analogy: run the **locker map formula**. Given the vending machine’s ID, your salt token, and the exact recipe card, you can **predict** which locker the safe will occupy **before** building it.

   - **deploy(bytecode, \_salt)**

     - Uses inline assembly `create2(value, ptr, size, salt)` to deploy.
     - `value = callvalue()` → forward any ETH sent with the transaction.
     - `ptr = add(bytecode, 0x20)` → skip the first 32 bytes (length prefix).
     - `size = mload(bytecode)` → actual bytecode size.
     - After deployment, verifies `extcodesize(addr) > 0` (deployment succeeded).
     - Emits `Deployed(addr, _salt)`.
     - Analogy: insert your **salt token** and recipe card into the vending machine; it fabricates the safe and places it in the predicted locker. Then you check the locker to ensure the safe is really there.

---

5. **CREATE2 – Why You’d Use It**

   - **Predictability:** You can know the contract address **before** deploying (useful for pre-sharing addresses, setting permissions, or funding ahead of time).
   - **Idempotency:** Same factory, same bytecode+args, same salt → **same address** (if not already deployed).
   - **Counterfactual setups:** Parties can sign deals referencing the future contract’s address **today**, and deploy **later** when conditions are met.
   - Analogy: reserve a **locker number** in advance, tell everyone where to deliver stuff, then build the safe later so it **appears** in that exact locker.

---

6. **TYPICAL FLOW (Story Time)**

   **Modern path (no assembly):**

   1. Call `Factory.deploy(_owner, _foo, _salt)`
   2. `new TestContract{salt: _salt}(_owner, _foo)` runs; instance lands at the CREATE2-derived address.
   3. You get the address back immediately.

   **Assembly path (predict, then deploy):**

   1. `bytecode = getBytecode(_owner, _foo)` → complete creation package.
   2. `predicted = getAddress(bytecode, _salt)` → compute where it will land.
   3. `deploy(bytecode, _salt)` → actually deploy with `create2`.
   4. Check event `Deployed(predicted, _salt)`; the emitted address should **equal** `predicted`.

---

7. **END**

---

### 🔎 Quick Reference (Cheat Sheet)

- **TestContract**

  - `owner`, `foo` set in constructor; payable on deploy.
  - `getBalance()` → Ether inside the contract (the safe’s cash).

- **Factory (no assembly)**

  - `deploy(_owner, _foo, _salt)` → `new TestContract{salt: _salt}(... )`
  - Deterministic address thanks to **CREATE2** under the hood.

- **FactoryAssembly (assembly)**

  - `getBytecode(_owner, _foo)` → creationCode + encoded args.
  - `getAddress(bytecode, salt)` → compute **future** address (0xff formula).
  - `deploy(bytecode, salt)` → inline `create2`; emits `Deployed(addr, salt)`.

- **CREATE2 Formula**

  - `addr = last20( keccak256( 0xff ++ deployer ++ salt ++ keccak256(bytecode) ) )`
  - Same inputs → same address.

**Analogy Recap:**

- Factory = **vending machine** / **locker system**.
- Salt = **token** that locks the **exact locker location**.
- Bytecode + args = **recipe card** describing the safe’s engraving.
- getAddress = **locker map** you can consult before building.
- create2 = the **mechanism** that guarantees your safe lands in the predicted locker.
