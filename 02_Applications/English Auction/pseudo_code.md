### 🧠 Pseudo Code with Real-World Analogies: `EnglishAuction`

---

1. **START**

2. **DEFINE** an interface `IERC721`

   - `safeTransferFrom(from, to, tokenId)`
   - `transferFrom(from, to, tokenId)`
   - Analogy: rules for handing over a **unique collectible** (the NFT) from one person to another, safely.

3. **DEFINE** a contract `EnglishAuction`

   - **EVENTS**

     - `Start()` — the auction officially opens (like cutting the ribbon).
     - `Bid(sender, amount)` — someone shouts a new highest bid in the room.
     - `Withdraw(bidder, amount)` — a non-winning bidder collects their deposit back at the cashier.
     - `End(winner, amount)` — the gavel falls; we announce the winner and final price.

   - **STATE**

     - `nft` (`IERC721`) — the collectible being auctioned.
     - `nftId` — the specific item number.
     - `seller` — the person consigning the collectible.
     - `endAt` — time when bidding closes.
     - `started` / `ended` — status flags (doors open / gavel fallen).
     - `highestBidder` / `highestBid` — current leader and their bid.
     - `bids[address]` — refundable balances for overbid bidders.

   - Analogy: a **live auction house** for one unique item. The seller puts the item on the stage; bidders raise paddles with higher offers; previous top bidders can reclaim their money after being outbid.

4. **CONSTRUCTOR(\_nft, \_nftId, \_startingBid)**

   - **SET** `nft` and `nftId` to identify the item.
   - **SET** `seller = msg.sender` (the consignor).
   - **SET** `highestBid = _startingBid` (reserve/minimum opening price).
   - Analogy: register the item, tag it with its lot number, and set the **reserve price** before opening the doors.

5. **FUNCTION** `start()`

   - **REQUIRE** auction not already started.
   - **REQUIRE** caller is the `seller`.
   - **TRANSFER** the NFT from `seller` to the auction contract (item moves to the **stage**).
   - **SET** `started = true`.
   - **SET** `endAt = now + 7 days` (auction duration).
   - **EMIT** `Start()`.
   - Analogy: seller hands the item to the auctioneer, who places it on the podium and starts the 7-day countdown.

6. **FUNCTION** `bid()` **payable**

   - **REQUIRE** `started == true` (doors open).
   - **REQUIRE** `now < endAt` (auction still in progress).
   - **REQUIRE** `msg.value > highestBid` (new bid must beat the current leader).
   - If there **is** a previous `highestBidder`:

     - **ACCUMULATE** their refundable balance: `bids[highestBidder] += highestBid`.
     - (Analogy: the previous leader’s paddle deposit gets moved to the **refund counter**.)

   - **SET** `highestBidder = msg.sender`.
   - **SET** `highestBid = msg.value`.
   - **EMIT** `Bid(msg.sender, msg.value)`.
   - Analogy: you raise your paddle with a **higher amount**; the previous leader steps aside and can later collect their deposit from the cashier.

7. **FUNCTION** `withdraw()`

   - **READ** `bal = bids[msg.sender]`.
   - **SET** `bids[msg.sender] = 0`.
   - **SEND** `bal` to `msg.sender`.
   - **EMIT** `Withdraw(msg.sender, bal)`.
   - Analogy: go to the **refund counter**, show your ticket, and get your money back because you were outbid.

8. **FUNCTION** `end()`

   - **REQUIRE** `started == true` (auction was opened).
   - **REQUIRE** `now >= endAt` (time’s up, gavel time).
   - **REQUIRE** `ended == false` (can’t end twice).
   - **SET** `ended = true`.
   - If there **is** a `highestBidder`:

     - **TRANSFER** the NFT from auction contract to `highestBidder` via `safeTransferFrom(...)`.
     - **PAY** the `seller` the `highestBid`.

   - Else (no bids above starting price):

     - **RETURN** NFT back to `seller`.

   - **EMIT** `End(highestBidder, highestBid)`.
   - Analogy: the auctioneer bangs the **gavel**. If someone won, the item goes to the winner and the seller gets the proceeds; otherwise, the item is returned to the seller.

9. **EDGE CASES & SAFETY NOTES**

   - **Only seller can start**; ensures the contract holds the NFT before accepting bids.
   - **Bids must strictly increase**; guarantees a single leader at any time.
   - **Pull over push** refunds: outbid funds sit in `bids[]` and are **withdrawn by the bidder**, reducing re-entrancy risk.
   - **`safeTransferFrom` on end** ensures the recipient can handle NFTs (if it’s a contract).
   - **Time gating**: bids rejected after `endAt`, and `end()` requires the auction to be finished and not already ended.

10. **TYPICAL LIFECYCLE (Story Time)**

    - **Setup**: Seller deploys auction with item info and starting price.
    - **Start**: Seller calls `start()`, moving the NFT into the auction and opening a 7-day bidding window.
    - **Bidding**: Participants call `bid()` with higher amounts. Each time, the previous leader’s money becomes withdrawable via `withdraw()`.
    - **Finish**: After `endAt`, anyone calls `end()` to finalize: NFT → winner, funds → seller; or NFT returns to seller if no valid bids.
    - **Refunds**: Outbid bidders call `withdraw()` anytime to reclaim their deposits.

11. **END**

---

### 🔎 Quick Reference

- **start()** → moves NFT to contract, opens auction, sets end time.
- **bid()** (payable) → must exceed current `highestBid`; previous leader’s bid becomes withdrawable.
- **withdraw()** → outbid bidders reclaim their ETH.
- **end()** → after time, send NFT to winner & pay seller (or return NFT if no winner).

**Analogy Recap:**
Auction contract = **auction house**
NFT = **unique art piece on the podium**
`bid()` = **paddle raise**
`withdraw()` = **refund counter**
`end()` = **gavel** and **settlement**.
