1. 🏗️ START building a system that demonstrates how to use `try/catch` for **external calls** and **contract creation**.

2. 🏷️ DEFINE a contract called **"Foo"**
   // An external contract with constructor checks and a function that may fail.

   a. 🧾 DECLARE public variable `owner` → address
   // Stores the assigned owner of this contract.

   b. 🧱 DEFINE constructor **Foo(address \_owner)**
   i. ⚠️ REQUIRE `_owner != address(0)` → revert with `"invalid address"`
   // Ensures the owner is not the zero address.
   ii. 🧨 ASSERT `_owner != 0x...0001`
   // Fails hard if the owner is exactly 0x01 — for demo purposes.
   iii. ✅ SET `owner = _owner`

   c. 🛠️ DEFINE function **myFunc(uint256 x)** → public & pure → returns string
   i. ⚠️ REQUIRE `x != 0` → revert with `"require failed"`
   // Ensures the input is not zero.
   ii. 🔁 RETURN `"my func was called"`
   // Returns success message.

3. 🏷️ DEFINE a contract called **"Bar"**
   // A controller contract that demonstrates `try/catch` usage on both function calls and contract deployment.

   a. 📣 DECLARE event `Log(string)`
   // Used to emit readable messages.

   b. 📣 DECLARE event `LogBytes(bytes)`
   // Used to emit low-level revert data (e.g. from `assert`).

   c. 🔗 DECLARE public variable `foo` of type `Foo`
   // Stores a reference to an external Foo contract.

   d. 🔧 DEFINE constructor
   i. 🚀 DEPLOY `Foo(msg.sender)` and store in `foo`
   // Deploys Foo with current caller as the owner.

4. 🔍 DEFINE function **tryCatchExternalCall(uint256 \_i)** → public
   // Demonstrates `try/catch` when calling an external contract.

   a. TRY calling `foo.myFunc(_i)`
   i. IF success:
   \- 🔁 RETURN string → emit `Log(result)`
   ii. IF failure:
   \- 📢 EMIT `Log("external call failed")`
   // Catches failure like require(x != 0)

5. 🧪 DEFINE function **tryCatchNewContract(address \_owner)** → public
   // Demonstrates `try/catch` for deploying a contract with risky constructor.

   a. TRY `new Foo(_owner)`
   i. IF success:
   \- 📢 EMIT `Log("Foo created")`
   ii. CATCH `Error(string reason)` → from `require()`
   \- 📢 EMIT `Log(reason)`
   iii. CATCH `bytes reason` → from `assert()`
   \- 📦 EMIT `LogBytes(reason)`
   // Captures lower-level byte error data.

6. 🏁 END setup for external call and contract creation error handling using try/catch.
