### 🏗️ START: Define Utility Libraries and Test Contracts

---

### 🧮 DEFINE a `library` called **Math**

> A lightweight math utility library with a square root function using the Babylonian method.

#### 1. ➕ DEFINE a function `sqrt(uint256 y)` → `pure` → `returns (uint256 z)`

> Computes the integer square root of `y` using an iterative approximation method.

##### a. ❓ IF `y > 3`

- ⛏️ SET `z = y`
- 📐 INITIALIZE `x = y / 2 + 1`
- 🔁 WHILE `x < z`:

  - 🧮 `z = x`
  - 🧮 `x = (y / x + x) / 2`
  - // This is the Babylonian method for finding square roots

##### b. ❓ ELSE IF `y != 0`

- 🧮 SET `z = 1`
- // If `y` is 1, 2, or 3, return 1

##### c. ❓ ELSE (i.e., `y == 0`)

- 🧮 `z = 0` (implicitly, default value)

---

### 🧪 DEFINE a contract called **TestMath**

> A contract that uses the `Math` library to test square root calculations.

#### 2. 🧪 DEFINE function `testSquareRoot(uint256 x)` → `pure` → returns `uint256`

- 🧪 CALL `Math.sqrt(x)`
- 🔁 RETURN the result

---

### 📦 DEFINE a `library` called **Array**

> A storage utility library to remove elements from a dynamic `uint256[]` array.

#### 3. ➖ DEFINE function `remove(uint256[] storage arr, uint256 index)` → `public`

> Efficiently removes an element from an array by replacing it with the last item.

##### a. 🛑 REQUIRE `arr.length > 0`

- // Prevents underflow if array is empty

##### b. 🧳 REPLACE `arr[index]` with `arr[arr.length - 1]`

- // Swap the element to delete with the last one

##### c. ✂️ REMOVE the last element using `arr.pop()`

---

### 🧪 DEFINE contract called **TestArray**

> A test contract that demonstrates usage of `Array.remove()` to manipulate arrays.

#### 4. 🧰 ACTIVATE `using Array for uint256[]`

> Enables dot notation on `arr` for custom library functions.

#### 5. 🗃️ DECLARE `uint256[] public arr`

> Storage for test array

#### 6. 🧪 DEFINE function `testArrayRemove()` → `public`

> Populates an array, removes an element, and asserts correctness.

##### a. 🔁 LOOP from `i = 0` to `i < 3`

- ➕ PUSH `i` to `arr` → arr becomes `[0, 1, 2]`

##### b. ❌ CALL `arr.remove(1)`

- Removes the value `1` by swapping with `2` and popping the end
- Resulting array: `[0, 2]`

##### c. ✅ ASSERT `arr.length == 2`

##### d. ✅ ASSERT `arr[0] == 0`

##### e. ✅ ASSERT `arr[1] == 2`

---

### 🏁 END of Pseudocode Summary for `Math`, `Array`, and Their Test Contracts
