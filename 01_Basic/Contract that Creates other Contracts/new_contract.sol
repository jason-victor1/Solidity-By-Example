// SPDX-License-Identifier: MIT
// 🪪 License declaration—this contract is released under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version declaration to ensure consistent and predictable behavior.

contract Car {
// 🚗 A contract that represents a car with an owner, model name, and its own address.

    address public owner;
    // 👤 Stores the address of the car owner.

    string public model;
    // 🏷️ Stores the model name of the car.

    address public carAddr;
    // 🏠 Stores the address of this contract instance (Car's own address).

    constructor(address _owner, string memory _model) payable {
        // 🧱 Initializes the car contract with owner and model, and allows ETH funding.

        owner = _owner;
        // 🧾 Sets the car owner.

        model = _model;
        // 🏷️ Sets the car model.

        carAddr = address(this);
        // 📍 Stores the contract’s own address in `carAddr`.
    }
}

contract CarFactory {
// 🏭 A factory contract that deploys Car contracts using various methods.

    Car[] public cars;
    // 📦 Stores a list of all deployed Car contracts.

    function create(address _owner, string memory _model) public {
        // 🛠️ Deploys a new Car contract without sending ETH.

        Car car = new Car(_owner, _model);
        // 🚗 Creates a new Car instance using standard `create`.

        cars.push(car);
        // 📥 Stores the new Car in the `cars` array.
    }

    function createAndSendEther(address _owner, string memory _model)
        public
        payable
    {
        // 💸 Deploys a new Car contract and sends ETH along with it.

        Car car = (new Car){value: msg.value}(_owner, _model);
        // 🚗 Creates a new Car instance and funds it with ETH.

        cars.push(car);
        // 📥 Adds the car to the factory’s tracking list.
    }

    function create2(address _owner, string memory _model, bytes32 _salt)
        public
    {
        // 🧂 Deploys a Car contract using the CREATE2 opcode for deterministic addressing.

        Car car = (new Car){salt: _salt}(_owner, _model);
        // 🚗 Creates a Car contract at a predictable address using `_salt`.

        cars.push(car);
        // 📥 Adds it to the list of deployed cars.
    }

    function create2AndSendEther(
        address _owner,
        string memory _model,
        bytes32 _salt
    ) public payable {
        // 🧂💸 Deploys a Car contract deterministically and sends ETH along with it.

        Car car = (new Car){value: msg.value, salt: _salt}(_owner, _model);
        // 🚗 Creates and funds the Car using CREATE2 and attached ETH.

        cars.push(car);
        // 📥 Saves the new contract instance.
    }

    function getCar(uint256 _index)
        public
        view
        returns (
            address owner,
            string memory model,
            address carAddr,
            uint256 balance
        )
    {
        // 🔍 Retrieves details about a specific Car instance from the factory.

        Car car = cars[_index];
        // 📦 Loads the Car contract at the given index.

        return (car.owner(), car.model(), car.carAddr(), address(car).balance);
        // 📤 Returns owner, model, address, and balance of the selected car.
    }
}