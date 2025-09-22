### 🧠 Pseudo Code with Real-World Analogies: `CrowdFund`

---

1. **START**

2. **DEFINE** interface `IERC20`

   - `transfer(to, amount)`
   - `transferFrom(from, to, amount)`
   - 💳 Analogy: This is the **bank’s API** for moving digital vouchers (ERC20 tokens) between accounts.

     - `transferFrom` = **auto-debit** with prior approval.
     - `transfer` = **send tokens** you already hold.

---

3. **DEFINE** contract `CrowdFund`

   - 📣 Purpose: A platform where creators **launch campaigns**, backers **pledge tokens**, and funds are **claimed** or **refunded** depending on whether the goal is met by the deadline.
   - **EVENTS** (public announcements on the bulletin board):

     - `Launch(id, creator, goal, startAt, endAt)` — a new campaign is posted.
     - `Cancel(id)` — a campaign is pulled **before** it starts.
     - `Pledge(id, caller, amount)` — someone chips in.
     - `Unpledge(id, caller, amount)` — someone reduces their pledge (before end).
     - `Claim(id)` — creator picks up the funds (goal reached).
     - `Refund(id, caller, amount)` — backer retrieves money (goal missed).

---

4. **DECLARE** `struct Campaign`

   - `creator` — who started the campaign (project owner).
   - `goal` — tokens needed to succeed.
   - `pledged` — tokens currently committed.
   - `startAt` — when pledging can begin.
   - `endAt` — when pledging ends.
   - `claimed` — whether funds have been handed to the creator.
   - 🎯 Analogy: A **project card** pinned on a community board with a target amount, open and close dates, and a status stamp (“claimed” or not).

---

5. **STATE** variables

   - `token` (immutable) — the ERC20 used for pledges.
   - `count` — the total number of campaigns ever created (used as unique IDs).
   - `campaigns[id]` — the campaign card by ID.
   - `pledgedAmount[id][user]` — how much a specific backer pledged to a specific campaign.
   - 🗂️ Analogy: A **filing cabinet**: each drawer is a campaign; inside are envelopes tracking each backer’s contribution.

---

6. **CONSTRUCTOR(tokenAddress)**

   - **SET** `token` to the ERC20 contract used for all payments.
   - 🏦 Analogy: The platform decides which **currency** (token) the crowdfunding accepts.

---

7. **FUNCTION** `launch(goal, startAt, endAt)`

   - **REQUIRE** `startAt >= now` (can’t start in the past).
   - **REQUIRE** `endAt >= startAt` (end after start).
   - **REQUIRE** `endAt <= now + 90 days` (max campaign length).
   - **INCREMENT** `count` to get a new campaign ID.
   - **CREATE** a new `Campaign` with zero pledged and `claimed=false`.
   - **EMIT** `Launch(id, creator, goal, startAt, endAt)`.
   - 🚀 Analogy: Pin a **new project poster** on the board with a fundraising target and a time window.

---

8. **FUNCTION** `cancel(id)`

   - **READ** the campaign.
   - **REQUIRE** caller is the `creator`.
   - **REQUIRE** `now < startAt` (can only cancel before the doors open).
   - **DELETE** the campaign entry.
   - **EMIT** `Cancel(id)`.
   - 🛑 Analogy: Take the poster down **before** the event starts; no one has pledged yet.

---

9. **FUNCTION** `pledge(id, amount)`

   - **LOAD** campaign (storage).
   - **REQUIRE** `now >= startAt` (campaign is live).
   - **REQUIRE** `now <= endAt` (not finished).
   - **UPDATE** `campaign.pledged += amount`.
   - **UPDATE** `pledgedAmount[id][caller] += amount`.
   - **TOKEN MOVE**: `token.transferFrom(caller, this, amount)` (caller must have approved this contract first).
   - **EMIT** `Pledge(id, caller, amount)`.
   - 💪 Analogy: You **drop tokens** into the project’s collection box; the platform notes your contribution under your name.

---

10. **FUNCTION** `unpledge(id, amount)`

    - **LOAD** campaign (storage).
    - **REQUIRE** `now <= endAt` (only during the campaign).
    - **UPDATE** `campaign.pledged -= amount`.
    - **UPDATE** `pledgedAmount[id][caller] -= amount`.
    - **TOKEN MOVE**: `token.transfer(caller, amount)` back to the backer.
    - **EMIT** `Unpledge(id, caller, amount)`.
    - 🔁 Analogy: You **pull tokens back** out of the box before the clock runs out.

---

11. **FUNCTION** `claim(id)`

    - **LOAD** campaign (storage).
    - **REQUIRE** caller is `creator`.
    - **REQUIRE** `now > endAt` (campaign ended).
    - **REQUIRE** `pledged >= goal` (success!).
    - **REQUIRE** `claimed == false` (can only claim once).
    - **SET** `claimed = true`.
    - **TOKEN MOVE**: `token.transfer(creator, pledged)`.
    - **EMIT** `Claim(id)`.
    - 🏁 Analogy: The project **met the target**; the organizer collects the **box of tokens** at the end.

---

12. **FUNCTION** `refund(id)`

    - **READ** campaign (memory).
    - **REQUIRE** `now > endAt` (campaign ended).
    - **REQUIRE** `pledged < goal` (failed).
    - **READ** `bal = pledgedAmount[id][caller]`.
    - **SET** pledgedAmount entry to `0`.
    - **TOKEN MOVE**: `token.transfer(caller, bal)`.
    - **EMIT** `Refund(id, caller, bal)`.
    - 💸 Analogy: The project **missed the target**; backers **line up** and receive their tokens back from the refund desk.

---

13. **LIFECYCLE (Story Mode)**

    - **Creator** posts a campaign with target & duration (`launch`).
    - **Backers** pledge (and can unpledge until the end).
    - **After deadline**:

      - If **goal met** → creator calls `claim` to collect all pledged tokens.
      - If **goal missed** → each backer calls `refund` to get back exactly what they pledged.

---

14. **SAFETY & UX NOTES**

    - **Allowance required**: Backers must `approve` the contract for `pledge` to succeed (since it uses `transferFrom`).
    - **Pull pattern**: Refunds are **pull-based** (backers call `refund`), reducing risk and complexity.
    - **One-way claim**: Once claimed, the creator cannot claim again.
    - **Time guards**: Strict checks ensure actions happen only in the correct phases.

---

15. **END**
