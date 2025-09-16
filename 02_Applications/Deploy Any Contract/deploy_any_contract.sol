// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Proxy (Raw Deployer & Executor)
 * @notice Deploy arbitrary creation bytecode and execute arbitrary calls with optional ETH.
 * @dev
 * 🧭 Real-World Analogy:
 * - This contract is a **general contractor & courier**.
 *   - **Builder mode (`deploy`)**: You hand it a **blueprint** (creation bytecode) and some **cash** (ETH).
 *     It constructs the **building** (contract) and tells you the new **address**.
 *   - **Runner mode (`execute`)**: You give it a **destination** (address) and an **instruction note** (calldata).
 *     It goes there (optionally carrying cash), **presses the buttons**, and reports success or failure.
 */
contract Proxy {
    /**
     * @notice Emitted after a successful deployment via {deploy}.
     * @param deployed The address of the newly deployed contract.
     *
     * 📣 Analogy: The contractor pins the **street address** of the new building on a notice board.
     */
    event Deploy(address deployed);

    /**
     * @notice Accept ETH sent directly to this contract.
     * @dev
     * 👛 Analogy: The contractor’s **cash drawer**; you can preload funds for upcoming jobs.
     */
    receive() external payable {}

    /**
     * @notice Deploy a new contract from raw creation bytecode.
     * @dev Uses `create(value, ptr, size)` in inline assembly.
     * Reverts if deployment returns the zero address.
     *
     * 🏗️ Analogy:
     * Hand the contractor a **blueprint** (bytecode) and optional **cash** (forwarded to the constructor);
     * they build the **structure** and return the **address** where it now stands.
     *
     * @param _code The complete creation bytecode (optionally includes ABI-encoded constructor args).
     * @return addr The address of the newly deployed contract.
     */
    function deploy(bytes memory _code)
        external
        payable
        returns (address addr)
    {
        assembly {
            // create(v, p, n)
            // v = ETH to send (msg.value)
            // p = memory pointer to the start of code (skip length word)
            // n = size of code (length)
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }
        require(addr != address(0), "deploy failed");
        emit Deploy(addr);
    }

    /**
     * @notice Execute an arbitrary call against a target, optionally sending ETH.
     * @dev Low-level `.call` with the provided calldata and msg.value.
     * Reverts if the call fails.
     *
     * 📨 Analogy:
     * Give the courier a **destination** (`_target`), an **instruction note** (`_data`),
     * and optionally **cash**. The courier goes there, follows the note exactly,
     * and brings back the outcome (reverts on failure).
     *
     * @param _target The contract to call.
     * @param _data Encoded function selector and arguments (ABI-encoded calldata).
     */
    function execute(address _target, bytes memory _data) external payable {
        (bool success, ) = _target.call{value: msg.value}(_data);
        require(success, "failed");
    }
}

/**
 * @title TestContract1
 * @notice Simple ownable contract that lets the current owner transfer ownership.
 * @dev
 * 🏷️ Analogy:
 * A small office with a **nameplate** on the door (`owner`).
 * Only the person currently on the nameplate can replace it.
 */
contract TestContract1 {
    /// @notice The current owner (initialized to deployer at deployment time).
    address public owner = msg.sender;

    /**
     * @notice Change the owner to `_owner`.
     * @dev Only callable by the current `owner`.
     * 🪪 Analogy: Only the person on the door’s nameplate can swap it out for a new name.
     * @param _owner The new owner address.
     */
    function setOwner(address _owner) public {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }
}

/**
 * @title TestContract2
 * @notice Demonstrates constructor parameters and capturing initial ETH at deployment.
 * @dev
 * 🧰 Analogy:
 * Another office installed with **model settings** (`x`, `y`) engraved at setup time,
 * and an initial **cash deposit** locked in the vault (`value`) during installation.
 */
contract TestContract2 {
    /// @notice The owner set to the deployer at deployment time.
    address public owner = msg.sender;

    /// @notice The amount of ETH sent during deployment (constructor’s `msg.value`).
    uint256 public value = msg.value;

    /// @notice Constructor parameter X (engraved at installation).
    uint256 public x;

    /// @notice Constructor parameter Y (engraved at installation).
    uint256 public y;

    /**
     * @notice Deploy with parameters `_x` and `_y`, optionally sending ETH to record in {value}.
     * @dev `value` is captured from the constructor’s `msg.value`.
     * 🧾 Analogy: When the office is installed, you engrave `x` and `y` and drop initial cash into its safe.
     * @param _x First constructor parameter.
     * @param _y Second constructor parameter.
     */
    constructor(uint256 _x, uint256 _y) payable {
        x = _x;
        y = _y;
    }
}

/**
 * @title Helper
 * @notice Convenience functions to produce deployable bytecode and calldata for use with {Proxy}.
 * @dev
 * 🧑‍🍳 Analogy:
 * - Prepares **blueprints** (creation code with/without constructor args).
 * - Prepares **instruction notes** (ABI-encoded calldata) for the courier to deliver.
 */
contract Helper {
    /**
     * @notice Get the raw creation bytecode for {TestContract1}.
     * @dev No constructor args required.
     *
     * 📄 Analogy: The plain **blueprint** for the “nameplate office”.
     * @return bytecode The creation code of TestContract1.
     */
    function getBytecode1() external pure returns (bytes memory bytecode) {
        bytecode = type(TestContract1).creationCode;
    }

    /**
     * @notice Get the full creation bytecode for {TestContract2} with constructor args.
     * @dev Concatenates `creationCode` with ABI-encoded `(_x, _y)`.
     *
     * 🧷 Analogy: The **blueprint** stapled together with a **settings sheet** (`x`, `y`).
     * @param _x Constructor parameter X.
     * @param _y Constructor parameter Y.
     * @return bytecode The creation code including encoded constructor args.
     */
    function getBytecode2(uint256 _x, uint256 _y)
        external
        pure
        returns (bytes memory bytecode)
    {
        bytes memory base = type(TestContract2).creationCode;
        bytecode = abi.encodePacked(base, abi.encode(_x, _y));
    }

    /**
     * @notice ABI-encode a call to `setOwner(address)` for {TestContract1}.
     * @dev Produces calldata suitable for {Proxy.execute}.
     *
     * 📝 Analogy: An **instruction note** telling the courier which button to press and with what argument.
     * @param _owner The address to set as the new owner.
     * @return data ABI-encoded calldata for `setOwner(address)`.
     */
    function getCalldata(address _owner) external pure returns (bytes memory data) {
        data = abi.encodeWithSignature("setOwner(address)", _owner);
    }
}