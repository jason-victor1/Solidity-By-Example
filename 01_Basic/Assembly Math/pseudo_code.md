### 🧮 Pseudocode with Analogies for Assembly-Based Math Operations

---

1. **START**

2. **DEFINE** a contract named `AssemblyMath`

   * This contract performs **low-level arithmetic** using Yul assembly, mimicking calculator operations under the hood.

---

3. **DEFINE** a function `yul_add`
   a. **MARK** the function as public and pure
   b. **ACCEPT** two inputs: `x` and `y` (unsigned integers)
   c. **IN YUL assembly**:
   i. **ADD** `x + y`, and store in `z`
   ii. **CHECK**: If result `z` is less than `x`, **REVERT** (simulate overflow)

   * 🧠 **Analogy**: Like stacking two towers of blocks; if your second tower vanishes after stacking, something went wrong—cancel it!

---

4. **DEFINE** a function `yul_mul`
   a. **MARK** the function as public and pure
   b. **ACCEPT** two inputs: `x` and `y` (unsigned integers)
   c. **IN YUL assembly**:
   i. **SWITCH** case on `x`:

   * If `x == 0`, return 0 immediately
   * Else:

     * **MULTIPLY** `x * y` into `z`
     * **VERIFY**: If `z / x != y`, it means **overflow** occurred—REVERT
   * 🧠 **Analogy**: Multiplying boxes in a warehouse; if the number of total boxes divided by one stack doesn’t give you the other, you’ve overcounted—sound the alarm!

---

5. **DEFINE** a function `yul_fixed_point_round`
   a. **MARK** the function as public and pure
   b. **ACCEPT** two inputs: `x` (value), `b` (base unit for rounding)
   c. **IN YUL assembly**:
   i. **CALCULATE** `half = b / 2`
   ii. **ADD** half to `x`
   iii. **ROUND** to nearest multiple:
   \- `z = ((x + half) / b) * b`

   * 🧠 **Analogy**: Imagine rounding money—\$90 with base unit of \$100 should become \$100, not \$0. So we give it a boost of \$50 before rounding.

---

6. **END**


