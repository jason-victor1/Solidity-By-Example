// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title StorageSlot
 * @notice Utility library for reading/writing primitive types to specific storage slots.
 * @dev
 * 🗄️ Real-World Analogy:
 * Ethereum storage is a giant **filing cabinet**. Each drawer is identified by a 32-byte label (a slot key).
 * This library hands you a **handle** to a specific drawer so you can put in or take out a card (e.g., an address)
 * without bumping into other drawers.
 */
library StorageSlot {
    /**
     * @dev A struct that wraps an address so we can return a **storage pointer** to it.
     *
     * 📇 Analogy:
     * A **folder** that holds exactly one **contact card** (an `address`) inside the labeled drawer.
     */
    struct AddressSlot {
        address value;
    }

    /**
     * @notice Get a storage pointer to an `AddressSlot` stored at a specific slot key.
     * @param slot The 32-byte storage slot key (the drawer’s unique label).
     * @return pointer A storage reference to the `AddressSlot` at `slot`.
     *
     * 🧭 Analogy:
     * Hand me the drawer’s **barcode** (`slot`) and I’ll give you the **handle** (`pointer`)
     * to read or write the card inside that drawer.
     *
     * ⚙️ Implementation:
     * Uses inline assembly to set `pointer.slot := slot`. No reads/writes happen here;
     * you just receive a reference to the location.
     */
    function getAddressSlot(bytes32 slot)
        internal
        pure
        returns (AddressSlot storage pointer)
    {
        assembly {
            // Point the returned reference to the exact storage slot key.
            pointer.slot := slot
        }
    }
}

/**
 * @title TestSlot
 * @notice Demonstrates using `StorageSlot` to safely read/write an address at a fixed slot.
 * @dev
 * 🧪 Real-World Analogy:
 * This contract keeps a special drawer labeled `TEST_SLOT`. You can
 *  - **write**: put a contact card (address) into that drawer,
 *  - **get**: open the drawer and read the card back out.
 */
contract TestSlot {
    /**
     * @notice Unique storage slot key for our demo drawer.
     * @dev `keccak256("TEST_SLOT")` is used to avoid collisions with other storage.
     *
     * 🏷️ Analogy: A **unique barcode** for our dedicated drawer in the filing cabinet.
     */
    bytes32 public constant TEST_SLOT = keccak256("TEST_SLOT");

    /**
     * @notice Write an address into the `TEST_SLOT` drawer.
     * @param _addr The address to store.
     *
     * 📝 Analogy:
     * Open the drawer labeled `TEST_SLOT` and place a **business card** with `_addr` on it.
     *
     * 🔐 Notes:
     * - This function overwrites the previous card in that drawer.
     * - No constructor state needed; the drawer label is constant.
     */
    function write(address _addr) external {
        StorageSlot.AddressSlot storage data =
            StorageSlot.getAddressSlot(TEST_SLOT);
        data.value = _addr;
    }

    /**
     * @notice Read the address stored in the `TEST_SLOT` drawer.
     * @return stored The address currently stored at `TEST_SLOT`.
     *
     * 👀 Analogy:
     * Pull open the **TEST_SLOT** drawer and read the **contact card** inside.
     */
    function get() external view returns (address stored) {
        StorageSlot.AddressSlot storage data =
            StorageSlot.getAddressSlot(TEST_SLOT);
        return data.value;
    }
}
