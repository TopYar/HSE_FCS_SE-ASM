;*****************
;* CeilFloor.asm * 
;***************** 

format pe gui 4.0 

include 'win32ax.inc' 

XLEN = 640 
YLEN = 400
ELAPSE = 15

struct RGBQUAD 
  rgbBlue     db ? 
  rgbGreen    db ? 
  rgbRed      db ? 
  rgbReserved db ? 
ends 

struct BITMAPINFO 
  bmiHeader BITMAPINFOHEADER 
  bmiColors RGBQUAD 
ends 

section '.data' data readable writeable 

strClass db 'CeilFloor', 0 
strTitle db 'Ceil&Floor - New Title', 0
strError db 'Bonkers!  I hate it when that happens.', 0 

wc WNDCLASS 0, WindowProc, 0, 0, 0, 0, 0, 0, 0, strClass 
bmi BITMAPINFO <28h, 280h, 0FFFFFE70h, 1, 20h, 0, 0, 0, 0, 0, 0>, <0, 0, 0, 0> 
msg MSG 
ps PAINTSTRUCT 

dwValue1 dd 0 
dwValue2 dd 0 

hDC1 dd ? 
hDC2 dd ? 
hDC3 dd ? 

hBitmap1 dd ? 

hGdiObject1 dd ? 
hGdiObject2 dd ? 
hGdiObject3 dd ? 

ppvBits dd ? 

byValue1 db ? 
byValue2 db ? 
byValue3 db ? 
byValue4 db ? 

TableH db 0x320 dup ? 
Table1 db 0x5a0 dup ? 
Table2 db 0x5a0 dup ? 
Table3 db 0x5a0 dup ? 
Table4 db 0x5a0 dup ? 

section '.code' code readable executable 

start: 
        invoke  GetModuleHandle, NULL 
        mov     [wc.hInstance], eax 
        mov     [wc.lpfnWndProc], WindowProc 
        mov     [wc.lpszClassName], strClass 

        invoke  GetStockObject, NULL 
        mov     [wc.hbrBackground], eax 

        stdcall CFProc0 
        invoke  ExitProcess, 0 


proc CFProc0 uses ebx esi edi 
        invoke  LoadIcon, NULL, IDI_APPLICATION 
        mov     [wc.hIcon], eax 

        invoke  LoadCursor, NULL, IDC_ARROW 
        mov     [wc.hCursor], eax 

        invoke  RegisterClass, wc 
        test    eax, eax 
        jz      CeilFloorError 

        invoke  CreateWindowEx, 0, strClass, strTitle, WS_VISIBLE or WS_SYSMENU or WS_HREDRAW, \
                                128, 128, 640, 400, 0, 0, [wc.hInstance], 0 
        test    eax, eax 
        jz      CeilFloorError 

CFProc001: 
        invoke  GetMessage, msg, NULL, 0, 0 
        cmp     eax, 1 
        jb      CeilFloorRet 
        jnz     CFProc001 

        invoke  TranslateMessage, msg 
        invoke  DispatchMessage, msg 

        jmp     CFProc001 

CeilFloorError: 
        invoke  MessageBox, NULL, strError, strTitle, MB_ICONHAND 

CeilFloorRet: 
        ret 
endp 


proc WindowProc uses ebx esi edi, hWnd, uMsg, wParam, lParam 
        mov     eax, [uMsg] 
        cmp     eax, WM_ERASEBKGND 
        jz      .OnEraseBkgnd 
        cmp     eax, WM_PAINT 
        jz      .OnPaint 
        cmp     eax, WM_DESTROY 
        jz      .OnDestroy 
        cmp     eax, WM_TIMER 
        jz      .OnTimer 
        cmp     eax, WM_CREATE 
        jz      .OnCreate 
        cmp     eax, WM_KEYFIRST 
        jz      .OnKeyFirst 

        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam] 
        jmp     WindowProcExit 

.OnKeyFirst: 
        cmp     [wParam], VK_ESCAPE 
        jnz     WindowProcRet 
        jmp     .OnDestroy 

