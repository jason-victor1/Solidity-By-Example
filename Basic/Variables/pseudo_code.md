1. START

2. DEFINE a contract named `Variables`

3. DECLARE state variables (stored on the blockchain):
   a. `text` - a public string initialized to "Hello"
   b. `num` - a public unsigned integer initialized to 123

4. DEFINE a function `doSomething`
   a. MARK function as public and view
   b. DECLARE a local variable `i`:
      i. Type: unsigned integer
      ii. Initial value: 456
      iii. NOTE: Local variables are not stored on the blockchain
   c. DECLARE a variable `timestamp` to hold the current block timestamp
      i. ASSIGN `block.timestamp` to `timestamp`
   d. DECLARE a variable `sender` to hold the address of the caller
      i. ASSIGN `msg.sender` to `sender`

5. END
