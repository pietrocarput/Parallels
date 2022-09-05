# patch prl_client_app

## 1. patch /usr/bin/codesign verify

find string xref to "/usr/bin/codesign"

### x86_64

```
__text:000000010093B8D0 55                                      push    rbp
__text:000000010093B8D1 48 89 E5                                mov     rbp, rsp
__text:000000010093B8D4 41 57                                   push    r15
__text:000000010093B8D6 41 56                                   push    r14
__text:000000010093B8D8 41 55                                   push    r13
__text:000000010093B8DA 41 54                                   push    r12
__text:000000010093B8DC 53                                      push    rbx
__text:000000010093B8DD 48 81 EC 38 04 00 00                    sub     rsp, 438h
__text:000000010093B8E4 4C 89 85 B8 FB FF FF                    mov     [rbp+var_448], r8
__text:000000010093B8EB 48 89 8D B0 FB FF FF                    mov     [rbp+var_450], rcx
__text:000000010093B8F2 48 89 95 A8 FB FF FF                    mov     [rbp+var_458], rdx
__text:000000010093B8F9 41 89 F4                                mov     r12d, esi
__text:000000010093B8FC 48 89 FB                                mov     rbx, rdi
__text:000000010093B8FF 48 8B 05 F2 91 B7 01                    mov     rax, cs:___stack_chk_guard_ptr
__text:000000010093B906 48 8B 00                                mov     rax, [rax]
__text:000000010093B909 48 89 45 D0                             mov     [rbp+var_30], rax
__text:000000010093B90D 48 8B 0D AC D9 C6 01                    mov     rcx, cs:off_1025A92C0 ; "4C6364ACXT"
__text:000000010093B914 48 8D 15 AC F2 18 00                    lea     rdx, aAnchorAppleGen_0 ; "=anchor apple generic and certificate l"...
__text:000000010093B91B 45 31 F6                                xor     r14d, r14d
__text:000000010093B91E 48 8D BD D0 FB FF FF                    lea     rdi, [rbp+__str] ; __str
__text:000000010093B925 BE 00 04 00 00                          mov     esi, 400h       ; __size
__text:000000010093B92A 31 C0                                   xor     eax, eax
__text:000000010093B92C E8 11 A0 01 00                          call    _snprintf
__text:000000010093B931 48 C7 85 C0 FB FF FF 00+                mov     [rbp+staticCode], 0
__text:000000010093B931 00 00 00
__text:000000010093B93C 48 8D 3D 72 F2 18 00                    lea     rdi, __file     ; "/usr/bin/codesign"
__text:000000010093B943 BE 01 00 00 00                          mov     esi, 1          ; int
__text:000000010093B948 E8 73 9A 01 00                          call    _access
__text:000000010093B94D 85 C0                                   test    eax, eax
__text:000000010093B94F 74 29                                   jz      short loc_10093B97A
```

after


```
__text:000000010093B8D0                         sub_10093B8D0   proc near               ; CODE XREF: sub_10093B890+11↑j
__text:000000010093B8D0                                                                 ; sub_10093B8B0+C↑j
__text:000000010093B8D0 6A 01                                   push    1
__text:000000010093B8D2 58                                      pop     rax
__text:000000010093B8D3 C3                                      retn
__text:000000010093B8D3                         sub_10093B8D0   endp
```

### arm64

```
__text:0000000100977800 FA 67 BB A9                             STP             X26, X25, [SP,#-0x10+var_40]!
__text:0000000100977804 F8 5F 01 A9                             STP             X24, X23, [SP,#0x40+var_30]
__text:0000000100977808 F6 57 02 A9                             STP             X22, X21, [SP,#0x40+var_20]
__text:000000010097780C F4 4F 03 A9                             STP             X20, X19, [SP,#0x40+var_10]
__text:0000000100977810 FD 7B 04 A9                             STP             X29, X30, [SP,#0x40+var_s0]
__text:0000000100977814 FD 03 01 91                             ADD             X29, SP, #0x40
__text:0000000100977818 FF 43 11 D1                             SUB             SP, SP, #0x450
__text:000000010097781C F6 03 04 AA                             MOV             X22, X4
__text:0000000100977820 F7 03 03 AA                             MOV             X23, X3
__text:0000000100977824 F4 03 02 AA                             MOV             X20, X2
__text:0000000100977828 F5 03 01 AA                             MOV             X21, X1
__text:000000010097782C F3 03 00 AA                             MOV             X19, X0
__text:0000000100977830 48 DB 00 B0                             ADRP            X8, #___stack_chk_guard_ptr@PAGE
__text:0000000100977834 08 69 45 F9                             LDR             X8, [X8,#___stack_chk_guard_ptr@PAGEOFF]
__text:0000000100977838 08 01 40 F9                             LDR             X8, [X8]
__text:000000010097783C A8 83 1B F8                             STUR            X8, [X29,#var_48]
__text:0000000100977840 E8 E2 00 D0                             ADRP            X8, #off_1025D5358@PAGE ; "4C6364ACXT"
__text:0000000100977844 08 AD 41 F9                             LDR             X8, [X8,#off_1025D5358@PAGEOFF] ; "4C6364ACXT"
__text:0000000100977848 E8 03 00 F9                             STR             X8, [SP,#0x490+var_490]
__text:000000010097784C C2 D9 00 F0 42 4C 3C 91                 ADRL            X2, aAnchorAppleGen_0 ; "=anchor apple generic and certificate l"...
__text:0000000100977854 E0 23 01 91                             ADD             X0, SP, #0x490+__str ; __str
__text:0000000100977858 01 80 80 52                             MOV             W1, #0x400 ; __size
__text:000000010097785C E1 7D 00 94                             BL              _snprintf
__text:0000000100977860 FF 1F 00 F9                             STR             XZR, [SP,#0x490+staticCode]
__text:0000000100977864 C0 D9 00 F0 00 04 3C 91                 ADRL            X0, aUsrBinCodesign ; "/usr/bin/codesign"
__text:000000010097786C 21 00 80 52                             MOV             W1, #1  ; int
__text:0000000100977870 1B 7B 00 94                             BL              _access
__text:0000000100977874 E0 01 00 34                             CBZ             W0, loc_1009778B0
```

after

```
__text:0000000100977800                         sub_100977800                           ; CODE XREF: sub_1009777DC+10↑j
__text:0000000100977800                                                                 ; sub_1009777F0+C↑j
__text:0000000100977800 20 00 80 D2                             MOV             X0, #1
__text:0000000100977804 C0 03 5F D6                             RET
__text:0000000100977804                         ; End of function sub_100977800
```

