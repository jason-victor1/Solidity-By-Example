// SPDX-License-Identifier: MIT
// 🪪 Open-source license tag—this contract uses the permissive MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version—ensures compatibility and safety checks.

/**
 * @title Counter
 * @dev A simple counter contract that increments a stored number.
 * 📟 Think of this like a digital tally counter at a shop's entrance — each press increases the number.
 */
contract Counter {
    /// @notice Current count value
    uint256 public count;

    /**
     * @notice Increase the counter by 1
     * 🖱 Like pressing the "add one" button on a counter device.
     */
    function increment() external {
        count += 1;
    }
}

/**
 * @title ICounter
 * @dev Interface for interacting with any Counter-like contract.
 * 🔌 Think of this like a remote control specification — it defines the buttons but doesn’t store the counter itself.
 */
interface ICounter {
    /// @notice Reads the current counter value
    function count() external view returns (uint256);

    /// @notice Increments the counter by 1
    function increment() external;
}

/**
 * @title MyContract
 * @dev Demonstrates calling another contract via its interface.
 * 📞 Think of this as calling a friend's counter machine to increase their tally.
 */
contract MyContract {
    /**
     * @notice Remotely increments another Counter contract.
     * @param _counter Address of the counter contract.
     * 🔍 Analogy: "Call the remote counter and press its increment button."
     */
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    /**
     * @notice Reads the count from another Counter contract.
     * @param _counter Address of the counter contract.
     * @return Current count from that contract.
     * 🔍 Analogy: "Call the remote counter and ask what number it's showing."
     */
    function getCount(address _counter) external view returns (uint256) {
        return ICounter(_counter).count();
    }
}

/**
 * @title UniswapV2Factory
 * @dev Interface for the Uniswap V2 Factory contract to get trading pairs.
 * 🏭 Think of this as a directory that tells you where two tokens can be traded.
 */
interface UniswapV2Factory {
    /**
     * @notice Finds the trading pair contract for two tokens.
     * @param tokenA Address of the first token.
     * @param tokenB Address of the second token.
     * @return pair Address of the pair contract.
     */
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

/**
 * @title UniswapV2Pair
 * @dev Interface for a Uniswap V2 Pair contract to get reserves.
 * 💰 Think of this like a storage room where you can ask how many of each token it holds.
 */
interface UniswapV2Pair {
    /**
     * @notice Gets the reserves of the two tokens in the pair.
     * @return reserve0 Amount of token0.
     * @return reserve1 Amount of token1.
     * @return blockTimestampLast Last time reserves were updated.
     */
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

/**
 * @title UniswapExample
 * @dev Demonstrates how to query token reserves from Uniswap V2.
 * 🔍 Think of this like asking the Uniswap storehouse, "How many DAI and WETH do you have?"
 */
contract UniswapExample {
    /// @notice Address of the Uniswap V2 factory
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    /// @notice Address of DAI token
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    /// @notice Address of WETH token
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    /**
     * @notice Retrieves the reserves of DAI and WETH from their Uniswap trading pair.
     * @return DAI reserve and WETH reserve.
     * 🛒 Analogy: "Go to the Uniswap warehouse, find the DAI-WETH section, and count how many of each they have."
     */
    function getTokenReserves() external view returns (uint256, uint256) {
        address pair = UniswapV2Factory(factory).getPair(dai, weth);
        (uint256 reserve0, uint256 reserve1,) =
            UniswapV2Pair(pair).getReserves();
        return (reserve0, reserve1);
    }
}
