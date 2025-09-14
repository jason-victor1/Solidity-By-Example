// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title MinimalProxy (EIP-1167-style)
 * @dev Deploys a tiny "forwarder" contract that delegates all calls to a given `target`.
 *
 * 🧭 Big Picture Analogy:
 * Think of the proxy as a **hollow storefront** with no inventory of its own.
 * When a customer walks in and asks for something, the storefront immediately
 * calls its **warehouse** (the `target` contract) to do the real work, then
 * hands the result back to the customer.
 *
 * Why do this?
 * - ⚡ Ultra-cheap to deploy many storefronts (proxies) that share one warehouse (logic).
 * - 🧩 Each proxy has its own storage (state), but **all logic** lives in the shared target.
 * - 🛠️ Upgrades & fixes happen in one place (the warehouse), without changing each storefront.
 */
contract MinimalProxy {
    /**
     * @notice Deploy a new minimal proxy that delegates to `target`.
     * @param target The warehouse (implementation) contract the proxy will delegate to.
     * @return result The address of the freshly deployed proxy.
     *
     * 🏗️ Analogy:
     * We assemble a tiny storefront whose front door **forwards every request**
     * to the warehouse at `target`. The storefront itself is just a façade and a phone line.
     */
    function clone(address target) external returns (address result) {
        // Convert address → 20-byte value for inlining into the runtime code.
        bytes20 targetBytes = bytes20(target);

        /*
         * ──────────────────────────────────────────────────────────────────────────────
         * 📦 What We’re Building (Bytecode Layout)
         * ──────────────────────────────────────────────────────────────────────────────
         *
         * We construct the **creation code** that, when deployed, returns the
         * **runtime code** of an EIP-1167 minimal proxy. That runtime code:
         *  - performs a `DELEGATECALL` to `target`, forwarding calldata & gas,
         *  - returns whatever the target returns (or reverts on failure).
         *
         * Creation code (copies runtime code into memory and returns it):
         *   0x3d602d80600a3d3981f3
         *
         * Runtime code (the permanent proxy logic):
         *   0x363d3d373d3d3d363d73 <20-byte target> 0x5af43d82803e903d91602b57fd5bf3
         *
         * Together (with target inserted), the final 55-byte blob is deployed.
         *
         * 🧠 Analogy:
         * - Creation code = the one-time **installer** that writes the program into ROM.
         * - Runtime code  = the **phone-forwarding script** the storefront runs forever.
         */

        assembly {
            // 1) Get the "free memory pointer" (Solidity keeps it at slot 0x40)
            //    This is where we’ll write our 55 bytes of creation+runtime code.
            let clone := mload(0x40)

            // 2) Write the first 32 bytes:
            //    - This chunk contains the tail of the creation code and the head of the runtime code,
            //      including the `PUSH20` opcode (0x73) that expects the 20-byte `target` next.
            //
            // Layout (first 32 bytes):
            //   3d602d80600a3d3981f3 363d3d373d3d3d363d 73 000000000000000000000000
            //   ^^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^  ^^  ^^^^^^^^^^^^^^^^^^^^^^
            //   creation code tail   runtime code head  P20 (placeholder for target)
            //
            // 🧱 Analogy: We’re placing the storefront’s phone-forwarding script template on the workbench,
            //             leaving a blank slot where the warehouse number (target) will be stamped next.
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )

            // 3) Stamp the 20-byte `target` right after the 20-byte placeholder (offset 0x14 = 20).
            //    This fills the operand for the `PUSH20` (0x73) instruction with the actual address.
            //
            // 🧾 Analogy: Write the warehouse’s phone number into the storefront’s speed-dial slot.
            mstore(add(clone, 0x14), targetBytes)

            // 4) Write the final 32 bytes:
            //    - This chunk completes the runtime code with the well-known EIP-1167 tail
            //      that performs the DELEGATECALL & RETURN.
            //
            //    0x5af43d82803e903d91602b57fd5bf3
            //     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            //     delegatecall/ret logic
            //
            // 🧰 Analogy: Attach the auto-forwarding instructions:
            //    “Call the warehouse with whatever the customer asked,
            //     then hand back exactly what the warehouse replied.”
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )

            // 5) Deploy the proxy:
            //    - value: 0 (send 0 ether)
            //    - offset: clone (start of our 55-byte buffer)
            //    - size:  0x37 (55 bytes total)
            //
            // 🏁 Analogy: Roll the finished storefront out onto Main Street.
            result := create(0, clone, 0x37)
        }

        require(result != address(0), "CLONE_DEPLOY_FAILED");
    }
}

/**
 * @title IContract (example target interface)
 * @dev Not used by the proxy code itself; shown for illustration/testing.
 *
 * 🧪 Analogy:
 * A simple “warehouse API” the storefront might forward to.
 */
interface IContract {
    /// @notice Example read method a proxy could delegate to.
    function getValue() external view returns (uint256);
}

/* ----------------------------------------------------------------------------
   🔎 Opcode Cliff Notes (for the curious)
   ----------------------------------------------------------------------------
   Creation code (installer): 3d602d80600a3d3981f3
     3d      RETURNDATASIZE  (push 0)
     60 2d   PUSH1 0x2d      (length to copy? here used in a known pattern)
     80      DUP1
     60 0a   PUSH1 0x0a
     3d      RETURNDATASIZE
     39      CODECOPY        (copy runtime into memory)
     81      DUP2
     f3      RETURN          (return runtime as deployed code)

   Runtime code (proxy): 363d3d373d3d3d363d73 <target> 5af43d82803e903d91602b57fd5bf3
     36      CALLDATASIZE
     3d      RETURNDATASIZE
     3d      RETURNDATASIZE
     37      CALLDATACOPY
     3d      RETURNDATASIZE
     3d      RETURNDATASIZE
     3d      RETURNDATASIZE
     36      CALLDATASIZE
     3d      RETURNDATASIZE
     73 ..   PUSH20 <target>
     5a      GAS
     f4      DELEGATECALL
     3d      RETURNDATASIZE
     82      DUP3
     80      DUP1
     3e      RETURNDATACOPY
     90      SWAP1
     3d      RETURNDATASIZE
     91      SWAP2
     60 2b   PUSH1 0x2b
     57      JUMPI
     fd      REVERT
     5b      JUMPDEST
     f3      RETURN

   🧠 Net effect:
   - Forward calldata & gas to `target` via DELEGATECALL.
   - Bubble up return data or revert reason exactly.
---------------------------------------------------------------------------- */