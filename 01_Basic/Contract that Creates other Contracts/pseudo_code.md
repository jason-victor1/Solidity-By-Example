1. 🏗️ START building a factory system that creates individual "Car" contracts using different deployment methods.

2. 🏷️ DEFINE a contract called **"Car"**
   // A standalone vehicle record storing its owner, model, and its own address.

   a. 🧾 DECLARE public variable `owner` → address
   // Stores who owns this car.

   b. 🚗 DECLARE public variable `model` → string
   // Stores the car’s model name.

   c. 🏠 DECLARE public variable `carAddr` → address
   // Records the contract’s own address.

   d. 🔧 DEFINE constructor **Car(address \_owner, string \_model)** → payable
   i. SET `owner = _owner`
   // Assigns the car to its owner.
   ii. SET `model = _model`
   // Labels the car with a model name.
   iii. SET `carAddr = address(this)`
   // Saves the address of this deployed car contract.

3. 🏭 DEFINE a contract called **"CarFactory"**
   // A factory that builds and stores deployed cars using different mechanisms.

   a. 📦 DECLARE dynamic array `cars` of type `Car[]`
   // Keeps a list of all deployed car contracts.

   b. 🛠️ DEFINE function **create(address \_owner, string \_model)** → public
   i. DEPLOY a new **Car** using `new Car(_owner, _model)`
   // Creates a car using standard deployment.
   ii. PUSH the new car into `cars` array

   c. 💸 DEFINE function **createAndSendEther(address \_owner, string \_model)** → public & payable
   i. DEPLOY a new **Car** using `new Car{value: msg.value}(_owner, _model)`
   // Sends ETH while deploying the car.
   ii. PUSH the new car into `cars`

   d. 🧂 DEFINE function **create2(address \_owner, string \_model, bytes32 \_salt)** → public
   i. DEPLOY a new **Car** using `new Car{salt: _salt}(_owner, _model)`
   // Deploys the car using deterministic address via `CREATE2`.
   ii. PUSH the car into `cars`

   e. 🧂💸 DEFINE function **create2AndSendEther(address \_owner, string \_model, bytes32 \_salt)** → public & payable
   i. DEPLOY new **Car** using `new Car{value: msg.value, salt: _salt}(_owner, _model)`
   // Combines ETH funding with deterministic deployment.
   ii. PUSH the new car into `cars`

   f. 🔍 DEFINE function **getCar(uint \_index)** → public view
   → returns `(owner, model, carAddr, balance)`
   i. LOOK UP the car at `cars[_index]`
   ii. RETURN car's owner, model, self-address, and balance
   // Reveals key data about the specific deployed car contract.

4. 🏁 END setup for the car deployment factory using `create`, `create2`, and ETH-funding methods.
