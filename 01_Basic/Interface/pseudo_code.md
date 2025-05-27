1. 🏗️ START building a digital counter system with external control and token reserve lookup.

2. 🏷️ Name the first building:
   DEFINE a contract called **"Counter"**
   // Think of it as a digital scoreboard anyone can read.

   a. 🧮 DECLARE a public counter called `count`
   // Visible tally board that starts at 0.

   b. 🔼 DEFINE function **"increment"**
   i. 📢 MARK it as external
   // Only visitors from outside this room can push the button.
   ii. ➕ INCREMENT `count` by 1
   // Adds one to the scoreboard.

3. 🧩 DEFINE a shared remote control interface:
   DEFINE interface **"ICounter"**
   // A remote that can read and press buttons on a Counter room.

   a. 🪟 DECLARE function **"count()"** as external view → returns number
   // Lets you read the scoreboard remotely.

   b. 🔘 DECLARE function **"increment()"** as external
   // Lets you press the increment button from afar.

4. 🧰 DEFINE a contract called **"MyContract"**
   // A control room that interacts with remote counter contracts.

   a. 🔼 DEFINE function **"incrementCounter(address \_counter)"**
   i. ⏭️ CALL `increment()` via `ICounter` interface
   // Remotely presses the increment button on a specific counter.

   b. 🪟 DEFINE function **"getCount(address \_counter)"**
   i. ⏮️ RETURN `count()` from remote counter
   // Retrieves the current number on someone else’s board.

5. 🧬 DEFINE interface **"UniswapV2Factory"**
   // A machine that builds token pairings.

   a. 🔍 DECLARE function **"getPair(tokenA, tokenB)"**
   i. RETURNS pair address
   // Returns the address for a token combination.

6. 🧬 DEFINE interface **"UniswapV2Pair"**
   // A vault that stores token reserves.

   a. 📊 DECLARE function **"getReserves()"**
   i. RETURNS reserve0, reserve1, and timestamp
   // Shows how much of each token is stored.

7. 💱 DEFINE a contract called **"UniswapExample"**
   // A vault reader that checks Uniswap reserves for DAI and WETH.

   a. 🏷️ DECLARE private `factory` address (Uniswap V2 Factory)
   // Factory that holds pairing logic.

   b. 🏷️ DECLARE private `dai` token address
   // DAI token reference.

   c. 🏷️ DECLARE private `weth` token address
   // Wrapped Ether reference.

   d. 📊 DEFINE function **"getTokenReserves()"**
   i. 🔗 GET pair address from `factory` using DAI and WETH
   // Ask the factory where the DAI/WETH vault is.
   ii. 📦 CALL `getReserves()` on the vault
   // Check how much DAI and WETH are stored.
   iii. 🔁 RETURN both reserves

8. 🏁 END setup for the external counter system and Uniswap reserve reader.
