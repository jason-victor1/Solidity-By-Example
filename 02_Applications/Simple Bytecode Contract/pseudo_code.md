### 🧠 Pseudo Code with Real-World Analogies: `Factory` (Raw EVM Bytecode Deployer)

---

1. **START**

---

2. **DEFINE** a contract called `Factory`

   - Purpose: **deploy a micro-contract from raw EVM bytecode** (no Solidity source) that always returns the number `255`.
   - Analogy: a **3D printer** that prints a tiny machine. The machine has only one button; press it and it always spits out the number **255**.

---

3. **DECLARE** an event `Log(address addr)`

   - Fires after deployment with the new contract’s address.
   - Analogy: the printer announces where it placed the tiny machine on the factory floor.

---

4. **DEFINE** function `deploy()`

   - **PREPARE** `bytecode` (as hex):

     - This is the **creation code** — the assembly recipe the printer follows to build the machine’s **runtime code**.
     - Analogy: the **instruction sheet** the printer reads to assemble the final device.

   - **CALL** EVM `create(value, offset, size)` in inline assembly:

     - `value = 0` (send 0 ether),
     - `offset = add(bytecode, 0x20)` (skip the length word to the start of data),
     - `size = 0x13` (19 bytes, the length of creation code).
     - Analogy: tell the 3D printer: _“Print using this blueprint starting at page 1 for 19 characters.”_

   - **CHECK** deployment success: `addr != address(0)`.

     - Analogy: confirm the machine actually got printed and powered on.

   - **EMIT** `Log(addr)` with the deployed address.

     - Analogy: post the map pin to where the new machine lives.

---

5. **DEFINE** interface `IContract`

   - Function: `getValue() external view returns (uint256)`
   - Analogy: the tiny machine’s **single button**. Press it and it shows a number. Here: **always 255**.

---

6. **DEEP DIVE**: What do the bytes do? (Creation vs Runtime)

   #### A) Runtime Code (what the deployed contract _runs_ when called)

   ```
   60ff        PUSH1 0xff         // put 255 on the stack
   6000        PUSH1 0x00         // memory offset 0
   52          MSTORE             // store 255 at memory[0..31]
   6020        PUSH1 0x20         // 32 bytes to return
   6000        PUSH1 0x00         // from memory offset 0
   f3          RETURN             // return 32 bytes: 0x...00ff
   ```

   - Analogy: the tiny machine writes **255** onto a sticky note at desk slot #0 and hands back **exactly 32 bytes** (standard EVM word size) containing that number.

   #### B) Creation Code (what runs _during deployment_ to install the runtime code)

   ```
   69 60ff60005260206000f3   // PUSH10 (the whole runtime code bytes)
   60 00                     // PUSH1 0 (store position)
   52                        // MSTORE (store runtime code into memory)
   60 0a                     // PUSH1 10 (length = 10 bytes of runtime)
   60 16                     // PUSH1 22 (offset where runtime begins in memory)
   f3                        // RETURN (return those 10 bytes as the runtime code)
   ```

   - Analogy: the printer **loads the runtime micro-program** into a staging table (memory) and then **carves** exactly those 10 bytes into the final device’s ROM. After deployment, only the ROM (runtime code) remains — the printer’s instructions (creation code) are thrown away.

---

7. **END-TO-END STORY**

   - You call `Factory.deploy()`.
   - The factory uses **creation code** to install **runtime code** that always returns `255`.
   - The factory logs the new address.
   - Anyone can interact via `IContract(addr).getValue()`, which triggers the runtime code returning **255** every time.
   - Analogy: the 3D printer builds a tiny calculator with one button; push it, it always displays **255**. The printer tells you where it put the calculator.

---

8. **SAFETY / PRACTICAL NOTES**

   - **Raw bytecode** is ultra-compact but hard to audit — keep comments and references (like the EVM playground) handy.
   - Returning a **32-byte word** is standard; lower bytes carry `0xff` (i.e., 255), higher bytes are zeros.
   - Creation code vs runtime code separation is crucial: creation sets up, runtime serves calls.

---

### 🔎 Quick Reference (Cheat Sheet)

- **Factory.deploy()** → uses `create` with **creation code** → installs **runtime code** that returns `255`.
- **Event** `Log(addr)` → where the micro-contract lives.
- **`IContract.getValue()`** → calls the tiny runtime, which: `MSTORE(255)` → `RETURN(32 bytes)` → **255**.
- **Analogy** → 3D printer (creation) builds a one-button calculator (runtime) that always shows **255**.
