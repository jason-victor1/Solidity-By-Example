1. 🏗️ START building a function-logging inheritance tree of smart contracts.

2. 🏷️ Name the base building:
   DEFINE a contract called **"A"**
   // Think of “A” as the main control room every other room extends.

   a. 🔔 DECLARE an event `Log(string message)`
   // A loudspeaker that records each announcement in the blockchain ledger.

   b. 🛎️ DEFINE function **"foo"**
   i. 📢 MARK it as public and override-able (`virtual`)
   // Anyone can press it; children may swap it out.
   ii. 🎙️ EMIT `Log("A.foo called")`
   // Announces that button “foo” in room A was pressed.

   c. 🛎️ DEFINE function **"bar"**
   i. 📢 MARK it as public and override-able (`virtual`)
   ii. 🎙️ EMIT `Log("A.bar called")`
   // Announces that button “bar” in room A was pressed.

3. 🌿 DEFINE branch building:
   DEFINE a contract called **"B"** that INHERITS **"A"**
   // A new room that customizes A’s buttons.

   a. 🛎️ OVERRIDE function **"foo"**
   i. 🎙️ EMIT `Log("B.foo called")`
   // Says the “foo” button was pressed in room B.
   ii. ⏭️ CALL `A.foo()`
   // Directly rings the original A button.

   b. 🛎️ OVERRIDE function **"bar"**
   i. 🎙️ EMIT `Log("B.bar called")`
   ii. 🔗 CALL `super.bar()`
   // Passes the baton to the next room in the chain.

4. 🌿 DEFINE another branch building:
   DEFINE a contract called **"C"** that INHERITS **"A"**
   // Twin room to B with its own announcements.

   a. 🛎️ OVERRIDE function **"foo"**
   i. 🎙️ EMIT `Log("C.foo called")`
   ii. ⏭️ CALL `A.foo()`

   b. 🛎️ OVERRIDE function **"bar"**
   i. 🎙️ EMIT `Log("C.bar called")`
   ii. 🔗 CALL `super.bar()`

5. 🍃 DEFINE leaf building:
   DEFINE a contract called **"D"** that INHERITS **"B"** and **"C"**
   // Final room deciding how the chain of calls flows.

   a. 🛎️ OVERRIDE function **"foo"** (from B, C)
   i. 🔗 CALL `super.foo()`
   // Follows C → A path; A executes once.

   b. 🛎️ OVERRIDE function **"bar"** (from B, C)
   i. 🔗 CALL `super.bar()`
   // Follows C → B → A path; A still executes only once.

6. 🏁 END setup for the inheritance-based logging system.
