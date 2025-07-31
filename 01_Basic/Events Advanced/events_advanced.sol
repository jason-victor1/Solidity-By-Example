// SPDX-License-Identifier: MIT
// 🪪 Open-source license to allow reuse

pragma solidity ^0.8.14;
// 🛠️ Solidity version 0.8.14 or higher

/// @title 📰 Event-Driven Architecture Example
/// @author 
/// @notice Demonstrates how smart contracts emit events and how other contracts subscribe to them.
/// @dev This code covers both emission and reaction to on-chain events using interfaces.

// -------------------------------------------
// Event-Driven Logic Contract
// -------------------------------------------
contract EventDrivenArchitecture {
    /// @notice 📣 Emitted when a transfer is started
    /// @param from 👤 The address initiating the transfer
    /// @param to 🛋 The recipient of the transfer
    /// @param value 💵 The amount being transferred
    event TransferInitiated(
        address indexed from, address indexed to, uint256 value
    );

    /// @notice 📅 Emitted when a transfer is confirmed
    /// @param from 👤 The confirmer's address
    /// @param to 🛋 Placeholder recipient (contract)
    /// @param value 💵 Set to 0 in this context
    event TransferConfirmed(
        address indexed from, address indexed to, uint256 value
    );

    /// @dev Mapping to track confirmed transfers using a transfer ID
    mapping(bytes32 => bool) public transferConfirmations;

    /// @notice ⏰ Start a new transfer by logging it
    /// @param to The address that will receive the transfer
    /// @param value The amount to transfer
    function initiateTransfer(address to, uint256 value) public {
        emit TransferInitiated(msg.sender, to, value);
        // ... (additional logic to initiate the transfer)
    }

    /// @notice 🔢 Confirm a transfer using its ID
    /// @param transferId A unique identifier for the transfer
    function confirmTransfer(bytes32 transferId) public {
        require(
            !transferConfirmations[transferId], "Transfer already confirmed"
        );
        transferConfirmations[transferId] = true;
        emit TransferConfirmed(msg.sender, address(this), 0);
        // ... (additional logic to confirm the transfer)
    }
}

// -------------------------------------------
// Interface for Subscribers
// -------------------------------------------
interface IEventSubscriber {
    /// @notice Handler for when a transfer event occurs
    /// @param from 👤 Sender address
    /// @param to 🛋 Recipient address
    /// @param value 💵 Amount transferred
    function handleTransferEvent(address from, address to, uint256 value)
        external;
}

// -------------------------------------------
// Event Subscription Manager
// -------------------------------------------
contract EventSubscription {
    /// @notice 🔔 Emitted whenever a transfer is triggered
    /// @param from Sender of the value
    /// @param to Recipient of the value
    /// @param value Amount transferred
    event LogTransfer(address indexed from, address indexed to, uint256 value);

    mapping(address => bool) public subscribers;
    address[] public subscriberList;

    /// @notice 📅 Subscribe to receive notifications
    function subscribe() public {
        require(!subscribers[msg.sender], "Already subscribed");
        subscribers[msg.sender] = true;
        subscriberList.push(msg.sender);
    }

    /// @notice 📄 Unsubscribe from notifications
    function unsubscribe() public {
        require(subscribers[msg.sender], "Not subscribed");
        subscribers[msg.sender] = false;
        for (uint256 i = 0; i < subscriberList.length; i++) {
            if (subscriberList[i] == msg.sender) {
                subscriberList[i] = subscriberList[subscriberList.length - 1];
                subscriberList.pop();
                break;
            }
        }
    }

    /// @notice 🚀 Perform a transfer and notify subscribers
    /// @param to The recipient address
    /// @param value The amount to transfer
    function transfer(address to, uint256 value) public {
        emit LogTransfer(msg.sender, to, value);
        for (uint256 i = 0; i < subscriberList.length; i++) {
            IEventSubscriber(subscriberList[i]).handleTransferEvent(
                msg.sender, to, value
            );
        }
    }
}
