🏗️ DEFINE a contract named "NestedMapping"
// This setup is like a cabinet (address) with smaller sub-cabinets (uint256) inside,
// and each sub-cabinet can hold a switch (true/false).

📂 DECLARE a public nested mapping called "nested"
// Top level: each address gets a big cabinet
// Inside each: keys (uint256) mapped to switches (bool)

🪟 DEFINE a function "get":
a. 📢 MARK as public and view-only
b. 📥 Accept "\_addr1" and "\_i"
c. 🔁 RETURN the boolean value in the nested drawer: nested[\_addr1][_i] - 📎 If the switch is unset, it defaults to false.

✍️ DEFINE a function "set":
a. 📢 MARK it public
b. 📥 Accept "\_addr1", "\_i", and "\_boo" (the switch state)
c. 🧾 Store "\_boo" in the appropriate nested drawer

🗑️ DEFINE a function "remove":
a. 📢 MARK it public
b. 📥 Accept "\_addr1" and "\_i"
c. 🧹 DELETE the switch at nested[\_addr1][_i]—reset to false

🏁 END the NestedMapping contract.
