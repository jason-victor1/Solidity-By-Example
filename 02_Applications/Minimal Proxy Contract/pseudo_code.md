### 🧠 Pseudo Code with Real-World Analogies: `MinimalProxy.clone(target)`

---

1. **START**

---

2. **DEFINE** a contract called `MinimalProxy`

   - Purpose: **deploy an ultra-light proxy** that forwards every call to a given `target` contract using `DELEGATECALL`.
   - Analogy: think of it as opening a tiny **front desk kiosk** (the proxy) for a big **back office** (the target).

     - The kiosk has no inventory (no own logic); it just picks up the phone and calls the back office, then relays the answer to the visitor.

---

3. **DECLARE** function `clone(target) -> result`

   - **INPUT**: `target` — the back office address the kiosk will call.

   - **OUTPUT**: `result` — the address where the new kiosk (proxy) is installed.

   - Steps overview:

     1. Convert `target` to 20-byte form → `targetBytes`.
     2. Build the **creation code** + **runtime code** template for the EIP-1167 minimal proxy in memory.
     3. Insert `targetBytes` into the runtime code (like stamping the phone number into the kiosk’s speed-dial).
     4. Use `create` to deploy the code; the chain returns the new proxy address.
     5. Ensure deployment succeeded; return `result`.

---

4. **PREPARE** the memory workspace

   - Read the **free memory pointer** at slot `0x40` → call it `clone`.
   - Analogy: clear a **workbench** where we’ll assemble the kiosk’s firmware.

---

5. **WRITE** the first 32 bytes: **creation tail + runtime head + PUSH20 placeholder**

   - Store the chunk:

     ```
     0x3d602d80600a3d3981f3 363d3d373d3d3d363d 73 000000000000000000000000
     ```

     - `3d602d80600a3d3981f3` → **creation code** that copies the runtime into memory and returns it.
     - `363d3d373d3d3d363d` → **runtime prologue** for copying calldata and preparing delegatecall.
     - `73` → `PUSH20` opcode for the target address (placeholder follows).

   - Analogy: place the **kiosk firmware template** on the bench, leaving a blank for the back-office phone number.

---

6. **STAMP** the 20-byte `targetBytes` into the placeholder

   - Write `targetBytes` at offset `0x14` (20 bytes after start).
   - Analogy: write the **exact phone number** of the back office into the kiosk’s speed-dial button.

---

7. **WRITE** the final 32 bytes: **delegatecall tail**

   - Store the tail:

     ```
     0x5af43d82803e903d91602b57fd5bf3
     ```

     - This is the well-known EIP-1167 tail that:

       - performs `DELEGATECALL` to the target with forwarded calldata/gas,
       - returns the target’s return data (or bubbles up the revert).

   - Analogy: attach the kiosk’s **auto-forwarding** rule: “send caller’s request to the back office; give them the exact response back.”

---

8. **DEPLOY** the assembled code with `create(0, clone, 0x37)`

   - `value = 0` (no Ether)

   - `offset = clone` (where we wrote the 55-byte blob)

   - `size = 0x37` (55 bytes total)

   - Save returned address to `result`.

   - **CHECK**: `result != address(0)` → deployment successful.

   - Analogy: roll the kiosk out to the lobby. If the kiosk didn’t show up, abort.

---

9. **RETURN** the new proxy address `result`

   - Anyone calling that address will trigger:

     - **Runtime code** → `DELEGATECALL target` with original calldata & gas → return exact output.

   - Analogy: visitors talk to the kiosk; the kiosk calls the back office and repeats the answer verbatim.

---

10. **END**

---

### 🔎 Quick Reference (Cheat Sheet)

- **What is EIP-1167?**
  A minimal proxy standard: tiny runtime code that forwards calls via `DELEGATECALL` to a fixed implementation.

- **Why use it?**

  - ⚡ **Ultra-cheap** mass deployments.
  - 🧩 Each proxy has its **own storage**, while sharing the **same logic** (the target).
  - 🔧 Centralized fixes/upgrades by pointing new proxies at a new target (existing proxies keep their target unless you design an upgradable pattern).

- **Core Bytecode Pieces**

  - **Creation code** (installer): copies runtime to memory & returns it.
  - **Runtime code** (forwarder): copies calldata → `DELEGATECALL target` → returns or reverts exactly.
  - Insert the **20-byte `target`** between `PUSH20` and the tail.

**Analogy Recap:**

- Proxy = **kiosk** (no inventory).
- Target = **back office** (does the real work).
- Creation code = **installer** writing the kiosk firmware.
- Runtime code = **speed-dial script** that calls the back office and relays the response.
