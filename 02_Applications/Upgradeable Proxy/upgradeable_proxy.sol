// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title CounterV1
 * @dev Minimal logic contract with a single increment action.
 *
 * 🧮 Analogy:
 * A wall-mounted **counter** with just one button — “+1”.
 * The number is written on the wall (storage) of the **building** that hosts it (the proxy).
 */
contract CounterV1 {
    /// @notice The counter value (lives in the proxy’s storage when called via delegatecall).
    uint256 public count;

    /**
     * @notice Increase the counter by one.
     * @dev Press the single “+1” button.
     */
    function inc() external {
        count += 1;
    }
}

/**
 * @title CounterV2
 * @dev Second version of the counter logic, adds a decrement action.
 *
 * 🔁 Analogy:
 * Same wall counter, now with **two** buttons: “+1” and “-1”.
 */
contract CounterV2 {
    /// @notice The counter value (still lives in the proxy’s storage).
    uint256 public count;

    /**
     * @notice Increase the counter by one.
     * @dev Press “+1”.
     */
    function inc() external {
        count += 1;
    }

    /**
     * @notice Decrease the counter by one.
     * @dev Press “-1”.
     */
    function dec() external {
        count -= 1;
    }
}

/**
 * @title BuggyProxy
 * @dev Simple proxy that forwards **all** calls (including admin calls) to the implementation.
 *      Demonstrates the pitfall solved by the transparent proxy pattern.
 *
 * ⚠️ Analogy:
 * One **public door** for everyone. Even the building manager (admin) is
 * pushed through reception and accidentally forwarded into tenant logic.
 * This can cause collisions, lockouts, and misrouted admin actions.
 */
