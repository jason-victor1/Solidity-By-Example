// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title IERC20 (Minimal)
 * @notice Minimal ERC20 interface used by the crowdfunding platform.
 * @dev
 * 💳 Real-World Analogy:
 * This is the **bank’s API** for moving digital vouchers.
 * - `transferFrom` = an **authorized auto-debit** from a supporter to the platform.
 * - `transfer`     = a **manual payout** from the platform back to someone.
 */
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount)
        external
        returns (bool);
}

/**
 * @title CrowdFund
 * @notice Token-based crowdfunding with launch, pledge/unpledge, claim, and refund.
 * @dev
 * 🧰 Real-World Analogy:
 * Imagine a **community bulletin board**:
 * - Creators **pin a project poster** with a funding goal and open/close dates.
 * - Supporters **drop tokens** into that project’s box during the open window.
 * - If the poster meets its goal by the deadline, the creator **collects the box**.
 * - If not, supporters **retrieve their tokens** from the refund desk.
 *
 * 🔒 Design Notes:
 * - Uses the **pull payment pattern** for refunds and unpledges.
 * - Requires supporters to `approve` before `transferFrom` can pull tokens.
 * - Enforces phase guards (not started / in progress / ended) to keep actions valid.
 */
contract CrowdFund {
    /**
     * @notice Emitted when a new campaign is created.
     * @param id       Campaign identifier (auto-incremented).
     * @param creator  Address of the campaign owner.
     * @param goal     Target amount of tokens to raise.
     * @param startAt  Timestamp when pledging can begin (inclusive).
     * @param endAt    Timestamp when pledging ends (inclusive).
     * @dev 📣 Analogy: A **new poster** is pinned to the community board.
     */
    event Launch(
        uint256 id,
        address indexed creator,
        uint256 goal,
        uint32 startAt,
        uint32 endAt
    );

    /**
     * @notice Emitted when a campaign is canceled before it starts.
     * @param id Campaign identifier.
     * @dev 🛑 Analogy: The **poster is taken down** before doors open.
     */
    event Cancel(uint256 id);

    /**
     * @notice Emitted when someone pledges tokens to a campaign.
     * @param id      Campaign identifier.
     * @param caller  Pledger’s address.
     * @param amount  Amount pledged.
     * @dev 💪 Analogy: A supporter **drops tokens** into the project’s box.
     */
    event Pledge(uint256 indexed id, address indexed caller, uint256 amount);

    /**
     * @notice Emitted when someone unpledges (withdraws) tokens before campaign end.
     * @param id      Campaign identifier.
     * @param caller  Backer’s address.
     * @param amount  Amount unpledged and returned.
     * @dev 🔁 Analogy: A supporter **pulls tokens back** from the box before the clock runs out.
     */
    event Unpledge(uint256 indexed id, address indexed caller, uint256 amount);

    /**
     * @notice Emitted when the creator claims funds after reaching the goal.
     * @param id Campaign identifier.
     * @dev 🏁 Analogy: The organizer **collects the box** after a successful drive.
     */
    event Claim(uint256 id);

    /**
     * @notice Emitted when a backer takes a refund after a failed campaign.
     * @param id      Campaign identifier.
     * @param caller  Backer receiving the refund.
     * @param amount  Refunded amount.
     * @dev 💸 Analogy: The **refund desk** returns a supporter’s contribution if the goal wasn’t met.
     */
    event Refund(uint256 id, address indexed caller, uint256 amount);

    /**
     * @notice Campaign metadata and accounting.
     * @dev
     * 🗂️ Analogy: A **project card** pinned to the board with its status and totals.
     */
    struct Campaign {
        address creator;   // 👤 Project owner
        uint256 goal;      // 🎯 Target to reach
        uint256 pledged;   // 📈 Running total pledged
        uint32 startAt;    // 🕰️ When pledging can begin
        uint32 endAt;      // 🕛 When pledging ends
        bool claimed;      // ✅ Creator already claimed after success?
    }

    /// @notice ERC20 token used for contributions.
    /// @dev 🏦 Analogy: The **currency** accepted by the platform.
    IERC20 public immutable token;

    /// @notice Total campaigns ever created; also the next ID to assign.
    /// @dev 🔢 Analogy: The **poster count**—each new poster gets the next number.
    uint256 public count;

    /// @notice Mapping from campaign id to its `Campaign` data.
    /// @dev 📇 Analogy: The **card catalog** for posters.
    mapping(uint256 => Campaign) public campaigns;

    /// @notice Per-campaign per-backer pledged amounts.
    /// @dev ✉️ Analogy: Inside each poster’s folder, envelopes tally each supporter’s contribution.
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

    /**
     * @notice Set the ERC20 token this platform accepts.
     * @param _token Address of the ERC20 contract used for pledges and payouts.
     */
    constructor(address _token) {
        token = IERC20(_token);
    }

    /**
     * @notice Create a new campaign with goal and time window.
     * @dev
     * Requirements:
     * - `_startAt >= now` (can’t start in the past).
     * - `_endAt >= _startAt` (must end after it starts).
     * - `_endAt <= now + 90 days` (limit max duration).
     *
     * 🧾 Analogy:
     * Pin a **new poster** with a target and a start/end date.
     *
     * @param _goal    Target amount of tokens to raise.
     * @param _startAt When pledging can begin.
     * @param _endAt   When pledging stops.
     */
    function launch(uint256 _goal, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt, "end at < start at");
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");

        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    /**
     * @notice Cancel a campaign before it starts.
     * @dev
     * Requirements:
     * - Caller must be the campaign `creator`.
     * - Current time must be before `startAt`.
     *
     * 🛑 Analogy:
     * Take the **poster down** before the fundraiser opens—no one has pledged yet.
     *
     * @param _id Campaign identifier to cancel.
     */
    function cancel(uint256 _id) external {
        Campaign memory campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp < campaign.startAt, "started");

        delete campaigns[_id];
        emit Cancel(_id);
    }

    /**
     * @notice Pledge tokens to an active campaign.
     * @dev
     * Requirements:
     * - Now within `[startAt, endAt]`.
     * - Caller must have approved this contract for `_amount` beforehand.
     * Effects:
     * - Increases total and per-backer tallies.
     * - Pulls tokens via `transferFrom`.
     *
     * 💪 Analogy:
     * Drop tokens into the **project’s box** during the open window.
     *
     * @param _id     Campaign ID to support.
     * @param _amount Amount of tokens to pledge.
     */
    function pledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }

    /**
     * @notice Unpledge (withdraw) pledged tokens before the campaign ends.
     * @dev
     * Requirements:
     * - Now must be ≤ `endAt`.
     * Effects:
     * - Decreases total and per-backer tallies.
     * - Returns tokens via `transfer`.
     *
     * 🔁 Analogy:
     * Pull some tokens **back out of the box** before time is up.
     *
     * @param _id     Campaign ID to unpledge from.
     * @param _amount Amount of tokens to withdraw.
     */
    function unpledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }

    /**
     * @notice Creator claims funds after a successful campaign.
     * @dev
     * Requirements:
     * - Caller is campaign `creator`.
     * - Now > `endAt`.
     * - `pledged >= goal`.
     * - Not already `claimed`.
     * Effects:
     * - Marks as claimed and transfers total pledged tokens to the creator.
     *
     * 🏁 Analogy:
     * The organizer **collects the box** after the drive succeeds.
     *
     * @param _id Campaign identifier to claim.
     */
    function claim(uint256 _id) external {
        Campaign storage campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        require(!campaign.claimed, "claimed");

        campaign.claimed = true;
        token.transfer(campaign.creator, campaign.pledged);

        emit Claim(_id);
    }

    /**
     * @notice Backer refund after a failed campaign (goal not met).
     * @dev
     * Requirements:
     * - Now > `endAt`.
     * - `pledged < goal`.
     * Effects:
     * - Zeroes caller’s pledged balance and transfers it back.
     *
     * 💸 Analogy:
     * Visit the **refund desk** to get back exactly what you pledged when the project misses the target.
     *
     * @param _id Campaign identifier to refund from.
     */
    function refund(uint256 _id) external {
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged >= goal");

        uint256 bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
}
