### 🧠 Pseudo Code with Real-World Analogies: `AssemblyBinExp.rpow`

---

1. **START**

2. **DEFINE** function `rpow(x, n, b) -> z` (pure)

   - Purpose: compute (x^n) using **binary exponentiation** (a.k.a. exponentiation by squaring) under **fixed-point scaling** with base `b`.
   - 🧮 Analogy: Think of `x` as a **scaled number** measured in “units per `b`.” Every multiply must **re-scale** by `b` to keep the units consistent, like converting inches↔feet after every calculation.

---

3. **EDGE CASES**

   - **IF** `x == 0`:

     - **IF** `n == 0`: set `z = b`

       - 🧩 Analogy: The ambiguous (0^0) returns the **neutral scaling value** `b` (i.e., 1.0 in fixed-point units).

     - **ELSE**: set `z = 0`

       - 🧯 Analogy: Any positive power of **zero** stays **zero**.

   - **ELSE (x > 0)**:

     - **IF** `n` is **even**: set `z = b` (multiplicative identity under scaling)

       - 🧱 Analogy: Start with a **neutral brick** sized exactly 1.0 (scaled as `b`).

     - **IF** `n` is **odd**: set `z = x`

       - 🧱 Analogy: Start with one **copy of x** already placed in your product.

---

4. **PREP ROUNDER**

   - Set `half = b / 2`.
   - 🎯 Analogy: A **rounding helper** so that whenever we divide by `b` to re-scale, we can do **round half up** by adding `half` first.

---

5. **MAIN LOOP: Exponentiation by Squaring**

   - Initialize loop with `n = n / 2` and repeat while `n > 0`, halving `n` each iteration.
   - 🏗️ Analogy: You’re building a tower using **doubling and halving**: square the base repeatedly, and when a bit of `n` is 1, you **attach** the current base to your result.

   **Each iteration:**

   1. **Square the base**: `xx = x * x`.

      - **Overflow check**: verify `xx / x == x`; if not, **revert**.
      - 🧨 Analogy: After mixing two large batches of paint, you check if the ratio stayed consistent; if not, the bucket **burst**—stop.

   2. **Re-scale with rounding**:

      - `xxRound = xx + half` (overflow check: `xxRound >= xx`), then `x = xxRound / b`.
      - 🎚️ Analogy: You have gallons but need **liters**; add a small **half-unit** nudge to round properly, then convert units.

   3. **If the current bit of n is 1 (`n % 2 == 1`)**: multiply result by base

      - `zx = z * x`
      - **Overflow guard**: if `x != 0` then ensure `zx / x == z`; otherwise **revert**.
      - **Re-scale with rounding**:

        - `zxRound = zx + half` (overflow check), then `z = zxRound / b`.

      - 🧱 Analogy: If the next **blueprint bit** says “attach,” you glue the current **brick x** onto your **tower z**; then convert back to the right unit size with rounding.

   4. **Halve the exponent**: `n = n / 2` (done by loop control).

      - 🔍 Analogy: Move to the **next bit** of the exponent by shifting right.

---

6. **RETURN `z`**

   - 🏁 Analogy: Your **tower** (the product) is complete, properly sized (re-scaled) and **rounded** at each step, with all overflow checks passed.

---

7. **WHY BINARY EXPONENTIATION?**

   - **Efficiency**: Instead of multiplying `x` by itself `n` times, we only do about **log2(n)** squarings and a few conditional multiplies.
   - 🏎️ Analogy: Climbing a mountain by **switchbacks** (squarings) and short **spurs** (conditional multiplies), rather than going straight up.

---

8. **FIXED-POINT SCALING & ROUNDING**

   - Every multiply makes numbers **b-times larger** in scale; dividing by `b` (with `+half`) returns to the **original scale** and rounds **half up**.
   - 🧯 Analogy: After each paint mix, you **relabel** the bucket to the standard unit and smooth out rounding errors with a fair “half-scoop” rule.

---

9. **SAFETY CHECKS (Assembly Guards)**

   - **Overflow checks** on each multiply (`xx / x == x`, `zx / x == z`).
   - **Rounding overflow checks** (`xxRound >= xx`, `zxRound >= zx`).
   - **Reverts** immediately if anything goes wrong.
   - 🛡️ Analogy: Every step has a **pressure gauge** and a **spill sensor**; if anything looks unsafe, the line **shuts down**.

---

10. **EDGE-CASE SUMMARY**

    - `0^0` returns **1.0** in fixed-point → `z = b`.
    - `0^n (n>0)` returns **0**.
    - For `x>0`, start `z` as **1.0** if `n` even, or as **x** if `n` odd.
    - 💡 Analogy: Choose the **right starting brick** based on the first **blueprint bit** (odd/even).

---

11. **END**
