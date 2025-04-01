1. 🏗️ START setting up a smart storage room where shelf items can be removed by shifting others left.

2. 🏷️ DEFINE a contract named "ArrayRemoveByShifting"
   // Imagine a shelf of boxes where if you remove one, all the ones to the right shift over to fill the gap.

   a. 📦 DECLARE a dynamic array "arr" to hold numbered boxes (uint256 values).

   b. ❌ DEFINE a function "remove":
   i. 📥 Accept an index "\_index" where a box should be removed.
   ii. 🧯 CHECK: If `_index` is outside the shelf (i.e., too big), throw an error: "index out of bounds"
   // Like pointing to a nonexistent shelf compartment.
   iii. 🧳 LOOP: From `_index` to one before the last slot: - Move each box one space to the left (`arr[i] = arr[i + 1]`)
   // Like sliding all boxes one step to the left to fill the removed box’s space.
   iv. 🧹 CALL `pop()` to remove the leftover last box (which is now a duplicate)
   // Like cutting off the extra box at the end of the shelf.

   c. 🧪 DEFINE a function "test":
   i. 🧰 Fill "arr" with `[1, 2, 3, 4, 5]`
   // Think of boxes labeled 1 to 5 on the shelf.
   ii. ❌ Remove the box at index 2 (the '3') using `remove(2)` - The result: `[1, 2, 4, 5]` (boxes slide left, last one cut off).
   iii. ✅ ASSERT: - arr[0] == 1 - arr[1] == 2 - arr[2] == 4 - arr[3] == 5 - arr.length == 4

   iv. 🧰 REINITIALIZE "arr" with `[1]` — a single box on the shelf.
   v. ❌ Remove index 0 (the only box) using `remove(0)` - Result: empty shelf `[]`
   vi. ✅ ASSERT: - arr.length == 0

3. 🏁 END of the shifting-shelf removal simulation.
