1. 🏗️ START building a demo that showcases **function & variable visibility** in Solidity.

2. 🏷️ Name the primary building:
   DEFINE a contract called **"Base"**
   // Think of “Base” as a training hall with doors of different access levels.

   a. 🔒 DEFINE **privateFunc()** – PRIVATE
   i. 🪪 RETURNS text “private function called”
   // A staff-only door; only this room can open it.

   b. 🪟 DEFINE **testPrivateFunc()** – PUBLIC
   i. 🔁 CALL `privateFunc()`
   // Public window that triggers the staff-only door internally.

   c. 🔑 DEFINE **internalFunc()** – INTERNAL
   i. 🪪 RETURNS text “internal function called”
   // A badge-access door; this room and its children may enter.

   d. 🪟 DEFINE **testInternalFunc()** – PUBLIC & VIRTUAL
   i. 🔁 CALL `internalFunc()`
   // Public window that pulls the badge-access lever.

   e. 🌐 DEFINE **publicFunc()** – PUBLIC
   i. 🪪 RETURNS “public function called”
   // Main entrance; anyone—inside or outside—can walk through.

   f. 📫 DEFINE **externalFunc()** – EXTERNAL
   i. 🪪 RETURNS “external function called”
   // Service hatch reachable only from the street (other contracts/users).

   g. 🚫 NOTE un-compiled sample: **testExternalFunc()**
   // Would fail because inside callers can’t use the street-only hatch.

   h. 📝 DECLARE state variables with varied locks
   i. 🔒 `privateVar` – PRIVATE string “my private variable”
   // Hidden drawer only this room can open.
   ii. 🔑 `internalVar` – INTERNAL string “my internal variable”
   // Drawer shareable with child rooms.
   iii. 🌐 `publicVar` – PUBLIC string “my public variable”
   // Drawer visible to everyone outside.
   iv. 🚫 External state vars not allowed (commented out).

3. 🌿 DEFINE a child building:
   DEFINE a contract called **"Child"** that EXTENDS **"Base"**
   // New room inherits doors and drawers from Base.

   a. 🔑 OVERRIDE **testInternalFunc()** – PUBLIC
   i. 🔁 CALL `internalFunc()`
   // Child pulls the badge-access lever it inherited.

   b. 🚫 NOTE: Child **cannot** access `privateFunc()` or `privateVar`
   // Staff-only doors remain locked to descendants.

4. 🏁 END setup for the visibility-showcase system.
