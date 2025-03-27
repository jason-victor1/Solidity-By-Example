1. 🏗️ START constructing a digital facility (smart contract) with fixtures that get locked in during setup.

2. 🏷️ Name the facility:
   DEFINE a contract called "Immutable"
   // This structure allows some info to be assigned once—during move-in (deployment)—and then locked forever.

   a. 🔒 DECLARE a public immutable variable "myAddr" of type address
   // This will act like an engraved plaque showing who owns the building, but it’s added _after_ construction starts—not hardcoded.

   b. 🔢 DECLARE a public immutable variable "myUint" of type unsigned integer
   // This is like placing a custom label or serial number that’s fixed once it's added during move-in.

   c. 🛬 DEFINE a constructor that accepts a number `_myUint` from whoever deploys the contract
   i. 🧾 ASSIGN "myAddr" with the address of the person deploying the contract (`msg.sender`)
   // Like putting their name on the entry badge—set once at move-in and permanent.

   ii. 🧮 ASSIGN "myUint" with the provided `_myUint`
   // Like stamping a unique serial number into the blueprint at construction time.

3. 🏁 END setup of the Immutable building.
