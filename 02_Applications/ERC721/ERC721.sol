// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title IERC165
 * @dev Interface detection standard.
 *
 * 🏷️ Analogy:
 * A badge scanner at a museum: “Do you support badge X?”
 * Contracts answer yes/no so tools know what features they implement.
 */
interface IERC165 {
    /**
     * @notice Returns true if this contract implements the interface defined by `interfaceID`.
     * @param interfaceID The bytes4 interface identifier.
     * @return supported Whether the interface is supported.
     *
     * 🧪 Analogy:
     * Scan the badge — green light if recognized, red if not.
     */
    function supportsInterface(bytes4 interfaceID)
        external
        view
        returns (bool supported);
}

/**
 * @title IERC721
 * @dev ERC-721 Non-Fungible Token Standard interface (unique collectibles).
 *
 * 🖼️ Analogy:
 * Each tokenId is a unique artwork in a catalog. You can:
 * - check who owns a piece,
 * - count a collector’s pieces,
 * - approve a courier to move one piece,
 * - appoint a gallery manager to move all your pieces,
 * - transfer pieces safely (with receipt) or plainly.
 */
interface IERC721 is IERC165 {
    /// @notice Number of artworks held by `owner`.
    function balanceOf(address owner) external view returns (uint256 balance);

    /// @notice Current owner of the artwork `tokenId`.
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /// @notice Safely move artwork `tokenId` from `from` to `to` (checks recipient).
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /// @notice Safely move with extra shipping instructions `data`.
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /// @notice Move artwork `tokenId` without recipient checks.
    function transferFrom(address from, address to, uint256 tokenId) external;

    /// @notice Give `to` permission to move artwork `tokenId`.
    function approve(address to, uint256 tokenId) external;

    /// @notice Current approved mover for artwork `tokenId`.
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    /// @notice Approve or revoke `operator` as gallery manager for all your artworks.
    function setApprovalForAll(address operator, bool _approved) external;

    /// @notice Whether `operator` can move all artworks owned by `owner`.
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

/**
 * @title IERC721Receiver
 * @dev Interface for contracts that want to accept safe ERC721 transfers.
 *
 * 🧾 Analogy:
 * A receiving dock signs a delivery slip. If they don’t sign correctly,
 * the courier won’t leave the sculpture there (transfer reverts).
 */
interface IERC721Receiver {
    /**
     * @notice Handle the receipt of an ERC721 token.
     * @param operator The caller that initiated the transfer.
     * @param from The previous owner of the token.
     * @param tokenId The artwork being transferred.
     * @param data Extra data attached to the transfer.
     * @return The selector to confirm receipt.
     *
     * 🖊️ Analogy:
     * The dock stamps the slip with the exact acknowledgment code.
     * Wrong stamp → courier aborts.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

/**
 * @title ERC721
 * @dev Minimal ERC-721 implementation with approvals and safe transfers.
 *
 * 🧭 Big Picture Analogy:
 * - `_ownerOf[id]`  = who holds artwork #id (catalog card).
 * - `_balanceOf[a]` = how many artworks a collector holds.
 * - `_approvals[id]` = courier holding a one-piece move permit.
 * - `isApprovedForAll[o][op]` = gallery manager allowed to move all pieces for owner.
 */
contract ERC721 is IERC721 {
    /**
     * @notice Emitted when artwork `id` moves from `from` to `to`.
     * @dev Also used for mint (`from = 0x0`) and burn (`to = 0x0`).
     *
     * 📣 Analogy: Museum loudspeaker: “Piece #id moved rooms.”
     */
    event Transfer(
        address indexed from, address indexed to, uint256 indexed id
    );

    /**
     * @notice Emitted when `spender` is approved to move artwork `id`.
     *
     * 📝 Analogy: One-time moving permit issued for that specific piece.
     */
    event Approval(
        address indexed owner, address indexed spender, uint256 indexed id
    );

    /**
     * @notice Emitted when `operator` is set or unset as manager for all of `owner`’s artworks.
     *
     * 🧰 Analogy: A standing contract with a logistics company to move any piece.
     */
    event ApprovalForAll(
        address indexed owner, address indexed operator, bool approved
    );

    /// @dev tokenId → owner (catalog card for each artwork).
    mapping(uint256 => address) internal _ownerOf;

    /// @dev owner → count of owned artworks.
    mapping(address => uint256) internal _balanceOf;

    /// @dev tokenId → approved single-piece courier.
    mapping(uint256 => address) internal _approvals;

    /// @inheritdoc IERC721
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /**
     * @inheritdoc IERC165
     * @dev Supports ERC721 and ERC165 interface IDs.
     */
    function supportsInterface(bytes4 interfaceId)
        external
        pure
        returns (bool)
    {
        return interfaceId == type(IERC721).interfaceId
            || interfaceId == type(IERC165).interfaceId;
    }

    /**
     * @inheritdoc IERC721
     * @dev Reverts if token doesn’t exist.
     */
    function ownerOf(uint256 id) external view returns (address owner) {
        owner = _ownerOf[id];
        require(owner != address(0), "token doesn't exist");
    }

    /**
     * @inheritdoc IERC721
     * @dev Reverts for zero address.
     */
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    /**
     * @inheritdoc IERC721
     * @dev Set or revoke a gallery manager for all your artworks.
     */
    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved); // 🗞️ Public notice.
    }

