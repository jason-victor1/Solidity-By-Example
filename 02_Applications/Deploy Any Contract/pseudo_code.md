### 🧠 Pseudo Code with Real-World Analogies: Raw Deployer `Proxy` + Helpers

---

1. **START**

---

2. **DEFINE** a contract `Proxy`

   - Purpose: a **universal contractor** that can:

     - **Deploy** _any_ contract from raw **bytecode** (using `create`)
     - **Execute** arbitrary calls with optional ETH to existing contracts

   - Analogy:

     - Think of `Proxy` as a **general builder** and **errand runner**:

       - Builder mode: “Hand me a blueprint (bytecode). I’ll construct the building (contract) and give you its address.”
       - Runner mode: “Give me an address and a note (calldata). I’ll go press the right buttons there, possibly carrying cash.”

   **a) `receive()` (payable)**

   - Accepts ETH sent directly to the `Proxy`.
   - Analogy: The builder has a **cash drawer**; you can drop in funds upfront.

   **b) `deploy(_code) -> addr` (payable)**

   - Inputs:

     - `_code`: **creation code** (blueprint) to deploy

   - Steps:

     1. In assembly, call `create(value, ptr, size)`:

        - `value` = `msg.value` (forward any ETH along with deployment)
        - `ptr` = memory pointer to the creation code: `add(_code, 0x20)` (skip the length word)
        - `size` = `mload(_code)` (the length of the code)

     2. `create` returns `addr` of the new contract (or `address(0)` on failure)
     3. `require(addr != 0)` — must succeed
     4. Emit `Deploy(addr)`

   - Analogy:

     - You hand the builder a **blueprint** (`_code`) and some **cash** (optional).
     - The builder constructs the **building** (new contract) and tells you the new **street address** (`addr`).
     - If something goes wrong, you get a “**build failed**” error.

   **c) `execute(_target, _data)` (payable)**

   - Inputs:

     - `_target`: address to call
     - `_data`: encoded function call (calldata)

   - Steps:

     1. Make a low-level call: `_target.call{value: msg.value}(_data)`
     2. `require(success)` — bubble failure if call failed

   - Analogy:

     - You send the runner to **an existing building** (`_target`), hand them a **note** (`_data`) with precise instructions (which bell to ring, which button to press), and possibly **cash** to pay there.
     - If the runner returns with “failed,” it means the building refused or the instructions were invalid.

---

3. **DEFINE** `TestContract1` (simple ownership setter)

   - **STATE**:

     - `owner` initialized to the **deployer** (`msg.sender` at construction)

   - **FUNCTIONS**:

     - `setOwner(_owner)`:

       - Only current `owner` may change it (require)

   - Analogy:

     - A **simple office** with a **nameplate** (`owner`) on the door.
     - Only the person whose name is on the plate can change the nameplate.

---

4. **DEFINE** `TestContract2` (constructor args + value capture)

   - **STATE**:

     - `owner` = deployer
     - `value` = ETH sent at deployment (`msg.value` during constructor)
     - `x`, `y` = parameters provided at construction

   - **CONSTRUCTOR** `(_x, _y)` (payable)

     - Stores `x`, `y`; captures initial ETH into `value`

   - Analogy:

     - Another office installed with **model settings** (`x`, `y`) printed into its manual, and initial **cash** placed in its vault at installation time.

---

5. **DEFINE** `Helper` (blueprint & instruction generator)

   - Purpose: provide **ready-made blueprints** (creation code) and **notes** (calldata) for the `Proxy`.

   **a) `getBytecode1() -> bytes`**

   - Returns raw **creation code** for `TestContract1` (no constructor args).
   - Analogy: A **blueprint** for the “owner-nameplate” office.

   **b) `getBytecode2(_x, _y) -> bytes`**

   - Gets `TestContract2.creationCode`, then **appends** ABI-encoded constructor args `(_x, _y)` using `abi.encodePacked(...)`.
   - Returns full deployable creation code.
   - Analogy: A **blueprint** stapled together with a **settings sheet** (`x,y`) for installation.

   **c) `getCalldata(_owner) -> bytes`**

   - Returns ABI-encoded calldata to call `setOwner(address)` with `_owner`.
   - Analogy: A **note** telling the runner: “Go to the office and ask them to set the nameplate to this new owner.”

---

6. **TYPICAL FLOWS (Story Time)**

   **A) Deploy `TestContract1` with `Proxy`**

   1. Ask `Helper.getBytecode1()` → get the **blueprint**
   2. Call `Proxy.deploy(bytecode)` → builder constructs **TestContract1**
   3. Listen to `Deploy(addr)` → you now know the **office address**

   **B) Deploy `TestContract2` with settings & initial ETH**

   1. Ask `Helper.getBytecode2(10, 20)` → blueprint + settings sheet
   2. Call `Proxy.deploy(bytecode)` with some `msg.value` (e.g., 1 ether) → builder installs and **funds** the office (constructor captures value)
   3. `Deploy(addr)` fired → see where it lives
   4. `value` inside the contract equals the deployment ETH

   **C) Execute a function on an existing contract using `Proxy`**

   1. Ask `Helper.getCalldata(newOwner)` → an **instruction note** to call `setOwner(newOwner)`
   2. Call `Proxy.execute(targetAddr, calldata)` (optionally with ETH if needed)
   3. If `success`, the change took effect; otherwise it **reverts** with “failed”

---

7. **END**

---

### 🔎 Quick Reference (Cheat Sheet)

- **`Proxy.deploy(_code)`**

  - Uses `create(value, ptr, size)` to **deploy** arbitrary creation code
  - `value` = `msg.value` → forward ETH to the constructor
  - Reverts if it returns `address(0)` (**build failed**)
  - Emits `Deploy(newAddr)`

- **`Proxy.execute(_target, _data)`**

  - Low-level `_target.call{value: msg.value}(_data)`
  - Forwards ETH and exact calldata; **reverts on failure**

- **`Helper`**

  - `getBytecode1()` → `TestContract1` blueprint
  - `getBytecode2(x, y)` → `TestContract2` blueprint + constructor args
  - `getCalldata(owner)` → instruction note for `setOwner(owner)`

- **`TestContract1`**

  - `owner` starts as deployer; `setOwner` only by current owner

- **`TestContract2`**

  - `owner` starts as deployer
  - `value` captures ETH sent at deployment
  - `x`, `y` set by constructor args

**Analogy Recap:**

- `Proxy` = **general contractor & courier** (builds from blueprints; runs errands with notes & cash).
- `creationCode` = **blueprint**; `calldata` = **instruction note**.
- `create` = **construction**; `call` = **visit & press buttons**.
- `Helper` = **back-office clerk** who prepares **blueprints** and **notes** so the contractor knows exactly what to do.
