%line 1+1 ./Project_Test/Tests/test_32/test.s



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
%line 5+1 ./Project_Test/Tests/test_32/test.s

[section .bss]
malloc_pointer:
 resq 1


[section .data]



%line 19+1 ./Project_Test/Tests/test_32/test.s

%line 23+1 ./Project_Test/Tests/test_32/test.s

%line 27+1 ./Project_Test/Tests/test_32/test.s

%line 31+1 ./Project_Test/Tests/test_32/test.s

%line 35+1 ./Project_Test/Tests/test_32/test.s

%line 39+1 ./Project_Test/Tests/test_32/test.s




%line 46+1 ./Project_Test/Tests/test_32/test.s

%line 55+1 ./Project_Test/Tests/test_32/test.s

%line 58+1 ./Project_Test/Tests/test_32/test.s

%line 63+1 ./Project_Test/Tests/test_32/test.s

%line 67+1 ./Project_Test/Tests/test_32/test.s

%line 76+1 ./Project_Test/Tests/test_32/test.s



%line 94+1 ./Project_Test/Tests/test_32/test.s


%line 99+1 ./Project_Test/Tests/test_32/test.s




notACLosureError:
 db "Error: trying to apply not-a-closure", 0
const_tbl:
db 1
db 2
db 5
%line 108+0 ./Project_Test/Tests/test_32/test.s
db 0
%line 109+1 ./Project_Test/Tests/test_32/test.s
db 5
%line 109+0 ./Project_Test/Tests/test_32/test.s
db 1
%line 110+1 ./Project_Test/Tests/test_32/test.s
db 7
%line 110+0 ./Project_Test/Tests/test_32/test.s
dq 5
db 113
db 117
db 111
db 116
db 101
%line 111+1 ./Project_Test/Tests/test_32/test.s
db 8
%line 111+0 ./Project_Test/Tests/test_32/test.s
dq (const_tbl+6)
%line 112+1 ./Project_Test/Tests/test_32/test.s
db 3
%line 112+0 ./Project_Test/Tests/test_32/test.s
dq 4
%line 113+1 ./Project_Test/Tests/test_32/test.s
db 3
%line 113+0 ./Project_Test/Tests/test_32/test.s
dq 5
%line 114+1 ./Project_Test/Tests/test_32/test.s
 db 10
%line 114+0 ./Project_Test/Tests/test_32/test.s
 dq const_tbl+38
 dq const_tbl+1
%line 115+1 ./Project_Test/Tests/test_32/test.s
 db 10
%line 115+0 ./Project_Test/Tests/test_32/test.s
 dq const_tbl+29
 dq const_tbl+47
%line 116+1 ./Project_Test/Tests/test_32/test.s
 db 10
%line 116+0 ./Project_Test/Tests/test_32/test.s
 dq const_tbl+64
 dq const_tbl+1
%line 117+1 ./Project_Test/Tests/test_32/test.s
 db 10
%line 117+0 ./Project_Test/Tests/test_32/test.s
 dq const_tbl+20
 dq const_tbl+81
%line 118+1 ./Project_Test/Tests/test_32/test.s
db 3
%line 118+0 ./Project_Test/Tests/test_32/test.s
dq 1
%line 119+1 ./Project_Test/Tests/test_32/test.s
db 3
%line 119+0 ./Project_Test/Tests/test_32/test.s
dq 2
%line 120+1 ./Project_Test/Tests/test_32/test.s
 db 10
%line 120+0 ./Project_Test/Tests/test_32/test.s
 dq const_tbl+124
 dq const_tbl+1
%line 121+1 ./Project_Test/Tests/test_32/test.s
 db 10
%line 121+0 ./Project_Test/Tests/test_32/test.s
 dq const_tbl+115
 dq const_tbl+133
%line 122+1 ./Project_Test/Tests/test_32/test.s
db 11
 dq 2
dq const_tbl+98
dq const_tbl+150




%line 134+1 ./Project_Test/Tests/test_32/test.s



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
 push qword 7
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
%line 204+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_boolean
%line 205+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 0], rax
 add qword [malloc_pointer], 1+8*2
