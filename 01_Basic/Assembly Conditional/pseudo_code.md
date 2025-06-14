### ✅ Pseudocode with Analogies: `AssemblyIf` Contract

---

1. **START**

2. **DEFINE** a contract named `AssemblyIf`

3. **DEFINE** a function `yul_if`

   - 📛 Function Name: `yul_if`

   - 📌 Purpose: Demonstrates an `if` condition using Yul (Solidity assembly)

   - **ACCEPT** an input parameter `x` (unsigned integer)

   - **MARK** function as public and pure

   - **DECLARE** a return variable `z` (unsigned integer)

   - ⚙️ Inside assembly block:

     - **IF** the condition `x < 10` is true, **SET** `z = 99`
     - 📦 **Analogy**: "If your age is under 10, you get a candy (99 points), else nothing happens"

4. **DEFINE** a function `yul_switch`

   - 📛 Function Name: `yul_switch`

   - 📌 Purpose: Demonstrates `switch-case` using Yul

   - **ACCEPT** an input parameter `x` (unsigned integer)

   - **MARK** function as public and pure

   - **DECLARE** a return variable `z` (unsigned integer)

   - ⚙️ Inside assembly block:

     - **SWITCH** on value `x`:

       - **CASE 1**: set `z = 10`
       - **CASE 2**: set `z = 20`
       - **DEFAULT**: set `z = 0`

     - 🎮 **Analogy**: "Like a vending machine: press 1 for soda (10), press 2 for juice (20), press any other key and get water (0)"

5. **END**
