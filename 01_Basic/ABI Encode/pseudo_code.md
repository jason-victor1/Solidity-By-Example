1. **START**

2. **DEFINE** an interface named `IERC20`  
   a. **DECLARE** a function named `transfer`:  
      i. TAKE two parameters:  
         - `address` of the recipient.  
         - `uint256` for the amount to transfer.  
      ii. SPECIFY that the function is `external`.

3. **DEFINE** a contract named `Token`  
   a. **DECLARE** a function named `transfer`:  
      i. TAKE two parameters:  
         - `address` of the recipient.  
         - `uint256` for the amount to transfer.  
      ii. SPECIFY that the function is `external`.  
      iii. LEAVE the function body empty.

4. **DEFINE** a contract named `AbiEncode`  
   a. **DEFINE** a function named `test`:  
      i. TAKE two parameters:  
         - `_contract` of type `address` (target contract).  
         - `data` of type `bytes` (encoded data).  
      ii. PERFORM a low-level `call` to `_contract` with `data`.  
      iii. REQUIRE that the call was successful; otherwise, revert with "call failed".

   b. **DEFINE** a function named `encodeWithSignature`:  
      i. TAKE two parameters:  
         - `to` of type `address` (recipient).  
         - `amount` of type `uint256` (amount to transfer).  
      ii. RETURN the ABI-encoded data for the `transfer` function using its string signature.  
         - STRING: `"transfer(address,uint256)"`.

   c. **DEFINE** a function named `encodeWithSelector`:  
      i. TAKE two parameters:  
         - `to` of type `address` (recipient).  
         - `amount` of type `uint256` (amount to transfer).  
      ii. RETURN the ABI-encoded data for the `transfer` function using its selector.  
         - SELECTOR: `IERC20.transfer.selector`.

   d. **DEFINE** a function named `encodeCall`:  
      i. TAKE two parameters:  
         - `to` of type `address` (recipient).  
         - `amount` of type `uint256` (amount to transfer).  
      ii. RETURN the ABI-encoded data for the `transfer` function using `abi.encodeCall`.  
         - VALIDATE function signature and arguments during compilation.

5. **END**

