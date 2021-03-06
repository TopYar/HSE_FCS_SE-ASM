; ������ ������� ����������
; ������� ������ ���191
; ������� 14
;
; �������: ����������� ���������, ���������� ��� ������� ����� � �������� ASCII-������ ����������
; ������� ������: ������, ������� �� ����� 1 000 ��������
; �������� ������: ������, � ������� ��� �������� ������� �������� ���������������� ���������� �������

format PE console

entry _start
include 'win32a.inc'
include 'ascii_macro.inc'

section '.data' data readable writable;
        formatStr      db '%s', 0
        inputFormatStr db "%1000[^", 10,"]c", 0 ; ��������� �������� 1000 ��������
        syllStr        db 'aeouyi', 0
        typeString     db 'Please, type your line of symbols:', 10, 13, 0
        yourOld        db 10, 13, 'Your old line:', 10, 13, '%s', 10, 13, 0
        yourNew        db 'Your new line:', 10, 13, '%s', 10, 13, 10, 13, 0
        symbolsCh      db 'Symbols were affected: %d ', 10, 13, 0
        newLine        db 10, 13, 0

        str1           rb 1001          ; �������� ������ (�� 1 ������, ��� �������� ����� ������)
        str2           rb 1001          ; ����� ������
        numChg         dd 0             ; ���������� ���������� ��������
        tmpStack       dd ?             ; ��������� ���������� ��� �����
        tmpStack2      dd ?             ; ��������� ���������� ��� �����
        ediTmp         dd ?             ; ��������� ���������� ��� EDI
        NULL = 0

section '.code' code readable executable
        _start:
                cinvoke printf, typeString          ; ������ ������ ������ ��������
                cinvoke scanf, inputFormatStr, str1 ; ��������� ASCII ������ �� ������� (�������� 1 000 ��������)

                mov     esi, str1                   ; ��������� ����� ��������� ��� str1 (�������� ������)
                mov     edi, str2                   ; ��������� ����� ��������� ��� str2 (����� ������)

                call    IterateStringSymbols        ; ���������� �� ���� �������� ��������� ������

                cinvoke printf, yourOld, str1       ; ������� �������� ������ � �������
                cinvoke printf, yourNew, str2       ; ������� ������������ ������ � �������
                cinvoke printf, symbolsCh, [numChg] ; ������� ���������� ���������� ��������
                call    [getch]

                jmp ExitProgram


;------------------------------------
; Input several macros with all work with esi and edi

        ;------------------------------------
        ; �������� �� ������� ������� � ESI. ���������, ������� �� �����. ���������� ������ � EDI
        IterationOfStringSymbols

        ;--------------------------------------------------------------------------
        ; ���������, �������� �� ������� AL ������� ��� ���. ����� ����� ���������� ������ � EDI
        CheckSymbolForBeingSyllable

        ;--------------------------------------------------------------------------
        ; ��������� ���������� ����� ������
        StrlenProcedure

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

