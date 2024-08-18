
// FUNCTION SimpleFunction.test 2


// SimpleFunction.test
(SimpleFunction.test)

// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1

// push local 0
@0
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 1
@1
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// add
@SP
M=M-1
A=M
D=M
A=A-1
M=M+D

// not
@SP
A=M-1
M=!M

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

// add
@SP
M=M-1
A=M
D=M
A=A-1
M=M+D

// push argument 1
@1
D=A
@ARG
A=D+M
D=M
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
