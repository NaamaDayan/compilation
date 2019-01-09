%line 1+1 ./Project_Test/Tests/test_17/test.s



%line 2+1 compiler.s

%line 15+1 compiler.s

%line 24+1 compiler.s

%line 27+1 compiler.s

%line 31+1 compiler.s


%line 36+1 compiler.s



%line 42+1 compiler.s









%line 54+1 compiler.s





%line 62+1 compiler.s







%line 74+1 compiler.s



%line 84+1 compiler.s




%line 93+1 compiler.s




%line 102+1 compiler.s

%line 106+1 compiler.s




%line 128+1 compiler.s




%line 150+1 compiler.s




%line 160+1 compiler.s

%line 166+1 compiler.s

%line 169+1 compiler.s

%line 172+1 compiler.s

%line 175+1 compiler.s


[extern exit]
%line 177+0 compiler.s
[extern printf]
[extern malloc]
%line 178+1 compiler.s
[global write_sob]
%line 178+0 compiler.s
[global write_sob_if_not_void]
[global print_string]
%line 179+1 compiler.s



write_sob_undefined:
 push rbp
 mov rbp, rsp

 mov rax, 0
 mov rdi, .undefined
 call printf

 leave
 ret

[section .data]
.undefined:
 db "#<undefined>", 0

write_sob_integer:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rsi+1]
 mov rdi, .int_format_string
 mov rax, 0
 call printf

 leave
 ret

[section .data]
.int_format_string:
 db "%ld", 0

write_sob_float:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rsi+1]
 movq xmm0, rsi
 mov rdi, .float_format_string
 mov rax, 1

 mov rsi, rsp
 and rsp, -16
 call printf
 mov rsp, rsi

 leave
 ret

[section .data]
.float_format_string:
 db "%f", 0

write_sob_char:
 push rbp
 mov rbp, rsp

 movzx rsi, byte [rsi+1]
 and rsi, 255

 cmp rsi, 0
 je .Lnul

 cmp rsi, 9
 je .Ltab

 cmp rsi, 10
 je .Lnewline

 cmp rsi, 12
 je .Lpage

 cmp rsi, 13
 je .Lreturn

 cmp rsi, 32
 je .Lspace
 jg .Lregular

 mov rdi, .special
 jmp .done

.Lnul:
 mov rdi, .nul
 jmp .done

.Ltab:
 mov rdi, .tab
 jmp .done

.Lnewline:
 mov rdi, .newline
 jmp .done

.Lpage:
 mov rdi, .page
 jmp .done

.Lreturn:
 mov rdi, .return
 jmp .done

.Lspace:
 mov rdi, .space
 jmp .done

.Lregular:
 mov rdi, .regular
 jmp .done

.done:
 mov rax, 0
 call printf

 leave
 ret

[section .data]
.space:
 db "#\space", 0
.newline:
 db "#\newline", 0
.return:
 db "#\return", 0
.tab:
 db "#\tab", 0
.page:
 db "#\page", 0
.nul:
 db "#\nul", 0
.special:
 db "#\x%02x", 0
.regular:
 db "#\%c", 0

write_sob_void:
 push rbp
 mov rbp, rsp

 mov rax, 0
 mov rdi, .void
 call printf

 leave
 ret

[section .data]
.void:
 db "#<void>", 0

write_sob_bool:
 push rbp
 mov rbp, rsp

 cmp word [rsi], word 5
 je .sobFalse

 mov rdi, .true
 jmp .continue

.sobFalse:
 mov rdi, .false

.continue:
 mov rax, 0
 call printf

 leave
 ret

[section .data]
.false:
 db "#f", 0
.true:
 db "#t", 0

write_sob_nil:
 push rbp
 mov rbp, rsp

 mov rax, 0
 mov rdi, .nil
 call printf

 leave
 ret

[section .data]
.nil:
 db "()", 0

write_sob_string:
 push rbp
 mov rbp, rsp

 push rsi

 mov rax, 0
 mov rdi, .double_quote
 call printf

 pop rsi

 mov rcx, qword [rsi+1]
 lea rax, [rsi+1+8]

