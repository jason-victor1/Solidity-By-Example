// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Factory (CREATE2 – high-level syntax)
 * @dev Deploys `TestContract` deterministically using Solidity’s salted creation (CREATE2) without inline assembly.
 *
 * 🧭 Big Picture Analogy:
 * Think of this Factory as a **vending machine for safes**. You provide:
 *  - the safe’s **owner name** (`_owner`),
 *  - a **model number** (`_foo`),
 *  - and a **salt token** (`_salt`).
 * Using CREATE2, the safe will appear in a **predictable locker** (address) determined by these inputs.
 *
 * 🔐 Why CREATE2?
 * - Deterministic address: know the safe’s locker **before** building it.
 * - Counterfactual setups: share/fund/permit that address ahead of time.
 */
contract Factory {
    /**
     * @notice Deploy a new `TestContract` via CREATE2 and return its address.
     * @param _owner The owner recorded by the new contract.
     * @param _foo A configuration number recorded by the new contract.
     * @param _salt The CREATE2 salt deciding the deterministic address.
     * @return deployed The address of the deployed `TestContract`.
     *
     * 🏭 Analogy:
     * Insert the **salt token** into the vending machine and it drops a safe
     * with the specified engraving (owner/model) into a **predicted locker**.
     */
    function deploy(address _owner, uint256 _foo, bytes32 _salt)
        public
        payable
        returns (address deployed)
    {
        // Newer Solidity syntax for CREATE2 deployments:
        deployed = address(new TestContract{salt: _salt}(_owner, _foo));
    }
}

/**
 * @title FactoryAssembly (CREATE2 – low-level)
 * @dev Classic CREATE2 flow with bytecode composition, address prediction, and assembly deployment.
 *
 * 🧭 Big Picture Analogy:
 * - `getBytecode`  → build the **recipe card** (blueprint + engravings).
 * - `getAddress`   → consult the **locker map** to predict where the safe will land.
 * - `deploy`       → feed recipe + salt into the **machine**, verify the safe exists, print receipt (event).
 */
contract FactoryAssembly {
    /// @notice Emitted after successful CREATE2 deployment.
    /// @param addr Deployed contract address.
    /// @param salt Salt used for CREATE2 derivation.
    /// 📣 Analogy: A receipt showing the **locker number** and the **token** used.
    event Deployed(address addr, uint256 salt);

    /**
     * @notice Build deployable creation bytecode for `TestContract` with constructor args.
     * @param _owner Owner to engrave into the safe.
     * @param _foo Model number to engrave into the safe.
     * @return creation The full creation code (contract creationCode + ABI-encoded args).
     *
     * 🧱 Analogy:
     * Take the **assembly manual** (creationCode) and staple a note:
     * “Set owner to `_owner`, model to `_foo`.”
     */
    function getBytecode(address _owner, uint256 _foo)
        public
        pure
        returns (bytes memory creation)
    {
        bytes memory bytecode = type(TestContract).creationCode;
        creation = abi.encodePacked(bytecode, abi.encode(_owner, _foo));
    }

    /**
     * @notice Predict the deterministic address for a CREATE2 deployment from this factory.
     * @param bytecode The full creation bytecode (from `getBytecode`).
     * @param _salt The numeric salt used for CREATE2.
     * @return predicted The address where the contract will be deployed.
     *
     * 🗺️ Analogy (Locker Map Formula):
     * address = last20( keccak256( 0xff ++ factory ++ salt ++ keccak256(bytecode) ) )
     * With the same inputs, you always get the **same locker**.
     */
    function getAddress(bytes memory bytecode, uint256 _salt)
        public
        view
        returns (address predicted)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),            // constant marker
                address(this),           // this factory (the vending machine)
                _salt,                   // your salt token
                keccak256(bytecode)      // recipe card fingerprint
            )
        );

        predicted = address(uint160(uint256(hash))); // take last 20 bytes
    }

    /**
     * @notice Deploy `bytecode` at a deterministic address using CREATE2 and emit `Deployed`.
     * @dev Reverts if deployment fails (no code at the computed address).
     * @param bytecode The full creation bytecode (from `getBytecode`).
     * @param _salt The salt controlling the deterministic address.
     *
     * ⚙️ Assembly Notes:
     * - `create2(value, ptr, size, salt)`:
     *   - Deploys new contract with `mem[ptr .. ptr+size)` as creation code
     *   - New address = keccak256(0xff ++ deployer ++ salt ++ keccak256(code))[12..31]
     *
     * 🏭 Analogy:
     * Feed the **recipe card** + **salt token** to the machine; it fabricates the safe,
     * places it into the predicted locker, and we print a receipt.
     */
    function deploy(bytes memory bytecode, uint256 _salt) public payable {
        address addr;
        assembly {
            // Deploy via CREATE2, forwarding any ETH sent with this call (callvalue()).
            addr := create2(
                callvalue(),
                add(bytecode, 0x20),  // skip the length word
                mload(bytecode),      // code size
                _salt
            )
            // If no code was created at `addr`, revert (deployment failed).
            if iszero(extcodesize(addr)) { revert(0, 0) }
        }

        emit Deployed(addr, _salt);
    }
}

/**
 * @title TestContract
 * @dev Simple contract deployed by the factories; records an owner and a number, accepts ETH.
 *
 * 🧭 Big Picture Analogy:
 * This is the **safe** being installed:
 *  - `owner` engraved on the door,
 *  - `foo` marking the model,
 *  - can hold some **cash** (ETH) inside.
 */
contract TestContract {
    /// @notice Engraved owner of this instance (who the safe belongs to).
    address public owner;

    /// @notice Arbitrary model/config number engraved at installation.
    uint256 public foo;

    /**
     * @notice Install the safe with engravings; optionally preload with ETH.
     * @param _owner The owner to record.
     * @param _foo A number to record.
     *
     * 💸 Analogy: During installation, you can drop some cash into the safe.
     */
    constructor(address _owner, uint256 _foo) payable {
        owner = _owner;
        foo = _foo;
    }

    /**
     * @notice Current ETH stored in this contract.
     * @return balance The ETH balance of the contract.
     *
     * 👀 Analogy: Open the safe and **count the cash**.
     */
    function getBalance() public view returns (uint256 balance) {
        balance = address(this).balance;
    }
}

/* -------------------------------------------------------------------------
   🧠 Quick Reference (Cheat Sheet)

   CREATE2 Determinism:
   - predicted = last20( keccak256( 0xff ++ deployer ++ salt ++ keccak256(bytecode) ) )

   High-Level Path (no assembly):
   - Factory.deploy(owner, foo, salt) → new TestContract{salt: salt}(owner, foo)

   Low-Level Path (assembly):
   - bytecode = FactoryAssembly.getBytecode(owner, foo)
   - predicted = FactoryAssembly.getAddress(bytecode, salt)
   - FactoryAssembly.deploy(bytecode, salt) → emits Deployed(addr, salt)
   - addr == predicted (if same inputs)

   Analogies:
   - Factory = **vending machine**, CREATE2 = **deterministic lockers**,
   - salt = **token** deciding the locker slot,
   - bytecode+args = **recipe card** describing the safe,
   - getAddress = **locker map** you can check ahead of time,
   - TestContract = the **safe** (owner name + model number), can hold **cash**.
--------------------------------------------------------------------------- */