
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

// FUNCTION Class1.set 0


// Class1.set
(Class1.set)

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

// pop static 0 || Class1.0 RAM[18]
@18
D=A
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

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

// pop static 1 || Class1.1 RAM[19]
@19
D=A
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

// push constant 0
@0
D=A
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

// FUNCTION Class1.get 0


// Class1.get
(Class1.get)

// push static 0 || Class1.0 RAM[18]
@18
D=M
@SP
A=M
M=D
@SP
M=M+1

// push static 1 || Class1.1 RAM[19]
@19
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

// bootstrap
@256
D=A
@SP
M=D

// CALL Sys.init 0


// PUSH (RETURN2)
@RETURN2
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

// RETURN2
(RETURN2)

// FUNCTION Class2.set 0


// Class2.set
(Class2.set)

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

// pop static 0 || Class2.0 RAM[20]
@20
D=A
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

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

// pop static 1 || Class2.1 RAM[21]
@21
D=A
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

// push constant 0
@0
D=A
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

// FUNCTION Class2.get 0


// Class2.get
(Class2.get)

// push static 0 || Class2.0 RAM[20]
@20
D=M
@SP
A=M
M=D
@SP
M=M+1

// push static 1 || Class2.1 RAM[21]
@21
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

// bootstrap
@256
D=A
@SP
M=D

// CALL Sys.init 0


// PUSH (RETURN4)
@RETURN4
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

// RETURN4
(RETURN4)

// FUNCTION Sys.init 0


// Sys.init
(Sys.init)

// push constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 8
@8
D=A
@SP
A=M
M=D
@SP
M=M+1

// CALL Class1.set 2


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
@2
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Class1.set
@Class1.set
0;JMP

// RETURN5
(RETURN5)

// pop temp 0
@0
D=A
@5
D=D+A
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

// push constant 23
@23
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 15
@15
D=A
@SP
A=M
M=D
@SP
M=M+1

// CALL Class2.set 2


// PUSH (RETURN6)
@RETURN6
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
@2
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Class2.set
@Class2.set
0;JMP

// RETURN6
(RETURN6)

// pop temp 0
@0
D=A
@5
D=D+A
@R13
M=D
@SP
M=M-1
A=M
D=M
@R13
A=M
M=D

// CALL Class1.get 0


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

// GOTO Class1.get
@Class1.get
0;JMP

// RETURN7
(RETURN7)

// CALL Class2.get 0


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
@0
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Class2.get
@Class2.get
0;JMP

// RETURN8
(RETURN8)

// END
(END)

// GOTO END
@END
0;JMP
