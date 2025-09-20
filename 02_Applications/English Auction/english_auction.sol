// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title IERC721 (Minimal)
 * @notice Minimal NFT interface needed for the auction: safe and unsafe transfers.
 * @dev
 * 🖼️ Real-World Analogy:
 * This is the **handover form** for a unique collectible.
 * - `transferFrom`: like manually handing the painting to the auction house.
 * - `safeTransferFrom`: like handing it over only if the recipient can properly store art.
 */
interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
}

/**
 * @title EnglishAuction
 * @notice Simple 7-day English auction for a single ERC-721 token (highest bid wins).
 * @dev
 * 🏛️ Real-World Analogy:
 * Think of a **live auction house** for one rare painting.
 * - `start`: the seller places the painting on the podium and the auction begins.
 * - `bid`: people raise their paddles with ever-higher offers.
 * - `withdraw`: outbid bidders pick up their refundable deposits from the cashier.
 * - `end`: the gavel falls—painting goes to the highest bidder, proceeds go to the seller.
 *
 * 🔒 Safety & Design:
 * - **Pull refunds**: Outbid funds are stored and later **withdrawn** by bidders (reduces re-entrancy risk).
 * - **Time-gated**: Bids accepted only before `endAt`; `end` finalizes once time passes.
 * - **Escrowed NFT**: Auction contract must hold the NFT while bidding to guarantee delivery at settlement.
 */
contract EnglishAuction {
    /**
     * @notice Emitted once when the auction officially starts.
     * @dev 🎀 Analogy: Cutting the ribbon to open the auction hall.
     */
    event Start();

    /**
     * @notice Emitted on each successful higher bid.
     * @param sender Address of the bidder who now leads.
     * @param amount New highest bid amount (in wei).
     * @dev 🪪 Analogy: The auctioneer calls out the bidder’s paddle number and bid.
     */
    event Bid(address indexed sender, uint256 amount);

    /**
     * @notice Emitted when an outbid participant withdraws their refundable balance.
     * @param bidder Address receiving the refund.
     * @param amount Amount refunded (in wei).
     * @dev 💵 Analogy: Cashier returns the bidder’s deposit after being outbid.
     */
    event Withdraw(address indexed bidder, uint256 amount);

    /**
     * @notice Emitted when the auction is finalized.
     * @param winner Address that won the NFT (zero address if no winning bid).
     * @param amount Final sale price paid to the seller (0 if no winner).
     * @dev 🔨 Analogy: The gavel falls; the painting is handed to the winner, proceeds to the seller.
     */
    event End(address winner, uint256 amount);

    /// @notice The NFT contract hosting the token being auctioned.
    IERC721 public nft;

    /// @notice The specific token ID of the NFT being auctioned.
    uint256 public nftId;

    /// @notice Seller (consignor) who owns the NFT and receives proceeds.
    address payable public seller;

    /// @notice UNIX timestamp when bidding closes (set 7 days after `start`).
    uint256 public endAt;

    /// @notice True once `start()` has been called and the NFT has been escrowed.
    bool public started;

    /// @notice True once `end()` has finalized the auction.
    bool public ended;

    /// @notice Current leading bidder (address(0) means no valid bids yet).
    address public highestBidder;

    /// @notice Current leading bid amount in wei.
    uint256 public highestBid;

    /// @notice Refundable balances for previously outbid bidders.
    mapping(address => uint256) public bids;

    /**
     * @notice Initialize auction parameters (NFT, token ID, and opening bid).
     * @dev
     * - Sets the seller to the deployer.
     * - Does not transfer the NFT here; that occurs on `start()`.
     *
     * 🎫 Analogy: Register the lot, tag it with a starting price, and identify the consignor.
     *
     * @param _nft Address of the ERC-721 contract.
     * @param _nftId ID of the specific NFT to auction.
     * @param _startingBid Minimum opening price (reserve).
     */
    constructor(address _nft, uint256 _nftId, uint256 _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    /**
     * @notice Start the auction by escrowing the NFT into this contract and opening a 7-day window.
     * @dev
     * Requirements:
     * - Not already started.
     * - Caller must be the seller.
     * Effects:
     * - Transfers NFT from seller to auction (escrow).
     * - Sets `started = true` and `endAt = block.timestamp + 7 days`.
     *
     * 🧰 Analogy: Seller places the painting on the podium and the auctioneer starts the clock.
     */
    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        // Escrow the NFT in the auction contract to guarantee delivery on settlement.
        nft.transferFrom(msg.sender, address(this), nftId);

        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }

    /**
     * @notice Place a higher bid than the current highest; attaches ETH as the bid amount.
     * @dev
     * Requirements:
     * - Auction must be started.
     * - Current time must be before `endAt`.
     * - `msg.value` must be strictly greater than `highestBid`.
     * Effects:
     * - Previous leader’s bid becomes **withdrawable** via `bids[highestBidder]`.
     * - Updates `highestBidder` and `highestBid` to the new leader.
     *
     * 📣 Analogy: Raise your paddle with a **higher amount**. The former leader’s money is moved to the refund counter.
     */
    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            // Accumulate the previous highest bid for a later withdrawal.
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    /**
     * @notice Withdraw your refundable balance after being outbid.
     * @dev
     * Effects:
     * - Reads the caller’s refundable amount, zeroes it out, and transfers the funds.
     *
     * 💳 Analogy: Visit the **cashier** to reclaim your deposit once someone outbids you.
     */
    function withdraw() external {
        uint256 bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    /**
     * @notice Finalize the auction after the end time: deliver the NFT and pay the seller.
     * @dev
     * Requirements:
     * - Auction must have been started.
     * - Current time must be >= `endAt`.
     * - Auction must not already be ended.
     * Effects:
     * - Marks `ended = true`.
     * - If there is a winner:
     *     * Transfers the NFT to the winner (safe).
     *     * Pays the seller the winning amount.
     *   Else:
     *     * Returns the NFT to the seller.
     *
     * 🔨 Analogy: The auctioneer drops the gavel. If there’s a winner, the painting changes hands and the seller is paid; otherwise the painting returns to the consignor.
     */
    function end() external {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;

        if (highestBidder != address(0)) {
            // Deliver the NFT to the winner and pay the seller.
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            // No valid bids — return the NFT to the seller.
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}