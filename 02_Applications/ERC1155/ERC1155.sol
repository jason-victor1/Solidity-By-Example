// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title IERC1155
 * @dev ERC-1155 Multi-Token Standard interface (single + batch transfers).
 *
 * 🏬 Analogy:
 * Think of one big **warehouse** that stores many **SKUs** (token IDs).
 * - Each SKU can have **many units** (fungible quantities).
 * - You can ship one SKU or many SKUs at once.
 * - You can appoint a **warehouse manager** who’s allowed to move all your SKUs.
 */
interface IERC1155 {
    /**
     * @notice Safely move `value` units of SKU `id` from `from` to `to`.
     * @param from Current holder.
     * @param to Destination address.
     * @param id SKU being moved.
     * @param value Units of that SKU.
     * @param data Extra shipping notes for the destination.
     *
     * 📦 Analogy: Send a **single pallet** (one SKU) with optional paperwork.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;

    /**
     * @notice Safely move multiple SKUs and quantities from `from` to `to`.
     * @param from Current holder.
     * @param to Destination address.
     * @param ids Array of SKUs.
     * @param values Array of units per SKU.
     * @param data Extra shipping notes for the destination.
     *
     * 🚚 Analogy: A **truck** delivering **many pallets** (multiple SKUs) in one trip.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;

    /**
     * @notice Units of SKU `id` held by `owner`.
     * @param owner Wallet to query.
     * @param id SKU to query.
     * @return balance Units of that SKU owned.
     *
     * 📊 Analogy: Check how many boxes of a product are on a person’s shelf.
     */
    function balanceOf(address owner, uint256 id)
        external
        view
        returns (uint256 balance);

    /**
     * @notice Bulk balance report for many `(owner, id)` pairs.
     * @param owners Array of owners.
     * @param ids Array of SKUs (parallel to `owners`).
     * @return balances Per-pair balances.
     *
     * 🧾 Analogy: One form listing “How many boxes of SKU X at location Y?” for many rows.
     */
    function balanceOfBatch(address[] calldata owners, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory balances);

    /**
     * @notice Hire or fire a warehouse manager for all your SKUs.
     * @param operator Manager address.
     * @param approved True to hire, false to revoke.
     *
     * 🧰 Analogy: Sign a standing work order allowing an operator to move any of your products.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @notice Whether `operator` is authorized to move **all** SKUs for `owner`.
     * @param owner The product owner.
     * @param operator The manager in question.
     * @return ok True if authorized.
     *
     * 🕵️ Analogy: “Is this logistics company currently allowed to handle all my pallets?”
     */
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool ok);
}

/**
 * @title IERC1155TokenReceiver
 * @dev Interface for contracts that accept ERC1155 safe transfers.
 *
 * 🧾 Analogy:
 * A receiving **dock** that must sign the delivery slip with the exact code.
 * If they don’t sign, the courier won’t leave the pallets (transfer reverts).
 */
