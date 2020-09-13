format PE console

entry _start
include 'win32a.inc'

section '.data' data readable writable;

        formatStr db '%s', 0

        helloWorld db 'Hello world!', 10, 13, 0   ; добавл€ем \n \r
        typeName db 'Please, type your name: ', 0
        answerStr db 'Hello, %s', 0
        name rd 2

        NULL = 0

section '.code' code readable executable
        _start:
                push helloWorld
                call [printf]
                push typeName
                call [printf]

                push name       ; добавл€ем им€ (метку) в стек
                push formatStr  ; добавл€ем формат строки
                call [scanf]    ; C style: scanf('%s', &name);

                push name
                push answerStr
                call [printf]   ; C style: printf(answerStr, name);

                call [getch]

                push NULL
                call [ExitProcess]

section '.idata' import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\ ;добавим функцию дл€ считывани€
               getch, '_getch'

