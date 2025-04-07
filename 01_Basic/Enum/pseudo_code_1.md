1. 🏗️ START setting up a digital logistics center for package tracking.

2. 🏷️ DEFINE a contract named "Enum"
   // This is like a package manager that tracks what stage a delivery is in.

   a. 📋 DEFINE an enum called "Status"

   - A predefined list of possible status tags a package can have:
     i. 🕓 Pending – waiting to be processed  
     ii. 📦 Shipped – out for delivery  
     iii. ✅ Accepted – successfully received  
     iv. ❌ Rejected – refused by the recipient  
     v. 🚫 Canceled – order was canceled

   b. 🏷️ DECLARE a public state label `status` of type `Status`

   - This tag shows the current state of the package.
   - 🧾 NOTE: By default, it starts as `Pending`, the first status in the list.

   c. 🪟 DEFINE a function `get`:
   i. 📢 Public and view-only
   ii. 🧾 Returns the current status tag on the package.

   d. ✍️ DEFINE a function `set`:
   i. 📥 Accepts a new status label `_status` from the list
   ii. 🏷️ Replaces the current tag with `_status`

   e. 🚫 DEFINE a function `cancel`:
   i. 🔖 Automatically marks the package as `Canceled`—no input required

   f. 🧹 DEFINE a function `reset`:
   i. 🗑️ Uses `delete` to wipe the tag back to the default (`Pending`)

3. 🏁 END the package status manager setup.
