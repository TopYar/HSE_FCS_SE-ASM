format PE console

entry _start
include 'win32a.inc'

section '.data' data readable writable;

        formatStr db '%s', 0
        formatInt db '%d', 0
        formatIntWithSpace db '%d ', 0
        typeSize db 'Please, type size of an array: ', 10, 13, 0
        typeArr db 'Please, type your (int) array: ', 10, 13, 0
        typeMax db 'Max number is %d', 10, 13, 0
        yourArr db 'Your new array:', 10, 13, 0
        newLine db 10, 13, 0

        N dd ?          ; размер массива
        num dd ?        ; введенное число
        i dd 0          ; счетчик в цикле
        arr dd ?        ; массив
        max dd -32768   ; нижн¤¤ граница dd

        NULL = 0

section '.code' code readable executable
        _start:
                cinvoke printf, typeSize
                cinvoke scanf, formatInt, N     ; считываем размер массива
                cinvoke printf, typeArr

                invoke  VirtualAlloc,NULL,[N],MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE ;массив на N чисел
                mov [arr], eax

                jmp _InputArray                 ; идем в процедуру ввода массива
                ReturnFromInput:                ; возвращаемс¤

                cinvoke printf, newLine

                mov [i], 0                      ; обнул¤ем счетчик цикла
                jmp _ChangeNegativeElements     ; выполнение задани¤: заменить отрицательные элементы на максимум
                ReturnFromChanging:

                cinvoke printf, typeMax, [max]  ; выводим максимум в массиве
                cinvoke printf, newLine
                cinvoke printf, yourArr

                mov [i], 0                      ; обнул¤ем счетчик цикла
                jmp _OutputArray                ; выводим весь массив
                ReturnFromOutput:

                call [getch]

                push NULL
                call [ExitProcess]

        ; --ѕ–ќ÷≈ƒ”–џ--
        _InputArray:
                cinvoke scanf, formatInt, num

                mov ecx, [i]
                imul ecx, dword 4       ; вычисл¤ем свдиг указател¤
                mov eax, [arr]
                add eax, ecx            ; смещаем указатель на только что посчитанный сдвиг
                mov ecx, [num]          ; запишем введенное число в ecx
                mov [eax], ecx          ; записали введенное число в ¤чейку массива

                cmp ecx, [max]          ; если введенное число больше максимума,
                jg _UpdateMax           ; то обновл¤ем максимум

                continueInput:          ; метка возвращени¤

                inc [i]                 ; инкременируем счетчик
                mov eax, [i]
                cmp eax, [N]            ; сравнение с размером массива
                jne _InputArray
                jmp ReturnFromInput

        _UpdateMax:                 ; ‘ункци¤, обновл¤юща¤ максимум
                mov [max], ecx
                jmp continueInput  ; возвращаемс¤ в цикл ввода

        _OutputArray:
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [arr]
                add eax, ecx
                mov ecx, [eax]  ; получаем значение элемента в массиве

                cinvoke printf, formatIntWithSpace, ecx   ; вывод числа

                inc [i]
                mov eax, [i]
                cmp eax, [N]
                jne _OutputArray
                jmp ReturnFromOutput

        _ChangeNegativeElements:
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [arr]
                add eax, ecx
                mov ecx, [eax]          ; получаем значение элемента в массиве

                cmp ecx, 0
                jl _UpdateElement       ; обновл¤ем элемент, если он меньше нул¤
                _ReturnChanging:        ; метка возврата из обновлени¤ элемента

                inc [i]
                mov eax, [i]
                cmp eax, [N]
                jne _ChangeNegativeElements
                jmp ReturnFromChanging

        _UpdateElement:
                mov ecx, [max]
                mov [eax], ecx
                jmp _ReturnChanging


section '.idata' import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               VirtualAlloc, 'VirtualAlloc'


        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\ ;добавим функцию дл¤ считывани¤
               getch, '_getch'

