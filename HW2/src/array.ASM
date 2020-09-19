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

        N dd ?          ; ������ �������
        num dd ?        ; ��������� �����
        i dd 0          ; ������� � �����
        arr dd ?        ; ������
        max dd -32768   ; ������ ������� dd

        NULL = 0

section '.code' code readable executable
        _start:
                cinvoke printf, typeSize
                cinvoke scanf, formatInt, N     ; ��������� ������ �������
                cinvoke printf, typeArr

                invoke  VirtualAlloc,NULL,[N],MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE ;������ �� N �����
                mov [arr], eax

                jmp _InputArray                 ; ���� � ��������� ����� �������
                ReturnFromInput:                ; ������������

                cinvoke printf, newLine

                mov [i], 0                      ; �������� ������� �����
                jmp _ChangeNegativeElements     ; ���������� �������: �������� ������������� �������� �� ��������
                ReturnFromChanging:

                cinvoke printf, typeMax, [max]  ; ������� �������� � �������
                cinvoke printf, newLine
                cinvoke printf, yourArr

                mov [i], 0                      ; �������� ������� �����
                jmp _OutputArray                ; ������� ���� ������
                ReturnFromOutput:

                call [getch]

                push NULL
                call [ExitProcess]

        ; --���������--
        _InputArray:
                cinvoke scanf, formatInt, num

                mov ecx, [i]
                imul ecx, dword 4       ; ��������� ����� ���������
                mov eax, [arr]
                add eax, ecx            ; ������� ��������� �� ������ ��� ����������� �����
                mov ecx, [num]          ; ������� ��������� ����� � ecx
                mov [eax], ecx          ; �������� ��������� ����� � ������ �������

                cmp ecx, [max]          ; ���� ��������� ����� ������ ���������,
                jg _UpdateMax           ; �� ��������� ��������

                continueInput:          ; ����� �����������

                inc [i]                 ; ������������� �������
                mov eax, [i]
                cmp eax, [N]            ; ��������� � �������� �������
                jne _InputArray
                jmp ReturnFromInput

        _UpdateMax:                 ; �������, ����������� ��������
                mov [max], ecx
                jmp continueInput  ; ������������ � ���� �����

        _OutputArray:
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [arr]
                add eax, ecx
                mov ecx, [eax]  ; �������� �������� �������� � �������

                cinvoke printf, formatIntWithSpace, ecx   ; ����� �����

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
                mov ecx, [eax]          ; �������� �������� �������� � �������

                cmp ecx, 0
                jl _UpdateElement       ; ��������� �������, ���� �� ������ ����
                _ReturnChanging:        ; ����� �������� �� ���������� ��������

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
               scanf, 'scanf',\ ;������� ������� ��� ����������
               getch, '_getch'
