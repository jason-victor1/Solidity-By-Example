### 🔐 **Pseudocode w/ Analogies – MultiSigWallet**

1. **START**

2. **DEFINE** a contract named `MultiSigWallet`
   💡 _Think of this as a secure safe that requires multiple keyholders to approve before opening._

3. **DECLARE** events for every major action:

   - `Deposit(sender, amount, balance)` – _Like logging every time someone puts cash into the safe._
   - `SubmitTransaction(owner, txIndex, to, value, data)` – _When someone proposes a withdrawal from the safe._
   - `ConfirmTransaction(owner, txIndex)` – _A co-owner signs off on the withdrawal request._
   - `RevokeConfirmation(owner, txIndex)` – _A co-owner withdraws their signature before execution._
   - `ExecuteTransaction(owner, txIndex)` – _The withdrawal request is approved, and the safe is opened._

4. **DECLARE** state variables:
   a. `owners[]` – list of authorized keyholders
   b. `isOwner[address]` – quick check if an address is a keyholder
   c. `numConfirmationsRequired` – the minimum number of approvals needed to open the safe

5. **DEFINE** struct `Transaction`:

   - `to` – recipient address
   - `value` – amount to withdraw
   - `data` – extra info for more complex transactions
   - `executed` – flag if the transaction is already done
   - `numConfirmations` – count of current approvals

6. **DECLARE** mapping `isConfirmed[txIndex][owner]` – tracks who has signed off on each request

7. **DECLARE** dynamic array `transactions[]` – to store all proposed withdrawals

8. **MODIFIERS** enforce rules:

   - `onlyOwner`: _Only keyholders can propose or approve_
   - `txExists(txIndex)`: _Check the proposal exists_
   - `notExecuted(txIndex)`: _Ensure the withdrawal hasn’t already happened_
   - `notConfirmed(txIndex)`: _Ensure the keyholder hasn’t already approved_

9. **CONSTRUCTOR**:

   - Accepts `_owners` and `_numConfirmationsRequired`
   - Enforces:

     - 🔐 At least one owner
     - Valid confirmation threshold
     - Unique, non-zero addresses

   - Sets up owners and required approvals

10. **`receive()`**:

    - Accepts incoming Ether
    - Emits `Deposit` event

11. **`submitTransaction(to, value, data)`**:

    - **onlyOwner** allowed
    - Creates a new `Transaction`, executes `transactions.push(...)`, emits `SubmitTransaction` with index
    - _Like a keyholder writing a withdrawal request with amount and details_

12. **`confirmTransaction(txIndex)`**:

    - **onlyOwner**, must exist, not executed, not already confirmed
    - Increases `numConfirmations`, marks `isConfirmed` for `msg.sender`
    - Emits `ConfirmTransaction`
    - _Like a co-owner signing the withdrawal request_

13. **`executeTransaction(txIndex)`**:

    - **onlyOwner**, must exist, not executed
    - Requires confirmations >= `numConfirmationsRequired`
    - Sets `executed = true`, sends Ether (and data) using `.call`, reverts on failure
    - Emits `ExecuteTransaction`
    - _Safe finally opens and the money is sent out_

14. **`revokeConfirmation(txIndex)`**:

    - **onlyOwner**, exists, not executed, must have confirmed
    - Decrements `numConfirmations`, clears `isConfirmed[msg.sender]`
    - Emits `RevokeConfirmation`
    - _Like a co-owner removing their signature before final execution_

15. **VIEW functions:**

    - `getOwners()`: returns array of owner addresses
    - `getTransactionCount()`: returns total proposals
    - `getTransaction(txIndex)`: returns detailed info for one proposal

16. **END**
