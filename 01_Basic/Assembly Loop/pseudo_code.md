### 🧠 **Pseudocode with Analogies for AssemblyLoop**

---

1. **START**

2. **DEFINE** a contract named `AssemblyLoop`

   - A simple factory that uses low-level **Yul (assembly)** to demonstrate loops like `for` and `while`
   - Think of this as a mini counter machine that counts operations manually

3. **DEFINE** a function `yul_for_loop`
   a. MARK it as `public` and `pure` (does not read or write blockchain state)
   b. IMPLEMENT a `for` loop in assembly:

   - **INITIALIZE** a counter `i = 0`
   - **CONDITION:** Continue as long as `i < 10`
   - **INCREMENT:** After each iteration, add 1 to `i`
   - **BODY:** For each cycle, add 1 to `z` (a running total)
   - **🧮 Analogy:** Like a child counting fingers from 0 to 9 — each time they count, they add one candy 🍬 to a jar (`z`)

4. **DEFINE** a function `yul_while_loop`
   a. MARK it as `public` and `pure`
   b. IMPLEMENT a loop resembling `while` using Yul’s flexible `for` structure:

   - **DECLARE** a counter `i = 0`
   - **CONDITION:** Keep looping as long as `i < 5`
   - **NO INIT/POST actions outside body** — do everything manually inside loop
   - **BODY:** Increment `i` and increment `z` on each pass
   - **🧮 Analogy:** Like stirring a pot 5 times — each stir increases the count (`z`) 🥄🥄🥄🥄🥄

5. **END**
