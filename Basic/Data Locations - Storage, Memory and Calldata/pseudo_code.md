1. **START**

2. **DEFINE** a contract named `DataLocations`
   a. **DECLARE** a public dynamic array `arr` stored in storage  
   b. **DECLARE** a mapping `map` from unsigned integers to addresses stored in storage  
   c. **DECLARE** a `struct` named `MyStruct`  
      i. CONTAINS a single unsigned integer property `foo`  
   d. **DECLARE** a mapping `myStructs` from unsigned integers to `MyStruct` instances, stored in storage  

3. **DEFINE** a function `f`
   a. MARK function as public  
   b. CALL internal function `_f` with arguments:  
      i. Storage reference to `arr`  
      ii. Storage reference to `map`  
      iii. Storage reference to `myStructs[1]`  
   c. ACCESS the `myStructs` mapping and ASSIGN its value at key `1` to a local storage variable `myStruct`  
   d. CREATE a new instance of `MyStruct` in memory named `myMemStruct` with `foo` initialized to `0`  

4. **DEFINE** an internal function `_f`
   a. MARK function as internal  
   b. ACCEPT references to:  
      i. A storage array `_arr`  
      ii. A storage mapping `_map`  
      iii. A storage struct `_myStruct`  
   c. IMPLEMENT operations with the storage variables (implementation not provided)  

5. **DEFINE** a function `g`
   a. MARK function as public  
   b. ACCEPT a dynamic array `_arr` stored in memory  
   c. RETURNS a modified memory array (implementation not provided)  

6. **DEFINE** a function `h`
   a. MARK function as external  
   b. ACCEPT a dynamic array `_arr` stored in calldata (read-only and gas-efficient)  
   c. IMPLEMENT operations with the calldata array (implementation not provided)  

7. **END**