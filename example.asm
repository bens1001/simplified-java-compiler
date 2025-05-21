TITLE prog
PILE SEGMENT STACK
    DW 100 DUP(?)
    base_pile EQU $
PILE ENDS

DONNEE SEGMENT
    age DW ?
    gender DB ?
    isStudent DB ?
    grades DW 560 DUP (?)
    b DW ?
    k DW ?
    j DW ?
    i DW ?
    code DB 6 DUP (?)
    duration DW ?
    names DW ?
    courses DW ?
    p1 DW ?
    courseCode DB 6 DUP (?)
    cs101 DW ?
    x DW ?
    studentCode DW ?
    s DW ?
    v DB ?
    result DW ?
    T0 DW ?
    T2 DW ?
    T5 DW ?
    T7 DW ?
    T14 DW ?
    T25 DW ?
    T26 DW ?
    T27 DW ?
    T28 DW ?
    T29 DW ?
    T30 DW ?
    T31 DW ?
    T32 DW ?
    p1_age DW ?
    p1_gender DB ?
    p1_isStudent DB ?
    p1_grades DW 560 DUP (?)
    cs101_code DB 6 DUP (?)
    cs101_duration DW ?
    s_names DW ?
    s_courses DW ?
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
    JMP L55
L1:
    MOV AX, 1
    MOV b, AX
    MOV AX, 0
    MOV k, AX
L3:
    MOV AX, b
    ADD AX, 1
    MOV T0, AX
    MOV AX, T0
    MOV b, AX
    MOV AX, 0
    MOV j, AX
    MOV AX, 16
    CMP AX, j
    JGE L16
    MOV AX, j
    ADD AX, 1
    MOV T2, AX
    MOV AX, T2
    MOV j, AX
    MOV AX, 0
    MOV j, AX
L10:
    MOV AX, 15
    CMP AX, j
    JGE L15
    MOV AX, T2
    MOV j, AX
    MOV AX, k
    ADD AX, 1
    MOV T5, AX
    MOV AX, T5
    MOV k, AX
    JMP L10
L15:
    JMP L3
L16:
    MOV AX, 1
    MOV i, AX
    JMP L68
L18:
    MOV AX, 22
    CMP AX, i
    JGE L22
    MOV AX, i
    ADD AX, 1
    MOV T7, AX
    MOV AX, T7
    MOV i, AX
    JMP L18
L22:
    JMP LEND
    MOV AX, 0
    MOV i, AX
L24:
    MOV AX, 35
    CMP AX, i
    JGE L35
    MOV AX, T7
    MOV i, AX
    MOV AX, 0
    MOV j, AX
L27:
    MOV AX, 34
    CMP AX, j
    JGE L34
    MOV AX, T2
    MOV j, AX
    MOV AX, 33
    CMP AX, i
    JNE L33
    MOV AX, T7
    MOV i, AX
    MOV AX, i
    SUB AX, 1
    MOV T14, AX
    MOV AX, T14
    MOV i, AX
L33:
    JMP L27
L34:
    JMP L24
L35:
    MOV AX, 1
    MOV i, AX
    JMP LEND
L37:
    MOV AX, 0
    MOV i, AX
L38:
    MOV AX, 42
    CMP AX, i
    JGE L42
    MOV AX, T7
    MOV i, AX
    MOV AX, 41
    CMP AX, i
    JLE L41
L41:
    JMP L38
L42:
    JMP L81
    MOV AX, 0
    MOV i, AX
L44:
    MOV AX, 54
    CMP AX, i
    JGE L54
    MOV AX, T7
    MOV i, AX
    MOV AX, 0
    MOV j, AX
L47:
    MOV AX, 53
    CMP AX, j
    JGE L53
    MOV AX, T2
    MOV j, AX
    MOV AX, 52
    CMP AX, j
    JLE L52
    MOV AX, T7
    MOV i, AX
    MOV AX, T14
    MOV i, AX
L52:
    JMP L47
L53:
    JMP L44
L54:
    JMP LEND
L55:
    MOV AX, T25
    MOV grades, AX
    MOV AX, age
    MOV p1_age, AX
    MOV AL, gender
    MOV p1_gender, AL
    MOV AL, isStudent
    MOV p1_isStudent, AL
    MOV AX, grades
    MOV p1_grades, AX
    MOV AX, T26
    MOV p1, AX
    JMP L1
L68:
    MOV AX, T27
    MOV courseCode, AL
    MOV AL, code
    MOV cs101_code, AL
    MOV AX, duration
    MOV cs101_duration, AX
    MOV AX, T28
    MOV cs101, AX
    MOV AX, 5
    MOV studentCode, AX
    MOV AX, names
    MOV s_names, AX
    MOV AX, courses
    MOV s_courses, AX
    MOV AX, T29
    MOV s, AX
    JMP L37
L81:
    MOV AX, T30
    MOV x, AX
    MOV AX, 96
    MOV v, AL
    MOV AX, x
    ADD AX, 1
    MOV T31, AX
    MOV AX, T31
    MOV x, AX
    MOV AX, x
    SUB AX, 1
    MOV T32, AX
    MOV AX, T32
    MOV x, AX
    MOV AX, 0
    MOV result, AX
    JMP LEND
LEND:           
    MOV AH, 4Ch
    INT 21h
LECODE ENDS
END MAIN
