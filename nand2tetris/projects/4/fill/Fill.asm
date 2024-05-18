// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/4/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, 
// the screen should be cleared.
(INIT)
    @SCREEN
    D=A
    @SP
    M=D

    @8192
    D=D+A
    @SCREEN_END
    M=D

    @KBD
    D=M
    @WHITE
    D;JEQ

    // set to black
    @color
    M=-1

    @DRAW
    0;JMP

    (WHITE)
    // set to white
    @color
    M=0

    (DRAW)

    // if SCREEN_END - SP == 0, then we are done
    @SCREEN_END
    D=M
    @SP
    D=D-M
    @INIT
    D;JEQ

    // set the color
    @color
    D=M
    @SP
    A=M
    M=D

    // increment SP
    @SP
    M=M+1

    @DRAW
    0;JMP
