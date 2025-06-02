1. 🏗️ START building a system to demonstrate contract-to-contract calls, ETH transfers, and return values.

2. 🏷️ Name the first building:
   DEFINE a contract called **"Callee"**
   // This contract receives function calls and optionally stores ETH.

   a. 🧮 DECLARE public variable `x`
   // Stores a number passed in by callers.

   b. 💰 DECLARE public variable `value`
   // Stores the amount of ETH received during a call.

   c. 🛠️ DEFINE function **setX(uint256 \_x)** → public → returns uint256
   i. ✍️ SET `x = _x`
   // Updates the stored number.
   ii. 🔁 RETURN updated value of `x`

   d. 🛠️ DEFINE function **setXandSendEther(uint256 \_x)** → public & payable
   → returns `(uint256, uint256)`
   i. ✍️ SET `x = _x`
   // Store the number input.
   ii. ✍️ SET `value = msg.value`
   // Store the amount of ETH received.
   iii. 🔁 RETURN `(x, value)`

3. 🏷️ Name the second building:
   DEFINE a contract called **"Caller"**
   // This contract initiates interactions with the `Callee`.

   a. 📞 DEFINE function **setX(Callee \_callee, uint256 \_x)** → public
   i. CALL `_callee.setX(_x)` and store the result in `x`
   // Passes a number to the target and retrieves the updated value.

   b. 📞 DEFINE function **setXFromAddress(address \_addr, uint256 \_x)** → public
   i. 🔄 CONVERT `_addr` into `Callee` contract instance
   // Treats the address as if it were a Callee contract.
   ii. CALL `setX(_x)` on the contract
   // Executes the update remotely using an address instead of a typed reference.

   c. 💸 DEFINE function **setXandSendEther(Callee \_callee, uint256 \_x)**
   → public & payable
   i. CALL `_callee.setXandSendEther(_x)` with attached ETH
   // Sends both data and Ether to the callee.
   ii. STORE returned values in `x` and `value`
   // Captures the result of the update and ETH receipt.

4. 🏁 END setup for contract-to-contract calling with and without ETH.