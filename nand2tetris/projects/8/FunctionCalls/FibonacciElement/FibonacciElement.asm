
// bootstrap
@256
D=A
@SP
M=D

// CALL Sys.init 0


// PUSH (RETURN0)
@RETURN0
D=A
@SP
A=M
M=D
@SP
M=M+1

// PUSH LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1

// PUSH ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 0 || push THIS
@0
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 1 || push THAT
@1
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// ARG = SP - 5 - numArgs
@SP
D=M
@5
D=D-A
@0
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Sys.init
@Sys.init
0;JMP

// RETURN0
(RETURN0)

// FUNCTION Main.fibonacci 0


// Main.fibonacci
(Main.fibonacci)

// push argument 0
@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 2
@2
D=A
@SP
A=M
M=D
@SP
M=M+1

// lt
@SP
M=M-1
A=M
D=M
A=A-1
D=M-D
@TRUE1
D;JLT
@SP
A=M-1
M=0
@CONTINUE1
0;JMP
(TRUE1)
@SP
A=M-1
M=-1
(CONTINUE1)

// IF-GOTO N_LT_2
@SP
M=M-1
A=M
D=M
@N_LT_2
D;JNE

// GOTO N_GE_2
@N_GE_2
0;JMP

// N_LT_2
(N_LT_2)

// push argument 0
@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// RETURN


// frame = LCL
@LCL
D=M
@frame
M=D

// ret = *(frame - 5)
@5
A=D-A
D=M
@ret
M=D

// pop argument 0
@0
D=A
@ARG
D=D+M
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

// SP = ARG + 1
@ARG
D=M
@SP
M=D+1

// THAT = *(LCL - 1)
@frame
D=M
@1
A=D-A
D=M
@THAT
M=D

// THIS = *(LCL - 2)
@frame
D=M
@2
A=D-A
D=M
@THIS
M=D

// ARG = *(LCL - 3)
@frame
D=M
@3
A=D-A
D=M
@ARG
M=D

// LCL = *(LCL - 4)
@frame
D=M
@4
A=D-A
D=M
@LCL
M=D

// goto returnAddress
@ret
A=M
0;JMP

// N_GE_2
(N_GE_2)

// push argument 0
@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 2
@2
D=A
@SP
A=M
M=D
@SP
M=M+1

// sub
@SP
M=M-1
A=M
D=M
A=A-1
M=M-D

// CALL Main.fibonacci 1


// PUSH (RETURN3)
@RETURN3
D=A
@SP
A=M
M=D
@SP
M=M+1

// PUSH LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1

// PUSH ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 0 || push THIS
@0
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 1 || push THAT
@1
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// ARG = SP - 5 - numArgs
@SP
D=M
@5
D=D-A
@1
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Main.fibonacci
@Main.fibonacci
0;JMP

// RETURN3
(RETURN3)

// push argument 0
@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1

// sub
@SP
M=M-1
A=M
D=M
A=A-1
M=M-D

// CALL Main.fibonacci 1


// PUSH (RETURN5)
@RETURN5
D=A
@SP
A=M
M=D
@SP
M=M+1

// PUSH LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1

// PUSH ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 0 || push THIS
@0
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 1 || push THAT
@1
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// ARG = SP - 5 - numArgs
@SP
D=M
@5
D=D-A
@1
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Main.fibonacci
@Main.fibonacci
0;JMP

// RETURN5
(RETURN5)

// add
@SP
M=M-1
A=M
D=M
A=A-1
M=M+D

// RETURN


// frame = LCL
@LCL
D=M
@frame
M=D

// ret = *(frame - 5)
@5
A=D-A
D=M
@ret
M=D

// pop argument 0
@0
D=A
@ARG
D=D+M
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

// SP = ARG + 1
@ARG
D=M
@SP
M=D+1

// THAT = *(LCL - 1)
@frame
D=M
@1
A=D-A
D=M
@THAT
M=D

// THIS = *(LCL - 2)
@frame
D=M
@2
A=D-A
D=M
@THIS
M=D

// ARG = *(LCL - 3)
@frame
D=M
@3
A=D-A
D=M
@ARG
M=D

// LCL = *(LCL - 4)
@frame
D=M
@4
A=D-A
D=M
@LCL
M=D

// goto returnAddress
@ret
A=M
0;JMP

// bootstrap
@256
D=A
@SP
M=D

// CALL Sys.init 0


// PUSH (RETURN7)
@RETURN7
D=A
@SP
A=M
M=D
@SP
M=M+1

// PUSH LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1

// PUSH ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 0 || push THIS
@0
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 1 || push THAT
@1
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// ARG = SP - 5 - numArgs
@SP
D=M
@5
D=D-A
@0
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Sys.init
@Sys.init
0;JMP

// RETURN7
(RETURN7)

// FUNCTION Sys.init 0


// Sys.init
(Sys.init)

// push constant 4
@4
D=A
@SP
A=M
M=D
@SP
M=M+1

// CALL Main.fibonacci 1


// PUSH (RETURN8)
@RETURN8
D=A
@SP
A=M
M=D
@SP
M=M+1

// PUSH LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1

// PUSH ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 0 || push THIS
@0
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push pointer 1 || push THAT
@1
D=A
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// ARG = SP - 5 - numArgs
@SP
D=M
@5
D=D-A
@1
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Main.fibonacci
@Main.fibonacci
0;JMP

// RETURN8
(RETURN8)

// END
(END)

// GOTO END
@END
0;JMP