%line 206+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_float
%line 207+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 8], rax
 add qword [malloc_pointer], 1+8*2
%line 208+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_integer
%line 209+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 16], rax
 add qword [malloc_pointer], 1+8*2
%line 210+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_pair
%line 211+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 24], rax
 add qword [malloc_pointer], 1+8*2
%line 212+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_null
%line 213+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 32], rax
 add qword [malloc_pointer], 1+8*2
%line 214+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_char
%line 215+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 40], rax
 add qword [malloc_pointer], 1+8*2
%line 216+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_vector
%line 217+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 48], rax
 add qword [malloc_pointer], 1+8*2
%line 218+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_string
%line 219+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 56], rax
 add qword [malloc_pointer], 1+8*2
%line 220+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_procedure
%line 221+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 64], rax
 add qword [malloc_pointer], 1+8*2
%line 222+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_symbol
%line 223+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 72], rax
 add qword [malloc_pointer], 1+8*2
%line 224+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_length
%line 225+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 80], rax
 add qword [malloc_pointer], 1+8*2
%line 226+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_ref
%line 227+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 88], rax
 add qword [malloc_pointer], 1+8*2
%line 228+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_set
%line 229+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 96], rax
 add qword [malloc_pointer], 1+8*2
%line 230+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], make_string
%line 231+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 104], rax
 add qword [malloc_pointer], 1+8*2
%line 232+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_length
%line 233+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 112], rax
 add qword [malloc_pointer], 1+8*2
%line 234+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_ref
%line 235+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 120], rax
 add qword [malloc_pointer], 1+8*2
%line 236+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_set
%line 237+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 128], rax
 add qword [malloc_pointer], 1+8*2
%line 238+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], make_vector
%line 239+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 136], rax
 add qword [malloc_pointer], 1+8*2
%line 240+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], symbol_to_string
%line 241+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 144], rax
 add qword [malloc_pointer], 1+8*2
%line 242+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], char_to_integer
%line 243+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 152], rax
 add qword [malloc_pointer], 1+8*2
%line 244+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], integer_to_char
%line 245+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 160], rax
 add qword [malloc_pointer], 1+8*2
%line 246+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_eq
%line 247+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 168], rax
 add qword [malloc_pointer], 1+8*2
%line 248+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_add
%line 249+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 176], rax
 add qword [malloc_pointer], 1+8*2
%line 250+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_mul
%line 251+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 184], rax
 add qword [malloc_pointer], 1+8*2
%line 252+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_sub
%line 253+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 192], rax
 add qword [malloc_pointer], 1+8*2
%line 254+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_div
%line 255+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 200], rax
 add qword [malloc_pointer], 1+8*2
%line 256+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_lt
%line 257+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 208], rax
 add qword [malloc_pointer], 1+8*2
%line 258+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_equ
%line 259+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 216], rax
 add qword [malloc_pointer], 1+8*2
%line 260+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], car
%line 261+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 224], rax
 add qword [malloc_pointer], 1+8*2
%line 262+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], cdr
%line 263+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 232], rax
 add qword [malloc_pointer], 1+8*2
%line 264+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], set_car
%line 265+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 240], rax
 add qword [malloc_pointer], 1+8*2
%line 266+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], set_cdr
%line 267+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 248], rax
 add qword [malloc_pointer], 1+8*2
%line 268+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], cons
%line 269+1 ./Project_Test/Tests/test_32/test.s
 mov [fvar_tbl + 256], rax




 forDebug:

mov rax , const_tbl + 167
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
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
 mov rax, const_tbl+4
 jmp .return

.wrong_type:
 mov rax, const_tbl+2
.return:
 leave
 ret

string_length:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 add qword [malloc_pointer], 1+8
%line 466+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 467+1 ./Project_Test/Tests/test_32/test.s

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
%line 483+0 ./Project_Test/Tests/test_32/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 484+1 ./Project_Test/Tests/test_32/test.s

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
 mov rax, const_tbl+0

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
%line 518+0 ./Project_Test/Tests/test_32/test.s
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
..@137.str_loop:
 jz ..@137.str_loop_end
 dec rcx
 mov byte [rax+rcx], dil
 jmp ..@137.str_loop
