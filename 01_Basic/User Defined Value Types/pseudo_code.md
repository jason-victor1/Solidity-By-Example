1. 🏗️ START with a system to build and decode a digital clock using bit-level assembly.

2. 📦 DEFINE custom-labeled components (user-defined value types):
   a. `Duration` = a uint64 part labeled as "duration" (like battery life or timeout)
   b. `Timestamp` = a uint64 part labeled as "timestamp" (when something happened)
   c. `Clock` = a uint128 unit representing both Duration and Timestamp packed together

3. 🧰 DEFINE a library `LibClock` to assemble and disassemble clocks:
   a. `wrap(duration, timestamp)`:

   - 🧪 Inputs: Duration + Timestamp
   - 🧩 Combine both parts into a single 128-bit Clock
   - ⚙️ Uses bit-shifting like putting two parts into one digital gear

   b. `duration(clock)`:

   - 🔍 Extract the first 64 bits to get the Duration
   - Like pulling out the battery from a watch

   c. `timestamp(clock)`:

   - 🔍 Extract the second 64 bits to get the Timestamp
   - Like reading the moment the watch was set

4. 🛠️ DEFINE a simplified version `LibClockBasic` (without part labeling):

   - `wrap(uint64 duration, uint64 timestamp)`:
     - Still assembles a Clock but doesn’t prevent mixups
     - No safety against putting parts in the wrong order

5. 🎯 DEFINE contract `Examples`:
   a. `example_no_uvdt()`:

   - Create Duration and Timestamp as **raw numbers**
   - ⚠️ Accidentally swap them—compiles fine but behavior may be incorrect

   b. `example_uvdt()`:

   - Create Duration and Timestamp as **typed parts** (UDVTs)
   - Use `.wrap()` and `.unwrap()` to convert between labeled and raw
   - ✅ Safe: prevents swapping parts by accident
   - 🚫 Compile-time error if you try to plug the parts in the wrong order

6. 🏁 END: Clear separation between labeled (safe) and unlabeled (risky) parts helps prevent bugs
