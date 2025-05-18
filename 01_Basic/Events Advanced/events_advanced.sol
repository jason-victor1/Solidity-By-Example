// SPDX-License-Identifier: MIT
// 🪪 Open-source license to allow reuse

pragma solidity ^0.8.14;
// 🛠️ Solidity version 0.8.14 or higher

// 📡 This contract represents a basic system that broadcasts events when transfers are initiated and confirmed.
contract EventDrivenArchitecture {
    // 📢 Event triggered when a new transfer is started
    event TransferInitiated(address indexed from, address indexed to, uint256 value);

    // ✅ Event triggered when a transfer is confirmed
    event TransferConfirmed(address indexed from, address indexed to, uint256 value);

    // 🧾 A registry to track which transfer IDs have already been confirmed
    mapping(bytes32 => bool) public transferConfirmations;

    // 🚚 Function to begin a new transfer — like initiating a package shipment
    function initiateTransfer(address to, uint256 value) public {
        emit TransferInitiated(msg.sender, to, value); // 🔔 Broadcast that a transfer is starting
        // ... (initiate logic could include locking tokens, etc.)
    }

    // ✅ Function to confirm a transfer by transfer ID — like confirming package delivery
    function confirmTransfer(bytes32 transferId) public {
        // ❌ Prevent duplicate confirmations
        require(!transferConfirmations[transferId], "Transfer already confirmed");

        // 🧾 Mark this transfer ID as confirmed
        transferConfirmations[transferId] = true;

        // 📣 Notify that the transfer is confirmed
        emit TransferConfirmed(msg.sender, address(this), 0);
        // ... (actual confirmation logic could unlock funds, update status, etc.)
    }
}

// 🛎️ Interface for any external contract that wants to respond to transfer events
interface IEventSubscriber {
    // 🔁 A hook function that subscribers must implement to react to a transfer
    function handleTransferEvent(address from, address to, uint256 value) external;
}

// 📡 This contract lets people subscribe to updates and get notified when a transfer happens
contract EventSubscription {
    // 📢 Event triggered when a transfer occurs
    event LogTransfer(address indexed from, address indexed to, uint256 value);

    // 📋 Track whether someone is subscribed or not
    mapping(address => bool) public subscribers;

    // 📦 List of all current subscribers
    address[] public subscriberList;

    // ➕ Let a user join the notification list
    function subscribe() public {
        require(!subscribers[msg.sender], "Already subscribed"); // 🚫 Don't let people join twice
        subscribers[msg.sender] = true; // ✅ Mark as subscribed
        subscriberList.push(msg.sender); // 📥 Add to the list
    }

    // ➖ Let a user leave the notification list
    function unsubscribe() public {
        require(subscribers[msg.sender], "Not subscribed"); // 🚫 Can't leave if not in
        subscribers[msg.sender] = false; // ❌ Mark as unsubscribed

        // 🧹 Remove from the list efficiently by swapping with last and popping
        for (uint256 i = 0; i < subscriberList.length; i++) {
            if (subscriberList[i] == msg.sender) {
                subscriberList[i] = subscriberList[subscriberList.length - 1];
                subscriberList.pop();
                break;
            }
        }
    }

    // 🚀 Trigger a transfer and notify all subscribers
    function transfer(address to, uint256 value) public {
        emit LogTransfer(msg.sender, to, value); // 🔔 Broadcast that a transfer happened

        // 📲 Notify every subscriber by calling their custom event handler
        for (uint256 i = 0; i < subscriberList.length; i++) {
            IEventSubscriber(subscriberList[i]).handleTransferEvent(
                msg.sender, to, value
            );
        }
    }
}
