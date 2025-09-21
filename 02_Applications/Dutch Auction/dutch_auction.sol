// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title IERC721 (Minimal)
 * @notice Minimal interface to transfer an ERC-721 token.
 * @dev
 * 🖼️ Real-World Analogy:
 * This is the **ownership transfer slip** for a unique artwork.
 * - `transferFrom` = handing the painting from one person to another with a signed receipt.
 */
interface IERC721 {
    function transferFrom(address _from, address _to, uint256 _nftId) external;
}

/**
 * @title DutchAuction
 * @notice A 7-day Dutch auction for a single NFT where the price starts high and decreases linearly over time.
 * @dev
 * 🏷️ Real-World Analogy:
 * Imagine a gallery with a **countdown price tag**:
 * - At opening, the tag shows the **starting price**.
 * - Every second, the price **ticks down** by `discountRate`.
 * - The first buyer to pay the **current tag price** gets the artwork.
 * - If they hand over extra cash, the cashier gives **change**.
 * - Once sold, the gallery closes this listing forever (contract self-destructs), sending proceeds to the seller.
 *
 * 🔒 Design Notes:
 * - `startingPrice >= discountRate * DURATION` ensures the price never goes below zero during the auction.
 * - All immutable parameters are fixed at deployment for gas efficiency and predictability.
 * - The NFT is transferred directly from `seller` to buyer upon purchase; this contract does not custody the NFT.
 */
contract DutchAuction {
    /// @notice Fixed auction length (7 days).
    /// @dev ⏳ Analogy: The gallery sets a one-week countdown clock.
    uint256 private constant DURATION = 7 days;

    /// @notice The NFT contract for the item being sold.
    /// @dev 🖼️ Analogy: The gallery’s catalog system that tracks the artwork.
    IERC721 public immutable nft;

    /// @notice The token ID of the NFT being sold.
    /// @dev 🧾 Analogy: The specific lot number of the artwork.
    uint256 public immutable nftId;

    /// @notice The seller who owns the NFT and receives sale proceeds.
    /// @dev 👤 Analogy: The consignor listing their artwork in the gallery.
    address payable public immutable seller;

    /// @notice The initial price at which the auction begins.
    /// @dev 💰 Analogy: The opening number on the countdown price tag.
    uint256 public immutable startingPrice;

    /// @notice Timestamp when the auction started.
    /// @dev 🕰️ Analogy: The moment the gallery doors opened for this listing.
    uint256 public immutable startAt;

    /// @notice Timestamp when the auction expires (no more purchases allowed).
    /// @dev 🚪 Analogy: Closing time—once reached, the painting is no longer for sale here.
    uint256 public immutable expiresAt;

    /// @notice Amount the price decreases per second.
    /// @dev 📉 Analogy: The tick-rate of the countdown price tag.
    uint256 public immutable discountRate;

    /**
     * @notice Configure a Dutch auction for a specific NFT.
     * @dev
     * Requirements:
     * - `startingPrice >= discountRate * DURATION` to prevent the price from going negative.
     *
     * 🎨 Analogy:
     * The seller places the painting in the gallery system,
     * sets the **opening price**, decides how **fast the price drops**,
     * and sets the **one-week window**.
     *
     * @param _startingPrice The price at auction start.
     * @param _discountRate  How much the price drops each second.
     * @param _nft           Address of the ERC-721 contract.
     * @param _nftId         Token ID of the NFT to sell.
     */
    constructor(
        uint256 _startingPrice,
        uint256 _discountRate,
        address _nft,
        uint256 _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        discountRate = _discountRate;

        // Ensure the price never goes below zero during the full duration.
        require(_startingPrice >= _discountRate * DURATION, "starting price < min");

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    /**
     * @notice Current price of the NFT according to the linear discount schedule.
     * @dev
     * Computation:
     * - `timeElapsed = now - startAt`
     * - `discount   = discountRate * timeElapsed`
     * - `price      = startingPrice - discount`
     *
     * 🧮 Analogy:
     * Look at the **countdown tag**: as seconds pass, the number ticks down by a fixed rate.
     *
     * @return The price a buyer must pay **right now** to purchase.
     */
    function getPrice() public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - startAt;
        uint256 discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    /**
     * @notice Purchase the NFT at the current price; refunds overpayment and closes the auction.
     * @dev
     * Flow:
     * 1) Require the auction is still active (`now < expiresAt`).
     * 2) Compute the current price with {getPrice()}.
     * 3) Require `msg.value >= price`.
     * 4) Transfer the NFT directly from `seller` to buyer.
     * 5) Refund any excess ETH sent.
     * 6) `selfdestruct(seller)` sends remaining balance to seller and removes the auction forever.
     *
     * 🛒 Analogy:
     * A buyer walks in, sees the **current tag price**, pays it, gets the painting,
     * receives **change** if they overpay, and the gallery immediately closes this listing and
     * hands all proceeds to the seller.
     *
     * @custom:security Consider ensuring the seller has approved this contract
     * to transfer the NFT beforehand if a different transfer mechanism is used.
     */
    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");

        uint256 price = getPrice();
        require(msg.value >= price, "ETH < price");

        // Transfer the artwork to the buyer.
        nft.transferFrom(seller, msg.sender, nftId);

        // Return change if buyer overpaid.
        uint256 refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        // Close the auction permanently; forward remaining ETH to the seller.
        selfdestruct(seller);
    }
}
