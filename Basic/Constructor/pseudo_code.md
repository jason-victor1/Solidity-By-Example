1. START

2. DEFINE a contract named `X`
   a. DECLARE a public string variable `name`
   b. DEFINE a constructor
      i. TAKE `input_name` as a parameter
      ii. ASSIGN `input_name` to `name`

3. DEFINE a contract named `Y`
   a. DECLARE a public string variable `text`
   b. DEFINE a constructor
      i. TAKE `input_text` as a parameter
      ii. ASSIGN `input_text` to `text`

4. DEFINE a contract named `B` that inherits `X` and `Y`
   a. PASS fixed parameters `"Input to X"` to `X` and `"Input to Y"` to `Y` in the inheritance list
   b. NOTE: Parent constructors are automatically called with the provided parameters

5. DEFINE a contract named `C` that inherits `X` and `Y`
   a. DEFINE a constructor
      i. TAKE `input_name` and `input_text` as parameters
      ii. PASS `input_name` to `X`'s constructor
      iii. PASS `input_text` to `Y`'s constructor
   b. NOTE: Allows dynamic initialization at deployment

6. DEFINE a contract named `D` that inherits `X` and `Y`
   a. DEFINE a constructor
      i. PASS fixed parameter `"X was called"` to `X`'s constructor
      ii. PASS fixed parameter `"Y was called"` to `Y`'s constructor
   b. NOTE: Parent constructors are executed in the order of inheritance (X, then Y)

7. DEFINE a contract named `E` that inherits `X` and `Y`
   a. DEFINE a constructor
      i. PASS fixed parameter `"Y was called"` to `Y`'s constructor
      ii. PASS fixed parameter `"X was called"` to `X`'s constructor
   b. NOTE: Despite the order in the constructor, parent constructors are still executed in the order of inheritance (X, then Y)

8. END
