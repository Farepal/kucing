// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// IMPORTANT: DOES NOT TRASH R0,R1 (even though the test allows it,
// it's terrible form)

// Simple multiplier: loops 15 times, using a bitmask to check if an
// addition needs to be made.

(INIT)
    @R2      // Initialize product (R2) to 0
    M = 0

    @MASK    // Initialize MASK to 0000...0001
    M = 1

    // multiplicand can positive or negative
    // multiplier must be positive

    @R0      // Initialize Multiplicand to copy of R0
    D = M
    @MULC
    M = D

    @R1      // Initialize Multiplier to copy of R1
    D = M
    @MULP
    M = D

    // if R1 or MULC is positive, we dont to positive both R1 and MULC
    @MULC
    D = M
    @SKIPPOSITIVE
    D; JGE

    @MULP
    D = M
    @SKIPPOSITIVE
    D; JGE

    // positive MULP and MULC
    @MULP
    M = -M
    @MULC
    M = -M

    (SKIPPOSITIVE)



    // if MULP > 0, we dont need to negative both MULP and MULC
    @MULP
    D = M
    @SKIPNEGATIVE
    D; JGE

    // negative MULP and MULC
    @MULP      
    M = -M
    @MULC
    M = -M
    (SKIPNEGATIVE)



    (LOOP)
        // if MULP - MASK < 0, END
        @MULP
        D = M
        @MASK
        D = D - M
        @END
        D; JLT

        // if MULP & MASK == 0, We dont need to add
        @MULP
        D = M
        @MASK
        D = D & M
        @NEXT
        D; JEQ

        // R2 = R2 + MULC
        @MULC
        D = M
        @R2
        M = M + D

        (NEXT)

        // shift 1 left MULC
        @MULC
        D = M
        M = M + D

        // shift left MASK
        @MASK
        D = M
        M = D + M

        @LOOP
        0; JMP
(END)
    @END
    0; JMP
