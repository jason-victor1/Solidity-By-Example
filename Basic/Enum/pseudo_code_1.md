1. **START**

2. **DEFINE** a contract named `Enum`:
   a. **DEFINE** an enum `Status` with the following possible values:
   i. Pending  
    ii. Shipped  
    iii. Accepted  
    iv. Rejected  
    v. Canceled

   b. **DECLARE** a public state variable `status` of type `Status`

   - **NOTE:** By default, `status` is set to `Pending` (the first element).

   c. **DEFINE** a function `get` that:
   i. IS marked as public and view  
    ii. RETURNS the current value of `status`

   d. **DEFINE** a function `set` that:
   i. ACCEPTS an input parameter `_status` of type `Status`  
    ii. SETS the state variable `status` to `_status`

   e. **DEFINE** a function `cancel` that:
   i. SETS the state variable `status` to `Canceled`

   f. **DEFINE** a function `reset` that:
   i. USES the `delete` operation to reset `status` to its default value (`Pending`)

3. **END**
