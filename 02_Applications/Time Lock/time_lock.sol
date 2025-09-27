// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title TimeLock
 * @notice Schedules arbitrary calls for future execution after a minimum delay and before an expiry window.
 * @dev
 * 🔐 Real-World Analogy:
 * Think of this contract as a **bank vault with a time lock**.
 * - You can **queue a sealed instruction box** (who to call, how much ETH, which function, what args, and when).
 * - The vault **won’t open** until a **minimum wait** has passed.
 * - After it unlocks, there’s a **grace window** to open the box; miss it and the box **expires**.
 * - Only the **vault owner (keyholder)** can load, open, or cancel boxes.
 *
 * Design highlights:
 * - Deterministic `txId` fingerprints each queued instruction (prevents accidental duplicates).
 * - Single-use semantics: executing or canceling clears the queue status to prevent replays.
 * - Low-level `.call` supports *any* target/function encoding; supply a signature or use fallback data.
 */
contract TimeLock {
    // ==========
    // Errors
    // ==========

    /**
     * @notice Thrown when a non-owner tries to operate the vault.
     * @dev 🗝️ Analogy: You don’t have the key to the time-lock room.
     */
    error NotOwnerError();

    /**
     * @notice Thrown when trying to queue an instruction box that already exists.
     * @param txId The computed fingerprint of the queued instruction.
     * @dev 📦 Analogy: This exact sealed box is already on the vault shelf.
     */
    error AlreadyQueuedError(bytes32 txId);

    /**
     * @notice Thrown when desired unlock time is not between min and max schedule windows.
     * @param blockTimestamp The current time (now).
     * @param timestamp The requested unlock time.
     * @dev ⏳ Analogy: You tried to set the vault to open either **too soon** or **too far ahead**.
     */
    error TimestampNotInRangeError(uint256 blockTimestamp, uint256 timestamp);

    /**
     * @notice Thrown when an operation expects a queued instruction but it isn’t queued.
     * @param txId The expected instruction fingerprint.
     * @dev 🗂️ Analogy: You looked for a box that isn’t on the shelf.
     */
    error NotQueuedError(bytes32 txId);

    /**
     * @notice Thrown when attempting to execute before the unlock time.
     * @param blockTimestamp The current time (now).
     * @param timestamp The unlock time.
     * @dev 🚫 Analogy: You arrived **too early**—the vault is still locked.
     */
    error TimestampNotPassedError(uint256 blockTimestamp, uint256 timestamp);

    /**
     * @notice Thrown when attempting to execute after the grace window has passed.
     * @param blockTimestamp The current time (now).
     * @param expiresAt The last valid timestamp to execute (unlock + grace).
     * @dev 🕯️ Analogy: You arrived **too late**—the window closed and the box expired.
     */
    error TimestampExpiredError(uint256 blockTimestamp, uint256 expiresAt);

    /**
     * @notice Thrown when the low-level call execution fails.
     * @dev ❌ Analogy: You opened the box, but the instructions couldn’t be carried out.
     */
    error TxFailedError();

    // ==========
    // Events
    // ==========

    /**
     * @notice Emitted when an instruction is queued into the time lock.
     * @param txId     Unique fingerprint of the queued instruction.
     * @param target   Address to call when executing.
     * @param value    ETH to forward with the call.
     * @param func     Function signature (e.g., "foo(address,uint256)"), or empty to use raw `data` as fallback.
     * @param data     ABI-encoded call arguments (or full payload if `func` is empty).
     * @param timestamp The earliest time at which execution is valid (unlock time).
     * @dev 📬 Analogy: A **sealed box** is placed on the vault shelf with its open-after time stamped on it.
     */
    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint256 value,
        string func,
        bytes data,
        uint256 timestamp
    );

    /**
     * @notice Emitted when a queued instruction is executed successfully.
     * @param txId     Unique fingerprint of the executed instruction.
     * @param target   Address that was called.
     * @param value    ETH sent with the call.
     * @param func     Function signature used (if any).
     * @param data     ABI-encoded args (or payload).
     * @param timestamp The unlock time originally specified for this instruction.
     * @dev 📤 Analogy: The **box is opened** and its instructions carried out.
     */
    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint256 value,
        string func,
        bytes data,
        uint256 timestamp
    );

    /**
     * @notice Emitted when a queued instruction is canceled.
     * @param txId Unique fingerprint of the canceled instruction.
     * @dev 🗑️ Analogy: The box is **removed from the shelf** and discarded before opening.
     */
    event Cancel(bytes32 indexed txId);

    // ==========
    // Constants
    // ==========

    /// @notice Minimum delay (in seconds) between queue and earliest execution time.
    /// @dev ⛔ Analogy: The **shortest wait** the vault will accept.
    uint256 public constant MIN_DELAY = 10; // seconds

    /// @notice Maximum allowed delay (in seconds) when scheduling unlock time.
    /// @dev 🧭 Analogy: You cannot schedule **too far into the future**.
    uint256 public constant MAX_DELAY = 1000; // seconds

    /// @notice Grace window (in seconds) after unlock during which execution is allowed.
    /// @dev 🪟 Analogy: The **time window** the vault door stays open before it auto-locks again.
    uint256 public constant GRACE_PERIOD = 1000; // seconds

    // ==========
    // Storage
    // ==========

    /// @notice Current owner (vault keyholder).
    address public owner;

    /// @notice Tracks whether a given `txId` is currently queued.
    /// @dev 📋 Analogy: The **shelf ledger** indicating which boxes are present.
    mapping(bytes32 => bool) public queued;

    // ==========
    // Construction & Access
    // ==========

    /**
     * @notice Initialize the time-lock with the deployer as the owner.
     * @dev 🔑 Analogy: The installer becomes the **first keyholder**.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Restrict function to the owner only.
     * @dev 🗝️ Analogy: Only the **keyholder** can operate the vault.
     */
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwnerError();
        _;
    }

    /**
     * @notice Accept ETH transfers.
     * @dev 🏦 Analogy: The vault can hold funds to forward with scheduled calls.
     */
    receive() external payable {}

    // ==========
    // Helpers
    // ==========

    /**
     * @notice Compute the unique fingerprint (txId) for a scheduled instruction.
     * @dev
     * The txId binds **all** parameters: target, ETH value, function signature, ABI data, and unlock timestamp.
     * Any change produces a different fingerprint, preventing accidental collisions.
     *
     * 🧬 Analogy:
     * This is the **serial number** engraved on the sealed box, derived from its contents and unlock time.
     *
     * @param _target    Address of the call destination.
     * @param _value     ETH amount to forward on execution.
     * @param _func      Function signature (e.g., "foo(address,uint256)"), or empty for fallback.
     * @param _data      ABI-encoded arguments (or full payload if `_func` empty).
     * @param _timestamp Earliest valid execution time (unlock time).
     * @return txId      Keccak-256 hash fingerprint of the instruction.
     */
    function getTxId(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) public pure returns (bytes32 txId) {
        txId = keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    // ==========
    // Queue / Execute / Cancel
    // ==========

    /**
     * @notice Queue a new instruction box for future execution.
     * @dev
     * Requirements:
     * - Instruction must not already be queued.
     * - `_timestamp` must be in `[block.timestamp + MIN_DELAY, block.timestamp + MAX_DELAY]`.
     *
     * 📦 Analogy:
     * You package the **destination, payment, function, arguments, and unlock time**
     * into a sealed box and place it on the vault shelf, stamped with its `txId`.
     *
     * @param _target    Address of contract or account to call.
     * @param _value     ETH to forward with the call on execution.
     * @param _func      Function signature (e.g., "foo(address,uint256)") or empty to use fallback with `_data`.
     * @param _data      ABI-encoded arguments (or full payload if `_func` is empty).
     * @param _timestamp Unlock time (earliest valid execution).
     * @return txId      Unique fingerprint for the queued instruction.
     */
    function queue(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) external onlyOwner returns (bytes32 txId) {
        txId = getTxId(_target, _value, _func, _data, _timestamp);
        if (queued[txId]) revert AlreadyQueuedError(txId);

        // Enforce scheduling window: [now + min, now + max]
        if (
            _timestamp < block.timestamp + MIN_DELAY ||
            _timestamp > block.timestamp + MAX_DELAY
        ) {
            revert TimestampNotInRangeError(block.timestamp, _timestamp);
        }

        queued[txId] = true;
        emit Queue(txId, _target, _value, _func, _data, _timestamp);
    }

    /**
     * @notice Execute a previously queued instruction if within its valid time window.
     * @dev
     * Requirements:
     * - Instruction must be queued.
     * - `block.timestamp >= _timestamp` (unlock reached).
     * - `block.timestamp <= _timestamp + GRACE_PERIOD` (not expired).
     *
     * Behavior:
     * - Unqueues the instruction (single-use).
     * - Builds call data:
     *   * If `_func` provided → `bytes4(keccak256(_func)) || _data`
     *   * Else                → `_data` (fallback path)
     * - Performs low-level call with `_value`, reverts on failure.
     *
     * 🧰 Analogy:
     * The vault **opens** (unlock reached), you **open the box**, and carry out the
     * exact instructions. If the mechanism fails, the attempt is aborted.
     *
     * @param _target    Address to call.
     * @param _value     ETH to forward with the call.
     * @param _func      Function signature (or empty for fallback).
     * @param _data      ABI-encoded args or full payload.
     * @param _timestamp Unlock time previously queued.
     * @return res       Raw ABI-encoded return data from the target call.
     */
    function execute(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) external payable onlyOwner returns (bytes memory res) {
        bytes32 txId =
            getTxId(_target, _value, _func, _data, _timestamp);

        if (!queued[txId]) revert NotQueuedError(txId);

        // Check time window: [unlock, unlock + grace]
        if (block.timestamp < _timestamp) {
            revert TimestampNotPassedError(block.timestamp, _timestamp);
        }
        if (block.timestamp > _timestamp + GRACE_PERIOD) {
            revert TimestampExpiredError(
                block.timestamp, _timestamp + GRACE_PERIOD
            );
        }

        // Single-use: unqueue before attempting the call.
        queued[txId] = false;

        // Build calldata: selector + args if func provided; else raw data.
        bytes memory callData;
        if (bytes(_func).length > 0) {
            callData = abi.encodePacked(
                bytes4(keccak256(bytes(_func))), _data
            );
        } else {
            callData = _data;
        }

        // Perform the call.
        (bool ok, bytes memory out) = _target.call{value: _value}(callData);
        if (!ok) revert TxFailedError();

        emit Execute(txId, _target, _value, _func, _data, _timestamp);
        return out;
    }

    /**
     * @notice Cancel a queued instruction before it is executed.
     * @dev
     * Requirements:
     * - Instruction must currently be queued.
     *
     * 🗑️ Analogy:
     * Remove the sealed box from the vault shelf—this instruction will no longer run.
     *
     * @param _txId Fingerprint of the instruction to cancel.
     */
    function cancel(bytes32 _txId) external onlyOwner {
        if (!queued[_txId]) revert NotQueuedError(_txId);
        queued[_txId] = false;
        emit Cancel(_txId);
    }
}
