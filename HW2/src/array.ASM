format PE console

entry _start
include 'win32a.inc'

section '.data' data readable writable;

        formatStr db '%s', 0
        formatInt db '%d', 0
        formatIntWithSpace db '%d ', 0
        typeSize db 'Please, type size of an array: ', 10, 13, 0
        typeArr db 'Please, type your (int) array: ', 10, 13, 0
        typeMax db 'Max number is %d', 10, 13, 10, 13, 0
        yourArr db 'Your new array:', 10, 13, 0
        wrongInput db 'Incorrect input. Please try again', 10, 13, 10, 13, 0
        newLine db 10, 13, 0

        N dd ?          ; размер массива
        num dd ?        ; введенное число
        i dd 0          ; счетчик в цикле
        arr dd ?        ; массив
        max dd -2147483648   ; нижн€€ граница dd
        tmpStack dd ?   ; временна€ переменна€ дл€ стека

        NULL = 0

section '.code' code readable executable
        _start:
                cinvoke printf, typeSize
                cinvoke scanf, formatInt, N     ; считываем размер массива

                mov eax, 1
                cmp eax, [N]                    ; провер€ем, был ли размер меньше единицы
                jg WrongInput

                cinvoke printf, typeArr         ; просим ввести массив

                invoke  VirtualAlloc,NULL,[N],MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE ;массив на N чисел
                mov [arr], eax

                call InputArray                 ; идем в процедуру ввода массива

                cinvoke printf, newLine

                mov [i], 0                      ; обнул€ем счетчик цикла
                call ChangeNegativeElements     ; выполнение задани€: заменить отрицательные элементы на максимум


                cinvoke printf, typeMax, [max]  ; выводим максимум в массиве
                cinvoke printf, yourArr

                mov [i], 0                      ; обнул€ем счетчик цикла
                call OutputArray                ; выводим весь массив


                invoke  VirtualFree, [arr], [N], MEM_DECOMMIT  ; освобождение пам€ти

                call [getch]

                jmp ExitProgram

        ; --ѕ–ќ÷≈ƒ”–џ--
        InputArray:
                mov [tmpStack], esp
                cinvoke scanf, formatInt, num

                mov ecx, [i]
                imul ecx, dword 4       ; вычисл€ем свдиг указател€
                mov eax, [arr]
                add eax, ecx            ; смещаем указатель на только что посчитанный сдвиг
                mov ecx, [num]          ; запишем введенное число в ecx
                mov [eax], ecx          ; записали введенное число в €чейку массива

                cmp ecx, [max]          ; если введенное число больше максимума,
                jg _UpdateMax           ; то обновл€ем максимум

                continueInput:          ; метка возвращени€

                inc [i]                 ; инкременируем счетчик
                mov eax, [i]
                cmp eax, [N]            ; сравнение с размером массива
                jne InputArray

                mov esp, [tmpStack]     ; возвращаем адрес возврата в стек
                ret

        _UpdateMax:                ; ‘ункци€, обновл€юща€ максимум
                mov [max], ecx
                jmp continueInput  ; возвращаемс€ в цикл ввода

        OutputArray:
                mov [tmpStack], esp
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [arr]
                add eax, ecx
                mov ecx, [eax]  ; получаем значение элемента в массиве

                cinvoke printf, formatIntWithSpace, ecx   ; вывод числа

                inc [i]
                mov eax, [i]
                cmp eax, [N]
                jne OutputArray

                mov esp, [tmpStack]  ; возвращаем адрес возврата в стек
                ret

        ChangeNegativeElements:
                mov [tmpStack], esp
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [arr]
                add eax, ecx
                mov ecx, [eax]          ; получаем значение элемента в массиве

                cmp ecx, 0
                jl _UpdateElement       ; обновл€ем элемент, если он меньше нул€
                _ReturnChanging:        ; метка возврата из обновлени€ элемента

                inc [i]
                mov eax, [i]
                cmp eax, [N]
                jne ChangeNegativeElements

                mov esp, [tmpStack]  ; возвращаем адрес возврата в стек
                ret

        _UpdateElement:
                mov ecx, [max]
                mov [eax], ecx
                jmp _ReturnChanging

        WrongInput:
                cinvoke printf, wrongInput
                jmp _start

        ExitProgram:
                push NULL
                call [ExitProcess]


section '.idata' import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               VirtualAlloc, 'VirtualAlloc',\   ; дл€ резервировани€ пам€ти
               VirtualFree, 'VirtualFree'       ; дл€ освобождени€ пам€ти


        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\ ;добавим функцию дл€ считывани€
               getch, '_getch'