.loop:
 cmp rcx, 0
 je .done
 mov bl, byte [rax]
 and rbx, 0xff

 cmp rbx, 9
 je .ch_tab
 cmp rbx, 10
 je .ch_newline
 cmp rbx, 12
 je .ch_page
 cmp rbx, 13
 je .ch_return
 cmp rbx, 34
 je .ch_doublequote
 cmp rbx, 92
 je .ch_backslash
 cmp rbx, 32
 jl .ch_hex

 mov rdi, .fs_simple_char
 mov rsi, rbx
 jmp .printf

.ch_hex:
 mov rdi, .fs_hex_char
 mov rsi, rbx
 jmp .printf

.ch_tab:
 mov rdi, .fs_tab
 mov rsi, rbx
 jmp .printf

.ch_page:
 mov rdi, .fs_page
 mov rsi, rbx
 jmp .printf

.ch_return:
 mov rdi, .fs_return
 mov rsi, rbx
 jmp .printf

.ch_newline:
 mov rdi, .fs_newline
 mov rsi, rbx
 jmp .printf

.ch_doublequote:
 mov rdi, .fs_doublequote
 mov rsi, rbx
 jmp .printf

.ch_backslash:
 mov rdi, .fs_backslash
 mov rsi, rbx

.printf:
 push rax
 push rcx
 mov rax, 0
 call printf
 pop rcx
 pop rax

 dec rcx
 inc rax
 jmp .loop

.done:
 mov rax, 0
 mov rdi, .double_quote
 call printf

 leave
 ret
[section .data]
.double_quote:
 db 34, 0
.fs_simple_char:
 db "%c", 0
.fs_hex_char:
 db "\x%02x;", 0
.fs_tab:
 db "\t", 0
.fs_page:
 db "\f", 0
.fs_return:
 db "\r", 0
.fs_newline:
 db "\n", 0
.fs_doublequote:
 db 92, 34, 0
.fs_backslash:
 db 92, 92, 0

write_sob_pair:
 push rbp
 mov rbp, rsp

 push rsi

 mov rax, 0
 mov rdi, .open_paren
 call printf

 mov rsi, [rsp]

 mov rsi, qword [rsi+1]
 call write_sob

 mov rsi, [rsp]
 mov rsi, qword [rsi+1+8]
 call write_sob_pair_on_cdr

 add rsp, 1*8

 mov rdi, .close_paren
 mov rax, 0
 call printf

 leave
 ret

[section .data]
.open_paren:
 db "(", 0
.close_paren:
 db ")", 0

write_sob_pair_on_cdr:
 push rbp
 mov rbp, rsp

 mov bl, byte [rsi]
 cmp bl, 2
 je .done

 cmp bl, 10
 je .cdrIsPair

 push rsi

 mov rax, 0
 mov rdi, .dot
 call printf

 pop rsi

 call write_sob
 jmp .done

.cdrIsPair:
 mov rbx, qword [rsi+1+8]
 push rbx
 mov rsi, qword [rsi+1]
 push rsi

 mov rax, 0
 mov rdi, .space
 call printf

 pop rsi
 call write_sob

 pop rsi
 call write_sob_pair_on_cdr

 add rsp, 1*8

.done:
 leave
 ret

[section .data]
.space:
 db " ", 0
.dot:
 db " . ", 0

write_sob_vector:
 push rbp
 mov rbp, rsp

 push rsi

 mov rax, 0
 mov rdi, .fs_open_vector
 call printf

 pop rsi

 mov rcx, qword [rsi+1]
 cmp rcx, 0
 je .done
 lea rax, [rsi+1+8]

 push rcx
 push rax
 mov rsi, qword [rax]
 call write_sob
 pop rax
 pop rcx
 dec rcx
 add rax, 8

.loop:
 cmp rcx, 0
 je .done

 push rcx
 push rax
 mov rax, 0
 mov rdi, .fs_space
 call printf

 pop rax
 push rax
 mov rsi, qword [rax]
 call write_sob
 pop rax
 pop rcx
 dec rcx
 add rax, 8
 jmp .loop

