1. 🏗️ START building two contracts that demonstrate the difference between `call` and `delegatecall`.

2. 🏷️ Name the first building:
   DEFINE a contract called **"B"**
   // This is the blueprint whose function logic is shared by others using `delegatecall`.

   a. 🧮 DECLARE public variable `num`
   // A shared number slot.

   b. 🧾 DECLARE public variable `sender`
   // Tracks who triggered the call.

   c. 💰 DECLARE public variable `value`
   // Records how much ETH was sent.

   d. 🛠️ DEFINE function **setVars(uint256 \_num)** → public & payable
   i. ✍️ SET `num = _num`
   // Saves the number.
   ii. ✍️ SET `sender = msg.sender`
   // Saves the caller’s address.
   iii. ✍️ SET `value = msg.value`
   // Saves the amount of ETH sent.

3. 🏷️ Name the second building:
   DEFINE a contract called **"A"**
   // This is the caller that will either execute logic in B using its own storage or trigger B directly.

   a. 🧮 DECLARE public variable `num`
   b. 🧾 DECLARE public variable `sender`
   c. 💰 DECLARE public variable `value`
   // All three match B’s layout — required for `delegatecall` to avoid corruption.

   d. 📣 DECLARE event `DelegateResponse(success, data)`
   // Emits the result of the `delegatecall`.

   e. 📣 DECLARE event `CallResponse(success, data)`
   // Emits the result of the `call`.

   f. 🪞 DEFINE function **setVarsDelegateCall(address \_contract, uint256 \_num)** → public & payable
   i. ⚙️ ENCODE call to `setVars(_num)` using `abi.encodeWithSignature`
   ii. 🔁 EXECUTE `delegatecall` to `_contract`
   // Runs B’s logic but **writes into A’s** storage — B’s state remains untouched.
   iii. 📢 EMIT `DelegateResponse(success, data)`

   g. 📞 DEFINE function **setVarsCall(address \_contract, uint256 \_num)** → public & payable
   i. ⚙️ ENCODE call to `setVars(_num)` using `abi.encodeWithSignature`
   ii. 🛰️ EXECUTE `.call{value}` to `_contract`
   // Runs B’s logic and **writes to B’s** storage — A’s state remains untouched.
   iii. 📢 EMIT `CallResponse(success, data)`

4. 🏁 END setup for the delegatecall vs call experiment.
