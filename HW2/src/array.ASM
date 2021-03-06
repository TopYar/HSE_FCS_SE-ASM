; ������ ������� ����������
; ������� ������ ���191
; ������� 14
;
; �������: ����������� ���������, ������������ ������������ ��������� ������ ��� ������,
; ������� ������ ���������� ������ A[N], ��������� �� ��������� ������� A ����� ������ B �� ���������� �������:
; �������� ��� ������������� ����� � ������� �� �������� �� ��������� ����� �������

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

        N dd ?          ; ������ �������
        num dd ?        ; ��������� �����
        i dd 0          ; ������� � �����
        A dd ?          ; ������ A
        B dd ?          ; ������ B
        arr dd ?        ; ������, � ������� �������� � ������ ������
        max dd -2147483648   ; ������ ������� dd
        tmpStack dd ?   ; ��������� ���������� ��� �����

        NULL = 0

section '.code' code readable executable
        _start:
                cinvoke printf, typeSize
                cinvoke scanf, formatInt, N     ; ��������� ������ �������

                mov eax, 1
                cmp eax, [N]                    ; ���������, ��� �� ������ ������ �������
                jg WrongInput

                cinvoke printf, typeArr         ; ������ ������ ������

                invoke  VirtualAlloc,NULL,[N],MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE ;������ A �� N �����
                mov [A], eax

                invoke  VirtualAlloc,NULL,[N],MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE ;������ B �� N �����
                mov [B], eax

                call InputArray                 ; ���� � ��������� ����� �������

                cinvoke printf, newLine

                mov [i], 0                      ; �������� ������� �����
                call ChangeNegativeElements     ; ���������� �������: �������� ������������� �������� �� ��������

                cinvoke printf, yourOldArr
                mov [i], 0                      ; �������� ������� �����
                mov eax, [A]                    ; ������, ������� ����� ��������
                mov [arr], eax
                call OutputArray                ; ������� ���� ������

                cinvoke printf, newLine
                cinvoke printf, typeMax, [max]  ; ������� �������� � �������
                cinvoke printf, yourNewArr

                mov [i], 0                      ; �������� ������� �����
                mov eax, [B]                    ; ������, ������� ����� ��������
                mov [arr], eax
                call OutputArray                ; ������� ���� ������


                invoke  VirtualFree, [A], [N], MEM_DECOMMIT  ; ������������ ������
                invoke  VirtualFree, [B], [N], MEM_DECOMMIT  ; ������������ ������

                call [getch]

                jmp ExitProgram

        ; --���������--
        InputArray:
                mov [tmpStack], esp
                cinvoke scanf, formatInt, num

                mov ecx, [i]
                imul ecx, dword 4       ; ��������� ����� ���������
                mov eax, [A]
                add eax, ecx            ; ������� ��������� �� ������ ��� ����������� �����
                mov ecx, [num]          ; ������� ��������� ����� � ecx
                mov [eax], ecx          ; �������� ��������� ����� � ������ �������

                cmp ecx, [max]          ; ���� ��������� ����� ������ ���������,
                jg _UpdateMax           ; �� ��������� ��������

                continueInput:          ; ����� �����������

                inc [i]                 ; ������������� �������
                mov eax, [i]
                cmp eax, [N]            ; ��������� � �������� �������
                jne InputArray

                mov esp, [tmpStack]     ; ���������� ����� �������� � ����
                ret

        _UpdateMax:                ; �������, ����������� ��������
                mov [max], ecx
                jmp continueInput  ; ������������ � ���� �����

        OutputArray:
                mov [tmpStack], esp
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [arr]
                add eax, ecx
                mov ecx, [eax]  ; �������� �������� �������� � �������

                cinvoke printf, formatIntWithSpace, ecx   ; ����� �����

                inc [i]
                mov eax, [i]
                cmp eax, [N]
                jne OutputArray

                mov esp, [tmpStack]  ; ���������� ����� �������� � ����
                ret

        ChangeNegativeElements:
                mov [tmpStack], esp     ; ��������� ����

                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [A]            ; �������� ������ �� ������ A
                add eax, ecx
                mov ebx, [eax]          ; �������� �������� �������� � �������

                mov eax, [B]            ; �������� ������ �� ������ B
                add eax, ecx
                mov [eax], ebx          ; ���������� �������� �������� � B

                cmp ebx, 0
                jl _UpdateElement       ; ��������� �������, ���� �� ������ ����
                _ReturnChanging:        ; ����� �������� �� ���������� ��������

                inc [i]                 ; ������������� �������
                mov eax, [i]
                cmp eax, [N]
                jne ChangeNegativeElements

                mov esp, [tmpStack]  ; ���������� ����� �������� � ����
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
               VirtualAlloc, 'VirtualAlloc',\   ; ��� �������������� ������
               VirtualFree, 'VirtualFree'       ; ��� ������������ ������


        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\ ;������� ������� ��� ����������
               getch, '_getch'

