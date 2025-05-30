1. 🏗️ START building a messaging system with low-level call behavior and fallback logic.

2. 🏷️ Name the first building:
   DEFINE a contract called **"Receiver"**
   // Acts like a receptionist that reacts to unknown calls and logs received funds.

   a. 📣 DECLARE event `Received(address, amount, message)`
   // Loudspeaker that logs who called, how much they sent, and the message attached.

   b. 🧲 DEFINE **fallback()** as external payable
   i. 📥 TRIGGERS when a call is made with no matching function
   ii. 📢 EMIT `Received(msg.sender, msg.value, "Fallback was called")`
   // Think of this as a catch-all response when the caller dials a non-existent extension.

   c. 🛎️ DEFINE function **"foo(string \_message, uint256 \_x)"** as public payable → returns uint256
   i. 📢 EMIT `Received(msg.sender, msg.value, _message)`
   // Logs the sender, sent ETH, and custom message.
   ii. ➕ RETURN `_x + 1`
   // Adds 1 to the input and hands it back.

3. 📤 DEFINE a contract called **"Caller"**
   // Like someone who only knows the address of a target but not its full definition.

   a. 📣 DECLARE event `Response(bool success, bytes data)`
   // Speaker system that confirms whether the call succeeded and shows the raw result.

   b. ☎️ DEFINE function **"testCallFoo(address \_addr)"** as public payable
   i. 🧬 ENCODE a function call for `foo("call foo", 123)` using `abi.encodeWithSignature`
   // Caller prepares a binary message to ask for foo with custom inputs.
   ii. 🧾 CALL `_addr.call` with 5000 gas and attached ETH
   // Sends the crafted message with specified fuel (gas) and funds.
   iii. 📢 EMIT `Response(success, data)`
   // Announces the success status and any result bytes.

   c. ☎️ DEFINE function **"testCallDoesNotExist(address \_addr)"** as public payable
   i. 🧬 ENCODE call to `doesNotExist()` using `abi.encodeWithSignature`
   // Caller prepares a message to a function that doesn't exist.
   ii. 🧲 CALL `_addr.call` with msg.value
   // Triggers fallback logic in the Receiver.
   iii. 📢 EMIT `Response(success, data)`
   // Logs whether the fallback was triggered and what came back.

4. 🏁 END setup for the dynamic calling and fallback-triggering system.