contract BuggyProxy {
    /// @notice Current implementation (tenant office) being delegated to.
    address public implementation;
    /// @notice Address allowed to upgrade the implementation.
    address public admin;

    /**
     * @notice Set the initial admin to the deployer.
     */
    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Delegate the current calldata to `implementation`.
     * 📞 Analogy: Reception forwards the entire call to the tenant office.
     */
    function _delegate() private {
        (bool ok,) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    /**
     * @notice Fallback for unknown function calls.
     * @dev Always forwards — this is the bug: even admin calls get forwarded.
     */
    fallback() external payable {
        _delegate();
    }

    /**
     * @notice Receive ether and forward.
     */
    receive() external payable {
        _delegate();
    }

    /**
     * @notice Upgrade implementation (admin-only).
     * @param _implementation New logic contract.
     *
     * ❗ Bug Context:
     * Even though this function exists, the shared door can still misroute
     * admin interactions in more complex setups.
     */
    function upgradeTo(address _implementation) external {
        require(msg.sender == admin, "not authorized");
        implementation = _implementation;
    }
}

/**
 * @title Dev
 * @dev Helper contract to expose function selectors for the transparent proxy admin panel.
 *
 * 🗒️ Analogy:
 * A **cheat sheet** of button codes on the control panel (selectors).
 */
contract Dev {
    /**
     * @notice Return selectors for admin panel functions on `Proxy`.
     * @return adminSel Selector for `Proxy.admin()`
     * @return implSel Selector for `Proxy.implementation()`
     * @return upgSel Selector for `Proxy.upgradeTo(address)`
     */
    function selectors() external view returns (bytes4 adminSel, bytes4 implSel, bytes4 upgSel) {
        return (Proxy.admin.selector, Proxy.implementation.selector, Proxy.upgradeTo.selector);
    }
}

/**
 * @title Proxy (Transparent Upgradeable Proxy, EIP-1967)
 * @dev Routes user calls to implementation via fallback, but intercepts admin calls (transparent pattern).
 *
 * 🏛️ Analogy:
 * - **Building** (this proxy address) has:
 *   - a **public lobby** (fallback) that forwards visitors to the current tenant office (implementation),
 *   - a **private manager entrance** (ifAdmin) that never forwards — used to read/change admin & implementation.
 *
 * 🗄️ Storage:
 * Uses **EIP-1967**-defined storage slots to avoid collisions with tenant storage on delegatecall.
 */
contract Proxy {
    // ---------------------------------------------------------------------
    // 🔒 EIP-1967 storage slots (avoid collisions with implementation state)
    // ---------------------------------------------------------------------

    /// @notice Slot for implementation address (EIP-1967): keccak256("eip1967.proxy.implementation") - 1
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    /// @notice Slot for admin address (EIP-1967): keccak256("eip1967.proxy.admin") - 1
    bytes32 private constant ADMIN_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1);

    /**
     * @notice Initialize proxy admin to deployer.
     * 🧑‍💼 Analogy: Appoint the first building manager.
     */
    constructor() {
        _setAdmin(msg.sender);
    }

    /**
     * @dev Modifier that executes the body **only** if caller is admin.
     * Otherwise, it behaves like a user call and forwards to the implementation.
     *
     * 🚪 Analogy:
     * - Manager uses a **private door** to the control room (executes function body).
     * - Non-managers are sent to reception (fallback forwarding).
     */
    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    // ---------------------------
    // 🧰 Internal admin utilities
    // ---------------------------

    /// @dev Read admin from the EIP-1967 slot.
    function _getAdmin() private view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    /// @dev Write admin to the EIP-1967 slot (non-zero).
    function _setAdmin(address _admin) private {
        require(_admin != address(0), "admin = zero address");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }

    /// @dev Read implementation from the EIP-1967 slot.
    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    /// @dev Write implementation to the EIP-1967 slot (must be a contract).
    function _setImplementation(address _implementation) private {
        require(_implementation.code.length > 0, "implementation is not a contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }

    // ------------------
    // 🛠️ Admin interface
    // ------------------

    /**
     * @notice Change the admin address.
     * @param _admin New admin.
     *
     * 🔐 Analogy: Hand the **master keys** to a new building manager.
     */
    function changeAdmin(address _admin) external ifAdmin {
        _setAdmin(_admin);
    }

    /**
     * @notice Upgrade to a new implementation.
     * @param _implementation Address of new logic contract.
     *
     * 🏗️ Analogy: Swap the **tenant office** the lobby forwards to; the building and its wall data remain.
     */
    function upgradeTo(address _implementation) external ifAdmin {
        _setImplementation(_implementation);
    }

    /**
     * @notice Read the current admin.
     * @return admin_ Admin address.
     *
     * 🧾 Analogy: Who currently holds the **manager badge**?
     */
    function admin() external ifAdmin returns (address admin_) {
        return _getAdmin();
    }

    /**
     * @notice Read the current implementation.
     * @return impl Implementation address.
     *
     * 🧾 Analogy: Which **office** (logic) are we forwarding to?
     */
    function implementation() external ifAdmin returns (address impl) {
        return _getImplementation();
    }

    // ----------------
    // 🙋 User interface
    // ----------------

    /**
     * @dev Delegate the current call to `_implementation`.
     *
     * 🧩 Assembly Steps:
     * 1) Copy the caller’s **entire request** (calldata) into memory.
     * 2) `DELEGATECALL` the implementation with that data and all gas.
     * 3) Copy back everything returned (or the revert data) and bubble it up.
     *
     * 📞 Analogy:
     * Reception puts the caller on speakerphone with the tenant office and
     * relays the answer (or the error) exactly as given.
     */
    function _delegate(address _implementation) internal virtual {
        assembly {
            // Copy calldata to memory
            calldatacopy(0, 0, calldatasize())

            // delegatecall(gas, target, inPtr, inSize, outPtr, outSize)
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

            // Copy returndata back
            returndatacopy(0, 0, returndatasize())

            // Bubble up result (revert or return)
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    /// @dev Route non-admin callers to the current implementation.
    function _fallback() private {
        _delegate(_getImplementation());
    }

    /**
     * @notice Fallback for unknown function calls.
     * @dev For non-admin callers, forwards to implementation.
     */
    fallback() external payable {
        _fallback();
    }

    /**
     * @notice Receive ether.
     * @dev For non-admin callers, forwards to implementation.
     */
    receive() external payable {
        _fallback();
    }
}

/**
 * @title ProxyAdmin
 * @dev External admin tool that **owns** the right to operate proxies’ admin panels.
 *
 * 🕹️ Analogy:
 * A **master console** that lets its owner press the buttons on the proxies’ control panels:
 * view admin/implementation, change admin, and upgrade.
 */
contract ProxyAdmin {
    /// @notice Owner of this admin console.
    address public owner;

    /**
     * @notice Initialize the console owner to the deployer.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Restrict to console owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    /**
     * @notice Read a proxy’s admin via its admin-only function (staticcall).
     * @param proxy Address of the Proxy contract.
     * @return proxyAdmin Address of the admin.
     *
     * 🧪 Note:
     * We call the proxy’s `admin()` selector. Because **we** are not the proxy admin,
     * the transparent pattern would normally forward us; however, we use `staticcall`
     * expecting the proxy to treat this as an admin read **when the proxy’s `ifAdmin` condition
     * is satisfied** (commonly used from a privileged context).
     */
    function getProxyAdmin(address proxy) external view returns (address proxyAdmin) {
        (bool ok, bytes memory res) = proxy.staticcall(abi.encodeCall(Proxy.admin, ()));
        require(ok, "call failed");
        return abi.decode(res, (address));
    }

    /**
     * @notice Read a proxy’s implementation via its admin-only function (staticcall).
     * @param proxy Address of the Proxy contract.
     * @return impl Address of the implementation.
     */
    function getProxyImplementation(address proxy) external view returns (address impl) {
        (bool ok, bytes memory res) = proxy.staticcall(abi.encodeCall(Proxy.implementation, ()));
        require(ok, "call failed");
        return abi.decode(res, (address));
    }

    /**
     * @notice Change a proxy’s admin (console owner only).
     * @param proxy Proxy to manage.
     * @param admin New admin address.
     *
     * 🔐 Analogy: Hand the **building keys** to a new manager.
     */
    function changeProxyAdmin(address payable proxy, address admin) external onlyOwner {
        Proxy(proxy).changeAdmin(admin);
    }

    /**
     * @notice Upgrade a proxy’s implementation (console owner only).
     * @param proxy Proxy to manage.
     * @param implementation New logic contract.
     *
     * 🏗️ Analogy: Swap the tenant office behind the lobby.
     */
    function upgrade(address payable proxy, address implementation) external onlyOwner {
        Proxy(proxy).upgradeTo(implementation);
    }
}

/**
 * @title StorageSlot
 * @dev Library for reading/writing primitive types to specific storage slots.
 *
 * 🗄️ Analogy:
 * Access a **labeled locker** in the basement by its exact GPS coordinates (slot key),
 * so you don’t bump into tenant variables stored elsewhere.
 */
library StorageSlot {
    /// @dev Address slot structure (points to a fixed storage key).
    struct AddressSlot {
        address value;
    }

    /**
     * @notice Return a storage pointer to an `AddressSlot` at `slot`.
     * @param slot The storage slot key.
     * @return r Reference to the address slot at `slot`.
     *
     * 🧰 Analogy: Hand back a handle to the **locker** so callers can read/write it.
     */
    function getAddressSlot(bytes32 slot)
        internal
        pure
        returns (AddressSlot storage r)
    {
        assembly {
            r.slot := slot
        }
    }
}

/**
 * @title TestSlot
 * @dev Demonstrates how to use `StorageSlot` with a custom slot key.
 *
 * 🧪 Analogy:
 * Create your own labeled **locker** (“TEST_SLOT”) and read/write an address in it.
 */
contract TestSlot {
    /// @notice A custom slot key for demonstration.
    bytes32 public constant slot = keccak256("TEST_SLOT");

    /**
     * @notice Read the address stored at `TEST_SLOT`.
     * @return addr The stored address.
     */
    function getSlot() external view returns (address addr) {
        return StorageSlot.getAddressSlot(slot).value;
    }

    /**
     * @notice Write an address into `TEST_SLOT`.
     * @param _addr Address to store.
     */
    function writeSlot(address _addr) external {
        StorageSlot.getAddressSlot(slot).value = _addr;
    }
}
