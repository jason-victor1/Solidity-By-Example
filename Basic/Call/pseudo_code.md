1. **START**

2. **DEFINE** a contract named `Receiver`  
   a. **DECLARE** an event named `Received` with parameters:  
      i. `caller` (type: `address`) to store the address of the sender.  
      ii. `amount` (type: `uint256`) to store the Ether sent.  
      iii. `message` (type: `string`) to store a custom message.  
   b. **DEFINE** a fallback function:  
      i. MARK it as external and payable.  
      ii. EMIT the `Received` event with:
         - `msg.sender` as the caller.
         - `msg.value` as the amount of Ether received.
         - `"Fallback was called"` as the message.  
   c. **DEFINE** a function named `foo`:  
      i. TAKE a parameter `_message` (type: `string`).  
      ii. TAKE a parameter `_x` (type: `uint256`).  
      iii. MARK the function as public and payable.  
      iv. EMIT the `Received` event with:
         - `msg.sender` as the caller.
         - `msg.value` as the amount of Ether received.
         - `_message` as the custom message.  
      v. RETURN `_x + 1`.

3. **DEFINE** a contract named `Caller`  
   a. **DECLARE** an event named `Response` with parameters:  
      i. `success` (type: `bool`) to indicate if the call succeeded.  
      ii. `data` (type: `bytes`) to store the returned data.  
   b. **DEFINE** a function named `testCallFoo`:  
      i. TAKE a parameter `_addr` (type: `address payable`) as the address of the `Receiver` contract.  
      ii. MARK the function as public and payable.  
      iii. PERFORM a low-level call to `foo(string,uint256)` on the `Receiver` contract with:  
         - `"call foo"` as the string argument.  
         - `123` as the integer argument.  
         - `msg.value` as the Ether sent.  
         - `5000` as the gas limit.  
      iv. EMIT the `Response` event with:  
         - `success` as the call's success status.  
         - `data` as the returned data.  
   c. **DEFINE** a function named `testCallDoesNotExist`:  
      i. TAKE a parameter `_addr` (type: `address payable`) as the address of the `Receiver` contract.  
      ii. MARK the function as public and payable.  
      iii. PERFORM a low-level call to `doesNotExist()` on the `Receiver` contract with:  
         - `msg.value` as the Ether sent.  
         - No additional arguments.  
      iv. EMIT the `Response` event with:  
         - `success` as the call's success status.  
         - `data` as the returned data.  

4. **END**
