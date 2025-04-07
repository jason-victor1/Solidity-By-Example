1. 🏗️ START setting up a digital warehouse where shelves (arrays) hold ordered items (integers).

2. 🏷️ DEFINE a contract named "Array"
   // This is your organized storage room with flexible and fixed-size shelves.

   a. 🧰 DECLARE a dynamic shelf named "arr"
   // Like a storage shelf that can grow or shrink as needed.

   b. 📦 DECLARE and INIT "arr2" with `[1, 2, 3]`
   // Pre-loaded shelf with three boxes labeled 1, 2, and 3.

   c. 🪵 DECLARE a fixed-size shelf "myFixedSizeArr" with 10 slots
   // Like a long shelf with 10 compartments, each starting empty (value 0).

   d. 🔍 DEFINE a function "get":
   i. 📥 Accept an index `i`
   ii. 👓 View-only
   iii. 🧾 Return the item stored at position `i` on the shelf `arr`.

   e. 📚 DEFINE a function "getArr":
   i. 👓 View-only
   ii. 🪪 Returns the entire shelf `arr` (copied into memory for external viewing).

   f. ➕ DEFINE a function "push":
   i. 📥 Accept a number `i`
   ii. ✍️ Public
   iii. 🧳 Add `i` to the end of the shelf—just like placing a new box at the far right.

   g. ➖ DEFINE a function "pop":
   i. ✍️ Public
   ii. 🧹 Remove the last item on the shelf—like pulling off the last box.

   h. 📏 DEFINE a function "getLength":
   i. 👓 View-only
   ii. 🧾 Return the number of boxes currently on the shelf.

   i. ❌ DEFINE a function "remove":
   i. 📥 Accept an index
   ii. ✍️ Public
   iii. 🧻 Reset the item at that position to 0, but the shelf remains the same length—like emptying a box without removing it.

   j. 🧪 DEFINE a function "examples":
   i. 🚪 External, pure (just for showing concepts)
   ii. 🧰 Create a new memory-only shelf `a` with 5 slots (temporary workbench)
   iii. 📦 Create a nested shelf `b` with 2 inner shelves - 🪄 For each spot in `b`, set it as a mini-shelf of 3 items.
   iv. 📐 Fill first inner shelf: `[1, 2, 3]`
   v. 📐 Fill second inner shelf: `[4, 5, 6]`

3. 🏁 END the Array contract setup.
