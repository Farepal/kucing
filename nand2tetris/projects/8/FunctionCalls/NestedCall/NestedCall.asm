
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

// FUNCTION Sys.init 0


// Sys.init
(Sys.init)

// push constant 4000
@4000
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 0 || pop THIS
@0
D=A
@3
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

// push constant 5000
@5000
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 1 || pop THAT
@1
D=A
@3
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

// CALL Sys.main 0


// PUSH (RETURN1)
@RETURN1
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

// GOTO Sys.main
@Sys.main
0;JMP

// RETURN1
(RETURN1)

// pop temp 1
@1
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

// LOOP
(LOOP)

// GOTO LOOP
@LOOP
0;JMP

// FUNCTION Sys.main 5


// Sys.main
(Sys.main)

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

// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 4001
@4001
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 0 || pop THIS
@0
D=A
@3
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

// push constant 5001
@5001
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 1 || pop THAT
@1
D=A
@3
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

// push constant 200
@200
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 1
@1
D=A
@LCL
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

// push constant 40
@40
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 2
@2
D=A
@LCL
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

// push constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 3
@3
D=A
@LCL
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

// push constant 123
@123
D=A
@SP
A=M
M=D
@SP
M=M+1

// CALL Sys.add12 1


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
@1
D=D-A
@ARG
M=D

// LCL = SP
@SP
D=M
@LCL
M=D

// GOTO Sys.add12
@Sys.add12
0;JMP

// RETURN2
(RETURN2)

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

// push local 2
@2
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 3
@3
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 4
@4
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

// add
@SP
M=M-1
A=M
D=M
A=A-1
M=M+D

// add
@SP
M=M-1
A=M
D=M
A=A-1
M=M+D

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

// FUNCTION Sys.add12 0


// Sys.add12
(Sys.add12)

// push constant 4002
@4002
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 0 || pop THIS
@0
D=A
@3
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

// push constant 5002
@5002
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 1 || pop THAT
@1
D=A
@3
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

// push constant 12
@12
D=A
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