.OnCreate: 
        invoke  GetDC, [hWnd] 
        mov     [hDC1], eax 
        invoke  CreateCompatibleDC, [hDC1] 
        mov     [hDC2], eax 

        invoke  CreateDIBSection, [hDC1], bmi, 0, ppvBits, 0, 0 
        mov     [hGdiObject1], eax 

        invoke  SelectObject, [hDC2], [hGdiObject1] 
        mov     [hGdiObject3], eax 

        invoke  CreateCompatibleDC, [hDC1] 
        mov     [hDC3], eax 

        invoke  CreateCompatibleBitmap, [hDC1], XLEN, YLEN 
        mov     [hBitmap1], eax 

        invoke  SelectObject, [hDC3], [hBitmap1] 
        mov     [hGdiObject2], eax 

        stdcall CFProc1 
        stdcall CFProc2 
        stdcall CFProc4, [hWnd] 

        invoke  ReleaseDC,  [hWnd], [hDC1] 
        invoke  SetTimer, [hWnd], 1, ELAPSE, NULL 
        jmp     WindowProcRet 

.OnTimer: 
        invoke  InvalidateRect, [hWnd], NULL, FALSE 
        jmp     WindowProcRet 

.OnEraseBkgnd: 
        mov     eax, 1 
        jmp     WindowProcRet 

.OnPaint: 
        invoke  BeginPaint, [hWnd], ps 
        mov     [hDC1], eax 
        stdcall CFProc3 
        invoke  BitBlt, [hDC3], 0, 0, XLEN, YLEN, [hDC2], 0, 0, SRCCOPY 
        invoke  BitBlt, [hDC1], 0, 0, XLEN, YLEN, [hDC3], 0, 0, SRCCOPY 
        invoke  EndPaint, [hWnd], ps 
        jmp     WindowProcRet 

.OnDestroy: 
        invoke  KillTimer, [hWnd], 1 
        invoke  SelectObject, [hDC3], [hGdiObject2] 
        invoke  DeleteObject, [hBitmap1] 
        invoke  DeleteDC, [hDC3] 
        invoke  SelectObject, [hDC2], [hGdiObject3] 
        invoke  DeleteDC, [hDC2] 
        invoke  DeleteObject, [hGdiObject1] 
        invoke  DestroyWindow, [hWnd] 
        invoke  PostQuitMessage, 0 

WindowProcRet: 
        xor     eax, eax 

WindowProcExit: 
        ret 
endp 


proc CFProc1 
        mov     esi, 0 
        mov     ecx, 20h 

CFProc101: 
        mov     eax, 20h 
        sub     eax, ecx 
        mov     [byValue3 + esi], al 
        mov     [byValue2 + esi], al 
        mov     byte [byValue1 + esi], 28h 
        mov     byte [byValue4 + esi], 0 
        add     esi, 4 
        loop    CFProc101 
        ret 
endp 


proc CFProc2 
  locals 
    dwVar1 dd ? 
  endl 
        mov     esi, TableH 
        mov     [dwVar1], 2710h 
        mov     ecx, 0 
        fild    [dwVar1] 
        fld     st0 

CFProc201: 
        mov     eax, 0CAh 
        sub     eax, ecx 
        add     eax, 2 
        mov     [dwVar1], eax 
        fidiv   [dwVar1] 
        fstp    dword [esi] 
        wait 
        fld     st0 
        add     esi, 4 
        inc     ecx 
        cmp     ecx, 0C8h 
        jnz     CFProc201 
        ffree   st1 
        ffree   st0 
        fldpi 
        push    0B4h 
        fidiv   dword [esp] 
        pop     eax 
        fld     st0 
        mov     ecx, 0 

CFProc202: 
        mov     ebx, ecx 
        shl     ebx, 2 
        push    ecx 
        fimul   dword [esp] 
        pop     eax 
        fsincos 
        fst     dword [ebx + Table1] 
        wait 
        push    140h 
        fidiv   dword [esp] 
        fstp    dword [ebx + Table3] 
        wait 
        fst     dword [ebx + Table2] 
        wait 
        fidiv   dword [esp] 
        fstp    dword [ebx + Table4] 
        wait 
        pop     eax 
        fld     st0 
        inc     ecx 
        cmp     ecx, 168h 
        jnz     CFProc202 
        ffree   st1 
        ffree   st0 
        ret 
