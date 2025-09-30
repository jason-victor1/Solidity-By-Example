### 📜 Pseudo Code

CONTRACT Airdrop:
STATE:
token: ERC20-like token contract that can mint
root: Merkle root (the "master seal" of valid claims)
claimed: map of leaf-hashes to boolean (tracks if already claimed)

    CONSTRUCTOR(tokenAddress, rootHash):
        token = tokenAddress
        root = rootHash

    FUNCTION getLeafHash(to, amount) RETURNS leafHash:
        leafHash = keccak256(encode(to, amount))
        RETURN leafHash

    FUNCTION claim(proof[], to, amount):
        leaf = getLeafHash(to, amount)

        REQUIRE claimed[leaf] == false
        REQUIRE MerkleProof.verify(proof, root, leaf) == true

        claimed[leaf] = true
        token.mint(to, amount)
        EMIT Claim(to, amount)

```

---

### 🌍 Real-World Analogy

Imagine a **concert ticket giveaway** where:

* 🎟 **`root`** = A **master guest list** sealed by the organizers.
* 🧾 **`getLeafHash(to, amount)`** = Each guest’s **personalized ticket stub**, which includes their name and number of free drink coupons.
* 📑 **`proof`** = A **chain of signatures** from different security desks at the venue, proving your stub is indeed part of the guest list.
* ✅ **MerkleProof.verify()** = The **final security guard** cross-checking your stub against the official sealed guest list.
* 🖊 **`claimed[leaf]`** = A **stamp on your wrist** that ensures you can’t claim twice.
* 🍹 **`mint()`** = The bartender handing you the exact number of free drink coupons promised.
* 📢 **Event Claim()** = The organizer announcing: “Guest Alice has claimed 5 coupons!”

---

⚖️ In short:

* The **Merkle root** is like a **sealed master list**.
* Each **leaf** is your **personalized entry ticket**.
* The **proof** is the **chain of checkpoints** proving your ticket is valid.
* Once stamped (`claimed = true`), you can’t sneak back in for seconds.

```
