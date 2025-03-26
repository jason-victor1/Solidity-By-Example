1. 🏗️ START building a digital device (smart contract) that tracks how many people enter or exit a room.

2. 🏷️ Name the building:
   DEFINE a contract called "Counter"

   a. 🧮 Install a public digital tally counter (unsigned integer):
   DECLARE "count" – a number visible to anyone (public), starting at 0
   // Think of this like a digital scoreboard above the door that starts at 0 and shows how many times it's been updated.

3. 🪟 Create a window for people to check the counter:
   DEFINE function "get"

   a. 📢 MARK it as public and view-only
   // Anyone can use it, but it doesn’t change anything—like a glass window to read the counter without pressing buttons.

   b. 🔁 RETURNS the current value of "count"
   // Shows the current number on the scoreboard.

4. 🔼 Add an "enter" button:
   DEFINE function "inc"

   a. 📢 MARK it as public
   // Anyone can press it.

   b. ➕ INCREMENT the counter by 1
   // Like pressing a button to increase the number when someone enters the room.

5. 🔽 Add an "exit" button:
   DEFINE function "dec"

   a. 📢 MARK it as public
   // Anyone can press it.

   b. ➖ DECREMENT the counter by 1
   i. ⚠️ NOTE: If the counter is at 0 and someone tries to go below, it breaks (Solidity 0.8+ auto-stops underflows)
   // Imagine trying to reduce the score below 0—the system prevents it to avoid negative numbers.

6. 🏁 END setup for the Counter building.
