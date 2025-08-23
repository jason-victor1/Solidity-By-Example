### 🧠 Pseudo Code with Real-World Analogies: `IterableMapping`

---

1. **START**

---

2. **DEFINE** a library called `IterableMapping`

   - Purpose: store key–value pairs like a mapping, but also **keep track of all keys** for iteration.
   - Analogy: imagine a **notebook** where:

     - Each page is labeled with a person’s address,
     - On that page, you write their balance (value),
     - You also keep an **index card catalog** so you know who’s inside and where their page is.

---

3. **STRUCT** `Map`

   - **`keys`**: list of all addresses inserted (like a contact list).

   - **`values`**: mapping from address → number (balances written on each contact’s page).

   - **`indexOf`**: mapping from address → index in the keys array (where they’re listed in the contact list).

   - **`inserted`**: mapping from address → bool (whether they’re already in the system).

   - Analogy:

     - `keys` = list of all contacts in order.
     - `values` = each contact’s account balance.
     - `indexOf` = "page number" in the contact list.
     - `inserted` = a checkmark that says “this person is already in the book.”

---

4. **FUNCTION** `get(map, key)`

   - Returns the stored value for a given key (address).
   - Analogy: look up a friend in the contact list and read their balance from their page.

---

5. **FUNCTION** `getKeyAtIndex(map, index)`

   - Returns the address stored at a specific index in the keys array.
   - Analogy: flip to a certain page in the notebook and read the contact’s name.

---

6. **FUNCTION** `size(map)`

   - Returns how many keys (contacts) are stored.
   - Analogy: count how many friends are in your notebook.

---

7. **FUNCTION** `set(map, key, val)`

   - If the key already exists (`inserted[key] == true`), update its value.
   - Otherwise:

     - Mark the key as inserted,
     - Assign it a value,
     - Record its index position,
     - Push the key into the `keys` list.

   - Analogy:

     - If the person already has a page, just update their balance.
     - If they’re new, add a new page, write their balance, and update the index card catalog.

---

8. **FUNCTION** `remove(map, key)`

   - If the key doesn’t exist, stop.
   - Otherwise:

     - Erase their inserted checkmark,
     - Delete their value,
     - Swap the last key in `keys` into this key’s spot (to keep the list tight),
     - Update the catalog (`indexOf`) for the swapped key,
     - Remove the last element from `keys`.

   - Analogy:

     - Cross this person out of the contact list,
     - Rip out their page,
     - Move the last person in the book into their slot,
     - Adjust the catalog so page numbers still line up.

---

9. **DEFINE** contract `TestIterableMap`

   - Uses the `IterableMapping` library.
   - Analogy: this is like a **front desk clerk** who uses the notebook to manage user balances.

---

10. **DECLARE** `map` (an IterableMapping.Map instance)

- Analogy: this is the actual notebook being managed by the clerk.

---

11. **FUNCTION** `setInMapping(val)`

- Stores the caller’s (`msg.sender`) balance in the notebook.
- Analogy: you walk up to the desk and say, “Please set my balance to X.”

---

12. **FUNCTION** `getFromMap()`

- Returns the balance of the caller.
- Analogy: you ask, “What’s my balance in the notebook?” and the clerk reads it back.

---

13. **FUNCTION** `getKeyAtIndex(index)`

- Returns the address at a specific index in the contact list.
- Analogy: the clerk says, “The person on page #2 is Alice.”

---

14. **FUNCTION** `sizeOfMapping()`

- Returns how many addresses (friends) are in the notebook.
- Analogy: count how many pages are filled in the notebook.

---

15. **FUNCTION** `removeFromMapping()`

- Removes the caller from the notebook.
- Analogy: you say, “Erase me from your records.” The clerk rips out your page and keeps the list tidy by moving the last person’s page into your old slot.

---

16. **END**
