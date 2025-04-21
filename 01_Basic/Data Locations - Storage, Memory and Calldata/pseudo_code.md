1. 🏁 START setting up a workspace that handles different "data locations" (long-term, temporary, read-only).

2. 🏢 DEFINE a contract named "DataLocations"
   // This contract explores how data is stored and referenced in Solidity:
   // - Storage = filing cabinet (permanent and shared)
   // - Memory = whiteboard (temporary and editable)
   // - Calldata = clipboard handout (read-only and gas-efficient)

   a. 🗃️ DECLARE a public dynamic array "arr" stored in storage
   // A shelf of numbers permanently stored on-chain.

   b. 🗺️ DECLARE a mapping "map" from uint to address stored in storage
   // Like a directory where each number points to a wallet address.

   c. 🧱 DECLARE a struct template "MyStruct"
   i. Contains a field: - `foo` – a simple integer stored inside the struct

   d. 🗃️ DECLARE a mapping "myStructs" from uint to "MyStruct"
   // Each ID maps to a personal folder (struct) holding one field.

3. 🔧 DEFINE a function "f"
   a. 🧭 Marked as public (can be called from outside)
   b. 📞 Calls internal function `_f` with:
   i. Reference to the main array "arr" (stored on-chain)
   ii. Reference to the address map "map" (stored on-chain)
   iii. Reference to a specific struct "myStructs[1]" (also on-chain)

   c. 📂 Locally access and store a reference to "myStructs[1]" as "myStruct"
   // Like temporarily opening and pointing at a specific drawer.

   d. 🧪 Create a new blank instance "myMemStruct" of MyStruct in memory with `foo = 0`
   // This is like scribbling on a whiteboard – temporary and cheap.

4. 🔧 DEFINE an internal function "\_f"
   a. 🧩 Internal-only (used within the contract)
   b. 🧷 Accepts:
   i. A reference to a storage array `_arr`
   ii. A reference to a storage mapping `_map`
   iii. A reference to a storage struct `_myStruct`
   c. 🔧 Operations on these storage references would manipulate on-chain data directly (implementation not shown).

5. 📐 DEFINE a function "g"
   a. 📭 Public
   b. 📥 Accepts a dynamic array `_arr` in memory
   // This array is editable and temporary (like a dry-erase list)
   c. 🔁 Returns a new version of the memory array (modifications are off-chain)

6. 📄 DEFINE a function "h"
   a. 📢 External
   b. 📥 Accepts a dynamic array `_arr` in calldata
   // This is like a printed sheet of paper passed in—efficient and read-only
   c. 🧪 Implementation would read and possibly loop over the calldata input (no writes allowed)

7. 🏁 END: This contract gives a hands-on walkthrough of Solidity’s data storage types: storage, memory, and calldata.