..@137.str_loop_end:
 pop rcx
 sub rax, 8+1
%line 519+1 ./Project_Test/Tests/test_32/test.s

 leave
 ret

vector_length:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 add qword [malloc_pointer], 1+8
%line 529+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 530+1 ./Project_Test/Tests/test_32/test.s

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
 mov rax, const_tbl+0

 leave
 ret

make_vector:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 mov rdi, qword [rbp+(4+1)*8]


 lea rax, [rsi*8+8+1]
%line 578+0 ./Project_Test/Tests/test_32/test.s
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
..@147.vec_loop:
 jz ..@147.vec_loop_end
 dec rcx
 mov qword [rax+rcx*8], rdi
 jmp ..@147.vec_loop
..@147.vec_loop_end:
 sub rax, 8+1
 pop rcx
%line 579+1 ./Project_Test/Tests/test_32/test.s

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
%line 598+0 ./Project_Test/Tests/test_32/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], dil
%line 599+1 ./Project_Test/Tests/test_32/test.s
 push rax
 add qword [malloc_pointer], 1+8
%line 600+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rcx
%line 601+1 ./Project_Test/Tests/test_32/test.s
 push rax
 push 2
 push const_tbl+1
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
%line 635+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 636+1 ./Project_Test/Tests/test_32/test.s

 leave
 ret

integer_to_char:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 and rsi, 255
 add qword [malloc_pointer], 1+1
%line 648+0 ./Project_Test/Tests/test_32/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 649+1 ./Project_Test/Tests/test_32/test.s

 leave
 ret

is_eq:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rdi, qword [rbp+(4+1)*8]
 cmp rsi, rdi
 je .true
 mov rax, const_tbl+2
 jmp .return

.true:
 mov rax, const_tbl+4

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
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
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
%line 740+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 741+1 ./Project_Test/Tests/test_32/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 745+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 746+1 ./Project_Test/Tests/test_32/test.s

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
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
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
%line 820+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 821+1 ./Project_Test/Tests/test_32/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 825+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 826+1 ./Project_Test/Tests/test_32/test.s

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
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
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
%line 900+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 901+1 ./Project_Test/Tests/test_32/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 905+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 906+1 ./Project_Test/Tests/test_32/test.s

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
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
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
%line 980+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 981+1 ./Project_Test/Tests/test_32/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 985+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 986+1 ./Project_Test/Tests/test_32/test.s

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
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
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
%line 1060+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1061+1 ./Project_Test/Tests/test_32/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1065+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1066+1 ./Project_Test/Tests/test_32/test.s

.return:

 mov rsi, qword [rax+1]
 cmp rsi, 0
 je .return_false
 mov rax, const_tbl+4
 jmp .final_return

.return_false:
 mov rax, const_tbl+2

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
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
 je .test_next
 or r8, 1

.test_next:

 mov rsi, qword [rbp+(4+1)*8]
 push rsi
 push 1
 push const_tbl+1
 call is_float
 add rsp, 3*8


 cmp rax, const_tbl+4
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
%line 1152+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1153+1 ./Project_Test/Tests/test_32/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1157+0 ./Project_Test/Tests/test_32/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1158+1 ./Project_Test/Tests/test_32/test.s

.return:

 mov rsi, qword [rax+1]
 cmp rsi, 0
 je .return_false
 mov rax, const_tbl+4
 jmp .final_return

.return_false:
 mov rax, const_tbl+2

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
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rdi, qword [rbp+(4+1)*8]
 add qword [malloc_pointer], 1+8*2
%line 1230+0 ./Project_Test/Tests/test_32/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 10
 mov qword [rax+1], rsi
 mov qword [rax+1+8], rdi
%line 1231+1 ./Project_Test/Tests/test_32/test.s

 leave
 ret
