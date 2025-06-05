1. 🏗️ START building a contract that imports symbols from another Solidity file and interacts with an external contract.

2. 📥 IMPORT `"./Foo.sol"`
   // Brings in all public symbols from the Foo.sol file in the same directory.

3. 📥 IMPORT specific items from `"./Foo.sol"` with aliasing:
   a. 🧱 `Unauthorized` → custom error
   b. ➕ `add` function is imported as alias **`func`**
   c. 📐 `Point` struct

   // This allows selective and renamed usage of specific features from `Foo.sol`.

4. 🏷️ DEFINE a contract called **"Import"**
   // This contract demonstrates symbol importing and Foo.sol interaction.

   a. 🧩 CREATE a public variable `foo` initialized with a new `Foo()`
   // Deploys an instance of the `Foo` contract and stores it for use.

   b. 🪟 DEFINE function **getFooName()** → public view → returns string
   i. CALL `foo.name()`
   // Reads the public `name` value from the deployed Foo instance.
   ii. 🔁 RETURN the name string

5. 🏁 END setup for the import demonstration and external contract interaction.
