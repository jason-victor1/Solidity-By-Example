// Pseudo Code for IfElse Contract

// Define a contract named IfElse
Contract IfElse:

    // Function foo takes an input x (unsigned integer) and returns an unsigned integer
    Function foo(x: unsigned integer) -> unsigned integer:
        If x is less than 10:
            Return 0
        Else If x is less than 20:
            Return 1
        Else:
            Return 2

    // Function ternary takes an input _x (unsigned integer) and returns an unsigned integer
    Function ternary(_x: unsigned integer) -> unsigned integer:
        // If _x is less than 10, return 1; otherwise, return 2
        Return 1 if (_x < 10) else 2
