1. START

2. DEFINE a contract named `Todos`

3. DECLARE state variables (stored on the blockchain):
   a. `todos` - a public dynamic array of structs `Todo`
      i. Each `Todo` contains:
         - `text` - a string to store the task description
         - `completed` - a boolean to store the completion status of the task

4. DEFINE a function `create`
   a. MARK function as public
   b. ACCEPT a parameter `_text` of type `string`
   c. PUSH a new `Todo` struct into the `todos` array with:
      i. `text` = `_text`
      ii. `completed` = `false`

5. DEFINE a function `get`
   a. MARK function as public and view
   b. ACCEPT a parameter `_index` of type `uint256`
   c. RETURN:
      i. `text` - the task description of the `Todo` at `_index`
      ii. `completed` - the completion status of the `Todo` at `_index`

6. DEFINE a function `updateText`
   a. MARK function as public
   b. ACCEPT parameters `_index` of type `uint256` and `_text` of type `string`
   c. ACCESS the `Todo` at `_index` in the `todos` array
   d. UPDATE the `text` field of the `Todo` to `_text`

7. DEFINE a function `toggleCompleted`
   a. MARK function as public
   b. ACCEPT a parameter `_index` of type `uint256`
   c. ACCESS the `Todo` at `_index` in the `todos` array
   d. TOGGLE the `completed` field of the `Todo`:
      i. IF `completed` is `true`, set it to `false`
      ii. ELSE, set it to `true`

8. DEFINE a function `getTodosLength`
   a. MARK function as public and view
   b. RETURN the length of the `todos` array (number of tasks)

9. END
