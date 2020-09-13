;
; A simple program written with FASM that shows how to fill an application window
; background with color gradient using the 'GradientFill' function.
;
; Program uses buffering to avoid possible flickering during the application window
; resize.
;
; (C) Mikolaj Hajduk, 28.03 - 06.04.2013.
;
format PE GUI 4.0

entry start


; Include a header file containing necessary macros.
;
include 'win32wx.inc'

; Use UTF-8 encoding if you want to have your strings displayed always the same
; way despite of local settings of the user system and if your application has to
; be multilingual.
;
include 'ENCODING\utf8.inc'

; A definition of the constant describing the program version (encoded date of
; the last changes).
;
PROG_VERSION equ '2013.04.06.0'

; Symbolic constants used as equivalents of the button dimensions.
;
BTN_WIDTH       = 150
BTN_HEIGHT      = 40

; A definition of the structure specifying indexes of two vertices in the array
; of TRIVERTEX structures used by GradientFill function. Chosen vertices determine
; the upper-left and lower-right boundaries of the rectangle filled with gradient.
;
struct GRADIENT_RECT
        UpperLeft       dd ?
        LowerRight      dd ?
ends

; Constants specifying possible gradient fill modes.
;
GRADIENT_FILL_RECT_H            = 0x0   ; Horizontal gradient.

GRADIENT_FILL_RECT_V            = 0x1   ; Vertical gradient.

; A constant used to define private messages within the scope of the application.
;
WM_APP          = 0x8000

; A code of the application specific message used to change gradient colors
; from default to custom ones.
;
WM_SETGRADIENT  = WM_APP


; The data section.
;
section '.data' data readable writeable

        HwndMain        dd 0    ; The handle of the main application window.

        HwndBis         dd 0    ; The handle of the additional resizable application
                                ; window.

        hFont           dd 0    ; The handle of the font used to display strings
                                ; inside window controls.

        ; An arbitrarily chosen class name of the created window.
        ;
        ClassName       du 'GradientFillExample', 0

        ; A string displayed in the application window title bar.
        ;
        WindowCaption   du 'Gradient fill example v.', PROG_VERSION, 0

        ; An instance of the WNDCLASSEX structure containing information about
        ; the created window class.
        ;
        wc              WNDCLASSEX      sizeof.WNDCLASSEX, 0, WindowProc, 0,\
                                        \
                                        8,\     ; The number of extra bytes allocated
                                        \       ; following every class instance.
                                        \       ; Here we need two double words for
                                        \       ; a button handle (first dword) and
                                        \       ; a 32-bit pointer to the array of the
                                        \       ; TRIVERTEX structure instances defining
                                        \       ; colors of actual gradient.
                                        \
                                        NULL, NULL, NULL, NULL, NULL,\
                                        \
                                        ClassName, NULL

        ; An instance of the MSG structure used to store information about
        ; messages from the thread message queue.
        ;
        msg             MSG

        ; The name of the used font. 'Tahoma' is the proper choice for applications
        ; that display strings denoted in the scripts other than Latin (supports
        ; most Unicode chars).
        ;
        FontName        du 'Tahoma', 0

        ; A constant used in INITCOMMONCONTROLSEX as a flag indicating that
        ; all standard common control classes have to be loaded from the DLL.
        ;
        ICC_STANDARD_CLASSES = 0x4000

        ; An instance of the structure carrying information used to load common
        ; control classes.
        ;
        icex            INITCOMMONCONTROLSEX    sizeof.INITCOMMONCONTROLSEX, ICC_STANDARD_CLASSES

        align 4

        ; A custom array of instances of the TRIVERTEX structure containing information
        ; about colors associated with upper-left and lower-right corners of the window
        ; application client area.
        ;
        ;                                       Upper-left
        ;                                       x       y       R       G       B       Alpha
        ;                                       ---------------------------------------------
        CustomVertices          TRIVERTEX       0,      0,      07D00h, 0AA00h, 0C300h, 0
                                TRIVERTEX       0,      0,      07D00h, 0FF00h, 04400h, 0

        ; Default array of instances of the TRIVERTEX structure containing information
        ; about colors associated with upper-left and lower-right corners of the window
        ; application client area.
        ;
        ;                                       Upper-left
        ;                                       x       y       R       G       B       Alpha
        ;                                       ---------------------------------------------
        DefaultVertices         TRIVERTEX       0,      0,      07D00h, 0AA00h, 0C300h, 0
                                TRIVERTEX       0,      0,      0FF00h, 02A00h, 04400h, 0

        ; An instance of the 'GRADIENT_RECT' structure determining indexes
        ; of the array of 'TRIVERTEX' structures used by 'GradientFill' function
        ; to fill an area with gradient.
        ;
        Mesh                    GRADIENT_RECT   0, 1


