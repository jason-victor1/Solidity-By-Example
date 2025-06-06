### 🏗️ START: Interface, Contract Setup, and ABI Encoding Tests

---

### 1. 📡 DEFINE an interface called `IERC20`

- This is a **minimal contract interface** that declares only the `transfer` function.
- Used to simulate interactions with an ERC-20 token.

#### a. ➡️ DEFINE function `transfer(address, uint256)` → external

- This is the standard ERC-20 function to transfer tokens.

---

### 2. 🏷️ DEFINE contract **Token**

- A placeholder ERC-20–like contract used in encoding tests.

#### a. ➡️ DEFINE function `transfer(address, uint256)` → external

- This dummy function satisfies the `IERC20` interface.
- Implementation is empty — it’s just for call simulation.

---

### 3. 🧪 DEFINE contract **AbiEncode**

- A testing utility for understanding how Solidity's ABI encoding works.

---

### 4. 🔍 DEFINE function `test(address _contract, bytes calldata data)` → external

- Used to **call another contract** using **low-level `.call()`**.
- Accepts:

  - `_contract`: the target address
  - `data`: the ABI-encoded payload

#### a. 📞 CALL the contract using `.call(data)`

- `(bool ok, ) = _contract.call(data);`
- Captures whether the call was successful.

#### b. ❌ REQUIRE success

- If the call fails, revert with `"call failed"`.

---

### 5. 🧪 DEFINE function `encodeWithSignature(address to, uint256 amount)` → external → pure

- Demonstrates **manual encoding** using a function signature string.

#### a. 💡 USE `abi.encodeWithSignature("transfer(address,uint256)", to, amount)`

- Encodes the function selector + arguments.
- ⚠️ Typo-prone: Signature strings are not checked at compile-time.

---

### 6. 🧪 DEFINE function `encodeWithSelector(address to, uint256 amount)` → external → pure

- Encodes using a **function selector** (more precise than a string).

#### a. USE `IERC20.transfer.selector`

- Ensures selector is derived correctly.
- Still doesn’t check argument types at compile time.

#### b. USE `abi.encodeWithSelector(...)`

- Safer than raw strings, but not as strict as `encodeCall`.

---

### 7. 🧪 DEFINE function `encodeCall(address to, uint256 amount)` → external → pure

- Demonstrates the **safest** ABI encoding approach.

#### a. USE `abi.encodeCall(IERC20.transfer, (to, amount))`

- ✨ Compile-time type and signature checking.
- 🧠 Prevents silent errors like mismatched types or misspelled function names.

---

### 🏁 END of ABI Encoding Test Suite
