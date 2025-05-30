1. 🏗️ START building a smart contract system that demonstrates how fallback functions forward calls and capture output.

2. 🏷️ Name the first building:
   DEFINE a contract called **"FallbackInputOutput"**
   // Think of this as a call-forwarding office that routes messages to another contract.

   a. 📦 DECLARE an immutable variable `target` of type address
   // A locked-in destination for all forwarded calls.

   b. 🧱 DEFINE constructor that accepts `_target`
   i. 🪪 SET `target` to the passed-in address
   // When built, it memorizes where to forward messages.

   c. 📥 DEFINE fallback function accepting calldata `data`
   i. 📤 FORWARD the message to `target` using `call` with attached value
   // Like rerouting a phone call and passing on the message + money.
   ii. 📋 REQUIRE the call to succeed, else revert with `"call failed"`
   // Drops the line if the message doesn't go through.
   iii. 🔁 RETURN the result bytes from the call
   // Sends back the response it received.

3. 🧮 DEFINE a contract called **"Counter"**
   // A digital number tracker that can be incremented or read.

   a. 🧾 DECLARE public variable `count` of type uint256
   // The number display outside the building.

   b. 🪟 DEFINE function **"get()"** as external view → returns `count`
   // Lets people look at the number without changing it.

   c. 🔼 DEFINE function **"inc()"** as external → returns new count
   i. ➕ INCREMENT `count` by 1
   // Presses the "increase number" button.
   ii. 🔁 RETURN updated `count`

4. 🧪 DEFINE a contract called **"TestFallbackInputOutput"**
   // A testing lab that checks what happens when using low-level calls.

   a. 📣 DECLARE event `Log(bytes res)`
   // A megaphone that echoes the response from the test.

   b. 🧪 DEFINE function **"test(address \_fallback, bytes calldata data)"**
   i. 🔄 CALL the fallback contract address with custom data
   // Tries sending a crafted message to the router building.
   ii. ⚠️ REQUIRE the call to succeed or fail with `"call failed"`
   iii. 📢 EMIT `Log(res)` with the result bytes
   // Announces the returned result publicly.

   c. 🛠️ DEFINE function **"getTestData()"** as pure → returns two byte arrays
   i. 🧬 USE `abi.encodeCall` to prepare inputs for `Counter.get()` and `Counter.inc()`
   // Prepares the binary messages that mimic calling those two functions.

5. 🏁 END setup for the fallback-forwarding and counter interaction demo.