; The code section.
;
section '.code' code readable executable

        start:
                ; Ensure that the common control DLL (Comctl32.dll) is loaded
                ; and register chosen common control classes.
                ;
                invoke  InitCommonControlsEx, icex

                stdcall ErrorRoutine, exit

                ; Retrieve a handle of the application file.
                ;
                invoke  GetModuleHandle, 0

                stdcall ErrorRoutine, exit

                mov     [wc.hInstance], eax

                ; As an application icon use one of the predefined icons.
                ;
                invoke  LoadIcon, 0, IDI_APPLICATION

                stdcall ErrorRoutine, exit

                mov     [wc.hIcon], eax

                ; A cursor associated with the application is a standard, arrow
                ; shaped one.
                ;
                invoke  LoadCursor, 0, IDC_ARROW

                stdcall ErrorRoutine, exit

                mov     [wc.hCursor], eax

                ; Registering the application window class in the system.
                ;
                invoke  RegisterClassEx, wc

                stdcall ErrorRoutine16, exit

                ; Create the main application window.
                ;
                invoke  CreateWindowEx, 0, ClassName, WindowCaption, WS_VISIBLE + WS_OVERLAPPEDWINDOW +\
                                \
                                WS_CLIPCHILDREN,\       ; Exclude child windows from redrawing when
                                \                       ; the drawing occurs within the parent, i.e.
                                \                       ; main application window area.
                                \
                                128, 128, 750, 192, NULL, NULL, [wc.hInstance], NULL

                stdcall ErrorRoutine, exit

                mov     [HwndMain], eax

                ; Create an additional resizable application window.
                ;
                invoke  CreateWindowEx, 0, ClassName, WindowCaption, WS_VISIBLE + WS_SIZEBOX +\
                                \
                                WS_CLIPCHILDREN,\       ; Exclude child windows from redrawing when
                                \                       ; the drawing occurs within the parent, i.e.
                                \                       ; main application window area.
                                \
                                300, 300, 350, 492, NULL, NULL, [wc.hInstance], NULL

                stdcall ErrorRoutine, exit

                mov     [HwndBis], eax

                ; Create a font that will be used to display all strings inside
                ; the application window controls.
                ;
                invoke  CreateFont, 16, 0, 0, 0, 0, FALSE, FALSE, FALSE,\
                                DEFAULT_CHARSET, OUT_RASTER_PRECIS, CLIP_DEFAULT_PRECIS,\
                                DEFAULT_QUALITY, FIXED_PITCH + FF_DONTCARE, FontName

                stdcall ErrorRoutine, cleanup

                mov     [hFont], eax

                ; Set the created font to the main and additional application windows.
                ;
                invoke  SendMessage, [HwndMain], WM_SETFONT, eax, TRUE

                invoke  SendMessage, [HwndBis], WM_SETFONT, [hFont], TRUE

                ; Change the default gradient to the custom one in the additional
                ; application window.
                ;
                invoke  SendMessage, [HwndMain], WM_SETGRADIENT, CustomVertices, 0

        ; A loop where all messages referring to the application window have been
        ; processed.
        ;
        msg_loop:
                ; Retrieve a message from the application message queue.
                ;
                invoke  GetMessage, msg, NULL, 0, 0

                ; Exit when the 'WM_QUIT' message has been retrieved.
                ;
                test    eax, eax
                jz      cleanup

                ; Display a proper error message when something has gone wrong
                ; (eax = -1).
                ;
                inc     eax

                stdcall ErrorRoutine, cleanup

                ; Translate virtual-key strokes into character messages.
                ;
                invoke  TranslateMessage, msg

                ; Dispatch the retrieved message to the window procedure.
                ;
                invoke  DispatchMessage, msg
                jmp     msg_loop

        ; Release all handles and allocated resources before exit.
        ;
        cleanup:
                ; Delete the font used to display strings in the application
                ; window controls.
                ;
                cmp     [hFont], 0
                je      exit

                invoke  DeleteObject, [hFont]

        ; Quit the application.
        ;
        exit:
                invoke  ExitProcess, [msg.wParam]

        ; The error handling routine that organizes the program flow when any of
        ; API functions returns zero value.
        ;
        ErrorRoutine16:
                ; Zeroize bits of the eax register from the 16th to the 31st one.
                ; Done to assure that the eax register won't contain any "garbage"
                ; after calling API functions returning 16-bit result.
                ;
                and     eax, 0xFFFF

        ErrorRoutine:
                ; Check value stored in the eax register. If it's nonzero then
                ; return to the address following the place the error procedure
                ; has been called.
                ;
                test    eax, eax
                jz      @f

                retn    4

                ; Check value of the last error that has occurred.
                ;
                @@:
                invoke  GetLastError
                test    eax, eax
                jnz     @f

                ; If there was no error, i.e. the 'GetLastError' function returned
                ; 'ERROR_SUCCESS', we return to the place when the 'ErrorRoutine'
                ; procedure was called and remove the 'ReturnTo' address stored on
                ; the stack before the procedure call.
                ;
                retn    4

                @@:
                ; If there was an error, we display a message box with a human readable
                ; description of the error, remove the address of the procedure caller
                ; and return to the 'ReturnTo' address.
                ;
                stdcall ShowLastError, NULL, eax

                add     esp, 4
                retn

        ; The main application window procedure. Here we specify how to react
        ; on the events occurring inside the window.
        ;
        proc    WindowProc, hwnd, wmsg, wparam, lparam

                locals
                        .Button         dd 0    ; The handle of the button.

                        .hVertices      dd 0    ; A 32-bit pointer to the array of the TRIVERTEX
                                                ; structure instances used to define gradient
                                                ; colors.

                        .hDC            dd 0    ; The handle of the application window DC.

                        .hMemDC         dd 0    ; The handle of the additional DC (buffer).

                        .hMemBM         dd 0    ; The handle of the bitmap used for the
                                                ; window redraw operations.

                        .Rect           RECT    ; An instance of the RECT structure used
                                                ; to store the coordinates of the upper-left
                                                ; and the lower-right corners of the window
                                                ; client area.
                endl

                push    ebx

                ; Depending on the message type perform proper actions.
                ;
                cmp     [wmsg], WM_CREATE
                je      .wmcreate

                ; Retrieve the handle of the button from the window extra memory and store
                ; it in the local variable '.Button'.
                ;
                invoke  GetWindowLong, [hwnd], 0

                stdcall ErrorRoutine, .wmdestroy

                mov     [.Button], eax

                ; Retrieve the pointer to the array of the TRIVERTEX structure instances
                ; and store it in the local variable '.hVertices'.
                ;
                invoke  GetWindowLong, [hwnd], 4

                stdcall ErrorRoutine, .wmdestroy

                mov     [.hVertices], eax

                cmp     [wmsg], WM_SIZE
                je      .wmsize

                cmp     [wmsg], WM_PAINT
                je      .wmpaint

                cmp     [wmsg], WM_SETFONT
                je      .wmsetfont

                cmp     [wmsg], WM_SETGRADIENT
                je      .wmsetgradient

                cmp     [wmsg], WM_DESTROY
                je      .wmdestroy

                ; Ensure that all messages not processed by the application
                ; window procedure will be processed by default window procedure.
                ;
                .defwndproc:
                        invoke  DefWindowProc, [hwnd], [wmsg], [wparam], [lparam]
                        jmp     .finish


                ; Actions performed when the application window has been created.
                ;
                .wmcreate:
                        ; Create an exemplary button.
                        ;
                        invoke  CreateWindowEx, 0, 'BUTTON', 'Button',\
                                        WS_VISIBLE + WS_CHILD,\
                                        0, 0, 0, 0, [hwnd], 0, [wc.hInstance], NULL

                        stdcall ErrorRoutine, .wmdestroy

                        mov     [.Button], eax

                        ; Store the handles created button handle and pointer to the array
                        ; of the TRIVERTEX structure instances in the reserved window extra
                        ; memory. It's necessary because these values must be available
                        ; during the next call of the 'WindowProc' procedure.
                        ;
                        invoke  SetLastError, 0
                        invoke  SetWindowLong, [hwnd], 0, [.Button]

                        stdcall ErrorRoutine, .wmdestroy

                        invoke  SetLastError, 0
                        invoke  SetWindowLong, [hwnd], 4, DefaultVertices

                        stdcall ErrorRoutine, .wmdestroy

                        ; Window procedure should return 0 when processes the 'WM_CREATE'
                        ; message.
                        ;
                        jmp .return0

                ; Actions performed when the application window has changed its sizes.
                ;
                .wmsize:
                        ; Retrieve the coordinates of the application window client area.
                        ; The result of the procedure 'GetClientRect' is stored in the
                        ; instance of the RECT structure. The coordinates of the upper-left
                        ; corner of the client area rectangle are always equal to (0, 0),
                        ; so the most important are coordinates of the lower-right corner
                        ; as a containing the whole information.
                        ;
                        lea     eax, [.Rect]
                        invoke  GetClientRect, [hwnd], eax

                        stdcall ErrorRoutine, .finish

                        ; Put the width of the client area to the eax register, subtract
                        ; the width of the button and divide the result by 2 to obtain
                        ; the new x coordinate of the upper-left corner of the button.
                        ;
                        mov     eax, [.Rect.right]
                        sub     eax, BTN_WIDTH
                        shr     eax, 1

                        ; Put the height of the client area to the ebx register, subtract
                        ; the height of the button and divide the result by 2 to obtain
                        ; the new y coordinate of the upper-left corner of the button.
                        ;
                        mov     ebx, [.Rect.bottom]
                        sub     ebx, BTN_HEIGHT
                        shr     ebx, 1

                        ; Move the button to the calculated position.
                        ;
                        invoke  MoveWindow, [.Button], eax, ebx, BTN_WIDTH, BTN_HEIGHT, TRUE

                        stdcall ErrorRoutine, .finish

                        ; Window procedure should return 0 when processes the 'WM_SIZE'
                        ; message.
                        ;
                        jmp     .return0

                ; Actions performed when a portion of the application window needs to be redrawn.
                ;
                .wmpaint:
                        ; Retrieve a handle to a device context of the client area of the
                        ; application window.
                        ;
                        invoke  GetDC, [hwnd]

                        stdcall ErrorRoutine, .finish

                        mov     [.hDC], eax

                        ; Retrieve the coordinates of the application window client area.
                        ;
                        lea     eax, [.Rect]
                        invoke  GetClientRect, [hwnd], eax

                        stdcall ErrorRoutine, .wmpaintcleanup

                        ;
                        ; Sequence of actions performed in order to buffer all redraw operations.
                        ;

                        ; Create an additional, memory device context compatible with DC of the
                        ; client area of our application window.
                        ;
                        invoke  CreateCompatibleDC, [.hDC]

                        stdcall ErrorRoutine, .wmpaintcleanup

                        mov     [.hMemDC], eax

                        ; Create a bitmap used to hold the result of the window redraw, assigned
                        ; to the DC of the application window.
                        ;
                        invoke  CreateCompatibleBitmap, [.hDC], [.Rect.right], [.Rect.bottom]

                        stdcall ErrorRoutine, .wmpaintcleanup

                        mov     [.hMemBM], eax

                        ; Change the default bitmap used in additional DC by the one created above.
                        ;
                        invoke  SelectObject, [.hMemDC], [.hMemBM]

                        stdcall ErrorRoutine, .wmpaintcleanup

                        ; Actualization of the coordinates of the structure pointed by '.hVertices'
                        ; with actual coordinates of the lower-right corner of the client area (fields
                        ; corresponding to the upper-left corner don't need to be actualized as they
                        ; are always equal to 0).
                        ;
                        mov     ebx, [.hVertices]
                        add     ebx, sizeof.TRIVERTEX   ; We refer to the second instance of the
                                                        ; TRIVERTEX structure in the array pointed
                                                        ; by '.hVertices'.

                        mov     eax, [.Rect.right]
                        mov     [ebx], eax              ; Lower-right x coordinate.

                        mov     eax, [.Rect.bottom]
                        mov     [ebx + 4], eax          ; Lower-right y coordinate.

                        ; Fill the application window background with gradient.
                        ;
                        invoke  GradientFill, [.hMemDC],\               ; The handle of the additional device
                                                \                       ; context where we perform all drawing
                                                \                       ; operations.
                                                \
                                                [.hVertices],\          ; The pointer to the array of 'TRIVERTEX'
                                                \                       ; structures that define vertices of the
                                                \                       ; area filled with gradient.
                                                \
                                                2,\                     ; Number of vertices in the array mentioned
                                                \                       ; above.
                                                \
                                                Mesh,\          ; A pointer to an array of the 'GRADIENT_RECTANGLE'
                                                \                       ; structures (specify the way we interpret the
                                                \                       ; vertices contained in the 'TRIVERTEX' structures
                                                \                       ; array).
                                                \
                                                1,\                     ; The number of rectangles in the array
                                                \                       ; mentioned above.
                                                \
                                                GRADIENT_FILL_RECT_V    ; The gradient fill mode (here: vertical).

                        stdcall ErrorRoutine, .wmpaintcleanup

                        ; Copy data of the newly drawn background from the source device context
                        ; (buffer) to the destination device context (DC associated with the client
                        ; area of our application window).
                        ;
                        invoke  BitBlt, [.hDC],\                ; The handle of the destination DC.
                                        \
                                        0, 0,\                  ; The coordinates of the upper-left corner
                                        \                       ; of the destination DC.
                                        \
                                        [.Rect.right],\         ; The width and height of the destination
                                        [.Rect.bottom],\        ; device context.
                                        \
                                        [.hMemDC],\             ; The handle of the source DC (memory buffer).
                                        \
                                        0, 0,\                  ; The coordinates of the upper-left corner
                                        \                       ; of the source DC.
                                        \
                                        SRCCOPY                 ; A raster-operation code (ordinary copy).

                        stdcall ErrorRoutine, .wmpaintcleanup

                        ; Release all handles and resources used during painting.
                        ;
                        .wmpaintcleanup:
                                ; Delete the additional unneeded device context.
                                ;
                                cmp     [.hMemDC], 0
                                je      .hMemBMdelete

                                invoke  DeleteDC, [.hMemDC]

                                ; Release resources occupied by the bitmap associated with the
                                ; application DC.
                                ;
                                .hMemBMdelete:
                                        cmp     [.hMemBM], 0
                                        je      .hDCrelease

                                        invoke  DeleteObject, [.hMemBM]

                                ; Release the application window device context retrieved by the
                                ; 'GetDC' function call.
                                ;
                                .hDCrelease:
                                        cmp     [.hDC], 0
                                        je      .wmdestroy

                                        invoke  ReleaseDC, [hwnd], [.hDC]

                                xor     eax, eax

                                jmp     .defwndproc

                ; Actions performed when the window procedure receives the 'WM_SETFONT'
                ; message. Here we forward the 'WM_SETFONT' message to all controls
                ; located inside the window.
                ;
                .wmsetfont:
                        ; Set the new font to the button instead the current one.
                        ;
                        invoke  SendMessage, [.Button], WM_SETFONT, [wparam], TRUE

                        jmp     .finish

                ; Actions performed when the window procedure receives the custom
                ; 'WM_SETGRADIENT' message. We change the pointer to the array of
                ; TRIVERTEX structure instances to the new one passed through 'wparam'
                ; parameter of the window procedure.
                ;
                .wmsetgradient:
                        invoke  SetLastError, 0
                        invoke  SetWindowLong, [hwnd], 4, [wparam]

                        stdcall ErrorRoutine, .finish

                        jmp     .finish

                ; Operations performed when the application window is to be destroyed.
                ; This is a regular cleanup after receiving the 'WM_DESTROY' message: here
                ; we delete objects and resources allocated during the application window
                ; creation. We don't need to destroy all controls (child windows) manually
                ; because it will be done automatically.
                ;
                .wmdestroy:
                        ; Post the 'WM_QUIT' message to the application message queue.
                        ;
                        invoke  PostQuitMessage, 0

                .return0:
                        xor     eax, eax

                .finish:
                        pop     ebx
                        ret
        endp

        ; A simple procedure that displays a message box containing a human readable
        ; description of the last error.
        ;
        proc    ShowLastError, hwnd, LastErr

                locals
                        Buffer dd ?
                endl

                lea     eax, [Buffer]
                invoke  FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + FORMAT_MESSAGE_FROM_SYSTEM, 0, [LastErr],\
                                LANG_NEUTRAL, eax, 0, 0

                invoke  MessageBox, [hwnd], [Buffer], NULL, MB_ICONERROR + MB_OK
                invoke  LocalFree, [Buffer]

                ret
        endp