.done:
 mov rax, 0
 mov rdi, .fs_close_vector
 call printf

 leave
 ret

[section .data]
.fs_open_vector:
 db "#(", 0
.fs_close_vector:
 db ")", 0
.fs_space:
 db " ", 0

write_sob_symbol:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rsi+1]

 mov rcx, qword [rsi+1]
 lea rax, [rsi+1+8]

 mov rdx, rcx

.loop:
 cmp rcx, 0
 je .done
 mov bl, byte [rax]
 and rbx, 0xff

 cmp rcx, rdx
 jne .ch_simple
 cmp rbx, '+'
 je .ch_hex
 cmp rbx, '-'
 je .ch_hex
 cmp rbx, 'A'
 jl .ch_hex

.ch_simple:
 mov rdi, .fs_simple_char
 mov rsi, rbx
 jmp .printf

.ch_hex:
 mov rdi, .fs_hex_char
 mov rsi, rbx

.printf:
 push rax
 push rcx
 mov rax, 0
 call printf
 pop rcx
 pop rax

 dec rcx
 inc rax
 jmp .loop

.done:
 leave
 ret

[section .data]
.fs_simple_char:
 db "%c", 0
.fs_hex_char:
 db "\x%02x;", 0

write_sob_closure:
 push rbp
 mov rbp, rsp

 mov rdx, qword [rsi+1+8]
 mov rsi, qword [rsi+1]

 mov rdi, .closure
 mov rax, 0
 call printf

 leave
 ret
[section .data]
.closure:
 db "#<closure [env:%p, code:%p]>", 0

[section .text]
write_sob:
 mov rbx, 0
 mov bl, byte [rsi]
 jmp qword [.jmp_table + rbx * 8]

[section .data]
.jmp_table:
 dq write_sob_undefined, write_sob_void, write_sob_nil
 dq write_sob_integer, write_sob_float, write_sob_bool
 dq write_sob_char, write_sob_string, write_sob_symbol
 dq write_sob_closure, write_sob_pair, write_sob_vector

[section .text]
write_sob_if_not_void:
 mov rsi, rax
 mov bl, byte [rsi]
 cmp bl, 1
 je .continue

 call write_sob

 mov rax, 0
 mov rdi, .newline
 call printf

.continue:
 ret
[section .data]
.newline:
 db 10, 0

[section .text]
print_string:
 push rax
 mov rax, 0
 call printf
 pop rax
%line 5+1 ./Project_Test/Tests/test_17/test.s

[section .bss]
malloc_pointer:
 resq 1


[section .data]







%line 23+1 ./Project_Test/Tests/test_17/test.s

%line 27+1 ./Project_Test/Tests/test_17/test.s

%line 31+1 ./Project_Test/Tests/test_17/test.s

%line 35+1 ./Project_Test/Tests/test_17/test.s

%line 39+1 ./Project_Test/Tests/test_17/test.s

%line 43+1 ./Project_Test/Tests/test_17/test.s




%line 50+1 ./Project_Test/Tests/test_17/test.s

%line 59+1 ./Project_Test/Tests/test_17/test.s

%line 62+1 ./Project_Test/Tests/test_17/test.s

%line 67+1 ./Project_Test/Tests/test_17/test.s

%line 71+1 ./Project_Test/Tests/test_17/test.s


%line 81+1 ./Project_Test/Tests/test_17/test.s

%line 90+1 ./Project_Test/Tests/test_17/test.s



%line 108+1 ./Project_Test/Tests/test_17/test.s


%line 113+1 ./Project_Test/Tests/test_17/test.s




notACLosureError:
 db "Error: trying to apply not-a-closure", 0