endp 


proc CFProc3 
  locals 
    dwVar1  dd ? 
    dwVar2  dd ? 
    dwVar3  dd ? 
    dwVar4 dd ? 
    dwVar5 dd ? 
    dwVar6 dd ? 
    dwVar7 dd ? 
    dwVar8 dd ? 
    dwVar9 dd ? 
  endl 
        mov     eax, 500h 
        mov     [dwVar1], eax 
        mov     eax, 0F9AFCh 
        mov     [dwVar2], eax 
        mov     ecx, 0FFFFFEC0h 

CFProc301: 
        mov     esi, dword [bmi.bmiColors.rgbBlue] 
        shl     esi, 2 
        push    ecx 
        fld     dword [esi + Table4] 
        fimul   dword [esp] 
        fld     dword [esi + Table1] 
        fsub    st0, st1 
        ffree   st1 
        fstp    [dwVar3] 
        wait 
        fld     dword [esi + Table3] 
        fimul   dword [esp] 
        fadd    dword [esi + Table2] 
        fstp    [dwVar4] 
        wait 
        pop     eax 
        mov     esi, ecx 
        shl     esi, 2 
        mov     eax, [dwVar1] 
        add     eax, esi 
        mov     [dwVar5], eax 
        mov     eax, [dwVar2] 
        add     eax, esi 
        mov     [dwVar6], eax 
        mov     [dwVar9], 0FFFFFF9Ch 
        mov     ebx, 0 

CFProc302: 
        mov     edi, ebx 
        shl     edi, 2 
        fld     dword [edi + TableH] 
        fmul    [dwVar3] 
        fiadd   [dwValue1] 
        fistp   [dwVar7] 
        wait 
        and     [dwVar7], 1Fh 
        fld     dword [edi + TableH] 
        fmul    [dwVar4] 
        fiadd   [dwValue2] 
        fistp   [dwVar8] 
        wait 
        mov     edi, [dwVar8] 
        and     edi, 1Fh 
        shl     edi, 5 
        add     edi, [dwVar7] 
        shl     edi, 2 
        mov     eax, [EdiTable + edi] 
        movzx   esi, al 
        sub     esi, [dwVar9] 
        jge     CFProc303 
        xor     esi, esi 

CFProc303: 
        movzx   edx, ah 
        sub     edx, [dwVar9] 
        jge     CFProc304 
        xor     edx, edx 

CFProc304: 
        shl     edx, 8 
        shr     eax, 10h 
        sub     eax, [dwVar9] 
        jge     CFProc305 
        xor     eax, eax 

CFProc305: 
        shl     eax, 10h 
        or      eax, edx 
        or      eax, esi 
        mov     edi, dword [ppvBits] 
        mov     esi, edi 
        add     edi, [dwVar5] 
        add     esi, [dwVar6] 
        mov     [edi], eax 
        mov     [edi+4], eax 
        mov     [esi], eax 
        mov     [esi+4], eax 
        add     [dwVar5], 0A00h 
        sub     [dwVar6], 0A00h 
        inc     [dwVar9] 
        inc     ebx 
        cmp     ebx, 0B4h 
        jnz     CFProc302 
        inc     ecx 
        cmp     ecx, 140h 
        jnz     CFProc301 
        add     [dwValue2], 2 
        add     [dwValue1], 2 
        mov     eax, dword [bmi.bmiColors.rgbBlue] 
        add     eax, 2 
        mov     ebx, 168h 
        xor     edx, edx 
        div     ebx 
        mov     dword [bmi.bmiColors.rgbBlue], edx 
        ret 
endp 


