
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title GasGolf
/// @notice Demonstrates progressive gas optimization techniques in Solidity through a single function
contract GasGolf {
    /*
        🧪 Optimization Trail:
        - Initial implementation:                        ~50908 gas
        - Use calldata (avoid memory copy):             ~49163 gas
        - Cache state variable (total) in memory:       ~48952 gas
        - Use short-circuit logic in condition:         ~48634 gas
        - Use prefix increment (++i instead of i+=1):   ~48244 gas
        - Cache array length in memory:                 ~48209 gas
        - Cache array elements in memory:               ~48047 gas
        - Use unchecked for loop counter:               ~47309 gas
    */

    /// @notice Cumulative total of valid numbers from all invocations
    uint256 public total;

    /*
    // 🔴 Initial (Unoptimized) Version for Reference
    function sumIfEvenAndLessThan99(uint[] memory nums) external {
        for (uint i = 0; i < nums.length; i += 1) {
            bool isEven = nums[i] % 2 == 0;
            bool isLessThan99 = nums[i] < 99;
            if (isEven && isLessThan99) {
                total += nums[i];
            }
        }
    }
    */

    /// @notice Adds only even numbers less than 99 from input array to the `total`
    /// @param nums The input array of unsigned integers (read-only via calldata)
    function sumIfEvenAndLessThan99(uint256[] calldata nums) external {
        // ✅ Cache state variable `total` into local variable `_total` to reduce SLOAD cost
        uint256 _total = total;

        // ✅ Cache array length to avoid repeated reads of `nums.length`
        uint256 len = nums.length;

        // ✅ Loop through the array with maximum gas efficiency
        for (uint256 i = 0; i < len;) {
            // ✅ Load current element into memory just once per iteration
            uint256 num = nums[i];

            // ✅ Short-circuit condition: checks evenness and bound in one expression
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }

            // ✅ Use unchecked block to skip overflow check for loop counter
            unchecked {
                ++i; // ++i is slightly cheaper than i += 1
            }
        }

        // ✅ Store final total back to state
        total = _total;
    }
}
