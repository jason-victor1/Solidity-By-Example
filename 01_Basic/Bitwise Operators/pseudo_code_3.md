### 🧠 Pseudocode: Most Significant Bit Finder Using Assembly

```
Define contract MostSignificantBitAssembly:

    Function mostSignificantBit(x):
        Initialize variable msb to 0

        // 🧱 Perform a series of binary range checks using inline assembly.
        // Each check compares x against a power-of-two boundary and right-shifts x if true,
        // while tracking the shift amount in msb using binary search logic.

        // Step 1: Check if x ≥ 2^128
        IF x > 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:
            Shift x right by 128 bits
            Set bit 7 (msb += 128)

        // Step 2: Check if x ≥ 2^64
        IF x > 0xFFFFFFFFFFFFFFFF:
            Shift x right by 64 bits
            Set bit 6 (msb += 64)

        // Step 3: Check if x ≥ 2^32
        IF x > 0xFFFFFFFF:
            Shift x right by 32 bits
            Set bit 5 (msb += 32)

        // Step 4: Check if x ≥ 2^16
        IF x > 0xFFFF:
            Shift x right by 16 bits
            Set bit 4 (msb += 16)

        // Step 5: Check if x ≥ 2^8
        IF x > 0xFF:
            Shift x right by 8 bits
            Set bit 3 (msb += 8)

        // Step 6: Check if x ≥ 2^4
        IF x > 0xF:
            Shift x right by 4 bits
            Set bit 2 (msb += 4)

        // Step 7: Check if x ≥ 2^2
        IF x > 0x3:
            Shift x right by 2 bits
            Set bit 1 (msb += 2)

        // Step 8: Check if x ≥ 2^1
        IF x > 0x1:
            Set bit 0 (msb += 1)

        Return msb
```

---

### ⚙️ Key Notes:

- This implementation performs a **binary search-style MSB discovery** using **low-level Yul assembly**, improving gas efficiency.
- `shl(n, condition)` is a clever trick: if `condition` is true (1), it left-shifts 1 by `n` bits, e.g., `shl(7, 1)` = `2^7 = 128`, and `or` adds it to the total.
- The result is a **high-performance MSB function** that avoids branching or loops and runs close to hardware.
