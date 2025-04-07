1. 🏗️ START building a small digital storage unit that can update and share a number.

2. 🏷️ Name the building:
   DEFINE a contract called "SimpleStorage"
   // This is like a tiny storage kiosk that holds and updates a single value anyone can read.

   a. 🧮 DECLARE a public signboard "num" (state variable of type unsigned integer)
      // This is like placing a number display above the door—visible to all visitors.

   b. 🛎️ DEFINE a function called "set"
      i. 📢 MARK it as public—any visitor can use this feature.
      ii. 📥 ACCEPT a number from the visitor (`_num`)
      iii. ✍️ UPDATE the number display by replacing it with `_num`
           // Like someone walking in and updating the whiteboard with a new number.

   c. 🪟 DEFINE a function called "get"
      i. 📢 MARK it as public and read-only (`view`)
         // Anyone can check the number without changing anything—just like peeking at a display.
      ii. 🔁 RETURNS a number
      iii. 🧾 RETURN the current value shown on the number display (`num`)

3. 🏁 END the setup for the SimpleStorage building.

