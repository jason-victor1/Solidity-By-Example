1. 🏗️ START building a contract that reveals the **function selector** of any given function signature string.

2. 🏷️ Name the building:
   DEFINE a contract called **"FunctionSelector"**
   // Think of this as a digital fingerprint reader for function signatures.

3. 📌 REFERENCE:
   EMBED example signatures and their selectors in comments:
   a. `"transfer(address,uint256)"` → `0xa9059cbb`
   b. `"transferFrom(address,address,uint256)"` → `0x23b872dd`
   // These are examples of function signatures and their 4-byte unique identifiers.

4. 🔎 DEFINE function **getSelector(string \_func)** → external & pure → returns `bytes4`
   // This function calculates the selector from any string that looks like a function signature.

   a. 🎯 CONVERT `_func` to `bytes`
   // Turn the string into raw bytes for hashing.
   b. 🧪 HASH the bytes using `keccak256`
   // Run the data through Ethereum’s hashing engine.
   c. ✂️ SLICE the first 4 bytes of the hash
   // Only the first 4 bytes matter for a function selector.
   d. 🔁 RETURN the result as `bytes4`
   // This is the unique selector that smart contracts use to recognize functions.

5. 🏁 END setup for the function selector calculation tool.
