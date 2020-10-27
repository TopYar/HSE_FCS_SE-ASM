; Дондик Ярослав Витальевич
; Студент группы БПИ191
; Вариант 14
;
; Условие: Разработать программу, заменяющую все гласные буквы в заданной ASCII-строке заглавными

format PE console

entry _start2
include 'win32a.inc'

section '.data' data readable writable;
        formatChar db '%c', 0
        formatInt db '%d', 0
        formatStr db '%s', 0
        syllStr db 'aeouyi', 0
        newLine db 10, 13, 0

        str1 rb 1000000
        str2 rb 1000000
        N dd ?          ; размер массива
        tmpStack dd ?   ; временная переменная для стека
        tmpStack2 dd ?   ; временная переменная для стека
        ediTmp dd ?
        NULL = 0

section '.code' code readable executable
        _start2:
                cinvoke scanf, formatStr, str1

                stdcall strlen, str1
                mov [N], eax

                call IterateStringSymbols

                cinvoke printf, formatStr, str2
                call [getch]

                jmp ExitProgram

         IterateStringSymbols:
                mov [tmpStack], esp
                mov ecx, [N]
                mov esi, str1
                mov edi, str2
                _loop:
                        push ecx

                        lodsb
                        mov [ediTmp], edi
                        call CheckForSyllable
                        pop ecx

                        LOOP _loop
                mov esp, [tmpStack]     ; возвращаем адрес возврата в стек
                ret

         CheckForSyllable:
                mov [tmpStack2], esp

                mov edi, syllStr
                mov ecx, 6
                repne scas byte [edi]
                je   ToUpper
                jmp EndChecking

         ToUpper:
                sub al, 32
                jmp EndChecking

         EndChecking:
                mov edi, [ediTmp]
                stosb
                mov esp, [tmpStack2]     ; возвращаем адрес возврата в стек
                ret

;--------------------------------------------------------------------------
; Strlen procedure (as strlen in C programming language library)
         strlen:
                mov     edi, [esp+4] ; using msg as stack argument
                mov     ecx, -1      ; ecx must be < 0
                xor     al, al       ; tail symbol is zero
                cld                  ; direction from begin to end
                repne   scasb        ; while(msg[edi] != al) {edi++; ecx--;}
                neg     ecx
                sub     ecx, 2       ; ecx = length(msg)-2
                mov     eax, ecx
                ret

        ExitProgram:
                push NULL
                call [ExitProcess]


section '.idata' import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               VirtualAlloc, 'VirtualAlloc',\   ; для резервирования памяти
               VirtualFree, 'VirtualFree'       ; для освобождения памяти


        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\ ;добавим функцию для считывания
               getch, '_getch'

