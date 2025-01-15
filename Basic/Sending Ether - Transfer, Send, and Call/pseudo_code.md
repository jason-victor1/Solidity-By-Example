1. **START**

2. **DEFINE** a contract named `ReceiveEther`

3. **DECLARE state variables** (stored on the blockchain):
   a. The contract's balance, implicitly tracked by the Ethereum blockchain.

4. **DEFINE a receive function (`receive`)**:
   a. MARK the function as external and payable.
   b. DESIGNED to handle plain Ether transfers.
   c. EXECUTED automatically when Ether is sent and `msg.data` is empty.

5. **DEFINE a fallback function (`fallback`)**:
   a. MARK the function as external and payable.
   b. EXECUTED when Ether is sent and `msg.data` is not empty or if the `receive` function does not exist.

6. **DEFINE a function `getBalance`**:
   a. MARK the function as public and view.
   b. RETURN the current Ether balance of the contract:
      i. CALL `address(this).balance` to retrieve the balance.

---

7. **DEFINE a contract named `SendEther`**

8. **DEFINE a function `sendViaTransfer`**:
   a. MARK the function as public and payable.
   b. ACCEPT a parameter `_to` of type `address payable`.
   c. SEND `msg.value` Ether to `_to` using the `transfer` method.
      i. NOTE: This method enforces a strict gas limit of 2300 and throws an error on failure.

9. **DEFINE a function `sendViaSend`**:
   a. MARK the function as public and payable.
   b. ACCEPT a parameter `_to` of type `address payable`.
   c. SEND `msg.value` Ether to `_to` using the `send` method.
      i. STORE the return value of the send operation in a boolean variable `sent`.
      ii. IF `sent` is false, REVERT the transaction with an error message.

10. **DEFINE a function `sendViaCall`**:
    a. MARK the function as public and payable.
    b. ACCEPT a parameter `_to` of type `address payable`.
    c. SEND `msg.value` Ether to `_to` using the `call` method:
       i. FORWARD all available gas or a specified gas amount.
       ii. STORE the success status in a boolean variable `sent`.
       iii. STORE additional return data in a `bytes` variable `data`.
    d. IF `sent` is false, REVERT the transaction with an error message.

11. **END**

