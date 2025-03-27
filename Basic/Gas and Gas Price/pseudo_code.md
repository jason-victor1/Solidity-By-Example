1. 🏗️ START building a digital testing facility (smart contract) to explore how fuel (gas) is consumed in Ethereum.

2. 🏷️ Name the building:
   DEFINE a contract called "Gas"
   // Think of this place as a workshop for understanding how much gas (energy) your contract actions consume.

3. 🪧 DECLARE a public state variable `i` initialized to 0
   // This is like a visible counter on the wall that tracks how many times an action is performed.

4. 🔁 DEFINE a function `forever`:
   a. 📢 MARK the function as public—any visitor can start this test.
   b. 🎯 PURPOSE: To demonstrate what happens when you run out of fuel (gas) by launching a never-ending process.
   c. 🌀 START an infinite loop:
   i. ➕ Each cycle, increment the wall counter `i` by 1
   // Like a machine that keeps clicking up the number with every spin—nonstop.

   d. 🛑 END of loop (theoretically unreachable since the machine never stops)

5. 💥 EXPLAIN what happens when someone triggers the `forever` function:
   a. 🧯 IF gas (fuel) runs out:
   i. ❌ The transaction fails like a machine stalling out due to running dry.
   ii. 🔄 All updates to the counter (`i`) are rolled back—it's like nothing ever happened.
   b. 🚫 NOTE: Any gas already burned is **not** refunded—fuel spent, even in failure, is gone.

6. 🏁 END setup of the Gas demo lab.
