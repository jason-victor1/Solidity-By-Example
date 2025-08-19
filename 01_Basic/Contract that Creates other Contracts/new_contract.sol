// SPDX-License-Identifier: MIT
// 🪪 License declaration—this contract is released under the MIT license.

pragma solidity ^0.8.26;
// 🛠️ Compiler version declaration to ensure consistent and predictable behavior.

contract Car {
    /**
     * @title Car
     * @dev A simple contract representing a "Car" with an owner, model, and its own address.
     *
     * 🚗 Analogy:
     * Think of each `Car` as a freshly minted vehicle:
     * - `owner` = who holds the car keys,
     * - `model` = the make/model name of the car,
     * - `carAddr` = the VIN number (the car’s unique blockchain identity).
     *
     * When the car is built (`constructor`), it registers these details.
     */

    /// @notice The current owner of the car.
    address public owner;

    /// @notice The car’s model (e.g., "Tesla", "BMW").
    string public model;

    /// @notice The unique blockchain address of this specific car contract.
    address public carAddr;

    /**
     * @notice Creates a new Car with a specified owner and model.
     * @dev `payable` means you can optionally fund the car with ether on creation.
     *
     * 🏭 Analogy:
     * This is the car factory’s assembly line:
     * - Install the owner in the driver’s seat.
     * - Paint the model name on the back.
     * - Stamp the VIN (contract address) into the logbook.
     *
     * @param _owner The address of the car’s owner.
     * @param _model The model name for the car.
     */
    constructor(address _owner, string memory _model) payable {
        owner = _owner;         // 🚘 Assign the car keys.
        model = _model;         // 🏷️ Label the car model.
        carAddr = address(this); // 🔑 Record the car’s VIN (this contract’s address).
    }
}

contract CarFactory {
    /**
     * @title Car Factory
     * @dev A factory contract that creates and manages `Car` instances.
     *
     * 🏭 Analogy:
     * This is a big car manufacturing plant:
     * - It builds new cars on demand.
     * - Stores all manufactured cars in its garage (`cars` array).
     * - Can build cars normally (`new`), with initial funding (ether), or deterministically with `create2`.
     */

    /// @notice List of all cars manufactured by this factory.
    Car[] public cars;

    /**
     * @notice Creates a new Car without sending ether.
     * @dev Uses the `new` keyword to deploy a fresh Car instance.
     *
     * 🚘 Analogy:
     * The factory builds a new car, assigns the owner + model, and parks it in the garage.
     *
     * @param _owner The new owner of the car.
     * @param _model The model name for the car.
     */
    function create(address _owner, string memory _model) public {
        Car car = new Car(_owner, _model); // 🏭 Build a new car.
        cars.push(car);                    // 🚗 Park it in the factory’s garage.
    }

    /**
     * @notice Creates a new Car and sends ether to fund it.
     * @dev `payable` allows the factory to forward ether during creation.
     *
     * 💰 Analogy:
     * The factory builds a new car, but also puts some gas money in its glovebox at delivery.
     *
     * @param _owner The new owner of the car.
     * @param _model The model name for the car.
     */
    function createAndSendEther(address _owner, string memory _model)
        public
        payable
    {
        Car car = (new Car){value: msg.value}(_owner, _model); // 🏭 Build + fund the car.
        cars.push(car);
    }

    /**
     * @notice Creates a new Car at a deterministic address using `create2`.
     * @dev `salt` allows you to predetermine the contract address before deployment.
     *
     * 🧂 Analogy:
     * Think of `salt` as a custom engraving you request on the car’s VIN.
     * With the same factory blueprint and same salt, you can predict exactly where the car will appear.
     *
     * @param _owner The new owner of the car.
     * @param _model The model name for the car.
     * @param _salt A unique salt value to deterministically fix the car’s address.
     */
    function create2(address _owner, string memory _model, bytes32 _salt)
        public
    {
        Car car = (new Car){salt: _salt}(_owner, _model); // 🔐 Predictable VIN car.
        cars.push(car);
    }

    /**
     * @notice Creates a new Car at a deterministic address using `create2` and funds it with ether.
     * @dev Combines deterministic deployment with ether forwarding.
     *
     * 🧂+💰 Analogy:
     * You engrave a VIN ahead of time with `salt`, then pay extra to deliver the car with a full tank of gas.
     *
     * @param _owner The new owner of the car.
     * @param _model The model name for the car.
     * @param _salt A unique salt value for predictable contract address.
     */
    function create2AndSendEther(
        address _owner,
        string memory _model,
        bytes32 _salt
    ) public payable {
        Car car = (new Car){value: msg.value, salt: _salt}(_owner, _model);
        cars.push(car);
    }

    /**
     * @notice Get details of a manufactured car by index.
     * @dev Returns multiple fields, including balance (any ether stored in the car).
     *
     * 📝 Analogy:
     * Look up a car in the factory’s garage logbook:
     * - Who owns it,
     * - What model it is,
     * - Its VIN (address),
     * - And how much gas money it currently has.
     *
     * @param _index Index of the car in the factory’s garage.
     * @return owner The car owner’s address.
     * @return model The car model string.
     * @return carAddr The car’s blockchain address.
     * @return balance How much ether is stored in the car’s wallet.
     */
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
        Car car = cars[_index]; // 📂 Retrieve the car at position `_index`.

        return (
            car.owner(),         // 👤 Car owner.
            car.model(),         // 🏷️ Car model.
            car.carAddr(),       // 🔑 Car address (VIN).
            address(car).balance // 💵 Ether balance.
        );
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Car:
 * - `owner`: Who owns the keys.
 * - `model`: Car model string.
 * - `carAddr`: The car’s own address (VIN).
 *
 * CarFactory:
 * - `create`: Normal car creation.
 * - `createAndSendEther`: Car creation with funding (ether).
 * - `create2`: Deterministic car creation (predictable address with `salt`).
 * - `create2AndSendEther`: Deterministic creation + funding.
 * - `getCar`: Query car details + balance.
 *
 * 🚘 Real-World Analogy:
 * - Each Car is like a vehicle with an owner, model, and VIN.
 * - The Factory is the manufacturing plant that builds, delivers, and logs cars.
 * - `create2` is like pre-booking a VIN number—you know the exact plate before the car is even made.
 */