const_tbl:
db 1
db 2
db 5
%line 122+0 ./Project_Test/Tests/test_17/test.s
db 0
%line 123+1 ./Project_Test/Tests/test_17/test.s
db 5
%line 123+0 ./Project_Test/Tests/test_17/test.s
db 1
%line 124+1 ./Project_Test/Tests/test_17/test.s
db 7
%line 124+0 ./Project_Test/Tests/test_17/test.s
dq 5
db 113
db 117
db 111
db 116
db 101
%line 125+1 ./Project_Test/Tests/test_17/test.s
db 8
%line 125+0 ./Project_Test/Tests/test_17/test.s
dq (const_tbl+6)
%line 126+1 ./Project_Test/Tests/test_17/test.s
db 7
%line 126+0 ./Project_Test/Tests/test_17/test.s
dq 1
db 98
%line 127+1 ./Project_Test/Tests/test_17/test.s
db 8
%line 127+0 ./Project_Test/Tests/test_17/test.s
dq (const_tbl+29)
%line 128+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 128+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+39
 dq const_tbl+1
%line 129+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 129+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+20
 dq const_tbl+48
%line 130+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 130+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+65
 dq const_tbl+1
%line 131+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 131+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+20
 dq const_tbl+82
%line 132+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 132+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+99
 dq const_tbl+1
%line 133+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 133+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+20
 dq const_tbl+116
%line 134+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 134+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+133
 dq const_tbl+1
%line 135+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 135+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+20
 dq const_tbl+150
%line 136+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 136+0 ./Project_Test/Tests/test_17/test.s
dq 1
%line 137+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 137+0 ./Project_Test/Tests/test_17/test.s
dq 2
%line 138+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 138+0 ./Project_Test/Tests/test_17/test.s
dq 3
%line 139+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 139+0 ./Project_Test/Tests/test_17/test.s
dq 4
%line 140+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 140+0 ./Project_Test/Tests/test_17/test.s
dq 5
%line 141+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 141+0 ./Project_Test/Tests/test_17/test.s
dq 6
%line 142+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 142+0 ./Project_Test/Tests/test_17/test.s
dq 7
%line 143+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 143+0 ./Project_Test/Tests/test_17/test.s
dq 8
%line 144+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 144+0 ./Project_Test/Tests/test_17/test.s
dq 9
%line 145+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 145+0 ./Project_Test/Tests/test_17/test.s
dq 10
%line 146+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 146+0 ./Project_Test/Tests/test_17/test.s
dq 11
%line 147+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 147+0 ./Project_Test/Tests/test_17/test.s
dq 12
%line 148+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 148+0 ./Project_Test/Tests/test_17/test.s
dq 13
%line 149+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 149+0 ./Project_Test/Tests/test_17/test.s
dq 14
%line 150+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 150+0 ./Project_Test/Tests/test_17/test.s
dq 15
%line 151+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 151+0 ./Project_Test/Tests/test_17/test.s
dq 16
%line 152+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 152+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+319
 dq const_tbl+1
%line 153+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 153+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+328
 dq const_tbl+1
%line 154+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 154+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+310
 dq const_tbl+345
%line 155+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 155+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+301
 dq const_tbl+362
%line 156+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 156+0 ./Project_Test/Tests/test_17/test.s
dq 17
%line 157+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 157+0 ./Project_Test/Tests/test_17/test.s
dq 18
%line 158+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 158+0 ./Project_Test/Tests/test_17/test.s
dq 19
%line 159+1 ./Project_Test/Tests/test_17/test.s
db 3
%line 159+0 ./Project_Test/Tests/test_17/test.s
dq 20
%line 160+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 160+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+423
 dq const_tbl+1
%line 161+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 161+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+414
 dq const_tbl+432
%line 162+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 162+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+405
 dq const_tbl+449
%line 163+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 163+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+396
 dq const_tbl+466
%line 164+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 164+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+379
 dq const_tbl+483
%line 165+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 165+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+292
 dq const_tbl+500
%line 166+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 166+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+283
 dq const_tbl+517
%line 167+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 167+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+274
 dq const_tbl+534
%line 168+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 168+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+265
 dq const_tbl+551
%line 169+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 169+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+256
 dq const_tbl+568
%line 170+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 170+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+247
 dq const_tbl+585
%line 171+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 171+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+238
 dq const_tbl+602
