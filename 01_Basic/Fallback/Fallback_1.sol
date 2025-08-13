                 send Ether
                      |
           msg.data is empty?
                /           \
            yes             no
             |                |
    receive() exists?     fallback()
        /        \
     yes          no
      |            |
  receive()     fallback()

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Fallback
 * @dev Demonstrates the difference between `receive()` and `fallback()` functions in Solidity.
 * 🏠 Analogy: Think of this contract as a house with:
 *   - **Front door (receive)**: For deliveries with no message.
 *   - **Side door (fallback)**: For deliveries with strange notes or unexpected instructions.
 */
contract Fallback {
    /// @notice Logs when a fallback or receive function is called, and how much gas is left.
    /// @param func The function triggered ("fallback" or "receive").
    /// @param gas The remaining gas at the time of function execution.
    event Log(string func, uint256 gas);

    /**
     * @notice Triggered when Ether is sent and:
     *  - `msg.data` is not empty, OR
     *  - There’s no `receive()` function defined.
     * @dev Declared as `external` and `payable` to accept Ether.
     * 📦 Analogy: The side door is used when the delivery man brings a package with odd instructions.
     */
    fallback() external payable {
        // `transfer` and `send` only give you 2300 gas here
        // `call` can forward all gas
        emit Log("fallback", gasleft());
    }

    /**
     * @notice Triggered when Ether is sent with no data.
     * @dev A variant of `fallback()` optimized for simple transfers.
     * 📦 Analogy: The front door is for packages with no note attached.
     */
    receive() external payable {
        emit Log("receive", gasleft());
    }

    /**
     * @notice Returns the current Ether balance of this contract.
     * @return The balance in wei.
     * 💰 Analogy: Checking how much cash is inside your house safe.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

/**
 * @title SendToFallback
 * @dev Demonstrates sending Ether to a contract’s `receive()` or `fallback()` function.
 * 📦 Analogy: Two ways to deliver money to someone’s house — either via a strict courier (transfer) or a flexible delivery service (call).
 */
contract SendToFallback {
    /**
     * @notice Sends Ether using `.transfer()`, which can only trigger `receive()` or `fallback()` with 2300 gas.
     * @param _to The payable address of the recipient.
     * 📬 Analogy: Hand-delivering a small cash envelope — you can’t give them extra time to do complex tasks.
     */
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    /**
     * @notice Sends Ether using `.call()`, forwarding all remaining gas and allowing more complex logic in `fallback()` or `receive()`.
     * @param _to The payable address of the recipient.
     * 📬 Analogy: Sending a courier who can stay as long as needed to help unpack the delivery.
     */
    function callFallback(address payable _to) public payable {
        (bool sent,) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}