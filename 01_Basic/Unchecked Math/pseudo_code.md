### 🏗️ Contract Overview

**Purpose:**
Demonstrates how `unchecked` blocks can reduce gas costs by disabling Solidity's default overflow/underflow protection during arithmetic operations.

---

### 🧱 Function: `add(x, y)`

```text
Function: add(x, y)
Input: Two unsigned integers x and y
Output: The result of x + y

Steps:
1. Begin unchecked block (disable overflow checks)
2. Compute sum = x + y
3. Return sum
```

---

### 🧱 Function: `sub(x, y)`

```text
Function: sub(x, y)
Input: Two unsigned integers x and y
Output: The result of x - y

Steps:
1. Begin unchecked block (disable underflow checks)
2. Compute difference = x - y
3. Return difference
```

---

### 🧱 Function: `sumOfCubes(x, y)`

```text
Function: sumOfCubes(x, y)
Input: Two unsigned integers x and y
Output: The sum of the cubes of x and y

Steps:
1. Begin unchecked block
2. Compute x³ = x * x * x
3. Compute y³ = y * y * y
4. Compute result = x³ + y³
5. Return result
```

---

### 🚫 Safety Notes

- Arithmetic inside `unchecked` blocks can **overflow or underflow silently**.
- Use only when you're confident that the input values won't cause overflow/underflow, or when wrapping is intentional.
