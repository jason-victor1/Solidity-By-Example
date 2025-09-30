// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Token (ERC20-like with Mint + Simple Authorization)
 * @notice Minimal ERC20-style token supporting transfers, allowances, and controlled minting.
 * @dev
 * 💸 Real-World Analogy:
 * - This contract is a **central bank + payment network**.
 * - Normal users can **transfer** funds and **authorize merchants** to spend on their behalf.
 * - Special **licensed printers** (addresses in `authorized`) can **mint new banknotes**.
 *
 * ⚠️ Important:
 * - Arithmetic uses Solidity 0.8+ checked math (auto-reverts on under/overflow), but there are **no balance/allowance guard checks** beyond that.
 *   Calling `transfer`, `transferFrom`, or decreasing allowances without sufficient balances/allowances will **revert**.
 * - No EIP-20 return value checks or safety wrappers around external calls (none are needed here).
 * - This is a didactic, minimal implementation; production tokens typically include pausing, role-based access control, and event-rich mint/burn policies.
 */
contract Token {
    /// @notice Emitted when `value` tokens move from `from` to `to`.
    /// @dev 📢 Analogy: Public ledger announcement “from -> to : amount”.
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// @notice Emitted when `owner` sets `spender`’s allowance to `value`.
    /// @dev 🧾 Analogy: An **IOU slip** the owner signs for the spender’s max charge.
    event Approval(
        address indexed owner, address indexed spender, uint256 value
    );

    /// @notice Total number of tokens in circulation.
    /// @dev 🧮 Analogy: All banknotes currently printed and not destroyed.
    uint256 public totalSupply;

    /// @notice Balance of each address.
    /// @dev 👛 Analogy: Each wallet’s current banknote count.
    mapping(address => uint256) public balanceOf;

    /// @notice Allowance mapping: owner => (spender => amount).
    /// @dev 🧾 Analogy: Signed IOU ledger: who can charge whom, and how much max.
    mapping(address => mapping(address => uint256)) public allowance;

    /// @notice Human-readable token name (e.g., "MyToken").
    string public name;

    /// @notice Human-readable token symbol (e.g., "MTK").
    string public symbol;

    /// @notice Number of decimals for UI display (e.g., 18).
    uint8 public decimals;

    /// @notice Addresses allowed to mint new tokens.
    /// @dev 🖨️ Analogy: **Licensed printing presses**. True = has license.
    mapping(address => bool) public authorized;

    /**
     * @notice Deploy a new token and grant the deployer mint authorization.
     * @dev
     * 🏁 Analogy: Founding the currency—choose its **name**, **symbol**, **denomination**,
     * and appoint the **first licensed printer** (the deployer).
     * @param _name     Token name.
     * @param _symbol   Token symbol.
     * @param _decimals Number of decimals (display precision).
     */
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        authorized[msg.sender] = true;
    }

    /**
     * @notice Grant or revoke mint authorization for `addr`.
     * @dev
     * 🔐 Analogy: The **chief banker** issues or revokes a **printing license**.
     * Requirements:
     * - Caller must be currently authorized.
     * @param addr Address to grant/revoke.
     * @param auth Set `true` to grant; `false` to revoke.
     */
    function setAuthorized(address addr, bool auth) external {
        require(authorized[msg.sender], "not authorized");
        authorized[addr] = auth;
    }

    /**
     * @notice Transfer `amount` tokens to `recipient`.
     * @dev
     * 💸 Analogy: Move banknotes from **your wallet** into **recipient’s wallet**.
     * Effects:
     * - Decreases `balanceOf[msg.sender]` by `amount` (reverts if insufficient).
     * - Increases `balanceOf[recipient]` by `amount`.
     * - Emits {Transfer}.
     * @param recipient The address to receive tokens.
     * @param amount    The number of tokens to send.
     * @return success  Always true on success.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool success)
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @notice Approve `spender` to spend up to `amount` of your tokens via {transferFrom}.
     * @dev
     * 🧾 Analogy: Sign an **IOU slip** letting a merchant charge up to `amount`.
     * Effects:
     * - Sets `allowance[msg.sender][spender] = amount`.
     * - Emits {Approval}.
     * @param spender Address allowed to spend your tokens.
     * @param amount  Maximum spendable amount.
     * @return success Always true on success.
     */
    function approve(address spender, uint256 amount) external returns (bool success) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Move `amount` tokens from `sender` to `recipient` using the caller’s allowance.
     * @dev
     * 🏪 Analogy: The merchant (caller) **charges** the owner’s wallet using the signed IOU,
     * delivering goods to `recipient`.
     * Effects:
     * - Decreases `allowance[sender][msg.sender]` by `amount` (reverts if insufficient).
     * - Decreases `balanceOf[sender]` by `amount` (reverts if insufficient).
     * - Increases `balanceOf[recipient]` by `amount`.
     * - Emits {Transfer}.
     * @param sender    Owner whose tokens are being spent.
     * @param recipient Address receiving the tokens.
     * @param amount    Amount to transfer.
     * @return success  Always true on success.
     */
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool success)
    {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @notice Internal mint function to create `amount` tokens for `to`.
     * @dev
     * 🖨️ Analogy: The printing press **prints new banknotes** and puts them into `to`’s wallet.
     * Effects:
     * - Increases `totalSupply` by `amount`.
     * - Increases `balanceOf[to]` by `amount`.
     * - Emits {Transfer} from `address(0)` to `to`.
     * @param to     Recipient of newly minted tokens.
     * @param amount Amount to mint.
     */
    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    /**
     * @notice Mint `amount` tokens to `to`. Caller must be authorized.
     * @dev
     * 🔑 Analogy: Only **licensed printers** can run the press.
     * Requirements:
     * - `authorized[msg.sender] == true`.
     * Effects: Calls {_mint}.
     * @param to     Recipient of newly minted tokens.
     * @param amount Amount to mint.
     */
    function mint(address to, uint256 amount) external {
        require(authorized[msg.sender], "not authorized");
        _mint(to, amount);
    }
}
