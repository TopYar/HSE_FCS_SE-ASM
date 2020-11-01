; Дондик Ярослав Витальевич
; Студент группы БПИ191
; Вариант 14
;
; Условие: Разработать программу, заменяющую все гласные буквы в заданной ASCII-строке заглавными

format PE console

entry _start2
include 'win32a.inc'
include 'ascii_macro.inc'

section '.data' data readable writable;
        formatChar db '%c', 0
        formatInt  db '%d', 0
        formatStr  db '%s', 0
        syllStr    db 'aeouyi', 0
        typeString db 'Please, type your line of symbols:', 10, 13, 0
        yourOld    db 10, 13, 'Your old line:', 10, 13, '%s', 10, 13, 0
        yourNew    db 'Your new line:', 10, 13, '%s', 10, 13, 10, 13, 0
        symbolsCh  db 'Symbols were affected: %d ', 10, 13, 0
        newLine    db 10, 13, 0

        str1       rb 1000000  ; исходная строка
        str2       rb 1000000  ; новая строка
        numChg     dd 0        ; количество измененных символов
        tmpStack   dd ?        ; временная переменная для стека
        tmpStack2  dd ?        ; временная переменная для стека
        ediTmp     dd ?        ; временная переменная для EDI
        NULL = 0

section '.code' code readable executable
        _start2:
                cinvoke printf, typeString          ; просим ввести строку символов
                cinvoke scanf, formatStr, str1      ; считываем ASCII строку из консоли

                mov     esi, str1                   ; указываем адрес источника как str1 (исходная строка)
                mov     edi, str2                   ; указываем адрес приемника как str2 (новая строка)

                call    IterateStringSymbols        ; проходимся по всем символам введенной строки

                cinvoke printf, yourOld, str1       ; выводим исходную строку в консоль
                cinvoke printf, yourNew, str2       ; выводим получившуюся строку в консоль
                cinvoke printf, symbolsCh, [numChg] ; выводим количество затронутых символов
                call    [getch]

                jmp ExitProgram
;--------------------------------------------------------------------------
; Iterates for every symbol in ESI. Then checks symbol for being syllable and writes symbol in EDI
         IterateStringSymbols:
                mov     [tmpStack], esp             ; сохраняем стек вместе в адресом возврата
                stdcall strlen, esi                 ; подсчитываем длину строки источника
                mov     ecx, eax                    ; установливаем счетчик цикла на EAX раз (длина строки)
                _loop:
                        push    ecx                 ; сохраняем счетчик в стек

                        lodsb                       ; загружаем символ [esi] (символ, на который указывает esi) в регистр AL: { AL = [esi]; esi += 1; }
                        mov     [ediTmp], edi       ; сохраняем адрес приемника
                        call    CheckForSyllable    ; проверяем символ AL на то, является ли гласной буквой

                        pop     ecx                 ; достаем счетчик из стека
                        LOOP    _loop
                mov esp, [tmpStack]                 ; возвращаем адрес возврата в стек
                ret
;--------------------------------------------------------------------------
; Check either AL is syllable or not. After that writes symbol in EDI
         CheckForSyllable:
                mov [tmpStack2], esp            ; сохраняем стек вместе в адресом возврата

                mov   edi, syllStr              ; указываем адрес приемника как строку с прописными гласными буквами
                mov   ecx, 6                    ; устанавливаем максимум 6 итераций, т.к. всего 6 гласных букв
                repne scas byte [edi]           ; while ( ecx > 0 && syllStr[i] != AL) { ecx -= 1; edi += 1}
                je    ToUpper                   ; если символ гласной нашелся в строке, устанавливается флаг ZF = 1 и происходит прыжок je
                jmp   EndChecking               ; иначе просто заканчиваем проверку

         ToUpper:
                sub   al, 32                    ; вычитаем 32 из кода ASCII прописной гласной (наш AL из [esi]) и получаем заглавную гласную
                inc   [numChg]                  ; увеличиваем количество затронутых символов
                jmp   EndChecking               ; заканчиваем проверку

         EndChecking:
                mov   edi, [ediTmp]             ; возвращаем наш регистр-приемник (str2)
                stosb                           ; устанавливаем AL в байт, на который указывает edi (регистр-приемник): {[edi] = AL; edi += 1; }
                mov   esp, [tmpStack2]          ; возвращаем адрес возврата в стек
                ret

;--------------------------------------------------------------------------
; Strlen0 procedure (as strlen in C programming language library)
         strlen:
                mov     [ediTmp], edi  ; save previous EDI
                mov     edi, [esp+4]   ; using str as stack argument
                mov     ecx, -1        ; ecx must be < 0
                xor     al, al         ; tail symbol is zero
                cld                    ; direction from begin to end
                repne   scasb          ; while(str[edi] != al) {edi++; ecx--;}
                neg     ecx
                sub     ecx, 1         ; ecx = length(str)-1; count \0 symbol
                mov     eax, ecx
                mov     edi, [ediTmp]  ; get previous EDI back
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

