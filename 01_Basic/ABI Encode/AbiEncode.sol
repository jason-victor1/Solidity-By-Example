// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//
// 🎯 Interface Definition
//

/// @notice Minimal ERC-20 interface for use with abi.encode*() examples
interface IERC20 {
    /// @notice Standard ERC-20 transfer function signature
    /// @param to The recipient address
    /// @param amount The amount of tokens to transfer
    function transfer(address to, uint256 amount) external;
}

//
// 🧱 Dummy ERC-20 Contract
//

/// @notice Dummy contract that mimics an ERC-20 transfer method
contract Token {
    /// @notice Dummy transfer implementation (empty body)
    function transfer(address, uint256) external {}
}

//
// 🧪 ABI Encoding & Calling Demonstration Contract
//

contract AbiEncode {
    
    /// @notice Executes a low-level call on an external contract with pre-encoded data
    /// @dev Uses `.call(data)` to trigger the function call. Returns true if the call succeeded.
    /// @param _contract The address of the target contract
    /// @param data ABI-encoded calldata to send to the contract
    function test(address _contract, bytes calldata data) external {
        // Low-level external call with ABI-encoded payload
        (bool ok,) = _contract.call(data);

        // Revert if call fails
        require(ok, "call failed");
    }

    /// @notice Encodes data using `abi.encodeWithSignature`
    /// @dev Uses string-based signature, which is NOT checked at compile time. Typos can break encoding silently.
    /// @param to Target address for the `transfer`
    /// @param amount Token amount to transfer
    /// @return ABI-encoded byte payload using the function signature
    function encodeWithSignature(address to, uint256 amount)
        external
        pure
        returns (bytes memory)
    {
        // ⛔ WARNING: "transfer(address,uint)" would compile, but silently produce an incorrect selector
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    /// @notice Encodes data using `abi.encodeWithSelector`
    /// @dev Selector comes from interface definition. More type-safe than string-based version, but still prone to argument mismatch.
    /// @param to Target address for the transfer
    /// @param amount Amount to transfer
    /// @return ABI-encoded byte payload using the function selector
    function encodeWithSelector(address to, uint256 amount)
        external
        pure
        returns (bytes memory)
    {
        // ✅ Better than signature strings — derives selector directly from interface
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    /// @notice Encodes data using `abi.encodeCall`
    /// @dev ✅ Most type-safe method. Catches typos and mismatched parameter types at compile-time.
    /// @param to Target address for the transfer
    /// @param amount Amount to transfer
    /// @return ABI-encoded byte payload with full compile-time checks
    function encodeCall(address to, uint256 amount)
        external
        pure
        returns (bytes memory)
    {
        // ✅ Compiler ensures function exists and argument types are correct
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}