; The import section.
;
section ".idata" import data readable writeable

library kernel32,               "KERNEL32.DLL",\
        user32,                 "USER32.DLL",\
        gdi32,                  "GDI32.DLL",\
        comctl32,               "COMCTL32.DLL",\
        msimg32,                "MSIMG32.DLL"

import  kernel32,\
        ExitProcess,            "ExitProcess",\
        FormatMessage,          "FormatMessageW",\
        GetLastError,           "GetLastError",\
        GetModuleHandle,        "GetModuleHandleW",\
        LocalFree,              "LocalFree",\
        SetLastError,           "SetLastError"

import  user32,\
        CreateWindowEx,         "CreateWindowExW",\
        DefWindowProc,          "DefWindowProcW",\
        DispatchMessage,        "DispatchMessageW",\
        GetClientRect,          "GetClientRect",\
        GetDC,                  "GetDC",\
        GetMessage,             "GetMessageW",\
        GetWindowLong,          "GetWindowLongW",\
        LoadCursor,             "LoadCursorW",\
        LoadIcon,               "LoadIconW",\
        MessageBox,             "MessageBoxW",\
        MoveWindow,             "MoveWindow",\
        PostQuitMessage,        "PostQuitMessage",\
        RegisterClassEx,        "RegisterClassExW",\
        ReleaseDC,              "ReleaseDC",\
        SendMessage,            "SendMessageW",\
        SetWindowLong,          "SetWindowLongW",\
        TranslateMessage,       "TranslateMessage"

