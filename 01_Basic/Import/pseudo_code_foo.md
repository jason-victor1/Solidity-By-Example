1. 🏗️ START setting up foundational elements: a struct, a global error, a global function, and a minimal contract.

2. 🧱 DEFINE a `struct` called **Point**
   // Think of this as a 2D coordinate with horizontal (x) and vertical (y) values.

   a. 🧮 DECLARE `x` → uint256
   // The x-coordinate.

   b. 🧮 DECLARE `y` → uint256
   // The y-coordinate.

3. 🚫 DEFINE a custom global error called **Unauthorized(address caller)**
   // Used to revert a transaction when a user is not allowed to perform an action.

4. ➕ DEFINE a **free function** called `add(uint256 x, uint256 y)` → pure → returns uint256
   // This is a basic calculator function that adds two numbers.

   a. 🔁 RETURN `x + y`
   // Outputs the sum of `x` and `y`.

5. 🏷️ DEFINE a contract called **Foo**
   // A simple contract with a public name label.

   a. 🏷️ DECLARE public variable `name` → string = "Foo"
   // The name is fixed and visible to everyone.

6. 🏁 END setup for the utility function, error, struct, and minimal contract.
