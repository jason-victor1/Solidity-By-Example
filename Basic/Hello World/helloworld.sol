// SPDX-License-Identifier: MIT
// 🪪 This is like a business license—"MIT" means the code is open-source and can be reused with minimal restrictions.

pragma solidity ^0.8.26;
// 🛠️ Tells the builder (compiler) which tools to use.
// Solidity version 0.8.26 ensures we're using a version that avoids bugs and supports new features.

contract HelloWorld {
    // 🏢 Think of this as creating a small digital building called "HelloWorld".
    // This building can store info and offer services (functions) to the public.

    string public greet = "Hello World!";
    // 🪧 This is like a welcome sign posted on the front of the building.
    // It's a permanent sign (state variable) that says "Hello World!".
    // The keyword 'public' makes this sign visible to anyone who walks by (i.e., any external user).
    // Solidity automatically installs a window so people can *look at* the sign (getter function), but they can't change it unless given permission.
}

