TITLE prog
PILE SEGMENT STACK
    DW 100 DUP(?)
PILE ENDS

DONNEE SEGMENT
    a DW ?
    b DW ?
    c DW ?
    d DW ?
    e DW ?
    f DW ?
    g DW ?
    h DW ?
    i DW ?
    j DW ?
    k DW ?
    l DW ?
    m DW ?
    z DW ?
    x DW ?
    y DW ?
    w DW ?
    T0 DW ?
    T1 DW ?
    T4 DW ?
    T14 DW ?
    T16 DW ?
    T17 DW ?
    T22 DW ?
    T26 DW ?
DONNEE ENDS

LECODE SEGMENT
MAIN:
    ASSUME CS:LECODE, DS:DONNEE
    MOV AX, DONNEE
    MOV DS, AX
    MOV AX, 2
    MOV a, AX
    MOV AX, a
    ADD AX, a
    MOV T0, AX
    MOV AX, T0
    MOV b, AX
    MOV AX, b
    ADD AX, 1
    MOV T1, AX
    MOV AX, T1
    MOV c, AX
    MOV AX, 0
    MOV d, AX
    MOV AX, d
    IMUL d
    MOV T4, AX
    MOV AX, T4
    MOV e, AX
    MOV AX, e
    MOV f, AX
    MOV AX, f
    MOV g, AX
    MOV AX, g
    MOV h, AX
    MOV AX, h
    MOV i, AX
    MOV AX, 0
    MOV j, AX
    MOV AX, c
    MOV k, AX
    MOV AX, T0
    MOV l, AX
    MOV AX, 7
    IMUL T1
    MOV T14, AX
    MOV AX, T14
    MOV m, AX
    MOV AX, 5
    MOV j, AX
    MOV AX, 1
    MOV z, AX
    MOV AX, j
    SUB AX, 1
    MOV T16, AX
    MOV AX, 4
    IMUL T16
    MOV T17, AX
    MOV AX, T17
    MOV x, AX
    MOV AX, T17
    MOV y, AX
    MOV AX, 4
    IMUL j
    MOV T22, AX
    MOV AX, T22
    MOV z, AX
    MOV AX, T22
    MOV w, AX
    MOV AX, z
    ADD AX, y
    MOV T26, AX
    MOV AX, T26
    MOV f, AX
    MOV AH, 4Ch
    INT 21h
LECODE ENDS
END MAIN