%line 172+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 172+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+229
 dq const_tbl+619
%line 173+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 173+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+220
 dq const_tbl+636
%line 174+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 174+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+211
 dq const_tbl+653
%line 175+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 175+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+211
 dq const_tbl+670
%line 176+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 176+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+202
 dq const_tbl+687
%line 177+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 177+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+193
 dq const_tbl+704
%line 178+1 ./Project_Test/Tests/test_17/test.s
 db 10
%line 178+0 ./Project_Test/Tests/test_17/test.s
 dq const_tbl+184
 dq const_tbl+721
%line 179+1 ./Project_Test/Tests/test_17/test.s



%line 186+1 ./Project_Test/Tests/test_17/test.s



fvar_tbl:
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
dq 0
[global main]
[section .text]
main:
 push rbp
 mov rbp, rsp

 mov rdi, 1024*1024*4*1024
 call malloc
 mov [malloc_pointer], rax






 push 0
 push qword 0502636308
 push qword 0
 push rsp

 call code_fragment
 add rsp, 4*8
 leave
 ret

code_fragment:
push rbp
mov rbp, rsp





 add qword [malloc_pointer], 1+8*2
%line 256+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_boolean
%line 257+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 0], rax
 add qword [malloc_pointer], 1+8*2
%line 258+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_float
%line 259+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 8], rax
 add qword [malloc_pointer], 1+8*2
%line 260+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_integer
%line 261+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 16], rax
 add qword [malloc_pointer], 1+8*2
%line 262+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_pair
%line 263+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 24], rax
 add qword [malloc_pointer], 1+8*2
%line 264+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_null
%line 265+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 32], rax
 add qword [malloc_pointer], 1+8*2
%line 266+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_char
%line 267+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 40], rax
 add qword [malloc_pointer], 1+8*2
%line 268+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_vector
%line 269+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 48], rax
 add qword [malloc_pointer], 1+8*2
%line 270+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_string
%line 271+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 56], rax
 add qword [malloc_pointer], 1+8*2
%line 272+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_procedure
%line 273+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 64], rax
 add qword [malloc_pointer], 1+8*2
%line 274+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_symbol
%line 275+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 72], rax
 add qword [malloc_pointer], 1+8*2
%line 276+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], string_length
%line 277+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 80], rax
 add qword [malloc_pointer], 1+8*2
%line 278+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], string_ref
%line 279+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 88], rax
 add qword [malloc_pointer], 1+8*2
%line 280+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], string_set
%line 281+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 96], rax
 add qword [malloc_pointer], 1+8*2
%line 282+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], make_string
%line 283+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 104], rax
 add qword [malloc_pointer], 1+8*2
%line 284+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], vector_length
%line 285+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 112], rax
 add qword [malloc_pointer], 1+8*2
%line 286+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], vector_ref
%line 287+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 120], rax
 add qword [malloc_pointer], 1+8*2
%line 288+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], vector_set
%line 289+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 128], rax
 add qword [malloc_pointer], 1+8*2
%line 290+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], make_vector
%line 291+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 136], rax
 add qword [malloc_pointer], 1+8*2
%line 292+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], symbol_to_string
%line 293+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 144], rax
 add qword [malloc_pointer], 1+8*2
%line 294+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], char_to_integer
%line 295+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 152], rax
 add qword [malloc_pointer], 1+8*2
%line 296+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], integer_to_char
%line 297+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 160], rax
 add qword [malloc_pointer], 1+8*2
%line 298+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], is_eq
%line 299+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 168], rax
 add qword [malloc_pointer], 1+8*2
%line 300+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], bin_add
%line 301+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 176], rax
 add qword [malloc_pointer], 1+8*2
%line 302+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], bin_mul
%line 303+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 184], rax
 add qword [malloc_pointer], 1+8*2
%line 304+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], bin_sub
%line 305+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 192], rax
 add qword [malloc_pointer], 1+8*2
%line 306+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], bin_div
%line 307+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 200], rax
 add qword [malloc_pointer], 1+8*2
