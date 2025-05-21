TITLE prog
PILE SEGMENT STACK
    DW 100 DUP(?)
    base_pile EQU $
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
    arr DW 10 DUP (?)
    matrix DW 9 DUP (?)
    T0 DW ?
    T1 DW ?
    T4 DW ?
    T14 DW ?
    T16 DW ?
    T17 DW ?
    T22 DW ?
    T26 DW ?
    T27 DW ?
    T28 DW ?
    T29 DW ?
    T30 DW ?
    T31 DW ?
DONNEE ENDS

LECODE SEGMENT
MAIN:
    ASSUME CS:LECODE, DS:DONNEE
    MOV AX, DONNEE
    MOV DS, AX
    ASSUME SS : PILE
    MOV AX, PILE
    MOV SS,AX
    MOV SP,base_pile
    JMP L1
L1:
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
    MOV AX, 5
    MOV arr[0], AX
    MOV AX, 10
    MOV arr[1], AX
    MOV AX, arr[0]
    ADD AX, arr[1]
    MOV T27, AX
    MOV AX, T27
    MOV arr[2], AX
    MOV AX, 1
    MOV matrix[0][0], AX
    MOV AX, 6
    MOV BX, 24
    IMUL BX
    MOV T28, AX
    MOV AX, T28
    ADD AX, 3
    MOV T29, AX
    MOV AX, 2
    MOV BX, 7
    IMUL BX
    MOV T30, AX
    MOV AX, T29
    SUB AX, T30
    MOV T31, AX
    MOV AX, T31
    MOV arr[0], AX
LEND:           
    MOV AH, 4Ch
    INT 21h
LECODE ENDS
END MAIN
