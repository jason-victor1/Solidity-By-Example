1. **START**

2. **DEFINE** a contract named `ArrayRemoveByShifting`
   a. **DECLARE** a dynamic array `arr` of unsigned integers.

   b. **DEFINE** a function `remove` that:
   i. ACCEPTS an unsigned integer `_index` as input.
   ii. **CHECK:** IF `_index` is NOT less than the length of `arr`, THROW an error "index out of bounds".
   iii. **LOOP:** For each index `i` from `_index` to `arr.length - 2` (i.e., while `i < arr.length - 1`): - ASSIGN `arr[i] = arr[i + 1]` (shift the next element into the current slot).
   iv. CALL `pop()` on `arr` to remove the last (now duplicate) element.

   c. **DEFINE** a function `test` that:
   i. INITIALIZE `arr` with `[1, 2, 3, 4, 5]`.
   ii. CALL `remove(2)` to remove the element at index 2. - EXPECT `arr` becomes `[1, 2, 4, 5]`.
   iii. ASSERT that: - `arr[0]` equals `1`. - `arr[1]` equals `2`. - `arr[2]` equals `4`. - `arr[3]` equals `5`. - `arr.length` equals `4`.
   iv. REINITIALIZE `arr` with `[1]`.
   v. CALL `remove(0)` to remove the element at index 0. - EXPECT `arr` becomes an empty array `[]`.
   vi. ASSERT that `arr.length` equals `0`.

3. **END**
