1. 🏗️ START building a digital storage room (smart contract) with both permanent signs and temporary notes.

2. 🏷️ Name the building:
   DEFINE a contract called "Variables"
   // This sets up the room where some information is stored permanently (on-chain), and some used temporarily.

3. 🪧 DECLARE two permanent signs on the wall (state variables stored on the blockchain):
   a. "text" – a public string that shows "Hello"
      // Like a welcome message that anyone can read.
   b. "num" – a public number starting at 123
      // Like a posted counter visible to all visitors.

4. 📋 DEFINE a temporary action area (function) called "doSomething":
   a. 📢 MARK it as public and view
      // Anyone can trigger it, but it doesn’t change anything—just checks and returns info.

   b. 📝 DECLARE a local notepad note called "i":
      i. A short-term unsigned number starting at 456
      ii. 🧾 NOTE: This note is used only during this one visit—it’s discarded afterward and *not* stored on the wall (blockchain).

   c. 🕒 DECLARE a variable "timestamp" to check what time the visitor entered:
      i. ASSIGN it to the current system clock (`block.timestamp`)
      // Like stamping the visitor's entry time at the front desk.

   d. 👤 DECLARE a variable "sender" to record who just walked in:
      i. ASSIGN it to the visitor's address (`msg.sender`)
      // Like writing down the visitor's name or badge number at the reception desk.

5. 🏁 END setup for the Variables contract.

