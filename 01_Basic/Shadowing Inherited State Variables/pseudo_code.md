1. 🏗️ START building a digital name-display system that shows and updates its label.

2. 🏷️ Name the building:
   DEFINE a contract called **"A"**
   // Like a kiosk with a sign that says its own name.

   a. 🏷️ DECLARE a public plaque `name` – string set to **"Contract A"**
   // The signboard starts out reading “Contract A.”

   b. 🪟 DEFINE function **"getName"**
   i. 📢 MARK as public and view-only (`view`)
   // Anyone can peek without changing anything.
   ii. 🔁 RETURNS a string
   iii. 🧾 RETURN the current text on the plaque (`name`)

3. 🏢 Add a specialized building on the same foundation:
   DEFINE a contract called **"C"** that EXTENDS **"A"**
   // A new kiosk inherits the original sign but can relabel itself.

   a. 🔧 DEFINE a constructor
   i. ⚙️ RUN once at deployment
   ii. ✍️ UPDATE the inherited plaque `name` to **"Contract C"**
   // Swaps the sign to display “Contract C.”

   b. 🪟 INHERIT function **"getName"** unchanged
   // Visitors still use the same window to read the sign.

4. 🏁 END setup for the Name-Display system.
