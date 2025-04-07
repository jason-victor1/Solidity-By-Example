1. START

2. DEFINE a contract named `Event`

3. DECLARE an event `Log`
   a. INCLUDE parameters:
      i. `sender` (address): The address of the caller
         - MARK as indexed to allow filtering by this parameter
      ii. `message` (string): A message string to log

4. DECLARE an event `AnotherLog`
   a. NO parameters included (acts as a simple signal)

5. DEFINE a function `test`
   a. MARK function as public
   b. EMIT the `Log` event:
      i. SET `sender` to the address of the caller (`msg.sender`)
      ii. SET `message` to `"Hello World!"`
   c. EMIT another instance of the `Log` event:
      i. SET `sender` to the address of the caller (`msg.sender`)
      ii. SET `message` to `"Hello EVM!"`
   d. EMIT the `AnotherLog` event (no parameters included)

6. END