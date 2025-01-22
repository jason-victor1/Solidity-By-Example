#### 1. **START**

---

#### 2. **IMPORT** the `Foo.sol` contract

   a. IMPORT the entire contract `Foo` from the current directory.
   b. IMPORT specific symbols from `Foo.sol`:
      - `Unauthorized` (custom error).
      - `add` (function) with alias `func`.
      - `Point` (struct).

---

#### 3. **DEFINE** a contract named `Import`

   ##### a. **DECLARE** a public state variable:
   - `foo`: An instance of the `Foo` contract.
   - INITIALIZE `foo` as a new instance of `Foo` during deployment.

   ##### b. **DEFINE** a function named `getFooName`:
   - **Purpose**: Retrieve the `name` variable from the `Foo` contract.
   - MARK the function as `public` and `view`.
   - RETURN the value of `name` by calling `foo.name()`.

---

#### 4. **END**

