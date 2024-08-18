
// push constant 111
@111
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 333
@333
D=A
@SP
A=M
M=D
@SP
M=M+1

// push constant 888
@888
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop static 8 || StaticTest.8 RAM[18]
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

// pop static 3 || StaticTest.3 RAM[19]
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

// pop static 1 || StaticTest.1 RAM[20]
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

// push static 3 || StaticTest.3 RAM[19]
@19
D=M
@SP
A=M
M=D
@SP
M=M+1

// push static 1 || StaticTest.1 RAM[20]
@20
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

// push static 8 || StaticTest.8 RAM[18]
@18
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
