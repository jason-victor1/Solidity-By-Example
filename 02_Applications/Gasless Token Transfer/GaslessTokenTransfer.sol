// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title IERC20Permit
 * @dev ERC-20 interface extended with EIP-2612 `permit` (gasless approvals).
 *
 * 📨 Real-World Analogy:
 * Standard banking + a **signed letter of authorization**:
 * - You sign a paper (off-chain, no gas) that lets a spender use up to `value`
 *   of your tokens before `deadline`.
 * - Anyone can take that paper to the bank (on-chain `permit`) and the bank
 *   updates your **card limit** (allowance) without you calling `approve`.
 *
 * ⚙️ Practical Notes:
 * - EIP-2612 typically includes per-owner **nonces** and EIP-712 typed data.
 * - The token contract is responsible for signature verification, deadline checks,
 *   and nonce consumption (prevents replay).
 */
interface IERC20Permit {
    /**
     * @notice Total number of tokens in existence.
     * @return Total supply.
     *
     * 🏦 Analogy: The mint’s ledger of how many notes were printed.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice Balance of `account`.
     * @param account The wallet to query.
     * @return The token amount held.
     *
     * 👛 Analogy: How much money is in this account?
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @notice Transfer tokens from caller to `recipient`.
     * @param recipient Receiver address.
     * @param amount Amount to send.
     * @return success True on success.
     *
     * 🤝 Analogy: Handing cash directly to someone.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool success);

    /**
     * @notice Remaining allowance `spender` can draw from `owner`.
     * @param owner The token holder.
     * @param spender The authorized spender.
     * @return remaining Unused allowance.
     *
     * 💳 Analogy: Check the remaining card limit the bank has on file.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);

    /**
     * @notice Approve `spender` to spend up to `amount` from caller’s balance.
     * @param spender Address allowed to spend.
     * @param amount Allowance to set.
     * @return success True on success.
     *
     * 🖊️ Analogy: Walk to the bank and set a card limit in person.
     */
    function approve(address spender, uint256 amount)
        external
        returns (bool success);

    /**
     * @notice Spender pulls `amount` from `sender` and sends to `recipient`.
     * @param sender Token owner to debit.
     * @param recipient Recipient to credit.
     * @param amount Amount to move.
     * @return success True on success.
     *
     * 🔄 Analogy: Use the card to pay a merchant from the owner’s account.
     */
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool success);

    /**
     * @notice Approve by signature (EIP-2612). Sets allowance for `spender` from `owner`
     *         to `value`, valid until `deadline`, if `(v,r,s)` is a valid signature.
     * @param owner Token owner granting the allowance.
     * @param spender Allowed spender.
     * @param value Allowance amount to set.
     * @param deadline Timestamp after which the permit is invalid.
     * @param v Signature recovery id.
     * @param r Signature parameter r.
     * @param s Signature parameter s.
     *
     * 📨 Analogy:
     * Owner signs a paper at home. A courier submits it to the bank.
     * The bank verifies the handwriting and date, then updates the card limit.
     *
     * ⚠️ Security:
     * - Tokens following EIP-2612 should verify EIP-712 domain, `owner`’s nonce,
     *   and `deadline` to prevent replay or cross-domain misuse.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

/**
 * @title GaslessTokenTransfer
 * @dev Moves tokens for a user **without the user paying gas** by combining:
 *      1) EIP-2612 `permit` to grant allowance via signature, then
 *      2) `transferFrom` to deliver tokens to a receiver and a relayer fee.
 *
 * 🧭 Real-World Analogy:
 * A **concierge** service:
 * - You (the user) sign a letter authorizing up to `amount + fee`.
 * - The concierge takes the letter to the bank (on-chain), the bank sets the card limit.
 * - The concierge pays your bill (`amount` → `receiver`) and collects a tip (`fee`).
 * - You didn’t need postage (ETH) — concierge covered it.
 */
contract GaslessTokenTransfer {
    /**
     * @notice Execute a gasless token transfer using EIP-2612 `permit` + `transferFrom`.
     * @param token Address of the ERC-20 with `permit` support.
     * @param sender Token owner who signed the permit.
     * @param receiver Final destination of `amount`.
     * @param amount Tokens to send to `receiver`.
     * @param fee Tokens to pay the relayer (caller) for gas/service.
     * @param deadline Last valid timestamp for the permit.
     * @param v Signature `v` (recovery id).
     * @param r Signature `r`.
     * @param s Signature `s`.
     *
     * 🧪 Flow (All-or-Nothing):
     * 1) `permit(sender, this, amount + fee, deadline, v,r,s)` → set allowance by signature.
     * 2) `transferFrom(sender, receiver, amount)` → pay the merchant.
     * 3) `transferFrom(sender, msg.sender, fee)` → pay the concierge.
     *
     * 🛡️ Safety Considerations:
     * - `deadline` should be reasonable to limit exposure.
     * - The underlying token should implement full EIP-2612 (nonce/domain checks).
     * - This function assumes `permit` sets or raises allowance to cover `amount + fee`.
     */
    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        // EIP-2612 signature
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // 1) Gasless approval via signature (sets allowance for this contract)
        IERC20Permit(token).permit(
            sender, address(this), amount + fee, deadline, v, r, s
        );

        // 2) Deliver payment to receiver
        //    (drawn from `sender` using the freshly set allowance)
        require(
            IERC20Permit(token).transferFrom(sender, receiver, amount),
            "transfer to receiver failed"
        );

        // 3) Collect relayer fee (pay the caller for gas/service)
        require(
            IERC20Permit(token).transferFrom(sender, msg.sender, fee),
            "transfer of fee failed"
        );
    }
}