### 🧠 Pseudo Code with Real-World Analogies: `MyToken`

---

1. **START**

---

2. **DEFINE** a contract called `MyToken`

   - It **inherits** from `ERC20`, which already provides the full banking system (balances, transfers, approvals, minting, burning).
   - Analogy: imagine `MyToken` is a **new branch** of a bank chain. Instead of building everything from scratch, it reuses the existing central banking system (`ERC20`) and just customizes its setup.

---

3. **CONSTRUCTOR** (runs once when the token is first deployed)

   - Takes three inputs:

     - `name`: the full name of the token (like “GoldCoin”).
     - `symbol`: shorthand/ticker for the token (like “GLD”).
     - `decimals`: how divisible the token is (like cents in a dollar).

   - Passes these values into the parent `ERC20` constructor so the token gets its identity.

   - Analogy: when opening a new bank branch, you put up the **signboard** (name, ticker, and how fine-grained your currency is).

---

4. **INITIAL MINTING**

   - Calls `_mint(msg.sender, 100 * 10 ** decimals)`.

     - `msg.sender`: the account that deployed the contract.
     - `100 * 10 ** decimals`: calculates the token’s base units.

       - Example: if `decimals = 18`, then `100 * 10^18` = 100 full tokens (like saying _1 dollar = 100 cents_, but here _1 token = 10^decimals subunits_).

   - This ensures the deployer starts with 100 tokens.

   - Analogy: the founder of a new currency prints the **first 100 bills** and puts them into their own wallet.

---

5. **END**

---
