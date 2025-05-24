// SPDX-License-Identifier: MIT
// 🪪 Open-source license plate: MIT lets anyone reuse this code.

pragma solidity ^0.8.26;
// 🛠️ Compiler version lock—keeps everyone on the same toolkit.

/* 🌳 Inheritance tree diagram
   A
 /  \
B   C
 \ /
  D
*/

contract A {
// 🏢 Base control room “A” that broadcasts every button press.

    event Log(string message);
    // 📣 Loudspeaker event—records messages permanently on the blockchain log.

    function foo() public virtual {
        emit Log("A.foo called"); // 🔔 Announces the Foo button was pressed in room A.
    }

    function bar() public virtual {
        emit Log("A.bar called"); // 🔔 Announces the Bar button was pressed in room A.
    }
}

contract B is A {
// 🌿 Branch room “B” that tweaks A’s buttons.

    function foo() public virtual override {
        emit Log("B.foo called"); // 📣 States Foo pressed in B.
        A.foo();                  // ⏭️ Directly presses A’s original Foo.
    }

    function bar() public virtual override {
        emit Log("B.bar called"); // 📣 States Bar pressed in B.
        super.bar();              // 🔗 Passes Bar call to next room in chain.
    }
}

contract C is A {
// 🌿 Parallel branch room “C” with its own log lines.

    function foo() public virtual override {
        emit Log("C.foo called"); // 📣 States Foo pressed in C.
        A.foo();                  // ⏭️ Directly presses A’s Foo.
    }

    function bar() public virtual override {
        emit Log("C.bar called"); // 📣 States Bar pressed in C.
        super.bar();              // 🔗 Passes Bar call onward.
    }
}

contract D is B, C {
// 🍃 Leaf room “D” combining both B and C behaviors.

    // 🧪 Call D.foo → Log shows C.foo then A.foo (single A call).
    // 🧪 Call D.bar → Log shows C.bar → B.bar → A.bar (A only once).

    function foo() public override(B, C) {
        super.foo(); // 🔗 Executes C.foo, which relays to A.foo.
    }

    function bar() public override(B, C) {
        super.bar(); // 🔗 Executes C.bar → B.bar → A.bar.
    }
}
