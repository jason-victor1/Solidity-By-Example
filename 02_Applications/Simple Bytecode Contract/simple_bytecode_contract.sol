// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Factory
 * @dev Deploys a minimal contract via raw EVM bytecode that ALWAYS returns 255.
 *
 * 🧭 Big Picture Analogy:
 * Imagine a **3D printer** (this Factory) that prints a **tiny calculator**.
 * The calculator has exactly one button—press it and it always shows **255**.
 *
 * 🧩 Creation Code vs Runtime Code (Why two programs?):
 * - **Creation code** = the printer’s assembly instructions. It runs ONCE at deploy time,
 *   and its only job is to install the tiny calculator’s brain (runtime code).
 * - **Runtime code** = the permanent brain left on-chain. It runs whenever someone calls the contract.
 *
 * 🔬 What the tiny calculator’s brain does (runtime code):
 * - Write the number 255 into memory,
 * - Return 32 bytes from memory (standard EVM word) containing that 255.
 *
 * 🧪 EVM Bytecode Used Here
 * - Runtime code (10 bytes):
 *   60 ff      PUSH1 0xff          // put 255 on the stack
 *   60 00      PUSH1 0x00          // memory offset 0
 *   52         MSTORE              // store 255 at memory[0..31]
 *   60 20      PUSH1 0x20          // return 32 bytes
 *   60 00      PUSH1 0x00          // from offset 0
 *   f3         RETURN              // return word: 0x...00ff
 *
 * - Creation code (19 bytes) that returns the above runtime code:
 *   69 60ff60005260206000f3  // PUSH10 (runtime bytes)
 *   60 00                    // PUSH1 0 (store position)
 *   52                       // MSTORE (place runtime into memory)
 *   60 0a                    // PUSH1 10 (runtime length)
 *   60 16                    // PUSH1 22 (offset where runtime begins)
 *   f3                       // RETURN (hand back runtime as deployed code)
 */
contract Factory {
    /**
     * @notice Emitted after a successful deployment.
     * @param addr Address of the freshly deployed tiny contract.
     *
     * 📣 Analogy: A loudspeaker pinging the **map pin** where the tiny calculator sits.
     */
    event Log(address addr);

    /**
     * @notice Deploy the minimal runtime-bytes contract that always returns 255.
     * @dev Uses `create(0, ptr, size)` in inline assembly to deploy raw **creation code**.
     *
     * 🛠️ Steps:
     * 1) Load the creation bytecode into memory.
     * 2) Call `create` with value=0, memory pointer, and size (19 bytes).
     * 3) Ensure a non-zero address returned (deployment success).
     * 4) Emit the deployed address.
     *
     * 🏭 Analogy:
     * Feed the **3D printer** the one-time instruction sheet (creation code).
     * The printer manufactures the tiny calculator (runtime code) and places it on the factory floor.
     */
    function deploy() external {
        // Creation code that installs runtime code returning 255:
        // 6960ff60005260206000f3600052600a6016f3  (19 bytes)
        bytes memory bytecode = hex"6960ff60005260206000f3600052600a6016f3";

        address addr;
        assembly {
            // create(value, offset, size)
            // - value = 0 wei sent
            // - offset = memory pointer to start of code (skip the first 32 bytes length slot)
            // - size   = 0x13 (19) bytes of creation code
            addr := create(0, add(bytecode, 0x20), 0x13)
        }

        require(addr != address(0), "DEPLOY_FAILED");

        emit Log(addr);
    }
}

/**
 * @title IContract
 * @dev Interface for interacting with the tiny deployed contract.
 *
 * 🧪 NOTE:
 * The deployed bytecode simply returns the 32-byte word ending in 0xff (i.e., 255).
 * Many tooling layers will expose it as a function returning `uint256`.
 *
 * 🎛️ Analogy:
 * This is the **single button** on the tiny calculator—press to read **255**.
 */
interface IContract {
    /**
     * @notice Get the constant value from the tiny deployed contract.
     * @return Always 255.
     */
    function getValue() external view returns (uint256);
}

/* -------------------------------------------------------------------------
   Playground Notes (for reference)
   -------------------------------------------------------------------------
   Runtime code that returns 255 (10 bytes):
     60 ff      PUSH1 0xff
     60 00      PUSH1 0x00
     52         MSTORE
     60 20      PUSH1 0x20
     60 00      PUSH1 0x00
     f3         RETURN

   Creation code that returns the runtime code (19 bytes):
     69 60ff60005260206000f3
     60 00
     52
     60 0a
     60 16
     f3

   🧠 Analogy Recap:
   - Creation code = the **printer’s instruction sheet** (used once).
   - Runtime code  = the **calculator’s brain** (kept forever).
   - The calculator always prints **255** on its display.
---------------------------------------------------------------------------- */