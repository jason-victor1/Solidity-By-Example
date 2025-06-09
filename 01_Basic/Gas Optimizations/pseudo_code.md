## 🏗️ Contract: GasGolf

A smart contract demonstrating progressive **gas optimizations** using micro-optimizations in Solidity. The function processes an array of numbers and sums only the even values that are less than 99.

---

### 🧱 STATE VARIABLE

1. 🔢 `total` → `uint256 public`

   - Tracks the running total of qualified numbers across all function calls.

---

### 🧠 FUNCTION: sumIfEvenAndLessThan99(uint256\[] calldata nums)

➡️ **Purpose:**
Sums all numbers in the input array that are both **even** and **less than 99**, while applying a series of **gas optimization techniques**.

---

### ⚙️ OPTIMIZATION STRATEGIES (Progressively applied)

1. 🪶 Use `calldata` instead of `memory` for the `nums` array

   - ✅ Saves on copy cost and avoids unnecessary duplication

2. 📤 Cache `total` into `_total` (local memory variable)

   - ✅ Accessing state variables is more expensive than local ones

3. 🧮 Cache `nums.length` into `len`

   - ✅ Reduces repeated reads of `nums.length` in the loop condition

4. 🪜 Loop increment with `unchecked { ++i; }`

   - ✅ Avoids overflow checks when `i` cannot realistically overflow

5. 📥 Load `nums[i]` into `num` once per iteration

   - ✅ Minimizes repeated storage access

6. 🚪 Use short-circuiting in condition:
   `if (num % 2 == 0 && num < 99)`

   - ✅ Efficient branching; second condition only runs if the first is true

---

### 🔄 LOOP LOGIC

For each element `num` in the array `nums`:

- ✅ Check if `num` is divisible by 2 (i.e., is even)
- ✅ Check if `num` is less than 99
- If both conditions are true:

  - ➕ Add `num` to `_total`

Finally:

- 🔄 Update state variable: `total = _total`

---

### ✅ EXAMPLE

Input: `[1, 2, 3, 4, 5, 100]`

Filter results:

- 2 → even and <99 → ✅
- 4 → even and <99 → ✅
  Sum = 6 → stored in `total`

---

### 🏁 END RESULT
