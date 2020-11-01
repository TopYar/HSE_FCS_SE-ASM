; Дондик Ярослав Витальевич
; Студент группы БПИ191
; Вариант 14
;
; Условие: Разработать программу, заменяющую все гласные буквы в заданной ASCII-строке заглавными
; Входные данные: строка, длинной не более 1 000 символов
; Выходные данные: строка, в которой все строчные гласные заменены соответствующими заглавными буквами

format PE console

entry _start
include 'win32a.inc'
include 'ascii_macro.inc'

section '.data' data readable writable;
        formatStr      db '%s', 0
        inputFormatStr db "%1000[^", 10,"]c", 0 ; считываем максимум 1000 символов
        syllStr        db 'aeouyi', 0
        typeString     db 'Please, type your line of symbols:', 10, 13, 0
        yourOld        db 10, 13, 'Your old line:', 10, 13, '%s', 10, 13, 0
        yourNew        db 'Your new line:', 10, 13, '%s', 10, 13, 10, 13, 0
        symbolsCh      db 'Symbols were affected: %d ', 10, 13, 0
        newLine        db 10, 13, 0

        str1           rb 1001          ; исходная строка (на 1 больше, для признака конца строки)
        str2           rb 1001          ; новая строка
        numChg         dd 0             ; количество измененных символов
        tmpStack       dd ?             ; временная переменная для стека
        tmpStack2      dd ?             ; временная переменная для стека
        ediTmp         dd ?             ; временная переменная для EDI
        NULL = 0

section '.code' code readable executable
        _start:
                cinvoke printf, typeString          ; просим ввести строку символов
                cinvoke scanf, inputFormatStr, str1 ; считываем ASCII строку из консоли (максимум 1 000 символов)

                mov     esi, str1                   ; указываем адрес источника как str1 (исходная строка)
                mov     edi, str2                   ; указываем адрес приемника как str2 (новая строка)

                call    IterateStringSymbols        ; проходимся по всем символам введенной строки

                cinvoke printf, yourOld, str1       ; выводим исходную строку в консоль
                cinvoke printf, yourNew, str2       ; выводим получившуюся строку в консоль
                cinvoke printf, symbolsCh, [numChg] ; выводим количество затронутых символов
                call    [getch]

                jmp ExitProgram


;------------------------------------
; Input several macros with all work with esi and edi

        ;------------------------------------
        ; Проходит по каждому символы в ESI. Проверяет, гласная ли буква. Записывает символ в EDI
        IterationOfStringSymbols

        ;--------------------------------------------------------------------------
        ; Проверяет, является ли регистр AL гласной или нет. После этого записывает символ в EDI
        CheckSymbolForBeingSyllable

        ;--------------------------------------------------------------------------
        ; Процедура вычисления длины строки
        StrlenProcedure

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