%line 308+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], bin_lt
%line 309+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 208], rax
 add qword [malloc_pointer], 1+8*2
%line 310+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], bin_equ
%line 311+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 216], rax
 add qword [malloc_pointer], 1+8*2
%line 312+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], car
%line 313+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 224], rax
 add qword [malloc_pointer], 1+8*2
%line 314+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], cdr
%line 315+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 232], rax
 add qword [malloc_pointer], 1+8*2
%line 316+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], set_car
%line 317+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 240], rax
 add qword [malloc_pointer], 1+8*2
%line 318+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], set_cdr
%line 319+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 248], rax
 add qword [malloc_pointer], 1+8*2
%line 320+0 ./Project_Test/Tests/test_17/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], 1
 mov qword [rax+1+8], cons
%line 321+1 ./Project_Test/Tests/test_17/test.s
 mov [fvar_tbl + 256], rax





mov rax , const_tbl + 167
 call write_sob_if_not_void



mov rax , const_tbl + 738
 call write_sob_if_not_void
leave
 ret
is_boolean:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 5
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_float:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 4
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_integer:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 3
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_pair:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 10
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_null:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 2
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_char:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 6
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_vector:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 11
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_string:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 7
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_procedure:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 9
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

is_symbol:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov sil, byte [rsi]

 cmp sil, 8
 jne .wrong_type
 mov rax, 2
 jmp .return

.wrong_type:
 mov rax, 4
.return:
 leave
 ret

string_length:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 add qword [malloc_pointer], 1+8
%line 522+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 523+1 ./Project_Test/Tests/test_17/test.s

 leave
 ret

string_ref:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 lea rsi, [rsi+1+8]
 mov rdi, qword [rbp+(4+1)*8]
 mov rdi, qword [rdi+1]
 shl rdi, 0
 add rsi, rdi

 mov sil, byte [rsi]
 add qword [malloc_pointer], 1+1
%line 539+0 ./Project_Test/Tests/test_17/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 540+1 ./Project_Test/Tests/test_17/test.s

 leave
 ret

string_set:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 lea rsi, [rsi+1+8]
 mov rdi, qword [rbp+(4+1)*8]
 mov rdi, qword [rdi+1]
 shl rdi, 0
 add rsi, rdi

 mov rax, qword [rbp+(4+2)*8]
 movzx rax, byte [rax+1]
 mov byte [rsi], al
 mov rax, 0

 leave
 ret

make_string:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 mov rdi, qword [rbp+(4+1)*8]
 movzx rdi, byte [rdi+1]
 and rdi, 255

 lea rax, [rsi+8+1]
%line 574+0 ./Project_Test/Tests/test_17/test.s
 add qword [malloc_pointer], rax
 push rax
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 7
 mov qword [rax+1], rsi
 push rcx
 add rax,8+1
 mov rcx, rsi
 cmp rcx, 0
..@197.str_loop:
 jz ..@197.str_loop_end
 dec rcx
 mov byte [rax+rcx], dil
 jmp ..@197.str_loop
..@197.str_loop_end:
 pop rcx
 sub rax, 8+1
%line 575+1 ./Project_Test/Tests/test_17/test.s

 leave
 ret

vector_length:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 add qword [malloc_pointer], 1+8
%line 585+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 586+1 ./Project_Test/Tests/test_17/test.s

 leave
 ret

vector_ref:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 lea rsi, [rsi+1+8]
 mov rdi, qword [rbp+(4+1)*8]
 mov rdi, qword [rdi+1]
 shl rdi, 3
 add rsi, rdi

 mov rax, [rsi]

 leave
 ret

vector_set:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 lea rsi, [rsi+1+8]
 mov rdi, qword [rbp+(4+1)*8]
 mov rdi, qword [rdi+1]
 shl rdi, 3
 add rsi, rdi

 mov rdi, qword [rbp+(4+2)*8]
 mov [rsi], rdi
 mov rax, 0

 leave
 ret

make_vector:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 mov rdi, qword [rbp+(4+1)*8]


 lea rax, [rsi*8+8+1]
