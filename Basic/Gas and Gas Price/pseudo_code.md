1. **START**

2. **DEFINE** a contract named `Gas`

3. **DECLARE state variables** (stored on the blockchain):
   a. `i` - a public unsigned integer initialized to `0`

4. **DEFINE a function `forever`**:
   a. MARK the function as public.
   b. EXPLAIN the purpose of the function:
      i. Demonstrates gas exhaustion by running an infinite loop.
   c. START an infinite loop:
      i. INCREMENT the state variable `i` by `1` in each iteration.
   d. END the loop (this line is unreachable due to the infinite nature of the loop).

5. **EXPLAIN the behavior of the `forever` function**:
   a. IF gas is exhausted:
      i. The transaction fails.
      ii. All state changes (e.g., `i` updates) are reverted.
   b. NOTE: Gas used before the failure is not refunded.

6. **END** 
