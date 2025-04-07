1. START

2. DEFINE a contract named `FunctionModifier`

3. DECLARE state variables (stored on the blockchain):
   a. `owner` - a public address that stores the owner's address
   b. `x` - a public unsigned integer initialized to 10
   c. `locked` - a public boolean flag initialized to false

4. DEFINE a constructor:
   a. SET `owner` to the address of the transaction sender (`msg.sender`)

5. DEFINE a modifier `onlyOwner`:
   a. REQUIRE that the caller (`msg.sender`) is the same as `owner`
   b. ALLOW execution of the rest of the function using `_`

6. DEFINE a modifier `validAddress`:
   a. ACCEPT one input parameter:
      i. `_addr` - an address
   b. REQUIRE that `_addr` is not the zero address
   c. ALLOW execution of the rest of the function using `_`

7. DEFINE a function `changeOwner`:
   a. MARK function as public
   b. APPLY `onlyOwner` modifier
   c. APPLY `validAddress` modifier with `_newOwner` as the input
   d. ACCEPT one input parameter:
      i. `_newOwner` - an address
   e. SET `owner` to `_newOwner`

8. DEFINE a modifier `noReentrancy`:
   a. REQUIRE that `locked` is false
   b. SET `locked` to true
   c. ALLOW execution of the rest of the function using `_`
   d. RESET `locked` to false

9. DEFINE a function `decrement`:
   a. MARK function as public
   b. APPLY `noReentrancy` modifier
   c. ACCEPT one input parameter:
      i. `i` - an unsigned integer
   d. SUBTRACT `i` from `x`
   e. IF `i` is greater than 1:
      i. CALL `decrement` recursively with `i - 1`

10. END
