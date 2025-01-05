1. Contract Name: SimpleDataLocations

2. State Variable:
    - numbers: An array of integers stored persistently.

3. Functions:

    3.1 Add a Number to the Array:
        INPUT: number (integer)
        ACTION: Append number to the end of the `numbers` array.

    3.2 Update the First Number in the Array:
        INPUT: newNumber (integer)
        ACTION:
            IF the `numbers` array is not empty:
                Update the first element of `numbers` to newNumber.
            ELSE:
                Do nothing.

    3.3 Double a Memory Array and Return It:
        INPUT: inputArray (array of integers in temporary memory)
        OUTPUT: doubledArray (array of integers in memory)
        ACTION:
            Create a new array `doubledArray` with the same length as `inputArray`.
            FOR each element in `inputArray`:
                Multiply the element by 2 and store it in `doubledArray`.
            RETURN `doubledArray`.

    3.4 Sum Up a Calldata Array:
        INPUT: inputArray (array of integers in read-only calldata)
        OUTPUT: sum (integer)
        ACTION:
            Initialize `sum` to 0.
            FOR each element in `inputArray`:
                Add the element to `sum`.
            RETURN `sum`.

4. Key Concepts:
    - `storage`: Persistent storage for state variables (e.g., `numbers`).
    - `memory`: Temporary storage for function-local computations.
    - `calldata`: Read-only storage for external function inputs.
    - Function Modifiers:
        - `public`: Functions accessible inside and outside the contract.
        - `external`: Functions accessible only from outside the contract.
        - `pure`: Functions that neither read nor modify state variables.
