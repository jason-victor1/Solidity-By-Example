### 🧠 Pseudocode Breakdown for `BitwiseOps`

```
Define contract BitwiseOps:

    Function and(x, y):
        # Bitwise AND: returns only the bits that are set in both x and y
        Return x AND y

    Function or(x, y):
        # Bitwise OR: returns bits that are set in either x or y
        Return x OR y

    Function xor(x, y):
        # Bitwise XOR: returns bits that are set in x or y but not both
        Return x XOR y

    Function not(x):
        # Bitwise NOT: flips all bits of x (only works on 8-bit for safe casting)
        Return bitwise negation of x

    Function shiftLeft(x, bits):
        # Bitwise left shift: move bits of x to the left by `bits` positions
        Return x shifted left by bits

    Function shiftRight(x, bits):
        # Bitwise right shift: move bits of x to the right by `bits` positions
        Return x shifted right by bits

    Function getLastNBits(x, n):
        # Extract the last n bits from x using a bitmask
        # Create a mask of n bits set to 1 (e.g., for n=3, mask = 0b111 = 7)
        mask = (1 << n) - 1
        Return x AND mask

    Function getLastNBitsUsingMod(x, n):
        # Alternative way to get last n bits using modulo arithmetic
        # Same as x % 2^n
        Return x MODULO (1 << n)

    Function mostSignificantBit(x):
        # Determine the position of the most significant bit (MSB)
        i = 0
        WHILE x > 1:
            x = x shifted right by 1
            Increment i by 1
        Return i

    Function getFirstNBits(x, n, len):
        # Extract the first n bits from x, given total bit length `len`
        # Build a mask for top n bits (shifted into position)
        mask = ((1 << n) - 1) shifted left by (len - n)
        Return x AND mask
```

---

### 🏷️ Notes:

* Bitwise operations are low-level tools that manipulate binary representations directly.
* `&`, `|`, `^`, `~`, `<<`, and `>>` are all **bitwise** operators—not arithmetic.
* Modulo and shifting can achieve similar effects for extracting bits.
* `mostSignificantBit` is useful for compression, hashing, and gas-efficient logic.
* `getFirstNBits` assumes you know the length (`len`) ahead of time.


