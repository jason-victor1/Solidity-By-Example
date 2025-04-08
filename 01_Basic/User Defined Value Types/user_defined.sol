// SPDX-License-Identifier: MIT
// 🪪 Declares the contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or later.

// ⏱️ These are custom-labeled time components (user-defined value types).
// Think of them as watch parts with labels that prevent accidental swaps.
type Duration is uint64;    // Like a timer or countdown (battery life)
type Timestamp is uint64;   // Like the moment the watch was set
type Clock is uint128;      // A packed timepiece that includes both

// 🛠️ LibClock = assembly-powered toolkit for assembling/disassembling a "Clock" from labeled parts.
library LibClock {
    // 🧩 Combines a Duration and Timestamp into a 128-bit Clock.
    // Duration occupies the high 64 bits, Timestamp the low 64 bits.
    function wrap(Duration _duration, Timestamp _timestamp)
        internal
        pure
        returns (Clock clock_)
    {
        assembly {
            // Imagine putting the Duration on the left (high bits),
            // and Timestamp on the right (low bits) of a single 128-bit box.
            clock_ := or(shl(0x40, _duration), _timestamp)
        }
    }

    // 🔍 Extracts the Duration (high 64 bits) from the packed Clock.
    function duration(Clock _clock)
        internal
        pure
        returns (Duration duration_)
    {
        assembly {
            // Shift right 64 bits to pull out the left-side (Duration)
            duration_ := shr(0x40, _clock)
        }
    }

    // 🔍 Extracts the Timestamp (low 64 bits) from the Clock.
    function timestamp(Clock _clock)
        internal
        pure
        returns (Timestamp timestamp_)
    {
        assembly {
            // Left shift to move Timestamp into position, then right shift to clean it out
            timestamp_ := shr(0xC0, shl(0xC0, _clock))
        }
    }
}

// 🛠️ LibClockBasic = Similar clock builder, but without type safety.
// No labels → easy to mess up which value is which.
library LibClockBasic {
    function wrap(uint64 _duration, uint64 _timestamp)
        internal
        pure
        returns (uint128 clock)
    {
        assembly {
            clock := or(shl(0x40, _duration), _timestamp)
        }
    }
}

// 🧪 Examples = Playground showing how type safety with UDVTs helps prevent errors.
contract Examples {
    function example_no_uvdt() external view {
        // 🛠️ Use raw values (no safety labels)
        uint128 clock;
        uint64 d = 1;
        uint64 t = uint64(block.timestamp);

        // ✅ Compiles fine...
        clock = LibClockBasic.wrap(d, t);
        // ❌ But this also compiles—even though the order is wrong!
        clock = LibClockBasic.wrap(t, d);  // Bug-prone!
    }

    function example_uvdt() external view {
        // 🔖 Wrap values with labels (type safety)
        Duration d = Duration.wrap(1);  // Clearly labeled as "duration"
        Timestamp t = Timestamp.wrap(uint64(block.timestamp));  // Clearly labeled as "timestamp"

        // 🔓 You can also unwrap to get raw numbers back
        uint64 d_u64 = Duration.unwrap(d);
        uint64 t_u64 = Timestamp.unwrap(t);

        // ✅ Assemble clock safely using labeled parts
        Clock clock = Clock.wrap(0);
        clock = LibClock.wrap(d, t);

        // ❌ This will not compile due to mismatched types (prevents a bug!)
        // clock = LibClock.wrap(t, d);
    }
}
