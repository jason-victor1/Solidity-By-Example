### 🧠 Pseudo Code with Real-World Analogies: `TimeLock`

---

1. **START**

2. **DEFINE** contract `TimeLock`

   - Purpose: **schedule a transaction for the future** and only allow it to be executed **after a delay** and **before it expires**.
   - Analogy: a **bank vault with a time lock**. You can load instructions (who to pay, what to call), but the vault opens only after a minimum wait, and if you’re too late, it closes again.

---

3. **ERRORS (Custom Reverts)**

   - `NotOwnerError()` — Only the vault manager can operate it.
   - `AlreadyQueuedError(txId)` — That exact package is already in the vault queue.
   - `TimestampNotInRangeError(now, ts)` — Your scheduled open time isn’t between “soon” and “too far”.
   - `NotQueuedError(txId)` — You tried to execute/cancel something not in the vault.
   - `TimestampNotPassedError(now, ts)` — You came **too early**; the vault hasn’t unlocked.
   - `TimestampExpiredError(now, expiresAt)` — You came **too late**; the grace window slammed shut.
   - `TxFailedError()` — The call inside the package failed to run.

---

4. **EVENTS (Notice Board)**

   - `Queue(txId, target, value, func, data, timestamp)` — A package was put in the time-lock queue.
   - `Execute(txId, ...)` — The package was opened and its instructions executed.
   - `Cancel(txId)` — The package was removed before execution.

---

5. **CONSTANTS (Vault Timing Rules)**

   - `MIN_DELAY = 10s` — **minimum wait** before the vault opens.
   - `MAX_DELAY = 1000s` — **maximum scheduling horizon**; can’t schedule too far ahead.
   - `GRACE_PERIOD = 1000s` — **window after unlock** during which you must execute; after that, it expires.

---

6. **STATE**

   - `owner` — the vault manager (only controller).
   - `queued[txId]` — registry of which packages are currently stored in the vault.
   - `receive()` — vault can **accept ETH** (e.g., to fund scheduled calls).
   - Analogy:

     - `owner` = **head keyholder**.
     - `queued` = **clipboard list** of all boxes waiting for their unlock time.

---

7. **CONSTRUCTOR**

   - Set `owner = msg.sender`.
   - Analogy: the person who installs the vault becomes the **initial keyholder**.

---

8. **MODIFIER `onlyOwner`**

   - Checks the caller is `owner`; otherwise **reject**.
   - Analogy: only the keyholder can load/open/cancel vault boxes.

---

9. **FUNCTION** `getTxId(target, value, func, data, timestamp) -> txId` (**pure**)

   - **Compute** a unique **fingerprint** (hash) for the scheduled instruction set.
   - Analogy: the **serial number** engraved on each vault box, derived from its contents and unlock time.

---

10. **FUNCTION** `queue(target, value, func, data, timestamp) -> txId` (**onlyOwner**)

- **Create** `txId = hash(target, value, func, data, timestamp)`.
- **Ensure** it’s not already queued (`AlreadyQueuedError`).
- **Ensure** `timestamp` ∈ `[now + MIN_DELAY, now + MAX_DELAY]` (`TimestampNotInRangeError`).
- **Mark** `queued[txId] = true`.
- **Emit** `Queue`.
- Analogy: you **pack a box** with instructions (who to call, how much ETH, which function signature, encoded args), pick an **unlock time**, and place it into the vault queue.

---

11. **FUNCTION** `execute(target, value, func, data, timestamp) -> bytes` (**payable, onlyOwner**)

- **Recompute** `txId`, verify it **is queued** (`NotQueuedError`).
- **Check time window**:

  - `now >= timestamp` else **too early** (`TimestampNotPassedError`).
  - `now <= timestamp + GRACE_PERIOD` else **too late** (`TimestampExpiredError`).

- **Unqueue**: set `queued[txId] = false`.
- **Prepare call data**:

  - If `func` is non-empty: `selector = first 4 bytes(keccak256(func))`; `dataToSend = selector || data`.
  - Else: `dataToSend = data` (call target’s fallback with raw data).

- **Perform low-level call**: `(ok, res) = target.call{value: value}(dataToSend)`; if not ok → `TxFailedError`.
- **Emit** `Execute`.
- **Return** `res` (raw return bytes).
- Analogy: At the scheduled time (within the **grace window**), you **open the box** and carry out the written instructions—call the destination, with the exact function and payment. If anything fails, the vault signals an alarm and the whole attempt is void.

---

12. **FUNCTION** `cancel(txId)` (**onlyOwner**)

- **Require** it **is queued** (`NotQueuedError`).
- Set `queued[txId] = false`.
- **Emit** `Cancel`.
- Analogy: remove the box from the vault **before** it’s opened; the scheduled action won’t happen.

---

13. **DATA PACKING DETAILS**

- `func` is a human-readable **function signature** (e.g., `"foo(address,uint256)"`).
- The contract turns it into a **function selector** (`bytes4(keccak256(bytes(func)))`) and concatenates it with ABI-encoded `data`.
- If `func` is empty, it sends `data` directly (fallback route).
- Analogy: either you write the **exact button panel** (which function) + the **parameters**, or you leave it to the **generic mailbox slot** (fallback).

---

14. **SECURITY & OPERATIONAL NOTES**

- **Deterministic txId**: contents + time → hash. Any change at all yields a **different** box serial.
- **Single-use boxes**: execution always **unqueues** the txId, preventing replays.
- **Time discipline**:

  - Must queue **with enough delay** (≥ `MIN_DELAY`) and **not too far out** (≤ `MAX_DELAY`).
  - Must execute **after unlock** and **before grace expires**.

- **Owner control**: only the keyholder can queue/execute/cancel (typical governance timelock pattern).
- **Low-level call risk**: the target function can revert; errors bubble up as `TxFailedError`.
- **Funding**: contract can hold ETH; `value` is forwarded on execution when specified.

---

15. **LIFECYCLE (Story Mode)**

1) **Queue**: The owner schedules a package with instructions and an unlock time (within rules).
2) **Wait**: Everyone can **inspect the event** and know what’s coming (transparency).
3) **Execute**: After the unlock and before the grace ends, the owner opens the box; the call is made with optional ETH.
4) **Cancel**: If needed, before execution, the owner can remove the package.

---

16. **END**
