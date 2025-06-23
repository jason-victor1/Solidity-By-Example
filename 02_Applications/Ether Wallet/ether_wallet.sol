// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title EtherWallet
/// @author [Your Name]
/// @notice A basic Ethereum wallet that can receive and withdraw Ether.
/// @dev Think of this contract like a secure piggy bank only the owner can unlock.
contract EtherWallet {
    /// @notice The wallet owner's address
    /// @dev Set to whoever deploys the contract
    address payable public owner;

    /// @notice Constructor sets the deployer as the owner
    /// @dev Equivalent to the person who places the piggy bank on the table
    constructor() {
        owner = payable(msg.sender);
    }

    /// @notice Enables the contract to receive Ether
    /// @dev Ether sent directly to the contract without calling a function is accepted here
    receive() external payable {}

    /// @notice Withdraw a specific amount of Ether from the contract
    /// @dev Only the owner can withdraw. Acts like a lock-and-key system.
    /// @param _amount The amount of Ether (in wei) to withdraw
    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(_amount);
    }

    /// @notice Get the current balance of the contract
    /// @dev Useful for checking how much Ether is saved in the wallet
    /// @return The balance in wei
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
