1. **START**

2. **DEFINE** a contract named `ArrayReplaceFromEnd`
   a. **DECLARE** a dynamic array `arr` of unsigned integers.

   b. **DEFINE** a function `remove` that:
   i. ACCEPTS an unsigned integer `index` as input.
   ii. ASSIGN the element at `arr[index]` to be equal to the last element in `arr` (i.e., `arr[arr.length - 1]`).
   iii. CALL the `pop()` method on `arr` to remove the last element (thus reducing the array length by 1).

   c. **DEFINE** a function `test` that:
   i. INITIALIZE `arr` with the values `[1, 2, 3, 4]`.
   ii. CALL `remove(1)` to remove the element at index 1. - AFTER removal, EXPECT `arr` to become `[1, 4, 3]`. - ASSERT that: - The length of `arr` is 3. - `arr[0]` equals `1`. - `arr[1]` equals `4`. - `arr[2]` equals `3`.
   iii. CALL `remove(2)` to remove the element at index 2 (from the current array `[1, 4, 3]`). - AFTER removal, EXPECT `arr` to become `[1, 4]`. - ASSERT that: - The length of `arr` is 2. - `arr[0]` equals `1`. - `arr[1]` equals `4`.

3. **END**
