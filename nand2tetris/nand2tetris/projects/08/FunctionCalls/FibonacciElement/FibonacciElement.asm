@256
D=A
@0
M=D


@Sys.init$1
D=A
@0
M=M+1
A=M-1
M=D
@1
D=M
@SP
M=M+1
A=M-1
M=D
@2
D=M
@SP
M=M+1
A=M-1
M=D
@3
D=A
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@3
D=A
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@5
D=A
@0
D=D+A
@0
D=M-D
@2
M=D
@0
D=M
@1
M=D
@Sys.init
0;JMP
(Sys.init$1)
(Main.fibonacci)
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
A=M-1
D=D-M
@IFZ6
D;JGT
@ELS6
0;JMP
(IFZ6)
@SP
A=M-1
M=-1
@ENDO6
0;JMP
(ELS6)
@SP
A=M-1
M=0
@ENDO6
0;JMP
(ENDO6)
@SP
M=M-1
A=M
D=M
@Main.fibonacci$IF_TRUE
D;JNE
@Main.fibonacci$IF_FALSE
0;JMP
(Main.fibonacci$IF_TRUE)
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@1
D=M
@13
M=D
@5
D=D-A
A=D
D=M
@14
M=D
@0
M=M-1
A=M
D=M
@2
A=M
M=D
@2
D=M
@0
M=D+1
@13
D=M
D=D-1
A=D
D=M
@4
M=D
@2
D=A
@13
D=M-D
A=D
D=M
@3
M=D
D=A
@13
D=M-D
A=D
D=M
@2
M=D
@4
D=A
@13
D=M-D
A=D
D=M
@1
M=D
@14
A=M
0;JMP
(Main.fibonacci$IF_FALSE)
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
A=A-1
M=M-D
@Main.fibonacci$2
D=A
@0
M=M+1
A=M-1
M=D
@1
D=M
@SP
M=M+1
A=M-1
M=D
@2
D=M
@SP
M=M+1
A=M-1
M=D
@3
D=A
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@3
D=A
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@5
D=A
@1
D=D+A
@0
D=M-D
@2
M=D
@0
D=M
@1
M=D
@Main.fibonacci
0;JMP
(Main.fibonacci$2)
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
A=A-1
M=M-D
@Main.fibonacci$3
D=A
@0
M=M+1
A=M-1
M=D
@1
D=M
@SP
M=M+1
A=M-1
M=D
@2
D=M
@SP
M=M+1
A=M-1
M=D
@3
D=A
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@3
D=A
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@5
D=A
@1
D=D+A
@0
D=M-D
@2
M=D
@0
D=M
@1
M=D
@Main.fibonacci
0;JMP
(Main.fibonacci$3)
@SP
M=M-1
A=M
D=M
A=A-1
M=M+D
@1
D=M
@13
M=D
@5
D=D-A
A=D
D=M
@14
M=D
@0
M=M-1
A=M
D=M
@2
A=M
M=D
@2
D=M
@0
M=D+1
@13
D=M
D=D-1
A=D
D=M
@4
M=D
@2
D=A
@13
D=M-D
A=D
D=M
@3
M=D
D=A
@13
D=M-D
A=D
D=M
@2
M=D
@4
D=A
@13
D=M-D
A=D
D=M
@1
M=D
@14
A=M
0;JMP
(Sys.init)
@4
D=A
@SP
A=M
M=D
@SP
M=M+1
@Main.fibonacci$4
D=A
@0
M=M+1
A=M-1
M=D
@1
D=M
@SP
M=M+1
A=M-1
M=D
@2
D=M
@SP
M=M+1
A=M-1
M=D
@3
D=A
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@3
D=A
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@5
D=A
@1
D=D+A
@0
D=M-D
@2
M=D
@0
D=M
@1
M=D
@Main.fibonacci
0;JMP
(Main.fibonacci$4)
(Sys.init$WHILE)
@Sys.init$WHILE
0;JMP
