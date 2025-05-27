// SPDX-License-Identifier: MIT
// 🪪 Open-source license tag—this contract uses the permissive MIT license.

pragma solidity ^0.8.26;
// 🛠️ Specifies the Solidity compiler version—ensures compatibility and safety checks.

contract Counter {
// 🧮 A simple counter contract that tracks a single public number.

    uint256 public count;
    // 📟 Public scoreboard—anyone can view the current count.

    function increment() external {
        count += 1; 
        // ➕ Increases the count by 1—can only be triggered externally.
    }
}

interface ICounter {
// 🧩 Interface to interact with any `Counter`-like contract remotely.

    function count() external view returns (uint256);
    // 🔍 Lets external callers read the current count.

    function increment() external;
    // 🔘 Allows external contracts to increment the counter.
}

contract MyContract {
// 🤖 This contract acts as a remote controller for any Counter-compatible contract.

    function incrementCounter(address _counter) external {
        ICounter(_counter).increment(); 
        // 🔗 Calls the `increment()` function on another contract via its address.
    }

    function getCount(address _counter) external view returns (uint256) {
        return ICounter(_counter).count(); 
        // 🔎 Reads the `count` value from the specified counter contract.
    }
}

// Uniswap example

interface UniswapV2Factory {
// 🏗️ Interface for the Uniswap V2 Factory—used to get token pair addresses.

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
        // 🔁 Returns the pair contract address for the given two tokens.
}

interface UniswapV2Pair {
// 🧪 Interface for Uniswap token pairs—used to retrieve liquidity info.

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
        // 💧 Returns the token reserves and last block timestamp.
}

contract UniswapExample {
// 🧾 Demonstrates how to retrieve liquidity pool reserves for a DAI/WETH pair on Uniswap.

    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    // 🏭 Address of the Uniswap V2 Factory on Ethereum mainnet.

    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // 💵 DAI token address.

    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // 🪙 Wrapped Ether (WETH) token address.

    function getTokenReserves() external view returns (uint256, uint256) {
        address pair = UniswapV2Factory(factory).getPair(dai, weth);
        // 🔗 Retrieves the DAI/WETH pair contract address from the factory.

        (uint256 reserve0, uint256 reserve1,) =
            UniswapV2Pair(pair).getReserves();
        // 💧 Reads reserve balances for DAI and WETH from the pair contract.

        return (reserve0, reserve1);
        // 📤 Returns the reserves to the external caller.
    }
}