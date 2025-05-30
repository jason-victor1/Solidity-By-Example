1. START

2. DEFINE a contract named `Fallback`
   a. DEFINE an event named `Log` with parameters:
      i. A string variable `func`
      ii. An unsigned integer variable `gas`
   b. DEFINE a fallback function
      i. MARK function as external and payable
      ii. EMIT the `Log` event with the values:
         - "fallback" for `func`
         - Remaining gas using `gasleft()`
   c. DEFINE a receive function
      i. MARK function as external and payable
      ii. EMIT the `Log` event with the values:
         - "receive" for `func`
         - Remaining gas using `gasleft()`
   d. DEFINE a function `getBalance`
      i. MARK function as public and view
      ii. RETURNS the current balance of the contract using `address(this).balance`

3. DEFINE a contract named `SendToFallback`
   a. DEFINE a function `transferToFallback`
      i. MARK function as public and payable
      ii. TRANSFER `msg.value` Ether to the `_to` address using the `transfer` method
   b. DEFINE a function `callFallback`
      i. MARK function as public and payable
      ii. SEND `msg.value` Ether to the `_to` address using the `call` method
         - INCLUDE all available gas
         - CHECK if the transfer was successful
            - IF not, REVERT with the message "F
