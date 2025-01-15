1. **START**

2. **DEFINE** a contract named `Payable`

3. **DECLARE** state variables (stored on the blockchain):
   a. `owner` - a public, payable address to store the owner of the contract.

4. **DEFINE** a constructor function
   a. MARK the function as `payable`.
   b. SET `owner` to the address of the account deploying the contract (`msg.sender`).

5. **DEFINE** a function `deposit`
   a. MARK the function as `public` and `payable`.
   b. (No additional logic is required as the contract's balance automatically updates with received Ether).

6. **DEFINE** a function `notPayable`
   a. MARK the function as `public`.
   b. (This function cannot accept Ether as it is not marked `payable`).

7. **DEFINE** a function `withdraw`
   a. MARK the function as `public`.
   b. CALCULATE the current balance of the contract (`address(this).balance`).
   c. SEND the entire balance to the `owner` using a low-level `call`.
   d. VERIFY the success of the transfer:
      i. IF the transfer fails, revert the transaction with an error message.

8. **DEFINE** a function `transfer`
   a. MARK the function as `public`.
   b. ACCEPT parameters:
      i. `_to` - a payable address to specify the recipient.
      ii. `_amount` - a uint256 to specify the amount of Ether to send (in wei).
   c. SEND `_amount` of Ether from the contract to `_to` using a low-level `call`.
   d. VERIFY the success of the transfer:
      i. IF the transfer fails, revert the transaction with an error message.

9. **END**
