// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title AssemblyBinExp
 * @notice Fixed-point binary exponentiation `z = (x^n)` with base-scaling `b` using Yul assembly.
 * @dev
 * 🧮 Real-World Analogy:
 * Think of `x` as paint measured in **scaled units** (e.g., liters-per-`b`). Every time you mix two buckets
 * (a multiplication), the amount ends up in the **wrong unit**, so you must carefully **relabel** it by
 * dividing by `b`, with a small **half-scoop** added for fair rounding.
 *
 * Why binary exponentiation?
 * - Instead of multiplying `x` by itself `n` times, we repeatedly **square** and sometimes **attach**
 *   the squared paint to our result when the current **bit** of `n` is 1. That’s like climbing a mountain
 *   via efficient **switchbacks** (squarings) with occasional **spurs** (conditional multiplies).
 *
 * Safety:
 * - Overflow checks after every multiply (pressure gauges).
 * - Rounding overflow checks when adding the half-scoop (spill sensors).
 * - Immediate **revert** if any safety check fails.
 */
contract AssemblyBinExp {
    /**
     * @notice Compute `z = (x^n)` in fixed-point arithmetic with scaling base `b`.
     * @dev
     * 🧰 Scaling & Rounding:
     * - All values are considered **scaled** by `b` (so mathematical 1 is represented as `b`).
     * - After each multiply, we re-scale by dividing by `b`.
     * - We add `half = b/2` before division to do **round half up**.
     *
     * Edge cases (handled up-front):
     * - `x == 0 && n == 0` → `z = b` (i.e., 1.0 in fixed-point)
     * - `x == 0 && n > 0` → `z = 0`
     * - For `x > 0`:
     *   - if `n` is even → start `z = b` (neutral 1.0)
     *   - if `n` is odd  → start `z = x`
     *
     * 🧯 Analogy:
     * - `b` is your **unit labeler**. Every time you mix (multiply) paint, you must re-apply the label (divide by `b`).
     * - `half = b/2` is your **half-scoop** to keep rounding fair when relabeling.
     *
     * @param x Base, in fixed-point with scale `b`. (e.g., if `b=1e18`, 1.5 is `1.5e18`)
     * @param n Exponent (non-negative integer).
     * @param b Fixed-point scale base (representation of mathematical 1).
     * @return z Result `(x^n)` in the same fixed-point scale `b`.
     */
    function rpow(uint256 x, uint256 n, uint256 b)
        public
        pure
        returns (uint256 z)
    {
        assembly {
            // Handle x == 0 early.
            switch x
            // Case: x = 0
            case 0 {
                switch n
                // 0^0 := 1 (in fixed-point → b)
                case 0 { z := b }
                // 0^n (n > 0) := 0
                default { z := 0 }
            }
            // Case: x > 0
            default {
                // Initialize z depending on parity of n:
                // if n is even → z = b (multiplicative identity under scaling)
                // if n is odd  → z = x
                switch mod(n, 2)
                    case 0 { z := b }
                    default { z := x }

                // half = b / 2, for "round half up" when dividing by b
                let half := div(b, 2)

                // Begin exponentiation by squaring:
                // We already consumed the least-significant bit of n in initialization,
                // so proceed with n = n / 2 and keep halving until n == 0.
                // for (n = n / 2; n > 0; n = n / 2)
                for { n := div(n, 2) } n { n := div(n, 2) } {
                    // Square x: xx = x * x
                    let xx := mul(x, x)

                    // Overflow check: if xx / x != x then multiplication overflowed
                    if iszero(eq(div(xx, x), x)) { revert(0, 0) }

                    // Re-scale with rounding: x = round((xx) / b)
                    // xxRound = xx + half; overflow check ensures addition didn't wrap
                    let xxRound := add(xx, half)
                    if lt(xxRound, xx) { revert(0, 0) }

                    x := div(xxRound, b)

                    // If current bit of n is 1, multiply result by the current x
                    if mod(n, 2) {
                        // zx = z * x
                        let zx := mul(z, x)

                        // Overflow guard:
                        // If x != 0 then ensure zx / x == z
                        if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) {
                            revert(0, 0)
                        }

                        // Re-scale with rounding: z = round((zx) / b)
                        let zxRound := add(zx, half)
                        if lt(zxRound, zx) { revert(0, 0) }

                        z := div(zxRound, b)
                    }
                }
            }
        }
    }
}