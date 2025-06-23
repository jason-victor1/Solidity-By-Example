### 🧠 Pseudo Code with Real-World Analogies: `EtherWallet`

---

1. **START**

2. **DEFINE** a digital wallet called `EtherWallet`

3. **DECLARE** a state variable `owner`

   - This holds the wallet owner's address
   - Think of this as the name on the bank account.

4. **CONSTRUCTOR**

   - Runs **once** when the wallet is created
   - **SET** `owner` to the address of the person deploying this contract
   - Analogy: the person opening the wallet becomes the rightful owner.

5. **DEFINE** a `receive` function

   - This is triggered **automatically** whenever someone sends Ether **directly** to this wallet (without calling a function)
   - Analogy: like dropping cash straight into a physical piggy bank.

6. **DEFINE** a `withdraw` function

   - **MARKED** as `external`, allowing it to be called from outside
   - **ACCEPTS** a parameter `_amount` (how much to withdraw)
   - **CHECK**: Only allow the `owner` to withdraw — like a security PIN check
   - **TRANSFER** the `_amount` of Ether to the owner’s address
   - Analogy: the wallet checks if you’re the owner before handing over the cash.

7. **DEFINE** a `getBalance` function

   - **MARKED** as `external view` to read data without changing it
   - **RETURNS** the wallet’s current Ether balance
   - Analogy: like looking inside the wallet to count the money.

8. **END**
