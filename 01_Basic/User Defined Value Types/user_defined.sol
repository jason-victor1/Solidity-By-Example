// SPDX-License-Identifier: MIT
// 🪪 Declares the contract as open-source under the MIT License.

pragma solidity ^0.8.26;
// 🛠️ Uses Solidity version 0.8.26 or later.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @notice 📄 Code adapted from Optimism repository:  
/// https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts-bedrock/src/dispute/lib/LibUDT.sol

/// @title User Defined Types for Time Tracking
/// @dev These `type` definitions and `LibClock` library help pack & unpack duration and timestamp into a single 128-bit `Clock` value.
/// Think of it like putting both the start time and the duration into a single 🗓️ calendar event.

/// @notice ⏳ Duration — how long something takes
type Duration is uint64;

/// @notice 🕒 Timestamp — when something starts
type Timestamp is uint64;

/// @notice 🗓️ Clock — combines duration and timestamp in one packed variable
type Clock is uint128;

/// @title Library for working with `Clock`
/// @notice 📦 Utility to pack (`wrap`) and unpack (`duration`, `timestamp`) a `Clock`
library LibClock {
    /// @notice Combines a `Duration` and a `Timestamp` into a single `Clock`.
    /// @param _duration ⏳ How long the event lasts.
    /// @param _timestamp 🕒 When the event starts.
    /// @return clock_ 🗓️ Combined `Clock` representing both.
    function wrap(Duration _duration, Timestamp _timestamp)
        internal
        pure
        returns (Clock clock_)
    {
        assembly {
            // 🧰 Pack into one number:
            // [ 64 bits duration | 64 bits timestamp ]
            clock_ := or(shl(0x40, _duration), _timestamp)
        }
    }

    /// @notice Extracts the ⏳ `Duration` from a packed `Clock`.
    /// @param _clock 🗓️ Packed clock.
    /// @return duration_ ⏳ Duration.
    function duration(Clock _clock)
        internal
        pure
        returns (Duration duration_)
    {
        assembly {
            // 👓 Shift right 64 bits to isolate duration
            duration_ := shr(0x40, _clock)
        }
    }

    /// @notice Extracts the 🕒 `Timestamp` from a packed `Clock`.
    /// @param _clock 🗓️ Packed clock.
    /// @return timestamp_ 🕒 Timestamp.
    function timestamp(Clock _clock)
        internal
        pure
        returns (Timestamp timestamp_)
    {
        assembly {
            // 👓 Mask out everything except the lowest 64 bits
            timestamp_ := shr(0xC0, shl(0xC0, _clock))
        }
    }
}

/// @title Simpler Clock Library (No User Defined Types)
/// @notice 🎒 Works with raw `uint64` instead of `Duration` and `Timestamp`
library LibClockBasic {
    /// @notice Combines `duration` and `timestamp` into `uint128`.
    /// @param _duration ⏳
    /// @param _timestamp 🕒
    /// @return clock 🗓️
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

/// @title Example Contract to Demonstrate Clock Usage
/// @notice 📚 Examples with and without user-defined value types
contract Examples {
    /// @notice Example without User Defined Value Types
    /// @dev Uses plain `uint64` and `uint128`, more error-prone.
    function example_no_uvdt() external view {
        uint128 clock;
        uint64 d = 1;
        uint64 t = uint64(block.timestamp);

        // ✅ Packs correctly
        clock = LibClockBasic.wrap(d, t);

        // 🚨 But you can accidentally swap the inputs and it still compiles
        clock = LibClockBasic.wrap(t, d); 
    }

    /// @notice Example with User Defined Value Types
    /// @dev Safer and clearer by explicitly using `Duration` and `Timestamp`.
    function example_uvdt() external view {
        // Wrap raw values into meaningful types
        Duration d = Duration.wrap(1);
        Timestamp t = Timestamp.wrap(uint64(block.timestamp));

        // Unwrap to primitive types if needed
        uint64 d_u64 = Duration.unwrap(d);
        uint64 t_u64 = Timestamp.unwrap(t);

        // ✅ Pack safely into a `Clock`
        Clock clock = Clock.wrap(0); // initialize
        clock = LibClock.wrap(d, t);

        // 🚨 Swapping the order of inputs is not allowed & won't compile
        // clock = LibClock.wrap(t, d);
    }
}