%line 634+0 ./Project_Test/Tests/test_17/test.s
 add qword [malloc_pointer], rax
 push rax
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 11
 mov qword [rax+1], rsi
 push rcx
 add rax, 8+1
 mov rcx, rsi
 cmp rcx, 0
..@207.vec_loop:
 jz ..@207.vec_loop_end
 dec rcx
 mov qword [rax+rcx*8], rdi
 jmp ..@207.vec_loop
..@207.vec_loop_end:
 sub rax, 8+1
 pop rcx
%line 635+1 ./Project_Test/Tests/test_17/test.s

 leave
 ret

symbol_to_string:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]

 mov rcx, qword [rsi+1]
 lea rdi, [rsi+1+8]

 push rcx
 push rdi

 mov dil, byte [rdi]
 add qword [malloc_pointer], 1+1
%line 654+0 ./Project_Test/Tests/test_17/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], dil
%line 655+1 ./Project_Test/Tests/test_17/test.s
 push rax
 add qword [malloc_pointer], 1+8
%line 656+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rcx
%line 657+1 ./Project_Test/Tests/test_17/test.s
 push rax
 push 2
 push 1
 call make_string
 add rsp, 4*8

 lea rsi, [rax+1+8]

 pop rdi
 pop rcx

.loop:
 cmp rcx, 0
 je .end
 lea r8, [rdi+rcx]
 lea r9, [rsi+rcx]

 mov bl, byte [r8]
 mov byte [r9], bl

 dec rcx
.end:

 leave
 ret

char_to_integer:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 movzx rsi, byte [rsi+1]
 and rsi, 255
 add qword [malloc_pointer], 1+8
%line 691+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 692+1 ./Project_Test/Tests/test_17/test.s

 leave
 ret

integer_to_char:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 and rsi, 255
 add qword [malloc_pointer], 1+1
%line 704+0 ./Project_Test/Tests/test_17/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 705+1 ./Project_Test/Tests/test_17/test.s

 leave
 ret

is_eq:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rdi, qword [rbp+(4+1)*8]
 cmp rsi, rdi
 je .true
 mov rax, 4
 jmp .return

.true:
 mov rax, 2

.return:
 leave
 ret

