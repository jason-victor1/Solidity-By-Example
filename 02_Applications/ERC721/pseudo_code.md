### 🧠 Pseudo Code with Real-World Analogies: `ERC721` (NFT Standard)

---

1. **START**

---

2. **DEFINE** interface `IERC165`

   - **FUNCTION** `supportsInterface(interfaceID) -> bool`
   - Analogy: a museum badge scanner. Ask an exhibit, “Do you support badge X?” The exhibit answers yes/no.

---

3. **DEFINE** interface `IERC721` (inherits `IERC165`)

   - Purpose: the official **rulebook for unique collectibles** (non-fungible tokens).
   - Key functions (what every NFT must be able to do):

     - `balanceOf(owner)` → how many collectibles this wallet holds (count of artworks).
     - `ownerOf(tokenId)` → who owns a specific artwork.
     - `transferFrom(from, to, tokenId)` → move an artwork (no safety check).
     - `safeTransferFrom(from, to, tokenId [, data])` → move an artwork safely (with recipient check).
     - `approve(to, tokenId)` → give one person the right to move **this** artwork.
     - `getApproved(tokenId)` → who currently has that right.
     - `setApprovalForAll(operator, approved)` → grant or revoke a gallery manager’s rights over **all** your artworks.
     - `isApprovedForAll(owner, operator)` → check if that gallery manager is active.

   - Analogy: the museum protocol — how to count pieces, check ownership, assign a curator to move a piece, and safely ship pieces.

---

4. **DEFINE** interface `IERC721Receiver`

   - **FUNCTION** `onERC721Received(operator, from, tokenId, data) -> selector`
   - Analogy: a receiving dock that **signs the delivery slip** when a sculpture arrives. If the dock doesn’t sign, the courier won’t leave it there.

---

5. **DEFINE** contract `ERC721` (implements `IERC721`)

   **Events (public announcements):**

   - `Transfer(from, to, id)` → an artwork moved (or minted/burned).
   - `Approval(owner, spender, id)` → a specific artwork can be moved by `spender`.
   - `ApprovalForAll(owner, operator, approved)` → a gallery manager may move **all** artworks for `owner`.

   **Storage (museum ledgers):**

   - `_ownerOf[id]` → who currently owns artwork `id`.
   - `_balanceOf[owner]` → how many artworks an owner holds.
   - `_approvals[id]` → the single account approved to move artwork `id`.
   - `isApprovedForAll[owner][operator]` → whether a gallery manager can move all of `owner`’s artworks.

   **FUNCTION** `supportsInterface(interfaceId)`

   - Returns `true` for IERC721 and IERC165 IDs.
   - Analogy: the exhibit has the right badges: “I’m an ERC721 exhibit, and I know the scanner protocol.”

   **FUNCTION** `ownerOf(id)`

   - **CHECK**: token must exist.
   - **RETURN** current owner.
   - Analogy: check the museum catalog: who holds this specific painting?

   **FUNCTION** `balanceOf(owner)`

   - **CHECK**: owner not zero address.
   - **RETURN** how many artworks they own.
   - Analogy: how many pieces are in Alice’s private collection?

   **FUNCTION** `setApprovalForAll(operator, approved)`

   - Toggle a gallery manager’s rights for all your pieces.
   - Emit `ApprovalForAll`.
   - Analogy: sign a standing contract with a logistics company to move any of your artworks.

   **FUNCTION** `approve(spender, id)`

   - **CHECK**: caller is the owner **or** an approved operator for the owner.
   - Set `_approvals[id] = spender`; emit `Approval`.
   - Analogy: write a one-time moving permit for a specific painting.

   **FUNCTION** `getApproved(id)`

   - **CHECK**: token exists.
   - **RETURN** the currently approved mover for this piece.
   - Analogy: who currently holds the move permit?

   **FUNCTION** `_isApprovedOrOwner(owner, spender, id) -> bool`

   - True if `spender` is the owner, an operator for owner, or specifically approved for `id`.
   - Analogy: are you the artist, the gallery manager, or the courier holding the permit?

   **FUNCTION** `transferFrom(from, to, id)`

   - **CHECKS**:

     - `from` is the current owner,
     - `to` isn’t the zero address,
     - caller is owner / operator / approved for this `id`.

   - **EFFECTS**:

     - decrement `from` balance, increment `to` balance,
     - update `_ownerOf[id] = to`,
     - clear `_approvals[id]`,
     - emit `Transfer`.

   - Analogy: the painting is moved from gallery room A to collector B; the prior permit is voided.

   **FUNCTION** `safeTransferFrom(from, to, id)`

   - Call `transferFrom`.
   - If `to` is a contract, **require** it returns the correct **receipt signature** via `onERC721Received`.
   - Analogy: the courier won’t leave the sculpture unless the receiving dock signs the delivery slip.

   **FUNCTION** `safeTransferFrom(from, to, id, data)`

   - Same as above, passing along extra shipping instructions (`data`).
   - Analogy: include special handling notes with the delivery.

   **FUNCTION** `_mint(to, id)` (internal)

   - **CHECKS**: `to` not zero; `id` not already minted.
   - Assign owner, increase balance, emit `Transfer(0 → to, id)`.
   - Analogy: a **new artwork is registered** into the catalog and placed into `to`’s collection.

   **FUNCTION** `_burn(id)` (internal)

   - **CHECK**: token exists.
   - Reduce owner’s balance, clear records, emit `Transfer(owner → 0, id)`.
   - Analogy: the artwork is **destroyed/retired** and removed from the catalog.

---

6. **DEFINE** contract `MyNFT` (extends `ERC721`)

   - **FUNCTION** `mint(to, id)` → calls `_mint(to, id)`.

     - Analogy: create and assign a brand-new artwork to a collector.

   - **FUNCTION** `burn(id)` → only current owner can call; then `_burn(id)`.

     - Analogy: the owner chooses to permanently retire/destroy their piece.

---

7. **TYPICAL FLOW (Story Time)**

   - **Minting**: Curator mints artwork #101 to Alice → catalog shows Alice owns #101.
   - **Approvals**: Alice approves Bob (specific piece) **OR** sets Charlie as operator for all.
   - **Transfers**:

     - `transferFrom(Alice → Dave, #101)` if caller is Alice/Bob/Charlie (authorized).
     - `safeTransferFrom(...)` ensures Dave (if contract) can actually receive NFTs by signing.

   - **Burning**: If Dave owns #101 and calls `burn(101)`, the piece is removed from the catalog.

---

8. **END**

---

### 🧭 Quick Reference (Cheat Sheet)

- **Ownership:** `ownerOf(id)` → who holds the unique piece.
- **Balances:** `balanceOf(owner)` → how many unique pieces they hold.
- **Permissions:**

  - One-off: `approve(spender, id)` / `getApproved(id)`
  - All pieces: `setApprovalForAll(operator, bool)` / `isApprovedForAll(owner, operator)`

- **Moves:**

  - Basic: `transferFrom(from, to, id)`
  - Safe: `safeTransferFrom(from, to, id [, data])` (requires recipient contract to sign the receipt)

- **Lifecycle:** `_mint(to, id)` to create; `_burn(id)` to destroy.
- **Introspection:** `supportsInterface(id)` (IERC165) to declare “I’m an ERC721 exhibit.”

**Analogy Recap:**

- Tokens = unique artworks.
- Owners = collectors.
- Approvals = moving permits.
- Operators = gallery managers.
- Safe transfer = courier requires a signed receipt if the destination is a warehouse (contract).
- Mint/Burn = register a new piece / retire a piece from the museum catalog.
