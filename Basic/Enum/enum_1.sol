// SPDX-License-Identifier: MIT              // License identifier indicating open-source status.
pragma solidity ^0.8.26;                     // Specifies the Solidity compiler version.

contract Enum {
    // Define an enum named 'Status' representing the shipping status of an item.
    // Enums in Solidity allow you to create a user-defined type with a finite set of values.
    enum Status {
        Pending,   // 0: The default state, indicating the item is pending shipment.
        Shipped,   // 1: The item has been shipped.
        Accepted,  // 2: The item has been accepted by the recipient.
        Rejected,  // 3: The item was rejected.
        Canceled   // 4: The shipment has been canceled.
    }

    // Declare a public state variable 'status' of type 'Status'.
    // Since enums default to the first element, 'status' is initially set to 'Pending' (0).
    Status public status;

    // Function to get the current shipping status.
    // Although the function returns an enum type, under the hood it corresponds to a uint value.
    // For example:
    //  - Pending  is 0
    //  - Shipped  is 1
    //  - Accepted is 2
    //  - Rejected is 3
    //  - Canceled is 4
    function get() public view returns (Status) {
        return status;
    }

    // Function to update the shipping status.
    // It accepts a parameter of type 'Status' and assigns it to the state variable 'status'.
    function set(Status _status) public {
        status = _status;
    }

    // Function to update the status to a specific value, 'Canceled'.
    // This demonstrates that you can set an enum value directly using its name.
    function cancel() public {
        status = Status.Canceled;
    }

    // Function to reset the status.
    // The 'delete' keyword resets the variable to its default value, which is the first value in the enum ('Pending').
    function reset() public {
        delete status;
    }
}
