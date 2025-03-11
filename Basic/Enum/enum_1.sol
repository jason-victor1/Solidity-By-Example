// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Enum {
    // Define an enumeration called Status that represents different shipping statuses.
    // Enumerations in Solidity are a way to create user-defined types with a finite set of values.
    enum Status {
        Pending,    // 0 - The default status, indicating the shipping process hasn't started.
        Shipped,    // 1 - Indicates that the item has been shipped.
        Accepted,   // 2 - Indicates that the item has been received and accepted.
        Rejected,   // 3 - Indicates that the item has been received but rejected.
        Canceled    // 4 - Indicates that the shipping process was canceled.
    }

    // Declare a state variable 'status' of type Status.
    // By default, this variable is initialized to the first element in the enum, which is 'Pending'.
    Status public status;

    // Function: get
    // This function is a public view function that returns the current value of the status variable.
    // Since enums are represented as uint under the hood:
    // Pending  - 0, Shipped  - 1, Accepted - 2, Rejected - 3, Canceled - 4.
    function get() public view returns (Status) {
        return status;
    }

    // Function: set
    // This function allows updating the 'status' state variable.
    // It takes an input of type Status and sets the state variable 'status' to this value.
    function set(Status _status) public {
        status = _status;
    }

    // Function: cancel
    // This function provides a convenient way to set the status to 'Canceled' directly.
    function cancel() public {
        status = Status.Canceled;
    }

    // Function: reset
    // This function resets the 'status' variable to its default value.
    // The 'delete' keyword resets the variable to its default value, which is the first element in the enum (Pending, or 0).
    function reset() public {
        delete status;
    }
}
