1. START

2. DEFINE a contract named `Counter`
   a. DECLARE a public unsigned integer variable `count` initialized to 0 (default)

3. DEFINE a function `get`
   a. MARK function as public and view
   b. RETURNS the current value of `count`

4. DEFINE a function `inc`
   a. MARK function as public
   b. INCREMENT the value of `count` by 1

5. DEFINE a function `dec`
   a. MARK function as public
   b. DECREMENT the value of `count` by 1
      i. NOTE: This function will fail if `count` is 0 (underflow check applies in Solidity 0.8.x and later)

6. END