bin_add:
 push rbp
 mov rbp, rsp

 mov r8, 0

 mov rsi, qword [rbp+(4+0)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .load_numbers
 or r8, 2

.load_numbers:
 push r8

 shr r8, 1
 jc .first_arg_int
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 movq xmm0, rsi
 jmp .load_next_float

.first_arg_int:
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm0, rsi

.load_next_float:
 shr r8, 1
 jc .second_arg_int
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 movq xmm1, rsi
 jmp .perform_float_op

.second_arg_int:
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm1, rsi

.perform_float_op:
 addsd xmm0, xmm1

 pop r8
 cmp r8, 3
 jne .return_float

 cvttsd2si rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 796+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 797+1 ./Project_Test/Tests/test_17/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 801+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 802+1 ./Project_Test/Tests/test_17/test.s

.return:

 leave
 ret

bin_mul:
 push rbp
 mov rbp, rsp

 mov r8, 0

 mov rsi, qword [rbp+(4+0)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .load_numbers
 or r8, 2

.load_numbers:
 push r8

 shr r8, 1
 jc .first_arg_int
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 movq xmm0, rsi
 jmp .load_next_float

.first_arg_int:
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm0, rsi

.load_next_float:
 shr r8, 1
 jc .second_arg_int
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 movq xmm1, rsi
 jmp .perform_float_op

.second_arg_int:
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm1, rsi

.perform_float_op:
 mulsd xmm0, xmm1

 pop r8
 cmp r8, 3
 jne .return_float

 cvttsd2si rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 876+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 877+1 ./Project_Test/Tests/test_17/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 881+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 882+1 ./Project_Test/Tests/test_17/test.s

.return:

 leave
 ret

bin_sub:
 push rbp
 mov rbp, rsp

 mov r8, 0

 mov rsi, qword [rbp+(4+0)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .load_numbers
 or r8, 2

.load_numbers:
 push r8

 shr r8, 1
 jc .first_arg_int
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 movq xmm0, rsi
 jmp .load_next_float

.first_arg_int:
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm0, rsi

.load_next_float:
 shr r8, 1
 jc .second_arg_int
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 movq xmm1, rsi
 jmp .perform_float_op

.second_arg_int:
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm1, rsi

.perform_float_op:
 subsd xmm0, xmm1

 pop r8
 cmp r8, 3
 jne .return_float

 cvttsd2si rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 956+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 957+1 ./Project_Test/Tests/test_17/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 961+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 962+1 ./Project_Test/Tests/test_17/test.s

.return:

 leave
 ret

bin_div:
 push rbp
 mov rbp, rsp

 mov r8, 0

 mov rsi, qword [rbp+(4+0)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .load_numbers
 or r8, 2

.load_numbers:
 push r8

 shr r8, 1
 jc .first_arg_int
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 movq xmm0, rsi
 jmp .load_next_float

.first_arg_int:
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm0, rsi

.load_next_float:
 shr r8, 1
 jc .second_arg_int
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 movq xmm1, rsi
 jmp .perform_float_op

.second_arg_int:
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm1, rsi

.perform_float_op:
 divsd xmm0, xmm1

 pop r8
 cmp r8, 3
 jne .return_float

 cvttsd2si rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1036+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1037+1 ./Project_Test/Tests/test_17/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1041+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1042+1 ./Project_Test/Tests/test_17/test.s

.return:

 leave
 ret

bin_lt:
 push rbp
 mov rbp, rsp

 mov r8, 0

 mov rsi, qword [rbp+(4+0)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .load_numbers
 or r8, 2

.load_numbers:
 push r8

 shr r8, 1
 jc .first_arg_int
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 movq xmm0, rsi
 jmp .load_next_float

.first_arg_int:
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm0, rsi

.load_next_float:
 shr r8, 1
 jc .second_arg_int
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 movq xmm1, rsi
 jmp .perform_float_op

.second_arg_int:
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm1, rsi

.perform_float_op:
 cmpltsd xmm0, xmm1

 pop r8
 cmp r8, 3
 jne .return_float

 cvttsd2si rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1116+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1117+1 ./Project_Test/Tests/test_17/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1121+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1122+1 ./Project_Test/Tests/test_17/test.s

.return:

 mov rsi, qword [rax+1]
 cmp rsi, 0
 je .return_false
 mov rax, 2
 jmp .final_return

.return_false:
 mov rax, 4

.final_return:


 leave
 ret

bin_equ:
 push rbp
 mov rbp, rsp

 mov r8, 0

 mov rsi, qword [rbp+(4+0)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push 1
 call is_float
 add rsp, 3*8


 cmp rax, 2
 je .load_numbers
 or r8, 2

.load_numbers:
 push r8

 shr r8, 1
 jc .first_arg_int
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 movq xmm0, rsi
 jmp .load_next_float

.first_arg_int:
 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm0, rsi

.load_next_float:
 shr r8, 1
 jc .second_arg_int
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 movq xmm1, rsi
 jmp .perform_float_op

.second_arg_int:
 mov rsi, qword [rbp+(4+1)*8]
 mov rsi, qword [rsi+1]
 cvtsi2sd xmm1, rsi

.perform_float_op:
 cmpeqsd xmm0, xmm1

 pop r8
 cmp r8, 3
 jne .return_float

 cvttsd2si rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1208+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1209+1 ./Project_Test/Tests/test_17/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1213+0 ./Project_Test/Tests/test_17/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1214+1 ./Project_Test/Tests/test_17/test.s

.return:

 mov rsi, qword [rax+1]
 cmp rsi, 0
 je .return_false
 mov rax, 2
 jmp .final_return

.return_false:
 mov rax, 4

.final_return:


 leave
 ret

car:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rax, qword [rsi + 1]

 leave
 ret

cdr:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rax, qword [rsi + 1 + 8]

 leave
 ret

set_car:













set_cdr:













cons:









