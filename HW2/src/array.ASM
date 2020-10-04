; Дондик Ярослав Витальевич
; Студент группы БПИ191
; Вариант 14
;
; Условие: Разработать программу, использующую динамическое выделение памяти под массив,
; которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B по следующему правилу:
; заменить все отрицательные числа в массиве на максимум из элементов этого массива

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
        yourOldArr db 'Your old array:', 10, 13, 0
        yourNewArr db 'Your new array:', 10, 13, 0
        wrongInput db 'Incorrect input. Please try again', 10, 13, 10, 13, 0
        newLine db 10, 13, 0

        N dd ?          ; размер массива
        num dd ?        ; введенное число
        i dd 0          ; счетчик в цикле
        A dd ?          ; массив A
        B dd ?          ; массив B
        arr dd ?        ; массив, с которым работаем в данный момент
        max dd -2147483648   ; нижняя граница dd
        tmpStack dd ?   ; временная переменная для стека

        NULL = 0

section '.code' code readable executable
        _start:
                cinvoke printf, typeSize
                cinvoke scanf, formatInt, N     ; считываем размер массива

                mov eax, 1
                cmp eax, [N]                    ; проверяем, был ли размер меньше единицы
                jg WrongInput

                cinvoke printf, typeArr         ; просим ввести массив

                invoke  VirtualAlloc,NULL,[N],MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE ;массив A на N чисел
                mov [A], eax

                invoke  VirtualAlloc,NULL,[N],MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE ;массив B на N чисел
                mov [B], eax

                call InputArray                 ; идем в процедуру ввода массива

                cinvoke printf, newLine

                mov [i], 0                      ; обнуляем счетчик цикла
                call ChangeNegativeElements     ; выполнение задания: заменить отрицательные элементы на максимум

                cinvoke printf, yourOldArr
                mov [i], 0                      ; обнуляем счетчик цикла
                mov eax, [A]                    ; массив, который будем выводить
                mov [arr], eax
                call OutputArray                ; выводим весь массив

                cinvoke printf, newLine
                cinvoke printf, typeMax, [max]  ; выводим максимум в массиве
                cinvoke printf, yourNewArr

                mov [i], 0                      ; обнуляем счетчик цикла
                mov eax, [B]                    ; массив, который будем выводить
                mov [arr], eax
                call OutputArray                ; выводим весь массив


                invoke  VirtualFree, [A], [N], MEM_DECOMMIT  ; освобождение памяти
                invoke  VirtualFree, [B], [N], MEM_DECOMMIT  ; освобождение памяти

                call [getch]

                jmp ExitProgram

        ; --ПРОЦЕДУРЫ--
        InputArray:
                mov [tmpStack], esp
                cinvoke scanf, formatInt, num

                mov ecx, [i]
                imul ecx, dword 4       ; вычисляем свдиг указателя
                mov eax, [A]
                add eax, ecx            ; смещаем указатель на только что посчитанный сдвиг
                mov ecx, [num]          ; запишем введенное число в ecx
                mov [eax], ecx          ; записали введенное число в ячейку массива

                cmp ecx, [max]          ; если введенное число больше максимума,
                jg _UpdateMax           ; то обновляем максимум

                continueInput:          ; метка возвращения

                inc [i]                 ; инкременируем счетчик
                mov eax, [i]
                cmp eax, [N]            ; сравнение с размером массива
                jne InputArray

                mov esp, [tmpStack]     ; возвращаем адрес возврата в стек
                ret

        _UpdateMax:                ; Функция, обновляющая максимум
                mov [max], ecx
                jmp continueInput  ; возвращаемся в цикл ввода

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
                mov [tmpStack], esp     ; сохраняем стек

                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [A]            ; получаем ссылку на массив A
                add eax, ecx
                mov ebx, [eax]          ; получаем значение элемента в массиве

                mov eax, [B]            ; получаем ссылку на массив B
                add eax, ecx
                mov [eax], ebx          ; записываем значение элемента в B

                cmp ebx, 0
                jl _UpdateElement       ; обновляем элемент, если он меньше нуля
                _ReturnChanging:        ; метка возврата из обновления элемента

                inc [i]                 ; инкременируем счетчик
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
               VirtualAlloc, 'VirtualAlloc',\   ; для резервирования памяти
               VirtualFree, 'VirtualFree'       ; для освобождения памяти


        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\ ;добавим функцию для считывания
               getch, '_getch'