import  gdi32,\
        BitBlt,                 "BitBlt",\
        CreateCompatibleBitmap, "CreateCompatibleBitmap",\
        CreateCompatibleDC,     "CreateCompatibleDC",\
        CreateFont,             "CreateFontW",\
        DeleteDC,               "DeleteDC",\
        DeleteObject,           "DeleteObject",\
        SelectObject,           "SelectObject"

import  comctl32,\
        InitCommonControlsEx,   "InitCommonControlsEx"

import  msimg32,\
        GradientFill,           "GradientFill"


; The section of the program resources. Here we specify information about the
; application (description, author, version) and the application manifest
; informing Windows which version of the common controls program should use
; giving it a modern visual style instead of the classical Win9x "boxy" style.
;
section '.rsrc' resource data readable

        RT_MANIFEST     = 24
        ID_MANIFEST     = 1

        directory       RT_VERSION, versions,\
                        RT_MANIFEST, manifest

        resource        versions,\
                        1, LANG_NEUTRAL, version

        resource        manifest,\
                        ID_MANIFEST, LANG_NEUTRAL, man

        versioninfo     version, VOS__WINDOWS32, VFT_APP, VFT2_UNKNOWN, LANG_ENGLISH + SUBLANG_DEFAULT, 0,\
                        'FileDescription', 'Gradient fill example',\
                        'LegalCopyright', '(C) Mikolaj Hajduk, 2013',\
                        'FileVersion', PROG_VERSION,\
                        'ProductVersion', PROG_VERSION,\
                        'OriginalFilename', 'GradientFill.exe'

        ; Content of the manifest included as an application resource.
        ;
        resdata man
                db '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
                db '<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">'
                db '<assemblyIdentity '
                        db 'version="', PROG_VERSION, '" '
                        db 'processorArchitecture="X86" '
                        db 'name="MikolajHajduk.GradientFill" '
                        db 'type="win32"'
                db '/>'
                db '<description>Gradient fill example.</description>'
                db '<dependency>'
                        db '<dependentAssembly>'
                                db '<assemblyIdentity '
                                        db 'type="win32" '
                                        db 'name="Microsoft.Windows.Common-Controls" '
                                        db 'version="6.0.0.0" '
                                        db 'processorArchitecture="X86" '
                                        db 'publicKeyToken="6595b64144ccf1df" '
                                        db 'language="*"'
                                db '/>'
                        db '</dependentAssembly>'
                db '</dependency>'
                db '</assembly>'
        endres