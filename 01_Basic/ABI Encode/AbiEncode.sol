// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Define an interface for the ERC20 standard
interface IERC20 {
    // Function declaration for transferring tokens
    // Parameters:
    // - address: recipient of the tokens
    // - uint256: amount of tokens to transfer
    function transfer(address, uint256) external;
}

// Define a contract named `Token`
contract Token {
    // Dummy implementation of the `transfer` function
    // Does nothing in this case
    function transfer(address, uint256) external {}
}

// Define a contract to demonstrate ABI encoding techniques
contract AbiEncode {
    // A function to test a low-level call to another contract
    // Parameters:
    // - _contract: address of the target contract
    // - data: raw bytes of encoded data to call the target contract
    function test(address _contract, bytes calldata data) external {
        // Perform a low-level call to the target contract with the provided data
        (bool ok, ) = _contract.call(data);
        // Revert the transaction if the call fails
        require(ok, "call failed");
    }

    // A function to encode data using `abi.encodeWithSignature`
    // Parameters:
    // - to: recipient address
    // - amount: number of tokens to transfer
    // Returns: raw bytes of the encoded function call
    function encodeWithSignature(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        // Encode the `transfer` function call with its signature and parameters
        // Note: Typos in the signature are not checked by the compiler
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    // A function to encode data using `abi.encodeWithSelector`
    // Parameters:
    // - to: recipient address
    // - amount: number of tokens to transfer
    // Returns: raw bytes of the encoded function call
    function encodeWithSelector(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        // Encode the `transfer` function call with its selector and parameters
        // Note: The selector is the first 4 bytes of the Keccak256 hash of the function signature
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    // A function to encode data using `abi.encodeCall`
    // Parameters:
    // - to: recipient address
    // - amount: number of tokens to transfer
    // Returns: raw bytes of the encoded function call
    function encodeCall(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        // Encode the `transfer` function call with type and argument validation
        // Note: The compiler will check for typos and argument types
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}
