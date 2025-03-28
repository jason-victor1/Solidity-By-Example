1. 🏗️ START building a decision-making hub (smart contract) that can respond differently based on input values.

2. 🏷️ Name the facility:
   DEFINE a contract called "IfElse"
   // Think of it as a smart checkpoint that decides what output to give based on what visitors bring (input).

   a. 🔁 DEFINE a function called "foo"
   i. 📢 MARK it as public and pure—anyone can use it, and it doesn’t read or change any permanent info.
   ii. 📥 ACCEPT an input number "x" from the visitor.
   iii. 🔁 RETURNS a number as a decision code.
   iv. 🧠 IMPLEMENT a sequence of gates: - IF x < 10 → RETURN 0  
    // Like the system saying, “Too small—send code 0.” - ELSE IF x < 20 → RETURN 1  
    // “In mid range—send code 1.” - ELSE → RETURN 2  
    // “Large input—send code 2.”

   b. ⚡ DEFINE a function called "ternary"
   i. 📢 MARK as public and pure—quick, lightweight decision tool.
   ii. 📥 ACCEPT an input number "\_x"
   iii. 🔁 RETURNS a number based on a single test
   iv. 🧠 Use a compact decision lever (ternary logic): - RETURN 1 if \_x < 10  
    // “Is the input under 10? Give 1.” - OTHERWISE RETURN 2  
    // “If not, give 2.”

3. 🏁 END setup for the IfElse decision system.
