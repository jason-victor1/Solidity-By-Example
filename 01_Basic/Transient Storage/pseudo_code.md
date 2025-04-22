1. 🏁 START — This system compares three kinds of memory in Solidity:

   - 🗃️ Storage = filing cabinet (permanent across transactions)
   - 🧽 Memory = whiteboard (temporary during a function call)
   - ⚡ Transient Storage = dry erase board that gets wiped after every transaction

2. 🧩 DEFINE interface "ITest"
   a. DECLARE a read-only function `val()` → returns uint256
   b. DECLARE a function `test()` → triggers test behavior

3. 🧪 DEFINE contract "Callback"
   a. DECLARE public storage variable `val` → simulates a shared notebook
   b. DEFINE a fallback function:
   i. WHEN someone sends a call to this contract: - READ value from the caller (cast to `ITest`) - SAVE that value into this contract’s notebook (`val`)
   c. DEFINE function `test(target)`:

   - CALL the `test()` function on the target address

4. 🧬 DEFINE contract "TestStorage"
   a. DECLARE public variable `val` in permanent storage
   b. DEFINE function `test()`:
   i. WRITE 123 to `val` (permanently)
   ii. INITIATE a callback to the caller using `msg.sender.call("")`

5. ⚡ DEFINE contract "TestTransientStorage"
   a. DEFINE a constant `SLOT = 0` to act like a drawer for transient notes
   b. DEFINE function `test()`:
   i. USE `tstore` to write 321 into transient storage slot 0
   ii. TRIGGER callback to caller using `msg.sender.call("")`
   c. DEFINE function `val()`:
   i. USE `tload` to read from slot 0 and return the result

6. 🧨 DEFINE contract "MaliciousCallback"
   a. DECLARE counter `count = 0`
   b. DEFINE fallback function:
   i. WHEN called, immediately calls `test()` on the original sender (attempts reentry)
   c. DEFINE function `attack(target)`:

   - INITIATE the first reentry attempt by calling `test()` on the target

7. 🔐 DEFINE contract "ReentrancyGuard"
   a. DECLARE private boolean `locked`
   b. DEFINE modifier `lock()`:
   i. REQUIRE that `locked` is false (vault must be open)
   ii. LOCK the vault before executing the function
   iii. UNLOCK the vault afterward
   c. DEFINE function `test()` using `lock`:
   i. Calls back to sender using `msg.sender.call("")`
   ii. Does not care if the call fails
   iii. This version uses ~27,587 gas

8. ⚡ DEFINE contract "ReentrancyGuardTransient"
   a. DEFINE constant `SLOT = 0` for transient guard lock
   b. DEFINE modifier `lock()` using assembly:
   i. IF slot 0 has value (locked), then revert
   ii. OTHERWISE, set slot 0 to 1 (lock)
   iii. After function completes, reset slot to 0 (unlock)
   c. DEFINE function `test()` using `lock`:
   i. Calls back to sender with `msg.sender.call("")`
   ii. More gas-efficient (~4,909 gas)

9. 🏁 END — This contract system teaches:
   - How storage/transient/memory behave
   - How fallbacks and low-level calls can trigger reentry
   - How to guard against reentrancy using different storage types (persistent vs transient)