interface IERC1155TokenReceiver {
    /**
     * @notice Handle receipt of a single-SKU delivery.
     * @return selector Must return `onERC1155Received.selector` to accept.
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @notice Handle receipt of a batch delivery (multi-SKU).
     * @return selector Must return `onERC1155BatchReceived.selector` to accept.
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

/**
 * @title ERC1155
 * @dev Minimal multi-token implementation with single + batch transfers,
 *      per-SKU balances, operator approvals, safe receiver checks, and mint/burn.
 *
 * 🧭 Big Picture Analogy:
 * - `balanceOf[owner][id]` → how many boxes of SKU `id` are on `owner`’s shelf.
 * - `isApprovedForAll[owner][op]` → whether a logistics manager can move all your boxes.
 * - Safe transfers require destination **warehouses (contracts)** to sign a receipt.
 */
contract ERC1155 is IERC1155 {
    /**
     * @notice Emitted for single-SKU transfers (including mint/burn).
     * @param operator Caller moving the tokens.
     * @param from Source address (0 on mint).
     * @param to Destination address (0 on burn).
     * @param id SKU moved.
     * @param value Units moved.
     *
     * 📣 Analogy: Loudspeaker: “Operator O moved V units of SKU #id from F to T.”
     */
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    /**
     * @notice Emitted for batch transfers.
     * @param operator Caller moving the tokens.
     * @param from Source address (0 on mint).
     * @param to Destination address (0 on burn).
     * @param ids SKUs moved.
     * @param values Units per SKU.
     *
     * 📰 Analogy: “Operator sent a truck with multiple pallets.”
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @notice Operator approval set or revoked for an owner.
     *
     * 🧰 Analogy: Hiring/firing the warehouse manager for all your SKUs.
     */
    event ApprovalForAll(
        address indexed owner, address indexed operator, bool approved
    );

    /**
     * @notice Metadata template notice for a given SKU.
     * @param value The metadata URI (often with `{id}` substitution).
     * @param id SKU the metadata applies to.
     *
     * 🧷 Analogy: Product page (spec sheet) for a specific SKU.
     */
    event URI(string value, uint256 indexed id);

    /// @dev owner => id => balance (how many units of this SKU on that shelf).
    mapping(address => mapping(uint256 => uint256)) public balanceOf;

    /// @inheritdoc IERC1155
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /**
     * @inheritdoc IERC1155
     * @dev Parallel arrays: owners[i] with ids[i].
     */
    function balanceOfBatch(address[] calldata owners, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory balances)
    {
        require(owners.length == ids.length, "owners length != ids length");
        balances = new uint256[](owners.length);
        unchecked {
            for (uint256 i = 0; i < owners.length; i++) {
                balances[i] = balanceOf[owners[i]][ids[i]];
            }
        }
    }

    /**
     * @inheritdoc IERC1155
     * @dev Set operator status and emit `ApprovalForAll`.
     */
    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @inheritdoc IERC1155
     * @dev Safe single-SKU transfer; destination contracts must acknowledge.
     *
     * 📦 Analogy:
     * Ship one pallet. If the destination is a warehouse (contract),
     * they must sign the delivery slip (`onERC1155Received`).
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external {
        require(
            msg.sender == from || isApprovedForAll[from][msg.sender],
            "not approved"
        );
        require(to != address(0), "to = 0 address");

        balanceOf[from][id] -= value; // 💥 reverts on insufficient balance (Solidity 0.8 checks)
        balanceOf[to][id]   += value;

        emit TransferSingle(msg.sender, from, to, id, value);

        if (to.code.length > 0) {
            require(
                IERC1155TokenReceiver(to).onERC1155Received(
                    msg.sender, from, id, value, data
                ) == IERC1155TokenReceiver.onERC1155Received.selector,
                "unsafe transfer"
            );
        }
    }

    /**
     * @inheritdoc IERC1155
     * @dev Safe batch transfer; destination contracts must acknowledge batch.
     *
     * 🚚 Analogy:
     * Send a truck with multiple pallets (SKUs). The receiving dock must sign once
     * for the whole shipment (`onERC1155BatchReceived`).
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external {
        require(
            msg.sender == from || isApprovedForAll[from][msg.sender],
            "not approved"
        );
        require(to != address(0), "to = 0 address");
        require(ids.length == values.length, "ids length != values length");

        for (uint256 i = 0; i < ids.length; i++) {
            balanceOf[from][ids[i]] -= values[i];
            balanceOf[to][ids[i]]   += values[i];
        }

        emit TransferBatch(msg.sender, from, to, ids, values);

        if (to.code.length > 0) {
            require(
                IERC1155TokenReceiver(to).onERC1155BatchReceived(
                    msg.sender, from, ids, values, data
                ) == IERC1155TokenReceiver.onERC1155BatchReceived.selector,
                "unsafe transfer"
            );
        }
    }

    /**
     * @notice ERC165 support declaration for ERC165, ERC1155, ERC1155MetadataURI.
     * @param interfaceId The queried interface ID.
     * @return supported True if recognized.
     *
     * 🪪 Analogy: Badges on the warehouse door showing supported standards.
     */
    function supportsInterface(bytes4 interfaceId)
        external
        pure
        returns (bool supported)
    {
        return interfaceId == 0x01ffc9a7 // ERC165
            || interfaceId == 0xd9b67a26 // ERC1155
            || interfaceId == 0x0e89341c; // ERC1155MetadataURI
    }

    /**
     * @notice Metadata template for SKU `id` (override to implement).
     * @param id SKU.
     * @return uri_ Metadata URI string.
     *
     * 🧷 Analogy: Product page link for this SKU.
     */
    function uri(uint256 id) public view virtual returns (string memory uri_) {}

    // ------------------------------------------------------------------------
    // 🧩 Internal Supply Ops (Manufacture / Destroy)
    // ------------------------------------------------------------------------

    /**
     * @notice Mint `value` units of SKU `id` to `to`.
     * @dev Emits `TransferSingle(0 → to)`. Requires receiver ack if `to` is a contract.
     *
     * 🏭 Analogy: Manufacture new boxes and place them on `to`’s shelf.
     */
    function _mint(address to, uint256 id, uint256 value, bytes memory data)
        internal
    {
        require(to != address(0), "to = 0 address");

        balanceOf[to][id] += value;
        emit TransferSingle(msg.sender, address(0), to, id, value);

        if (to.code.length > 0) {
            require(
                IERC1155TokenReceiver(to).onERC1155Received(
                    msg.sender, address(0), id, value, data
                ) == IERC1155TokenReceiver.onERC1155Received.selector,
                "unsafe transfer"
            );
        }
    }

    /**
     * @notice Mint multiple SKUs to `to` in one batch.
     * @dev Emits `TransferBatch(0 → to)`. Requires receiver ack if `to` is a contract.
     *
     * 🏭🚚 Analogy: Produce many SKUs and stock them at `to` with one truck.
     */
    function _batchMint(
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) internal {
        require(to != address(0), "to = 0 address");
        require(ids.length == values.length, "ids length != values length");

        for (uint256 i = 0; i < ids.length; i++) {
            balanceOf[to][ids[i]] += values[i];
        }

        emit TransferBatch(msg.sender, address(0), to, ids, values);

        if (to.code.length > 0) {
            require(
                IERC1155TokenReceiver(to).onERC1155BatchReceived(
                    msg.sender, address(0), ids, values, data
                ) == IERC1155TokenReceiver.onERC1155BatchReceived.selector,
                "unsafe transfer"
            );
        }
    }

    /**
     * @notice Burn `value` units of SKU `id` from `from`.
     * @dev Emits `TransferSingle(from → 0)`.
     *
     * 🔥 Analogy: Destroy boxes of a specific SKU from `from`’s shelf.
     */
    function _burn(address from, uint256 id, uint256 value) internal {
        require(from != address(0), "from = 0 address");
        balanceOf[from][id] -= value;
        emit TransferSingle(msg.sender, from, address(0), id, value);
    }

    /**
     * @notice Burn multiple SKUs from `from` in one batch.
     * @dev Emits `TransferBatch(from → 0)`.
     *
     * 🔥🚚 Analogy: Bulk destruction — remove pallets of several SKUs at once.
     */
    function _batchBurn(
        address from,
        uint256[] calldata ids,
        uint256[] calldata values
    ) internal {
        require(from != address(0), "from = 0 address");
        require(ids.length == values.length, "ids length != values length");

        for (uint256 i = 0; i < ids.length; i++) {
            balanceOf[from][ids[i]] -= values[i];
        }

        emit TransferBatch(msg.sender, from, address(0), ids, values);
    }
}

/**
 * @title MyMultiToken
 * @dev Simple extension exposing mint/batchMint/burn/batchBurn to the caller.
 *
 * 🧪 Analogy:
 * A self-serve kiosk at the warehouse where a user can manufacture or destroy
 * units on their own shelf (demo pattern).
 */
contract MyMultiToken is ERC1155 {
    /**
     * @notice Mint `value` units of SKU `id` to yourself.
     * @param id SKU to mint.
     * @param value Units to mint.
     * @param data Optional metadata payload for receivers.
     *
     * 🏭 Analogy: Produce boxes of this SKU and place them on your shelf.
     */
    function mint(uint256 id, uint256 value, bytes memory data) external {
        _mint(msg.sender, id, value, data);
    }

    /**
     * @notice Mint many SKUs to yourself in one batch.
     * @param ids SKUs.
     * @param values Units per SKU.
     * @param data Optional payload for receivers.
     *
     * 🏭🚚 Analogy: Produce multiple SKUs and stock them all at once.
     */
    function batchMint(
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external {
        _batchMint(msg.sender, ids, values, data);
    }

    /**
     * @notice Burn `value` units of SKU `id` from yourself.
     * @param id SKU to burn.
     * @param value Units to burn.
     *
     * 🔥 Analogy: Discard boxes of this SKU from your shelf.
     */
    function burn(uint256 id, uint256 value) external {
        _burn(msg.sender, id, value);
    }

    /**
     * @notice Burn multiple SKUs from yourself in one batch.
     * @param ids SKUs.
     * @param values Units per SKU.
     *
     * 🔥🚚 Analogy: Bulk discard: remove several SKUs in one go.
     */
    function batchBurn(uint256[] calldata ids, uint256[] calldata values)
        external
    {
        _batchBurn(msg.sender, ids, values);
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Balances:
 * - `balanceOf(owner, id)` → units of SKU `id` on `owner`’s shelf
 * - `balanceOfBatch(owners, ids)` → bulk inventory report
 *
 * Approvals:
 * - `setApprovalForAll(op, true/false)` → hire/fire warehouse manager
 * - `isApprovedForAll(owner, op)` → check manager status
 *
 * Transfers:
 * - `safeTransferFrom(from, to, id, value, data)` → ship one SKU (requires receipt if `to` is contract)
 * - `safeBatchTransferFrom(from, to, ids, values, data)` → ship many SKUs at once (batch receipt)
 *
 * Supply Ops (internal):
 * - `_mint/_batchMint` → manufacture new units (emit Transfer from 0x0)
 * - `_burn/_batchBurn` → destroy units (emit Transfer to 0x0)
 *
 * Metadata & Introspection:
 * - `uri(id)` → SKU product page
 * - `supportsInterface` → ERC165/1155/metadata badges
 *
 * 🔁 Analogy Recap:
 * - ERC1155 = one **warehouse** with many **product lines** (SKUs) and **quantities**.
 * - Batch ops = one **truck** moving multiple pallets in one trip.
 * - Safe transfers = **no drop-offs** unless the receiving warehouse signs the slip.
 */
