1. 🏗️ START setting up a digital task board for personal or shared to-do tracking.

2. 🏷️ DEFINE a contract named "Todos"
   // This is like creating a virtual workspace where tasks can be added, viewed, and marked complete.

3. 🗂️ DECLARE state variables:
   a. "todos" - a public dynamic list of "Todo" task cards
   i. Each task card includes: - 📝 `text` – the description of the task (like writing "Buy groceries") - ✅ `completed` – a checkbox to track if the task is done or not

4. 🆕 DEFINE a function "create":
   a. 🔓 Publicly accessible
   b. 📥 Accepts a string `_text` for the task description
   c. ➕ Adds a new task card (`Todo`) to the board with:

   - `text` = `_text`
   - `completed` = `false` (the checkbox is initially unchecked)

5. 🔍 DEFINE a function "get":
   a. 🔓 Public and view-only (read-only)
   b. 📥 Accepts an index `_index` to look up a specific task
   c. 📦 Returns:

   - The task text (`text`)
   - The checkbox status (`completed`)

6. ✏️ DEFINE a function "updateText":
   a. 🔓 Public
   b. 📥 Accepts:

   - `_index` – which task to update
   - `_text` – the new description
     c. 📝 Access the specified task card
     d. ✍️ Update its `text` to the new message

7. 🔁 DEFINE a function "toggleCompleted":
   a. 🔓 Public
   b. 📥 Accepts the task index (`_index`)
   c. ☑️ Access the task card
   d. 🔄 Flip the checkbox:

   - If it's checked (`true`), uncheck it (`false`)
   - If it's unchecked, check it

8. 📊 DEFINE a function "getTodosLength":
   a. 🔓 Public and view-only
   b. 🔢 Returns the number of tasks on the board (length of `todos` array)

9. 🏁 END the setup for this interactive task board
