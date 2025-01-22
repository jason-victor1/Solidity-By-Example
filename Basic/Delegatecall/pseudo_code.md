#### 1. START

---

#### 2. DEFINE a contract named `B`

   a. DECLARE variables:
      - `num` (unsigned integer, public): To store a number.
      - `sender` (address, public): To store the caller's address.
      - `value` (unsigned integer, public): To store the Ether sent.

   b. DEFINE a function `setVars`:
      i. MARK the function as `public` and `payable`.
      ii. ACCEPT one parameter:
         - `_num` (unsigned integer): The value to update `num`.
      iii. FUNCTION LOGIC:
         - SET `num` to `_num`.
         - SET `sender` to the caller's address (`msg.sender`).
         - SET `value` to the Ether sent (`msg.value`).

---

#### 3. DEFINE a contract named `A`

---

   ##### a. DECLARE variables:
      - `num` (unsigned integer, public): To store a number.
      - `sender` (address, public): To store the caller's address.
      - `value` (unsigned integer, public): To store the Ether sent.

   ##### b. DEFINE events:
      - **`DelegateResponse`**:
        i. PARAMETERS:
           - `success` (boolean): Indicates the result of the `delegatecall`.
           - `data` (bytes): Logs any returned data from the `delegatecall`.

      - **`CallResponse`**:
        i. PARAMETERS:
           - `success` (boolean): Indicates the result of the `call`.
           - `data` (bytes): Logs any returned data from the `call`.

---

   ##### c. DEFINE a function `setVarsDelegateCall`:
      i. MARK the function as `public` and `payable`.
      ii. ACCEPT parameters:
         - `contractAddress` (address): The target contract's address.
         - `_num` (unsigned integer): The value to pass to the target contract.
      iii. FUNCTION LOGIC:
         - PERFORM a `delegatecall` to the `setVars` function in the target contract.
         - USE `abi.encodeWithSignature` to encode the function signature and arguments.
         - STORE the result in:
            - `success` (boolean): Indicates if the `delegatecall` succeeded.
            - `data` (bytes): Stores any data returned.
         - EMIT the `DelegateResponse` event with `success` and `data`.

---

   ##### d. DEFINE a function `setVarsCall`:
      i. MARK the function as `public` and `payable`.
      ii. ACCEPT parameters:
         - `contractAddress` (address): The target contract's address.
         - `_num` (unsigned integer): The value to pass to the target contract.
      iii. FUNCTION LOGIC:
         - PERFORM a `call` to the `setVars` function in the target contract.
         - FORWARD the Ether sent using `{value: msg.value}`.
         - USE `abi.encodeWithSignature` to encode the function signature and arguments.
         - STORE the result in:
            - `success` (boolean): Indicates if the `call` succeeded.
            - `data` (bytes): Stores any data returned.
         - EMIT the `CallResponse` event with `success` and `data`.

---

#### 4. END

