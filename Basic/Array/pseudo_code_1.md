1. **START**

2. **DEFINE** a contract named `Array`
   a. **DECLARE** a dynamic array `arr` of unsigned integers  
   b. **DECLARE** and **INITIALIZE** a dynamic array `arr2` of unsigned integers with values `[1, 2, 3]`  
   c. **DECLARE** a fixed-size array `myFixedSizeArr` of 10 unsigned integers (all elements default to 0)

   d. **DEFINE** a function `get` that:
   i. ACCEPTS an unsigned integer `i` as input  
    ii. IS marked as public and view  
    iii. RETURNS the element at index `i` from `arr`

   e. **DEFINE** a function `getArr` that:
   i. IS marked as public and view  
    ii. RETURNS the entire dynamic array `arr` (as memory)

   f. **DEFINE** a function `push` that:
   i. ACCEPTS an unsigned integer `i` as input  
    ii. IS marked as public  
    iii. APPENDS `i` to the end of the dynamic array `arr`

   g. **DEFINE** a function `pop` that:
   i. IS marked as public  
    ii. REMOVES the last element from the dynamic array `arr`

   h. **DEFINE** a function `getLength` that:
   i. IS marked as public and view  
    ii. RETURNS the length of the dynamic array `arr`

   i. **DEFINE** a function `remove` that:
   i. ACCEPTS an unsigned integer `index` as input  
    ii. IS marked as public  
    iii. DELETES the element at `arr[index]` (resets it to the default value without changing array length)

   j. **DEFINE** a function `examples` that:
   i. IS marked as external and pure  
    ii. CREATES a new dynamic array `a` in memory of fixed size 5  
    iii. CREATES a new nested dynamic array `b` in memory that can hold 2 arrays  
    - FOR each index `i` in `b` (from 0 to 1):  
    \* INITIALIZE `b[i]` as a new dynamic array in memory with fixed size 3  
    iv. SETS the elements of the first inner array:  
    - `b[0][0] = 1`  
    - `b[0][1] = 2`  
    - `b[0][2] = 3`  
    v. SETS the elements of the second inner array:  
    - `b[1][0] = 4`  
    - `b[1][1] = 5`  
    - `b[1][2] = 6`

3. **END**
