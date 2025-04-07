// SPDX-License-Identifier: MIT
// Specifies the license under which the code is distributed.

pragma solidity ^0.8.26;

// Declares the Solidity compiler version, ensuring compatibility with 0.8.26 and higher minor versions.

// External contract used for try/catch examples
contract Foo {
    // State variable to store the owner address
    address public owner;

    // Constructor function to initialize the contract
    constructor(address _owner) {
        // Require statement to ensure the owner address is not the zero address
        require(_owner != address(0), "invalid address");

        // Assert statement to ensure the owner address is not a specific invalid address
        assert(_owner != 0x0000000000000000000000000000000000000001);

        // Assign the provided owner address to the `owner` state variable
        owner = _owner;
    }

    // Function that demonstrates input validation using `require`
    function myFunc(uint256 x) public pure returns (string memory) {
        // Ensure that the input `x` is not zero
        require(x != 0, "require failed");

        // Return a success message
        return "my func was called";
    }
}

// Contract that demonstrates the use of try/catch with external calls and contract creation
contract Bar {
    // Event for logging string messages
    event Log(string message);

    // Event for logging raw bytes (useful for debugging)
    event LogBytes(bytes data);

    // State variable to hold an instance of the `Foo` contract
    Foo public foo;

    // Constructor function to initialize the `Bar` contract
    constructor() {
        // Deploy a new `Foo` contract with the sender's address as the owner
        foo = new Foo(msg.sender);
    }

    // Function to demonstrate try/catch with an external call
    // Input `_i` is passed to the `myFunc` function of the `Foo` contract
    function tryCatchExternalCall(uint256 _i) public {
        // Attempt to call `myFunc` on the `Foo` contract
        try foo.myFunc(_i) returns (string memory result) {
            // If successful, emit the returned result
            emit Log(result);
        } catch {
            // If the call fails, emit a failure message
            emit Log("external call failed");
        }
    }

    // Function to demonstrate try/catch with contract creation
    // Input `_owner` is the address used to initialize a new `Foo` contract
    function tryCatchNewContract(address _owner) public {
        // Attempt to create a new instance of the `Foo` contract
        try new Foo(_owner) returns (Foo foo) {
            // If successful, emit a success message
            emit Log("Foo created");
        } catch Error(string memory reason) {
            // Catch and handle failures caused by `require` or `revert`
            emit Log(reason);
        } catch (bytes memory reason) {
            // Catch and handle failures caused by `assert`
            emit LogBytes(reason);
        }
    }
}