    /**
     * @inheritdoc IERC721
     * @dev Caller must be owner or an approved operator for owner.
     */
    function approve(address spender, uint256 id) external {
        address owner = _ownerOf[id];
        require(
            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authorized"
        );

        _approvals[id] = spender; // ✍️ Issue one-piece permit.
        emit Approval(owner, spender, id);
    }

    /**
     * @inheritdoc IERC721
     * @dev Reverts if token not minted.
     */
    function getApproved(uint256 id) external view returns (address) {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        return _approvals[id];
    }

    /**
     * @notice Internal check: is `spender` owner, approved operator, or per-piece approved?
     * @param owner The current owner of the token.
     * @param spender The address attempting the move.
     * @param id The tokenId to move.
     * @return ok True if authorized.
     *
     * 🕵️ Analogy:
     * Are you the artist (owner), the gallery manager (operator), or the courier with the permit?
     */
    function _isApprovedOrOwner(address owner, address spender, uint256 id)
        internal
        view
        returns (bool ok)
    {
        return (
            spender == owner || isApprovedForAll[owner][spender]
                || spender == _approvals[id]
        );
    }

    /**
     * @inheritdoc IERC721
     * @dev Clears previous per-piece approval on successful transfer.
     *
     * 🚚 Analogy:
     * Move sculpture from `from` to `to`, then invalidate the old courier’s permit.
     */
    function transferFrom(address from, address to, uint256 id) public {
        require(from == _ownerOf[id], "from != owner");
        require(to != address(0), "transfer to zero address");
        require(_isApprovedOrOwner(from, msg.sender, id), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[id] = to;

        delete _approvals[id]; // 🧹 Permit consumed.

        emit Transfer(from, to, id);
    }

    /**
     * @inheritdoc IERC721
     * @dev If `to` is a contract, it must sign the receipt (onERC721Received).
     *
     * 📦 Analogy:
     * Courier won’t leave the crate unless the warehouse signs the delivery slip.
     */
    function safeTransferFrom(address from, address to, uint256 id) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0
                || IERC721Receiver(to).onERC721Received(msg.sender, from, id, "")
                    == IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    /**
     * @inheritdoc IERC721
     * @dev Same as above, with extra shipping instructions `data`.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes calldata data
    ) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0
                || IERC721Receiver(to).onERC721Received(msg.sender, from, id, data)
                    == IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    /**
     * @notice Create (mint) a new artwork `id` for `to`.
     * @param to Receiver of the newly created token.
     * @param id Unique tokenId to mint.
     *
     * 🎨 Analogy:
     * Register a brand-new piece in the catalog and place it in `to`’s collection.
     */
    function _mint(address to, uint256 id) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[id] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    /**
     * @notice Destroy (burn) artwork `id`.
     * @param id Token to remove from circulation.
     *
     * 🕯️ Analogy:
     * Retire the piece — remove it from the catalog entirely.
     */
    function _burn(uint256 id) internal {
        address owner = _ownerOf[id];
        require(owner != address(0), "not minted");

        _balanceOf[owner] -= 1;

        delete _ownerOf[id];
        delete _approvals[id];

        emit Transfer(owner, address(0), id);
    }
}

/**
 * @title MyNFT
 * @dev Example ERC721 collection with open mint and owner-only burn for a given token.
 *
 * 🏛️ Analogy:
 * A small gallery where anyone can request a new catalog entry (`mint`),
 * and only the piece’s current owner may retire it (`burn`).
 */
contract MyNFT is ERC721 {
    /**
     * @notice Mint a new token `id` to `to`.
     * @param to Recipient address.
     * @param id Unique token ID to create.
     *
     * 🧾 Analogy:
     * Add a new artwork to `to`’s wall.
     */
    function mint(address to, uint256 id) external {
        _mint(to, id);
    }

    /**
     * @notice Burn token `id` if you are its current owner.
     * @param id Token to burn.
     *
     * 🔒 Analogy:
     * Only the collector holding the piece may retire it from the catalog.
     */
    function burn(uint256 id) external {
        require(msg.sender == _ownerOf[id], "not owner");
        _burn(id);
    }
}

/**
 * 🧠 Quick Reference (Cheat Sheet)
 *
 * Ownership & Counts:
 * - `ownerOf(id)` → who holds the artwork.
 * - `balanceOf(owner)` → how many artworks the owner has.
 *
 * Permissions:
 * - `approve(spender, id)` → one-piece permit.
 * - `setApprovalForAll(operator, true/false)` → gallery manager for all pieces.
 * - `getApproved(id)`, `isApprovedForAll(owner, operator)` → check current rights.
 *
 * Moves:
 * - `transferFrom(from, to, id)` → plain move (no recipient check).
 * - `safeTransferFrom(...)` → safe move (recipient must sign receipt if contract).
 *
 * Lifecycle:
 * - `_mint(to, id)` → create new artwork.
 * - `_burn(id)` → retire/destroy artwork.
 *
 * Introspection:
 * - `supportsInterface(iface)` → badge scanner compatibility (ERC721/ERC165).
 *
 * Analogy Recap:
 * - Tokens = unique artworks, cataloged by ID.
 * - Approvals = moving permits; operators = gallery managers.
 * - Safe transfer = courier requires signed delivery receipt when delivering to warehouses (contracts).
 */