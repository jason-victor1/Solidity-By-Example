🏗️ START setting up a digital filing system.

📛 DEFINE a contract named "Mapping"
   // This contract acts like a receptionist’s desk that links people's wallet addresses to numbers.

📂 DECLARE a public mapping called "myMap"
   // Think of this as a cabinet where each drawer is labeled with an address, and inside is a number (uint256).
   // If a drawer hasn't been used yet, it just shows the default (0).

🪟 DEFINE a function "get":
   a. 📢 MARK it public and view-only.
   b. 📥 Accept a visitor’s address "_addr".
   c. 🔁 RETURN the number stored under "_addr" in the drawer (myMap[_addr]).
      - 📎 If the drawer is empty, it returns 0 by default.

✍️ DEFINE a function "set":
   a. 📢 MARK it public.
   b. 📥 Accept "_addr" and a number "_i".
   c. 🧾 Store "_i" in the drawer labeled "_addr".

🗑️ DEFINE a function "remove":
   a. 📢 MARK it public.
   b. 📥 Accept "_addr".
   c. 🧹 DELETE the value under "_addr", resetting it to 0 (default).

🏁 END the Mapping contract.