proc CFProc4 uses ebx ecx edx esi edi, hWnd 
  locals 
    dwVar1 dd ? 
    dwVar2 dd ? 
    dwVar3 dd ? 
    X     dd ? 
    Y     dd ? 
  endl 
        invoke  GetSystemMetrics, SM_CYCAPTION 
        mov     [dwVar1], eax 
        invoke  GetSystemMetrics, SM_CXFIXEDFRAME 
        mov     [dwVar3], eax 
        shl     [dwVar3], 1 
        invoke  GetSystemMetrics, SM_CYFIXEDFRAME 
        mov     [dwVar2], eax 
        invoke  GetSystemMetrics, SM_CXSCREEN 
        mov     ecx, XLEN 
        add     ecx, [dwVar3] 
        sub     eax, ecx 
        shr     eax, 1 
        mov     [X], eax 
        invoke  GetSystemMetrics, SM_CYSCREEN 
        mov     ecx, YLEN 
        add     ecx, [dwVar1] 
        add     ecx, [dwVar2] 
        sub     eax, ecx 
        mov     ecx, 3 
        sub     edx, edx 
        div     ecx 
        mov     [Y], eax 
        mov     ebx, XLEN 
        add     ebx, [dwVar3]  ; cx 
        mov     eax, YLEN 
        add     eax, [dwVar1] 
        add     eax, [dwVar2]  ; cy 
        invoke  SetWindowPos, [hWnd], HWND_TOP, [X], [Y], ebx, eax, SWP_NOZORDER 
        ret 
endp 

EdiTable: 

dd 0x0003A3A03, 0x0003F3F20, 0x0003F3F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F3F20
dd 0x0003F3F20, 0x000303F20, 0x000303F20, 0x0003F3F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F3F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00020003F, 0x000303F20, 0x00020003F, 0x00020003F, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x00020003F, 0x00020003F, 0x00020003F, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00020003F, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x00020003F
dd 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x00020003F, 0x00020003F
dd 0x00020003F, 0x00020003F, 0x000303F20, 0x00020003F, 0x00020003F, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x00020003F
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00020003F, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x00020003F
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00020003F, 0x000303F20, 0x00020003F, 0x00020003F, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x00020003F
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x00020003F, 0x00020003F, 0x00020003F, 0x000303F20, 0x00020003F, 0x00020003F, 0x00020003F, 0x000303F20
dd 0x00020003F, 0x00020003F, 0x00020003F, 0x00020003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F
dd 0x0003F003F, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x0003F003F, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20
dd 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20
dd 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x0003F003F, 0x000303F20, 0x0003F003F, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F
dd 0x0003F003F, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x0003F003F, 0x000303F20, 0x0003F003F, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x0003F003F, 0x0003F003F, 0x0003F003F, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x0003F003F, 0x000303F20, 0x0003F003F, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x0003F003F, 0x0003F003F, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20
dd 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x0003F003F, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000200010, 0x000200010, 0x000200010, 0x000303F20, 0x000200010
dd 0x000200010, 0x000200010, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000200010, 0x000200010, 0x000303F20, 0x000303F20
dd 0x000200010, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20
dd 0x000303F20, 0x000200010, 0x000303F20, 0x000200010, 0x000200010, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000200010, 0x000200010, 0x000200010, 0x000303F20, 0x000200010
dd 0x000200010, 0x000200010, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20
dd 0x000303F20, 0x000200010, 0x000303F20, 0x000200010, 0x000200010, 0x000303F20, 0x000200010, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20
dd 0x000303F20, 0x000200010, 0x000303F20, 0x000200010, 0x000200010, 0x000303F20, 0x000200010, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20
dd 0x000303F20, 0x000200010, 0x000200010, 0x000303F20, 0x000303F20, 0x000200010, 0x000200010, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000303F20, 0x000200010
dd 0x000200010, 0x000200010, 0x000303F20, 0x000200010, 0x000200010, 0x000200010, 0x000303F20, 0x000200010
dd 0x000200010, 0x000200010, 0x000303F20, 0x000200010, 0x000200010, 0x000200010, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20, 0x000200010, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x00000203F, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F3F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F3F20, 0x000303F20
dd 0x000303F20, 0x0003F3F20, 0x0003F3F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F3F20
dd 0x0003F3F20, 0x0003A3A03, 0x0003F3F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20
dd 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x000303F20, 0x0003F3F20
dd 0x0003A3A03, 0x000000000 

.end start 
