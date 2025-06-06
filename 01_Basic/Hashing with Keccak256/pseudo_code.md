### 🔐 `HashFunction` Contract

---

1. 🏗️ START contract definition: **HashFunction**

2. 🔢 DEFINE function: `hash(string _text, uint256 _num, address _addr)` → returns `bytes32`
   // Combines multiple inputs into a single hash using `keccak256`.

   a. 📦 ENCODE `_text`, `_num`, `_addr` using `abi.encodePacked`
   b. 🔐 HASH the packed data using `keccak256`
   c. 🔁 RETURN the resulting `bytes32` hash

3. 🚨 DEFINE function: `collision(string _text, string _anotherText)` → returns `bytes32`
   // Demonstrates a potential **hash collision** using `abi.encodePacked`.

   a. ⚠️ WARNING: Passing two dynamic types (like strings) to `encodePacked` can cause **collisions**
   Example:

   - `encodePacked("AAA", "BBB") → "AAABBB"`
   - `encodePacked("AA", "ABBB") → also "AAABBB"`
     b. 📦 PACK `_text`, `_anotherText` with `abi.encodePacked`
     c. 🔐 HASH with `keccak256`
     d. 🔁 RETURN the potentially unsafe hash

4. 🏁 END contract definition

---

### 🪄 `GuessTheMagicWord` Contract

---

1. 🏗️ START contract definition: **GuessTheMagicWord**

2. 🧱 DECLARE public variable `answer` → `bytes32`
   // Precomputed hash of the word "Solidity"

3. 🔍 DEFINE function: `guess(string _word)` → view → returns `bool`
   // Checks if the user-supplied word hashes to the precomputed answer.

   a. 📦 ENCODE `_word` using `abi.encodePacked`
   b. 🔐 HASH the encoded word with `keccak256`
   c. ❓ COMPARE hash to stored `answer`
   d. 🔁 RETURN `true` if match, else `false`

4. 🏁 END contract definition
