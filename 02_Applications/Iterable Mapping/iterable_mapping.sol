// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library IterableMapping {
    /**
     * @title Iterable Mapping Library
     * @dev A mapping that can be iterated because it keeps an array of keys in insertion order.
     *
     * 📒 Real-World Analogy:
     * Imagine a front-desk notebook:
     *  - `values` = each customer’s tab written on their personal page,
     *  - `keys` = the index of all customers in order (table of contents),
     *  - `indexOf` = the page number where a customer’s tab lives,
     *  - `inserted` = a checkmark saying “this customer already has a page.”
     * This design lets you both look up by name (mapping) and flip through everyone (array).
     */

    /// @notice Internal storage for an iterable mapping from `address` to `uint256`.
    /// @dev `keys` preserves iteration order; the mappings store values & bookkeeping.
    struct Map {
        address[] keys;                     // 📚 Table of contents: every customer in order.
        mapping(address => uint256) values; // 🧾 Each customer's current tab.
        mapping(address => uint256) indexOf;// 🧭 Page number for each customer in `keys`.
        mapping(address => bool) inserted;  // ✅ Whether they already have a page.
    }

    /**
     * @notice Get the value stored for `key`.
     * @dev O(1) lookup via mapping.
     * @param map The iterable map.
     * @param key The address (customer) to look up.
     * @return The stored value (their tab).
     *
     * 🔎 Analogy: Look up a customer by name and read their tab.
     */
    function get(Map storage map, address key) public view returns (uint256) {
        return map.values[key];
    }

    /**
     * @notice Get the key (address) stored at a given position.
     * @dev O(1) index read from `keys`.
     * @param map The iterable map.
     * @param index The position in the `keys` array.
     * @return The address at that index.
     *
     * 📖 Analogy: Flip to a page number in the table of contents and read the customer’s name.
     */
    function getKeyAtIndex(Map storage map, uint256 index)
        public
        view
        returns (address)
    {
        return map.keys[index];
    }

    /**
     * @notice Number of keys stored in the map.
     * @dev Equals `keys.length`.
     * @param map The iterable map.
     * @return Count of entries.
     *
     * 🧮 Analogy: How many pages are filled in the notebook?
     */
    function size(Map storage map) public view returns (uint256) {
        return map.keys.length;
    }

    /**
     * @notice Insert or update a key → value pair.
     * @dev If `key` is new, it’s appended to `keys` and indexed; otherwise only the value is updated.
     * @param map The iterable map.
     * @param key The address to set.
     * @param val The value to store.
     *
     * 📝 Analogy:
     * - If the customer already has a page, just overwrite their tab.
     * - If they’re new, add a fresh page at the end and write their tab there.
     */
    function set(Map storage map, address key, uint256 val) public {
        if (map.inserted[key]) {
            map.values[key] = val; // ✍️ Update existing tab.
        } else {
            map.inserted[key] = true;               // ✅ Mark page as created.
            map.values[key] = val;                  // 🧾 Write their tab.
            map.indexOf[key] = map.keys.length;     // 🧭 Record page number.
            map.keys.push(key);                     // 📚 Add to table of contents.
        }
    }

    /**
     * @notice Remove a key from the map, keeping `keys` compact (no gaps).
     * @dev Swaps the last key into the removed key’s slot, updates indices, and pops the array.
     * @param map The iterable map.
     * @param key The address to remove.
     *
     * 🧽 Analogy:
     * - Cross the customer out of the notebook,
     * - Move the last page into their page number (to avoid an empty hole),
     * - Update the page number for that moved customer,
     * - Tear out the now-duplicate last page.
     */
    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return; // 🤷 Nothing to do if the customer never had a page.
        }

        delete map.inserted[key]; // ❌ Remove the checkmark.
        delete map.values[key];   // 🗑️ Erase their tab.

        uint256 index = map.indexOf[key];                // Old page number.
        address lastKey = map.keys[map.keys.length - 1]; // The last page’s owner.

        map.indexOf[lastKey] = index; // 🔁 Move last page into the empty slot.
        delete map.indexOf[key];      // 🧹 Clear old index.

        map.keys[index] = lastKey;    // ↔️ Swap in array.
        map.keys.pop();               // ✂️ Remove trailing duplicate page.
    }
}

contract TestIterableMap {
    /**
     * @title Iterable Mapping Demo
     * @dev Uses `IterableMapping.Map` to track caller balances and iterate keys.
     *
     * 🏪 Analogy:
     * This contract is the **front desk**:
     * - Visitors identify themselves by address,
     * - The clerk writes/updates their tab,
     * - The clerk can also flip through the customer list in order.
     */

    using IterableMapping for IterableMapping.Map;

    /// @notice The actual notebook managed by our clerk.
    IterableMapping.Map private map;

    /**
     * @notice Set your own value in the iterable mapping.
     * @dev `msg.sender` is used as the key.
     * @param val The value to store for your address.
     *
     * 💡 Analogy: You walk up and say, “Please set my tab to `val`,” and the clerk writes it down.
     */
    function setInMapping(uint256 val) public {
        map.set(msg.sender, val);
    }

    /**
     * @notice Get your stored value.
     * @dev Reads `map.values[msg.sender]`.
     * @return Your current value.
     *
     * 🧾 Analogy: “What’s my tab?” The clerk reads your page back to you.
     */
    function getFromMap() public view returns (uint256) {
        return map.get(msg.sender);
    }

    /**
     * @notice Get an address by its index in the keys array.
     * @dev Useful for iterating over all entries off-chain by walking indices.
     * @param index The position in `keys`.
     * @return The address at that index.
     *
     * 📖 Analogy: “Who is on page `index`?” The clerk reads the name on that page.
     */
    function getKeyAtIndex(uint256 index) public view returns (address) {
        return map.getKeyAtIndex(index);
    }

    /**
     * @notice Number of entries currently stored.
     * @dev Equal to the number of keys tracked.
     * @return The size of the mapping.
     *
     * 🧮 Analogy: “How many customers are in the book?”
     */
    function sizeOfMapping() public view returns (uint256) {
        return map.size();
    }

    /**
     * @notice Remove your own entry from the mapping.
     * @dev Deletes your value and compacts the `keys` array.
     *
     * 🧽 Analogy: “Please erase my page.” The clerk removes you and keeps the list tidy by moving the last page into your spot.
     */
    function removeFromMapping() public {
        map.remove(msg.sender);
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * - `IterableMapping.Map`: Notebook with pages (`keys`) + fast name lookups (`values`).
 * - `set(map, key, val)`: Add/update a page; track its page number.
 * - `get(map, key)`: Read the tab for a specific customer.
 * - `remove(map, key)`: Delete a page and slide the last page forward (no gaps).
 * - `getKeyAtIndex(map, i)`: Flip to page `i` and read who’s there.
 * - `size(map)`: Count how many pages exist.
 *
 * 🏷️ Real-World Analogy Recap:
 * - Mapping = quick name → page lookup,
 * - Array of keys = ordered table of contents,
 * - Index bookkeeping = page numbers,
 * - Swap-and-pop = tidy removal without leaving torn-out gaps.
 */