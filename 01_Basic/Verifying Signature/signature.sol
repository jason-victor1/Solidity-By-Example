
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
🛡️ Signature Verification Flow:

✍️ Signing (Off-chain)
1. Create the original message (e.g., recipient, amount, note, nonce)
2. Hash it using keccak256 (via abi.encodePacked)
3. Sign the hash using a wallet like MetaMask (keep private key secure)

✅ Verifying (On-chain)
1. Rebuild the hash of the original message
2. Prefix it with Ethereum’s signature header
3. Recover the signer using `ecrecover` and compare to claimed signer
*/

contract VerifySignature {
    /*
    🔐 Generates a hash of the message using keccak256.
    This is the hash that will be signed off-chain.

    @param _to - recipient address
    @param _amount - token or ETH amount
    @param _message - custom string message (e.g., note, purpose)
    @param _nonce - a unique number to prevent replay attacks
    @return messageHash - hashed message for signing
    */
    function getMessageHash(
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /*
    🧾 Prefixes the original message hash with Ethereum's required header
    before signing or recovering.

    This is what MetaMask/Web3 uses internally when signing personal messages.
    Format: "\x19Ethereum Signed Message:\n32" + messageHash

    @param _messageHash - hash created by `getMessageHash`
    @return ethSignedMessageHash - standardized Ethereum-signed hash
    */
    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
        );
    }

    /*
    ✅ Verifies that a given signature was created by the `_signer`.

    Steps:
    1. Recreate the original hash.
    2. Wrap it as an Ethereum-signed message.
    3. Recover the address from the signature.
    4. Compare recovered address to claimed `_signer`.

    @param _signer - address claiming to have signed the message
    @param _to - recipient address used in the message
    @param _amount - amount used in the message
    @param _message - the string message
    @param _nonce - nonce used in the original message
    @param signature - the signature to verify
    @return true if signature is valid and from `_signer`
    */
    function verify(
        address _signer,
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    /*
    🧠 Uses `ecrecover` to retrieve the signer address from a signature.
    Signature must be split into (r, s, v) parts first.

    @param _ethSignedMessageHash - fully wrapped Ethereum message hash
    @param _signature - complete 65-byte signature
    @return address - recovered signer
    */
    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    /*
    🪓 Splits a standard 65-byte signature into its `r`, `s`, and `v` components.

    Signature layout:
    - First 32 bytes: r
    - Next 32 bytes: s
    - Final 1 byte: v (usually 27 or 28)

    @param sig - raw signature bytes
    @return r, s, v - elliptic curve signature components
    */
    function splitSignature(bytes memory sig)
        public
        pure
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            // Read first 32 bytes after array length → r
            r := mload(add(sig, 32))
            // Read second 32 bytes → s
            s := mload(add(sig, 64))
            // Read the first byte of the third 32 bytes → v
            v := byte(0, mload(add(sig, 96)))
        }
    }
}

