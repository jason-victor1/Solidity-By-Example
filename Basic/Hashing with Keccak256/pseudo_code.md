#### 1. **START**

---

#### 2. **DEFINE** a contract named `HashFunction`

   ##### a. **DEFINE** a function named `hash`:
   - **Purpose**: Generate a hash using `keccak256` from multiple inputs.
   - **Details**:
      1. MARK the function as `public` and `pure`.
      2. ACCEPT three parameters:
         - `_text` (string): A dynamic string input.
         - `_num` (unsigned integer): A numeric input.
         - `_addr` (address): An Ethereum address input.
      3. LOGIC:
         - Combine `_text`, `_num`, and `_addr` into a single byte array using `abi.encodePacked`.
         - Hash the byte array using `keccak256`.
      4. RETURN the resulting hash (`bytes32`).

   ##### b. **DEFINE** a function named `collision`:
   - **Purpose**: Demonstrate potential hash collisions with `abi.encodePacked`.
   - **Details**:
      1. MARK the function as `public` and `pure`.
      2. ACCEPT two parameters:
         - `_text` (string): First dynamic string input.
         - `_anotherText` (string): Second dynamic string input.
      3. LOGIC:
         - Combine `_text` and `_anotherText` into a single byte array using `abi.encodePacked`.
         - Hash the byte array using `keccak256`.
      4. RETURN the resulting hash (`bytes32`).
      5. **Warning**:
         - Hash collisions may occur due to ambiguous concatenation of inputs.
         - Example:
           - `"AAA", "BBB"` produces `"AAABBB"`.
           - `"AA", "ABBB"` also produces `"AAABBB"`.

---

#### 3. **DEFINE** a contract named `GuessTheMagicWord`

   ##### a. **DECLARE** a public state variable `answer`:
   - **Purpose**: Store the precomputed hash of the magic word `"Solidity"`.
   - **Details**:
      1. VARIABLE TYPE: `bytes32`.
      2. VALUE: `0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00`.

   ##### b. **DEFINE** a function named `guess`:
   - **Purpose**: Allow users to guess the magic word by comparing hashes.
   - **Details**:
      1. MARK the function as `public` and `view`.
      2. ACCEPT one parameter:
         - `_word` (string): The guessed word input.
      3. LOGIC:
         - Hash `_word` using `keccak256` with `abi.encodePacked`.
         - Compare the computed hash with the stored `answer`.
      4. RETURN:
         - `true` if the hashes match.
         - `false` otherwise.

---

#### 4. **END**

