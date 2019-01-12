%line 1+1 ./Project_Test/Tests/test_0/test.s



%line 2+1 compiler.s

%line 15+1 compiler.s

%line 24+1 compiler.s

%line 27+1 compiler.s

%line 31+1 compiler.s


%line 36+1 compiler.s



%line 42+1 compiler.s









%line 54+1 compiler.s



%line 60+1 compiler.s

%line 64+1 compiler.s







%line 76+1 compiler.s



%line 86+1 compiler.s




%line 95+1 compiler.s




%line 104+1 compiler.s

%line 108+1 compiler.s




%line 130+1 compiler.s




%line 152+1 compiler.s




%line 162+1 compiler.s

%line 168+1 compiler.s

%line 171+1 compiler.s

%line 174+1 compiler.s

%line 177+1 compiler.s


[extern exit]
%line 179+0 compiler.s
[extern printf]
[extern malloc]
%line 180+1 compiler.s
[global write_sob]
%line 180+0 compiler.s
[global write_sob_if_not_void]
[global print_string]
%line 181+1 compiler.s



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
%line 5+1 ./Project_Test/Tests/test_0/test.s

[section .bss]
malloc_pointer:
 resq 1


[section .data]



%line 19+1 ./Project_Test/Tests/test_0/test.s

%line 23+1 ./Project_Test/Tests/test_0/test.s

%line 27+1 ./Project_Test/Tests/test_0/test.s

%line 31+1 ./Project_Test/Tests/test_0/test.s

%line 35+1 ./Project_Test/Tests/test_0/test.s

%line 39+1 ./Project_Test/Tests/test_0/test.s




%line 46+1 ./Project_Test/Tests/test_0/test.s

%line 55+1 ./Project_Test/Tests/test_0/test.s





notACLosureError:
 db "Error: trying to apply not-a-closure", 0
const_tbl:
db 1
db 2
db 5
%line 65+0 ./Project_Test/Tests/test_0/test.s
db 0
%line 66+1 ./Project_Test/Tests/test_0/test.s
db 5
%line 66+0 ./Project_Test/Tests/test_0/test.s
db 1
%line 67+1 ./Project_Test/Tests/test_0/test.s
db 7
%line 67+0 ./Project_Test/Tests/test_0/test.s
dq 8
db 119
db 104
db 97
db 116
db 101
db 118
db 101
db 114
%line 68+1 ./Project_Test/Tests/test_0/test.s
db 8
%line 68+0 ./Project_Test/Tests/test_0/test.s
dq (const_tbl+6)
%line 69+1 ./Project_Test/Tests/test_0/test.s
db 3
%line 69+0 ./Project_Test/Tests/test_0/test.s
dq 0
%line 70+1 ./Project_Test/Tests/test_0/test.s
db 3
%line 70+0 ./Project_Test/Tests/test_0/test.s
dq 1
%line 71+1 ./Project_Test/Tests/test_0/test.s
db 7
%line 71+0 ./Project_Test/Tests/test_0/test.s
dq 57
db 116
db 104
db 105
db 115
db 32
db 115
db 104
db 111
db 117
db 108
db 100
db 32
db 98
db 101
db 32
db 97
db 110
db 32
db 101
db 114
db 114
db 111
db 114
db 44
db 32
db 98
db 117
db 116
db 32
db 121
db 111
db 117
db 32
db 100
db 111
db 110
db 39
db 116
db 32
db 115
db 117
db 112
db 112
db 111
db 114
db 116
db 32
db 101
db 120
db 99
db 101
db 112
db 116
db 105
db 111
db 110
db 115
%line 72+1 ./Project_Test/Tests/test_0/test.s
db 6
%line 72+0 ./Project_Test/Tests/test_0/test.s
db 0
%line 73+1 ./Project_Test/Tests/test_0/test.s
db 3
%line 73+0 ./Project_Test/Tests/test_0/test.s
dq 2
%line 74+1 ./Project_Test/Tests/test_0/test.s



%line 81+1 ./Project_Test/Tests/test_0/test.s



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
%line 166+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_boolean
%line 167+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 0], rax
 add qword [malloc_pointer], 1+8*2
%line 168+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_float
%line 169+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 8], rax
 add qword [malloc_pointer], 1+8*2
%line 170+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_integer
%line 171+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 16], rax
 add qword [malloc_pointer], 1+8*2
%line 172+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_pair
%line 173+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 24], rax
 add qword [malloc_pointer], 1+8*2
%line 174+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_null
%line 175+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 32], rax
 add qword [malloc_pointer], 1+8*2
%line 176+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_char
%line 177+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 40], rax
 add qword [malloc_pointer], 1+8*2
%line 178+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_vector
%line 179+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 48], rax
 add qword [malloc_pointer], 1+8*2
%line 180+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_string
%line 181+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 56], rax
 add qword [malloc_pointer], 1+8*2
%line 182+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_procedure
%line 183+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 64], rax
 add qword [malloc_pointer], 1+8*2
%line 184+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_symbol
%line 185+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 72], rax
 add qword [malloc_pointer], 1+8*2
%line 186+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_length
%line 187+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 80], rax
 add qword [malloc_pointer], 1+8*2
%line 188+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_ref
%line 189+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 88], rax
 add qword [malloc_pointer], 1+8*2
%line 190+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_set
%line 191+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 96], rax
 add qword [malloc_pointer], 1+8*2
%line 192+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], make_string
%line 193+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 104], rax
 add qword [malloc_pointer], 1+8*2
%line 194+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_length
%line 195+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 112], rax
 add qword [malloc_pointer], 1+8*2
%line 196+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_ref
%line 197+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 120], rax
 add qword [malloc_pointer], 1+8*2
%line 198+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_set
%line 199+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 128], rax
 add qword [malloc_pointer], 1+8*2
%line 200+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], make_vector
%line 201+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 136], rax
 add qword [malloc_pointer], 1+8*2
%line 202+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], symbol_to_string
%line 203+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 144], rax
 add qword [malloc_pointer], 1+8*2
%line 204+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], char_to_integer
%line 205+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 152], rax
 add qword [malloc_pointer], 1+8*2
%line 206+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], integer_to_char
%line 207+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 160], rax
 add qword [malloc_pointer], 1+8*2
%line 208+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_eq
%line 209+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 168], rax
 add qword [malloc_pointer], 1+8*2
%line 210+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_add
%line 211+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 176], rax
 add qword [malloc_pointer], 1+8*2
%line 212+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_mul
%line 213+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 184], rax
 add qword [malloc_pointer], 1+8*2
%line 214+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_sub
%line 215+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 192], rax
 add qword [malloc_pointer], 1+8*2
%line 216+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_div
%line 217+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 200], rax
 add qword [malloc_pointer], 1+8*2
%line 218+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_lt
%line 219+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 208], rax
 add qword [malloc_pointer], 1+8*2
%line 220+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_equ
%line 221+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 216], rax
 add qword [malloc_pointer], 1+8*2
%line 222+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], car
%line 223+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 224], rax
 add qword [malloc_pointer], 1+8*2
%line 224+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], cdr
%line 225+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 232], rax
 add qword [malloc_pointer], 1+8*2
%line 226+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], set_car
%line 227+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 240], rax
 add qword [malloc_pointer], 1+8*2
%line 228+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], set_cdr
%line 229+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 248], rax
 add qword [malloc_pointer], 1+8*2
%line 230+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], cons
%line 231+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 256], rax
 add qword [malloc_pointer], 1+8*2
%line 232+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], apply
%line 233+1 ./Project_Test/Tests/test_0/test.s
 mov [fvar_tbl + 264], rax




 forDebug:



mov rax, qword [fvar_tbl+256]
 push rax

mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 4

 add qword [malloc_pointer], 1+8*2
%line 255+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode0
%line 256+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont0
Lcode0:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 262+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 263+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 270+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 271+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt4:
 cmp rcx, 0
 je copyParamsEndLoopOpt4
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt4
copyParamsEndLoopOpt4:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 286+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt0
%line 287+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt0
LcodeOpt0:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil0


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop0:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 305+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 306+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop0


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack0:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack0


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN0

 shiftStackAndPushNil0:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil0:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil0

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN0:
 mov qword [rbp + 3*8], 1


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax

mov rax , const_tbl + 1
 push rax
push 2


mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 24
%line 378+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 379+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 389+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 390+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple3:
 cmp rcx, 0
 je copyParamsEndLoopSimple3
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple3
copyParamsEndLoopSimple3:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 405+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode1
%line 406+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont1
Lcode1:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 418+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 419+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 32
%line 428+0 ./Project_Test/Tests/test_0/test.s
 push 32
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 429+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]



mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 442+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 443+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple2:
 cmp rcx, 0
 je copyParamsEndLoopSimple2
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple2
copyParamsEndLoopSimple2:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 458+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode2
%line 459+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont2
Lcode2:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure9

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic9

NotAClosure9:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic9:

cmp rax, const_tbl+2
je Lelse0

 mov rax, qword [rbp + 8*(4 + 0)]
jmp LexitIf0
Lelse0:


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1


mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 40
%line 513+0 ./Project_Test/Tests/test_0/test.s
 push 40
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 514+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]




mov qword r8, [rbx + 24]
mov qword [r9 + 32], r8
mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 530+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 531+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple1:
 cmp rcx, 0
 je copyParamsEndLoopSimple1
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple1
copyParamsEndLoopSimple1:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 546+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode3
%line 547+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont3
Lcode3:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 559+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 560+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 48
%line 569+0 ./Project_Test/Tests/test_0/test.s
 push 48
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 570+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]





mov qword r8, [rbx + 32]
mov qword [r9 + 40], r8
mov qword r8, [rbx + 24]
mov qword [r9 + 32], r8
mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 589+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 590+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple0:
 cmp rcx, 0
 je copyParamsEndLoopSimple0
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple0
copyParamsEndLoopSimple0:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 605+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode4
%line 606+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont4
Lcode4:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 4]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure8

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic8

NotAClosure8:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic8:

cmp rax, const_tbl+2
je Lelse1



 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 4]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure6

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic6

NotAClosure6:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic6:

 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 4]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure7

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic7

NotAClosure7:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic7:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP3

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP3:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP3

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP3:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf1
Lelse1:




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 4]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure4

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic4

NotAClosure4:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic4:

 push rax
push 1


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]

cmp byte [rax], 9
jne NotAClosure3

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic3

NotAClosure3:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic3:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 4]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure5

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic5

NotAClosure5:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic5:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 4]
mov rax, qword [rax + 8 * 3]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP2

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP2:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP2

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP2:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf1:
leave
ret
Lcont4:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]


leave
ret
Lcont3:


cmp byte [rax], 9
jne NotAClosure2

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic2

NotAClosure2:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic2:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP1

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP1:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP1

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP1:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf0:
leave
ret
Lcont2:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]


leave
ret
Lcont1:


cmp byte [rax], 9
jne NotAClosure1

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic1

NotAClosure1:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic1:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP0

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP0:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP0

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP0:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
LcontOpt0:

leave
ret
Lcont0:


cmp byte [rax], 9
jne NotAClosure0

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic0

NotAClosure0:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic0:

mov qword [fvar_tbl+272], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+216]
 push rax
push 1

 add qword [malloc_pointer], 1+8*2
%line 1139+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode5
%line 1140+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont5
Lcode5:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 1146+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 1147+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 1154+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 1155+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple5:
 cmp rcx, 0
 je copyParamsEndLoopSimple5
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple5
copyParamsEndLoopSimple5:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 1170+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode6
%line 1171+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont6
Lcode6:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 32
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP4

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP4:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP4

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP4:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont6:

leave
ret
Lcont5:


cmp byte [rax], 9
jne NotAClosure10

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic10

NotAClosure10:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic10:

mov qword [fvar_tbl+280], rax
mov rax, const_tbl+0
 call write_sob_if_not_void




 add qword [malloc_pointer], 1+8*2
%line 1272+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], LcodeOpt1
%line 1273+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt1
LcodeOpt1:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil1


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop1:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 1291+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 1292+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop1


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack1:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack1


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN1

 shiftStackAndPushNil1:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil1:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil1

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN1:
 mov qword [rbp + 3*8], 1

 mov rax, qword [rbp + 8*(4 + 0)]
leave
ret
LcontOpt1:

mov qword [fvar_tbl+288], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+24]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 3

 add qword [malloc_pointer], 1+8*2
%line 1374+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode7
%line 1375+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont7
Lcode7:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 1381+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 1382+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 1389+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 1390+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple6:
 cmp rcx, 0
 je copyParamsEndLoopSimple6
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple6
copyParamsEndLoopSimple6:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 1405+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode8
%line 1406+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont8
Lcode8:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure12

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic12

NotAClosure12:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic12:

 cmp rax, const_tbl+2
 jne LexitOr0



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure14

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic14

NotAClosure14:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic14:

cmp rax, const_tbl+2
je Lelse2



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure13

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic13

NotAClosure13:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic13:

 push rax
push 1

mov rax, qword [fvar_tbl+296]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP5

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP5:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP5

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP5:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf2
Lelse2:

mov rax , const_tbl + 2
LexitIf2:
 cmp rax, const_tbl+2
 jne LexitOr0
LexitOr0:

leave
ret
Lcont8:

leave
ret
Lcont7:


cmp byte [rax], 9
jne NotAClosure11

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic11

NotAClosure11:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic11:

mov qword [fvar_tbl+296], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+176]
 push rax

mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+24]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 4

 add qword [malloc_pointer], 1+8*2
%line 1621+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode9
%line 1622+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont9
Lcode9:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 1628+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 1629+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 1636+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 1637+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple9:
 cmp rcx, 0
 je copyParamsEndLoopSimple9
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple9
copyParamsEndLoopSimple9:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 1652+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode10
%line 1653+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont10
Lcode10:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax

mov rax , const_tbl + 23
 push rax
push 2

 add qword [malloc_pointer], 24
%line 1667+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 1668+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 1678+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 1679+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple8:
 cmp rcx, 0
 je copyParamsEndLoopSimple8
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple8
copyParamsEndLoopSimple8:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 1694+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode11
%line 1695+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont11
Lcode11:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 1)]
push rbx
 add qword [malloc_pointer], 8
%line 1707+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 1708+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 1)], rax
mov rax, const_tbl+0





mov rax , const_tbl + 32
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0


 add qword [malloc_pointer], 32
%line 1723+0 ./Project_Test/Tests/test_0/test.s
 push 32
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 1724+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]



mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 1737+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 1738+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple7:
 cmp rcx, 0
 je copyParamsEndLoopSimple7
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple7
copyParamsEndLoopSimple7:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 1753+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode12
%line 1754+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont12
Lcode12:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure19

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic19

NotAClosure19:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic19:

cmp rax, const_tbl+2
je Lelse3

 mov rax, qword [rbp + 8*(4 + 1)]
jmp LexitIf3
Lelse3:



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure18

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic18

NotAClosure18:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic18:

cmp rax, const_tbl+2
je Lelse4



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

mov rax , const_tbl + 41
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure16

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic16

NotAClosure16:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic16:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure17

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic17

NotAClosure17:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic17:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP7

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP7:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP7

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP7:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf4
Lelse4:

mov rax , const_tbl + 50
LexitIf4:
LexitIf3:
leave
ret
Lcont12:

push rax

 mov rax, qword [rbp + 8*(4 + 1)]
pop qword [rax]
mov rax, const_tbl+0


mov rax , const_tbl + 32
 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 2


 mov rax, qword [rbp + 8*(4 + 1)]
mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP8

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP8:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP8

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP8:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall



leave
ret
Lcont11:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP6

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP6:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP6

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP6:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont10:

leave
ret
Lcont9:


cmp byte [rax], 9
jne NotAClosure15

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic15

NotAClosure15:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic15:

mov qword [fvar_tbl+304], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+304]
 push rax

mov rax, qword [fvar_tbl+216]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+104]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 5

 add qword [malloc_pointer], 1+8*2
%line 2137+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode13
%line 2138+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont13
Lcode13:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 2144+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 2145+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 2152+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 2153+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt10:
 cmp rcx, 0
 je copyParamsEndLoopOpt10
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt10
copyParamsEndLoopOpt10:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 2168+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt2
%line 2169+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt2
LcodeOpt2:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 1
 cmp rax, 0
 je shiftStackAndPushNil2


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop2:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 2187+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 2188+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop2


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 1
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 1
 shiftStack2:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack2


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN2

 shiftStackAndPushNil2:
 mov rcx, 4 + 1
 mov r12, 0
 shiftStackNil2:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil2

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN2:
 mov qword [rbp + 3*8], 2



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure24

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic24

NotAClosure24:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic24:

cmp rax, const_tbl+2
je Lelse5


mov rax , const_tbl + 116
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP10

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP10:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP10

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP10:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf5
Lelse5:




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure23

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic23

NotAClosure23:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic23:

 push rax

mov rax , const_tbl + 41
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure22

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic22

NotAClosure22:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic22:

cmp rax, const_tbl+2
je Lelse6



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure21

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic21

NotAClosure21:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic21:

 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP9

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP9:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP9

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP9:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf6
Lelse6:

mov rax , const_tbl + 50
LexitIf6:
LexitIf5:
leave
ret
LcontOpt2:

leave
ret
Lcont13:


cmp byte [rax], 9
jne NotAClosure20

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic20

NotAClosure20:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic20:

mov qword [fvar_tbl+104], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+32]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+136]
 push rax

mov rax, qword [fvar_tbl+304]
 push rax
push 4

 add qword [malloc_pointer], 1+8*2
%line 2553+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode14
%line 2554+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont14
Lcode14:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 2560+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 2561+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 2568+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 2569+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt11:
 cmp rcx, 0
 je copyParamsEndLoopOpt11
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt11
copyParamsEndLoopOpt11:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 2584+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt3
%line 2585+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt3
LcodeOpt3:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 1
 cmp rax, 0
 je shiftStackAndPushNil3


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop3:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 2603+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 2604+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop3


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 1
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 1
 shiftStack3:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack3


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN3

 shiftStackAndPushNil3:
 mov rcx, 4 + 1
 mov r12, 0
 shiftStackNil3:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil3

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN3:
 mov qword [rbp + 3*8], 2



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure29

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic29

NotAClosure29:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic29:

cmp rax, const_tbl+2
je Lelse7


mov rax , const_tbl + 32
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP12

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP12:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP12

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP12:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf7
Lelse7:




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure28

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic28

NotAClosure28:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic28:

 push rax

mov rax , const_tbl + 41
 push rax
push 2

mov rax, qword [fvar_tbl+216]

cmp byte [rax], 9
jne NotAClosure27

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic27

NotAClosure27:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic27:

cmp rax, const_tbl+2
je Lelse8



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure26

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic26

NotAClosure26:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic26:

 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP11

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP11:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP11

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP11:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf8
Lelse8:

mov rax , const_tbl + 50
LexitIf8:
LexitIf7:
leave
ret
LcontOpt3:

leave
ret
Lcont14:


cmp byte [rax], 9
jne NotAClosure25

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic25

NotAClosure25:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic25:

mov qword [fvar_tbl+136], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+168]
 push rax
push 1

 add qword [malloc_pointer], 1+8*2
%line 2957+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode15
%line 2958+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont15
Lcode15:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 2964+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 2965+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 2972+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 2973+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple12:
 cmp rcx, 0
 je copyParamsEndLoopSimple12
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple12
copyParamsEndLoopSimple12:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 2988+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode16
%line 2989+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont16
Lcode16:
 push rbp
mov rbp, rsp




mov rax , const_tbl + 4
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure31

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic31

NotAClosure31:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic31:

cmp rax, const_tbl+2
je Lelse9

mov rax , const_tbl + 2
jmp LexitIf9
Lelse9:

mov rax , const_tbl + 4
LexitIf9:
leave
ret
Lcont16:

leave
ret
Lcont15:


cmp byte [rax], 9
jne NotAClosure30

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic30

NotAClosure30:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic30:

mov qword [fvar_tbl+312], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+16]
 push rax

mov rax, qword [fvar_tbl+8]
 push rax
push 2

 add qword [malloc_pointer], 1+8*2
%line 3082+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode17
%line 3083+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont17
Lcode17:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 3089+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 3090+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 3097+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 3098+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple13:
 cmp rcx, 0
 je copyParamsEndLoopSimple13
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple13
copyParamsEndLoopSimple13:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 3113+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode18
%line 3114+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont18
Lcode18:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure33

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic33

NotAClosure33:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic33:

 cmp rax, const_tbl+2
 jne LexitOr1


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP13

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP13:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP13

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP13:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

 cmp rax, const_tbl+2
 jne LexitOr1
LexitOr1:

leave
ret
Lcont18:

leave
ret
Lcont17:


cmp byte [rax], 9
jne NotAClosure32

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic32

NotAClosure32:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic32:

mov qword [fvar_tbl+320], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+264]
 push rax

mov rax, qword [fvar_tbl+256]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 5

 add qword [malloc_pointer], 1+8*2
%line 3267+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode19
%line 3268+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont19
Lcode19:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 3274+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 3275+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 3282+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 3283+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt20:
 cmp rcx, 0
 je copyParamsEndLoopOpt20
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt20
copyParamsEndLoopOpt20:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 3298+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt4
%line 3299+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt4
LcodeOpt4:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 2
 cmp rax, 0
 je shiftStackAndPushNil4


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop4:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 3317+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 3318+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop4


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 2
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 2
 shiftStack4:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack4


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN4

 shiftStackAndPushNil4:
 mov rcx, 4 + 2
 mov r12, 0
 shiftStackNil4:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil4

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN4:
 mov qword [rbp + 3*8], 3



 mov rax, qword [rbp + 8*(4 + 2)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure47

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic47

NotAClosure47:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic47:

cmp rax, const_tbl+2
je Lelse10


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 add qword [malloc_pointer], 24
%line 3416+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 3417+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 3427+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 3428+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple19:
 cmp rcx, 0
 je copyParamsEndLoopSimple19
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple19
copyParamsEndLoopSimple19:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 3443+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode23
%line 3444+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont23
Lcode23:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 32
%line 3455+0 ./Project_Test/Tests/test_0/test.s
 push 32
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 3456+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]



mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 3469+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 3470+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple18:
 cmp rcx, 0
 je copyParamsEndLoopSimple18
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple18
copyParamsEndLoopSimple18:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 3485+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode24
%line 3486+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont24
Lcode24:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 3498+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 3499+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 40
%line 3508+0 ./Project_Test/Tests/test_0/test.s
 push 40
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 3509+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]




mov qword r8, [rbx + 24]
mov qword [r9 + 32], r8
mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 3525+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 3526+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple17:
 cmp rcx, 0
 je copyParamsEndLoopSimple17
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple17
copyParamsEndLoopSimple17:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 3541+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode25
%line 3542+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont25
Lcode25:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure46

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic46

NotAClosure46:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic46:

cmp rax, const_tbl+2
je Lelse12

mov rax , const_tbl + 1
jmp LexitIf12
Lelse12:




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure43

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic43

NotAClosure43:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic43:

 push rax
push 1


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]

cmp byte [rax], 9
jne NotAClosure42

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic42

NotAClosure42:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic42:

 push rax



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure45

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic45

NotAClosure45:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic45:

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure44

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic44

NotAClosure44:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic44:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP20

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP20:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP20

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP20:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf12:
leave
ret
Lcont25:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 1


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP21

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP21:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP21

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP21:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall



leave
ret
Lcont24:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP19

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP19:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP19

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP19:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont23:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP18

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP18:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP18

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP18:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf10
Lelse10:


 mov rax, qword [rbp + 8*(4 + 2)]
 push rax

 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 2

 add qword [malloc_pointer], 24
%line 3947+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 3948+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 3958+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 3959+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple16:
 cmp rcx, 0
 je copyParamsEndLoopSimple16
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple16
copyParamsEndLoopSimple16:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 3974+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode20
%line 3975+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont20
Lcode20:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 32
%line 3986+0 ./Project_Test/Tests/test_0/test.s
 push 32
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 3987+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]



mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 4000+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 4001+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple15:
 cmp rcx, 0
 je copyParamsEndLoopSimple15
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple15
copyParamsEndLoopSimple15:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 4016+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode21
%line 4017+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont21
Lcode21:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 4029+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 4030+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 40
%line 4039+0 ./Project_Test/Tests/test_0/test.s
 push 40
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 4040+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]




mov qword r8, [rbx + 24]
mov qword [r9 + 32], r8
mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 4056+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 4057+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple14:
 cmp rcx, 0
 je copyParamsEndLoopSimple14
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple14
copyParamsEndLoopSimple14:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 4072+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode22
%line 4073+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont22
Lcode22:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure41

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic41

NotAClosure41:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic41:

cmp rax, const_tbl+2
je Lelse11

mov rax , const_tbl + 1
jmp LexitIf11
Lelse11:




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 4]

 push rax
push 2

mov rax, qword [fvar_tbl+328]

cmp byte [rax], 9
jne NotAClosure36

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic36

NotAClosure36:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic36:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure37

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic37

NotAClosure37:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic37:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]

cmp byte [rax], 9
jne NotAClosure35

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic35

NotAClosure35:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic35:

 push rax



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 3]

 push rax
push 2

mov rax, qword [fvar_tbl+328]

cmp byte [rax], 9
jne NotAClosure39

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic39

NotAClosure39:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic39:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure40

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic40

NotAClosure40:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic40:

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]

 push rax
push 3

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure38

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic38

NotAClosure38:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic38:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 3]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP16

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP16:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP16

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP16:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf11:
leave
ret
Lcont22:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 2


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP17

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP17:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP17

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP17:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall



leave
ret
Lcont21:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP15

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP15:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP15

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP15:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont20:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP14

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP14:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP14

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP14:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf10:
leave
ret
LcontOpt4:

leave
ret
Lcont19:


cmp byte [rax], 9
jne NotAClosure34

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic34

NotAClosure34:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic34:

mov qword [fvar_tbl+328], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+176]
 push rax

mov rax, qword [fvar_tbl+304]
 push rax

mov rax, qword [fvar_tbl+136]
 push rax

mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+24]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 7

 add qword [malloc_pointer], 1+8*2
%line 4609+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode26
%line 4610+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont26
Lcode26:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 4616+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 4617+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 4624+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 4625+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple23:
 cmp rcx, 0
 je copyParamsEndLoopSimple23
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple23
copyParamsEndLoopSimple23:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 4640+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode27
%line 4641+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont27
Lcode27:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 24
%line 4652+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 4653+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 4663+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 4664+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple22:
 cmp rcx, 0
 je copyParamsEndLoopSimple22
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple22
copyParamsEndLoopSimple22:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 4679+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode28
%line 4680+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont28
Lcode28:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 4692+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 4693+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 32
%line 4702+0 ./Project_Test/Tests/test_0/test.s
 push 32
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 4703+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]



mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 4716+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 4717+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple21:
 cmp rcx, 0
 je copyParamsEndLoopSimple21
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple21
copyParamsEndLoopSimple21:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 4732+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode29
%line 4733+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont29
Lcode29:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure54

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic54

NotAClosure54:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic54:

cmp rax, const_tbl+2
je Lelse13

 mov rax, qword [rbp + 8*(4 + 1)]
jmp LexitIf13
Lelse13:



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure53

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic53

NotAClosure53:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic53:

cmp rax, const_tbl+2
je Lelse14



 mov rax, qword [rbp + 8*(4 + 2)]
 push rax

mov rax , const_tbl + 41
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 6]


cmp byte [rax], 9
jne NotAClosure49

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic49

NotAClosure49:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic49:

 push rax





 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure51

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic51

NotAClosure51:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic51:

 push rax

 mov rax, qword [rbp + 8*(4 + 2)]
 push rax

 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 3

mov rax, qword [fvar_tbl+128]

cmp byte [rax], 9
jne NotAClosure50

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic50

NotAClosure50:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic50:


 mov rax, qword [rbp + 8*(4 + 1)]

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure52

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic52

NotAClosure52:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic52:

 push rax
push 3


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP23

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 6
mov r12, 1
LoopTP23:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP23

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP23:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf14
Lelse14:

mov rax , const_tbl + 50
LexitIf14:
LexitIf13:
leave
ret
Lcont29:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0


mov rax , const_tbl + 32
 push rax



 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 5]


cmp byte [rax], 9
jne NotAClosure56

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic56

NotAClosure56:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic56:

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure55

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic55

NotAClosure55:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic55:

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 3


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP24

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 6
mov r12, 1
LoopTP24:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP24

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP24:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall



leave
ret
Lcont28:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP22

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP22:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP22

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP22:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont27:

leave
ret
Lcont26:


cmp byte [rax], 9
jne NotAClosure48

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic48

NotAClosure48:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic48:

mov qword [fvar_tbl+336], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+192]
 push rax

mov rax, qword [fvar_tbl+112]
 push rax

mov rax, qword [fvar_tbl+256]
 push rax

mov rax, qword [fvar_tbl+120]
 push rax

mov rax, qword [fvar_tbl+208]
 push rax
push 5

 add qword [malloc_pointer], 1+8*2
%line 5249+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode30
%line 5250+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont30
Lcode30:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 5256+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 5257+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 5264+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 5265+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple26:
 cmp rcx, 0
 je copyParamsEndLoopSimple26
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple26
copyParamsEndLoopSimple26:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 5280+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode31
%line 5281+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont31
Lcode31:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 24
%line 5292+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 5293+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 5303+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 5304+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple25:
 cmp rcx, 0
 je copyParamsEndLoopSimple25
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple25
copyParamsEndLoopSimple25:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 5319+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode32
%line 5320+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont32
Lcode32:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 5332+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 5333+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 32
%line 5342+0 ./Project_Test/Tests/test_0/test.s
 push 32
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 5343+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]



mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 5356+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 5357+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple24:
 cmp rcx, 0
 je copyParamsEndLoopSimple24
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple24
copyParamsEndLoopSimple24:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 5372+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode33
%line 5373+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont33
Lcode33:
 push rbp
mov rbp, rsp




mov rax , const_tbl + 32
 push rax

 mov rax, qword [rbp + 8*(4 + 2)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure61

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic61

NotAClosure61:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic61:

cmp rax, const_tbl+2
je Lelse15

 mov rax, qword [rbp + 8*(4 + 1)]
jmp LexitIf15
Lelse15:



mov rax , const_tbl + 41
 push rax

 mov rax, qword [rbp + 8*(4 + 2)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure58

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic58

NotAClosure58:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic58:

 push rax


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax


 mov rax, qword [rbp + 8*(4 + 2)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure60

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic60

NotAClosure60:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic60:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure59

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic59

NotAClosure59:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic59:

 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 3


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP26

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 6
mov r12, 1
LoopTP26:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP26

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP26:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf15:
leave
ret
Lcont33:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0



mov rax , const_tbl + 41
 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure63

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic63

NotAClosure63:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic63:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure62

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic62

NotAClosure62:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic62:

 push rax

mov rax , const_tbl + 1
 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 3


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP27

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 6
mov r12, 1
LoopTP27:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP27

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP27:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall



leave
ret
Lcont32:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP25

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP25:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP25

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP25:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont31:

leave
ret
Lcont30:


cmp byte [rax], 9
jne NotAClosure57

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic57

NotAClosure57:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic57:

mov qword [fvar_tbl+344], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+336]
 push rax
push 1

 add qword [malloc_pointer], 1+8*2
%line 5813+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode34
%line 5814+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont34
Lcode34:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 5820+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 5821+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 5828+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 5829+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt27:
 cmp rcx, 0
 je copyParamsEndLoopOpt27
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt27
copyParamsEndLoopOpt27:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 5844+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt5
%line 5845+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt5
LcodeOpt5:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil5


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop5:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 5863+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 5864+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop5


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack5:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack5


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN5

 shiftStackAndPushNil5:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil5:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil5

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN5:
 mov qword [rbp + 3*8], 1


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP28

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP28:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP28

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP28:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
LcontOpt5:

leave
ret
Lcont34:


cmp byte [rax], 9
jne NotAClosure64

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic64

NotAClosure64:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic64:

mov qword [fvar_tbl+352], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+264]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+176]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 5

 add qword [malloc_pointer], 1+8*2
%line 6032+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode35
%line 6033+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont35
Lcode35:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 16
%line 6044+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 6045+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 6052+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 6053+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple29:
 cmp rcx, 0
 je copyParamsEndLoopSimple29
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple29
copyParamsEndLoopSimple29:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 6068+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode36
%line 6069+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont36
Lcode36:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 6081+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 6082+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 24
%line 6091+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 6092+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 6102+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 6103+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt28:
 cmp rcx, 0
 je copyParamsEndLoopOpt28
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt28
copyParamsEndLoopOpt28:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 6118+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt6
%line 6119+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt6
LcodeOpt6:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil6


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop6:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 6137+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 6138+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop6


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack6:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack6


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN6

 shiftStackAndPushNil6:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil6:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil6

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN6:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure69

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic69

NotAClosure69:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic69:

cmp rax, const_tbl+2
je Lelse16

mov rax , const_tbl + 32
jmp LexitIf16
Lelse16:




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure67

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic67

NotAClosure67:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic67:

 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure66

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic66

NotAClosure66:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic66:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure68

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic68

NotAClosure68:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic68:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP30

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP30:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP30

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP30:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf16:
leave
ret
LcontOpt6:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]


leave
ret
Lcont36:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP29

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP29:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP29

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP29:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont35:


cmp byte [rax], 9
jne NotAClosure65

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic65

NotAClosure65:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic65:

mov qword [fvar_tbl+176], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+264]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+184]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 5

 add qword [malloc_pointer], 1+8*2
%line 6505+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode37
%line 6506+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont37
Lcode37:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 16
%line 6517+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 6518+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 6525+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 6526+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple31:
 cmp rcx, 0
 je copyParamsEndLoopSimple31
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple31
copyParamsEndLoopSimple31:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 6541+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode38
%line 6542+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont38
Lcode38:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 6554+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 6555+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 24
%line 6564+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 6565+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 6575+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 6576+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt30:
 cmp rcx, 0
 je copyParamsEndLoopOpt30
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt30
copyParamsEndLoopOpt30:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 6591+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt7
%line 6592+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt7
LcodeOpt7:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil7


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop7:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 6610+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 6611+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop7


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack7:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack7


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN7

 shiftStackAndPushNil7:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil7:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil7

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN7:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure74

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic74

NotAClosure74:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic74:

cmp rax, const_tbl+2
je Lelse17

mov rax , const_tbl + 41
jmp LexitIf17
Lelse17:




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure72

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic72

NotAClosure72:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic72:

 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure71

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic71

NotAClosure71:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic71:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure73

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic73

NotAClosure73:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic73:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP32

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP32:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP32

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP32:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf17:
leave
ret
LcontOpt7:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]


leave
ret
Lcont38:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP31

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP31:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP31

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP31:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont37:


cmp byte [rax], 9
jne NotAClosure70

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic70

NotAClosure70:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic70:

mov qword [fvar_tbl+184], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+304]
 push rax

mov rax, qword [fvar_tbl+264]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+176]
 push rax

mov rax, qword [fvar_tbl+192]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 7

 add qword [malloc_pointer], 1+8*2
%line 6984+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode39
%line 6985+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont39
Lcode39:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 16
%line 6996+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 6997+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 7004+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 7005+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple34:
 cmp rcx, 0
 je copyParamsEndLoopSimple34
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple34
copyParamsEndLoopSimple34:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 7020+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode40
%line 7021+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont40
Lcode40:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 7033+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 7034+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 24
%line 7043+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 7044+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 7054+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 7055+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt32:
 cmp rcx, 0
 je copyParamsEndLoopOpt32
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt32
copyParamsEndLoopOpt32:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 7070+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt8
%line 7071+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt8
LcodeOpt8:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil8


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop8:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 7089+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 7090+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop8


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack8:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack8


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN8

 shiftStackAndPushNil8:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil8:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil8

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN8:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure79

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic79

NotAClosure79:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic79:

cmp rax, const_tbl+2
je Lelse18

mov rax , const_tbl + 32
jmp LexitIf18
Lelse18:



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure76

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic76

NotAClosure76:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic76:

 push rax



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 6]


cmp byte [rax], 9
jne NotAClosure78

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic78

NotAClosure78:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic78:

 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure77

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic77

NotAClosure77:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic77:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP34

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP34:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP34

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP34:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf18:
leave
ret
LcontOpt8:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0

 add qword [malloc_pointer], 24
%line 7352+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 7353+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 7363+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 7364+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt33:
 cmp rcx, 0
 je copyParamsEndLoopOpt33
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt33
copyParamsEndLoopOpt33:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 7379+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt9
%line 7380+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt9
LcodeOpt9:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil9


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop9:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 7398+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 7399+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop9


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack9:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack9


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN9

 shiftStackAndPushNil9:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil9:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil9

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN9:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure86

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic86

NotAClosure86:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic86:

cmp rax, const_tbl+2
je Lelse19

mov rax , const_tbl + 50
jmp LexitIf19
Lelse19:



mov rax , const_tbl + 41
 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 5]


cmp byte [rax], 9
jne NotAClosure85

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic85

NotAClosure85:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic85:

 push rax
push 2

mov rax, qword [fvar_tbl+216]

cmp byte [rax], 9
jne NotAClosure84

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic84

NotAClosure84:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic84:

cmp rax, const_tbl+2
je Lelse20



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure83

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic83

NotAClosure83:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic83:

 push rax

mov rax , const_tbl + 32
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP36

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP36:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP36

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP36:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf20
Lelse20:




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 6]


cmp byte [rax], 9
jne NotAClosure81

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic81

NotAClosure81:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic81:

 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure80

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic80

NotAClosure80:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic80:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure82

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic82

NotAClosure82:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic82:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP35

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP35:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP35

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP35:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf20:
LexitIf19:
leave
ret
LcontOpt9:



leave
ret
Lcont40:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP33

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP33:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP33

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP33:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont39:


cmp byte [rax], 9
jne NotAClosure75

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic75

NotAClosure75:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic75:

mov qword [fvar_tbl+192], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+304]
 push rax

mov rax, qword [fvar_tbl+264]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+184]
 push rax

mov rax, qword [fvar_tbl+200]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 7

 add qword [malloc_pointer], 1+8*2
%line 7918+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode41
%line 7919+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont41
Lcode41:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 7925+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 7926+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 7933+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 7934+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt35:
 cmp rcx, 0
 je copyParamsEndLoopOpt35
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt35
copyParamsEndLoopOpt35:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 7949+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt10
%line 7950+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt10
LcodeOpt10:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil10


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop10:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 7968+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 7969+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop10


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack10:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack10


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN10

 shiftStackAndPushNil10:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil10:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil10

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN10:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure94

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic94

NotAClosure94:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic94:

cmp rax, const_tbl+2
je Lelse21

mov rax , const_tbl + 50
jmp LexitIf21
Lelse21:



mov rax , const_tbl + 41
 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 5]


cmp byte [rax], 9
jne NotAClosure93

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic93

NotAClosure93:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic93:

 push rax
push 2

mov rax, qword [fvar_tbl+216]

cmp byte [rax], 9
jne NotAClosure92

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic92

NotAClosure92:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic92:

cmp rax, const_tbl+2
je Lelse22



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure91

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic91

NotAClosure91:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic91:

 push rax

mov rax , const_tbl + 41
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP38

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP38:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP38

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP38:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf22
Lelse22:




 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 6]


cmp byte [rax], 9
jne NotAClosure89

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic89

NotAClosure89:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic89:

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 2]

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure88

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic88

NotAClosure88:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic88:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure90

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic90

NotAClosure90:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic90:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP37

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP37:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP37

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP37:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf22:
LexitIf21:
leave
ret
LcontOpt10:

leave
ret
Lcont41:


cmp byte [rax], 9
jne NotAClosure87

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic87

NotAClosure87:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic87:

mov qword [fvar_tbl+200], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+216]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 4

 add qword [malloc_pointer], 1+8*2
%line 8424+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode42
%line 8425+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont42
Lcode42:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 16
%line 8436+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 8437+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 8444+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 8445+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple38:
 cmp rcx, 0
 je copyParamsEndLoopSimple38
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple38
copyParamsEndLoopSimple38:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 8460+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode43
%line 8461+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont43
Lcode43:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 8473+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 8474+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 24
%line 8483+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 8484+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 8494+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 8495+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple36:
 cmp rcx, 0
 je copyParamsEndLoopSimple36
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple36
copyParamsEndLoopSimple36:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 8510+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode44
%line 8511+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont44
Lcode44:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure100

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic100

NotAClosure100:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic100:

cmp rax, const_tbl+2
je Lelse23

mov rax , const_tbl + 4
jmp LexitIf23
Lelse23:




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure99

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic99

NotAClosure99:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic99:

 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure98

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic98

NotAClosure98:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic98:

cmp rax, const_tbl+2
je Lelse24



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure96

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic96

NotAClosure96:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic96:

 push rax


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure97

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic97

NotAClosure97:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic97:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP40

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP40:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP40

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP40:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf24
Lelse24:

mov rax , const_tbl + 2
LexitIf24:
LexitIf23:
leave
ret
Lcont44:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0

 add qword [malloc_pointer], 24
%line 8756+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 8757+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 8767+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 8768+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt37:
 cmp rcx, 0
 je copyParamsEndLoopOpt37
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt37
copyParamsEndLoopOpt37:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 8783+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt11
%line 8784+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt11
LcodeOpt11:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil11


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop11:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 8802+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 8803+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop11


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack11:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack11


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN11

 shiftStackAndPushNil11:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil11:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil11

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN11:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure103

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic103

NotAClosure103:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic103:

cmp rax, const_tbl+2
je Lelse25

mov rax , const_tbl + 50
jmp LexitIf25
Lelse25:



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure101

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic101

NotAClosure101:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic101:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure102

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic102

NotAClosure102:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic102:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP41

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP41:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP41

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP41:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf25:
leave
ret
LcontOpt11:



leave
ret
Lcont43:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP39

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP39:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP39

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP39:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont42:


cmp byte [rax], 9
jne NotAClosure95

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic95

NotAClosure95:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic95:

mov qword [fvar_tbl+216], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+208]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 4

 add qword [malloc_pointer], 1+8*2
%line 9123+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode45
%line 9124+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont45
Lcode45:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 16
%line 9135+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 9136+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 9143+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 9144+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple41:
 cmp rcx, 0
 je copyParamsEndLoopSimple41
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple41
copyParamsEndLoopSimple41:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 9159+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode46
%line 9160+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont46
Lcode46:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 9172+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 9173+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 24
%line 9182+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 9183+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 9193+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 9194+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple39:
 cmp rcx, 0
 je copyParamsEndLoopSimple39
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple39
copyParamsEndLoopSimple39:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 9209+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode47
%line 9210+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont47
Lcode47:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure109

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic109

NotAClosure109:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic109:

cmp rax, const_tbl+2
je Lelse26

mov rax , const_tbl + 4
jmp LexitIf26
Lelse26:




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure108

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic108

NotAClosure108:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic108:

 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure107

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic107

NotAClosure107:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic107:

cmp rax, const_tbl+2
je Lelse27



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure105

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic105

NotAClosure105:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic105:

 push rax


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure106

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic106

NotAClosure106:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic106:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP43

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP43:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP43

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP43:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf27
Lelse27:

mov rax , const_tbl + 2
LexitIf27:
LexitIf26:
leave
ret
Lcont47:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0

 add qword [malloc_pointer], 24
%line 9455+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 9456+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 9466+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 9467+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt40:
 cmp rcx, 0
 je copyParamsEndLoopOpt40
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt40
copyParamsEndLoopOpt40:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 9482+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt12
%line 9483+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt12
LcodeOpt12:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil12


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop12:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 9501+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 9502+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop12


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack12:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack12


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN12

 shiftStackAndPushNil12:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil12:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil12

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN12:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure112

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic112

NotAClosure112:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic112:

cmp rax, const_tbl+2
je Lelse28

mov rax , const_tbl + 50
jmp LexitIf28
Lelse28:



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure110

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic110

NotAClosure110:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic110:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure111

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic111

NotAClosure111:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic111:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP44

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP44:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP44

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP44:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf28:
leave
ret
LcontOpt12:



leave
ret
Lcont46:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP42

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP42:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP42

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP42:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont45:


cmp byte [rax], 9
jne NotAClosure104

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic104

NotAClosure104:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic104:

mov qword [fvar_tbl+208], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+312]
 push rax

mov rax, qword [fvar_tbl+216]
 push rax

mov rax, qword [fvar_tbl+208]
 push rax

mov rax, qword [fvar_tbl+32]
 push rax
push 6

 add qword [malloc_pointer], 1+8*2
%line 9828+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode48
%line 9829+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont48
Lcode48:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 16
%line 9840+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 9841+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 9848+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 9849+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple44:
 cmp rcx, 0
 je copyParamsEndLoopSimple44
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple44
copyParamsEndLoopSimple44:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 9864+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode49
%line 9865+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont49
Lcode49:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 9877+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 9878+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 24
%line 9887+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 9888+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 9898+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 9899+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple42:
 cmp rcx, 0
 je copyParamsEndLoopSimple42
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple42
copyParamsEndLoopSimple42:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 9914+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode50
%line 9915+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont50
Lcode50:
 push rbp
mov rbp, rsp




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure121

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic121

NotAClosure121:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic121:

cmp rax, const_tbl+2
je Lelse29

mov rax , const_tbl + 4
jmp LexitIf29
Lelse29:






 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure118

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic118

NotAClosure118:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic118:

 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure117

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic117

NotAClosure117:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic117:

 cmp rax, const_tbl+2
 jne LexitOr2



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure120

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic120

NotAClosure120:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic120:

 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure119

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic119

NotAClosure119:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic119:

 cmp rax, const_tbl+2
 jne LexitOr2
LexitOr2:

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure116

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic116

NotAClosure116:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic116:

cmp rax, const_tbl+2
je Lelse30



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 5]


cmp byte [rax], 9
jne NotAClosure114

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic114

NotAClosure114:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic114:

 push rax


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure115

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic115

NotAClosure115:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic115:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP46

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP46:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP46

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP46:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf30
Lelse30:

mov rax , const_tbl + 2
LexitIf30:
LexitIf29:
leave
ret
Lcont50:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0

 add qword [malloc_pointer], 24
%line 10259+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 10260+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 10270+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 10271+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopOpt43:
 cmp rcx, 0
 je copyParamsEndLoopOpt43
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopOpt43
copyParamsEndLoopOpt43:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 10286+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], LcodeOpt13
%line 10287+1 ./Project_Test/Tests/test_0/test.s
jmp LcontOpt13
LcodeOpt13:
 push rbp
mov rbp, rsp



 mov rax, qword [rbp + 3*8]
 sub rax, 0
 cmp rax, 0
 je shiftStackAndPushNil13


 mov rdx, const_tbl+1
 mov rcx, rax
 mov r9, qword [rbp + 8*3]
 optToListLoop13:
 mov rbx, qword [rbp + 8*(r9+3)]
 add qword [malloc_pointer], 1+8*2
%line 10305+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov r10, qword [malloc_pointer]
 sub r10, [rsp]
 add rsp, 8
 mov byte [r10], 10
 mov qword [r10+1], rbx
 mov qword [r10+1+8], rdx
%line 10306+1 ./Project_Test/Tests/test_0/test.s
 mov rdx, r10
 dec r9
 dec rcx
 jne optToListLoop13


 mov r9, qword [rbp + 8 *3]
 add r9, 3
 mov qword [rbp + 8*r9], rdx


 mov rcx, 4 + 0
 mov r12, rcx
 dec r12
 mov r10, qword [rbp + 8*3]
 sub r10, 1 + 0
 shiftStack13:
 mov r8, qword [rbp+r12*8]
 mov r13, r12
 add r13 , r10
 mov [rbp+ 8*r13], r8
 dec r12
 dec rcx
 jne shiftStack13


 mov rax, r10
 mov rbx, 8
 mul rbx
 add rbp, rax
 add rsp, rax

 jmp fixN13

 shiftStackAndPushNil13:
 mov rcx, 4 + 0
 mov r12, 0
 shiftStackNil13:
 mov r8, qword [rbp+r12*8]
 mov [rbp+ 8*r12 - 8], r8
 inc r12
 dec rcx
 jne shiftStackNil13

 sub rbp, 8
 sub rsp, 8


 mov r8, const_tbl+1


 mov r9, qword [rbp + 8 *3]
 add r9, 4
 mov qword [rbp + 8*r9], r8


 fixN13:
 mov qword [rbp + 3*8], 1



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure124

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic124

NotAClosure124:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic124:

cmp rax, const_tbl+2
je Lelse31

mov rax , const_tbl + 50
jmp LexitIf31
Lelse31:



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 5]


cmp byte [rax], 9
jne NotAClosure122

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic122

NotAClosure122:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic122:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]


cmp byte [rax], 9
jne NotAClosure123

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic123

NotAClosure123:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic123:

 push rax
push 2


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP47

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP47:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP47

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP47:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf31:
leave
ret
LcontOpt13:



leave
ret
Lcont49:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP45

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP45:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP45

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP45:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont48:


cmp byte [rax], 9
jne NotAClosure113

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic113

NotAClosure113:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic113:

mov qword [fvar_tbl+360], rax
mov rax, const_tbl+0
 call write_sob_if_not_void





mov rax, qword [fvar_tbl+192]
 push rax

mov rax, qword [fvar_tbl+152]
 push rax

mov rax, qword [fvar_tbl+232]
 push rax

mov rax, qword [fvar_tbl+224]
 push rax

mov rax, qword [fvar_tbl+168]
 push rax

mov rax, qword [fvar_tbl+48]
 push rax

mov rax, qword [fvar_tbl+56]
 push rax

mov rax, qword [fvar_tbl+40]
 push rax

mov rax, qword [fvar_tbl+24]
 push rax

mov rax, qword [fvar_tbl+8]
 push rax

mov rax, qword [fvar_tbl+16]
 push rax

mov rax, qword [fvar_tbl+112]
 push rax

mov rax, qword [fvar_tbl+120]
 push rax

mov rax, qword [fvar_tbl+88]
 push rax

mov rax, qword [fvar_tbl+80]
 push rax

mov rax, qword [fvar_tbl+312]
 push rax

mov rax, qword [fvar_tbl+216]
 push rax

mov rax, qword [fvar_tbl+208]
 push rax
push 18

 add qword [malloc_pointer], 1+8*2
%line 10668+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode51
%line 10669+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont51
Lcode51:
 push rbp
mov rbp, rsp



 add qword [malloc_pointer], 16
%line 10676+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 10677+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 10684+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 10685+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple49:
 cmp rcx, 0
 je copyParamsEndLoopSimple49
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple49
copyParamsEndLoopSimple49:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 10700+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode54
%line 10701+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont54
Lcode54:
 push rbp
mov rbp, rsp



mov rax , const_tbl + 23
 push rax
push 1

 add qword [malloc_pointer], 24
%line 10712+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 10713+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 10723+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 10724+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple48:
 cmp rcx, 0
 je copyParamsEndLoopSimple48
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple48
copyParamsEndLoopSimple48:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 10739+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode55
%line 10740+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont55
Lcode55:
 push rbp
mov rbp, rsp






 mov rax, qword [rbp + 8*(4 + 0)]
push rbx
 add qword [malloc_pointer], 8
%line 10752+0 ./Project_Test/Tests/test_0/test.s
 push 8
 mov rbx, qword [malloc_pointer]
 sub rbx, [rsp]
 add rsp, 8
%line 10753+1 ./Project_Test/Tests/test_0/test.s
mov [rbx], rax
mov rax, rbx
pop rbx
mov qword [rbp + 8*(4 + 0)], rax
mov rax, const_tbl+0




 add qword [malloc_pointer], 32
%line 10762+0 ./Project_Test/Tests/test_0/test.s
 push 32
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 10763+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]



mov qword r8, [rbx + 16]
mov qword [r9 + 24], r8
mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 10776+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 10777+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple47:
 cmp rcx, 0
 je copyParamsEndLoopSimple47
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple47
copyParamsEndLoopSimple47:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 10792+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode56
%line 10793+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont56
Lcode56:
 push rbp
mov rbp, rsp




mov rax , const_tbl + 32
 push rax

 mov rax, qword [rbp + 8*(4 + 3)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure155

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic155

NotAClosure155:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic155:

cmp rax, const_tbl+2
je Lelse45

mov rax , const_tbl + 4
jmp LexitIf45
Lelse45:




 mov rax, qword [rbp + 8*(4 + 3)]
 push rax

 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 2

 mov rax, qword [rbp + 8*(4 + 2)]

cmp byte [rax], 9
jne NotAClosure153

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic153

NotAClosure153:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic153:

 push rax


 mov rax, qword [rbp + 8*(4 + 3)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword [rbp + 8*(4 + 2)]

cmp byte [rax], 9
jne NotAClosure154

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic154

NotAClosure154:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic154:

 push rax
push 2

mov rax, qword [fvar_tbl+368]

cmp byte [rax], 9
jne NotAClosure152

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic152

NotAClosure152:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic152:

cmp rax, const_tbl+2
je Lelse46



mov rax , const_tbl + 41
 push rax

 mov rax, qword [rbp + 8*(4 + 3)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 2]
mov rax, qword [rax + 8 * 17]


cmp byte [rax], 9
jne NotAClosure151

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic151

NotAClosure151:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic151:

 push rax

 mov rax, qword [rbp + 8*(4 + 2)]
 push rax

 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 4


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP51

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 7
mov r12, 1
LoopTP51:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP51

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP51:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

jmp LexitIf46
Lelse46:

mov rax , const_tbl + 2
LexitIf46:
LexitIf45:
leave
ret
Lcont56:

push rax

 mov rax, qword [rbp + 8*(4 + 0)]
pop qword [rax]
mov rax, const_tbl+0





 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure160

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic160

NotAClosure160:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic160:

 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure161

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic161

NotAClosure161:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic161:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure159

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic159

NotAClosure159:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic159:

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 2]


cmp byte [rax], 9
jne NotAClosure158

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic158

NotAClosure158:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic158:

cmp rax, const_tbl+2
je Lelse47

mov rax , const_tbl + 2
jmp LexitIf47
Lelse47:



mov rax , const_tbl + 41
 push rax


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 3]


cmp byte [rax], 9
jne NotAClosure157

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic157

NotAClosure157:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic157:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 17]


cmp byte [rax], 9
jne NotAClosure156

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic156

NotAClosure156:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic156:

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 2]

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 4


 mov rax, qword [rbp + 8*(4 + 0)]
mov rax, qword [rax]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP52

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 7
mov r12, 1
LoopTP52:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP52

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP52:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

LexitIf47:


leave
ret
Lcont55:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP50

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP50:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP50

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP50:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont54:

 push rax
push 1

 add qword [malloc_pointer], 16
%line 11379+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 11380+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 11387+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 11388+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple46:
 cmp rcx, 0
 je copyParamsEndLoopSimple46
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple46
copyParamsEndLoopSimple46:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 11403+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode52
%line 11404+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont52
Lcode52:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 24
%line 11410+0 ./Project_Test/Tests/test_0/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 11411+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword r8, [rbx + 8]
mov qword [r9 + 16], r8
mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 11421+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 11422+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple45:
 cmp rcx, 0
 je copyParamsEndLoopSimple45
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple45
copyParamsEndLoopSimple45:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 11437+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode53
%line 11438+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont53
Lcode53:
 push rbp
mov rbp, rsp





 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 7]


cmp byte [rax], 9
jne NotAClosure128

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic128

NotAClosure128:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic128:

cmp rax, const_tbl+2
je Lelse32



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 7]


cmp byte [rax], 9
jne NotAClosure127

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic127

NotAClosure127:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic127:

cmp rax, const_tbl+2
je Lelse33


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure126

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic126

NotAClosure126:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic126:

jmp LexitIf33
Lelse33:

mov rax , const_tbl + 2
LexitIf33:
jmp LexitIf32
Lelse32:

mov rax , const_tbl + 2
LexitIf32:
 cmp rax, const_tbl+2
 jne LexitOr3



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 8]


cmp byte [rax], 9
jne NotAClosure131

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic131

NotAClosure131:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic131:

cmp rax, const_tbl+2
je Lelse34



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 8]


cmp byte [rax], 9
jne NotAClosure130

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic130

NotAClosure130:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic130:

cmp rax, const_tbl+2
je Lelse35


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure129

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic129

NotAClosure129:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic129:

jmp LexitIf35
Lelse35:

mov rax , const_tbl + 2
LexitIf35:
jmp LexitIf34
Lelse34:

mov rax , const_tbl + 2
LexitIf34:
 cmp rax, const_tbl+2
 jne LexitOr3



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 9]


cmp byte [rax], 9
jne NotAClosure139

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic139

NotAClosure139:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic139:

cmp rax, const_tbl+2
je Lelse36



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 9]


cmp byte [rax], 9
jne NotAClosure138

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic138

NotAClosure138:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic138:

cmp rax, const_tbl+2
je Lelse37




 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 14]


cmp byte [rax], 9
jne NotAClosure136

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic136

NotAClosure136:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic136:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 14]


cmp byte [rax], 9
jne NotAClosure137

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic137

NotAClosure137:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic137:

 push rax
push 2

mov rax, qword [fvar_tbl+368]

cmp byte [rax], 9
jne NotAClosure135

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic135

NotAClosure135:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic135:

cmp rax, const_tbl+2
je Lelse38



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 15]


cmp byte [rax], 9
jne NotAClosure133

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic133

NotAClosure133:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic133:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 15]


cmp byte [rax], 9
jne NotAClosure134

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic134

NotAClosure134:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic134:

 push rax
push 2

mov rax, qword [fvar_tbl+368]

cmp byte [rax], 9
jne NotAClosure132

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic132

NotAClosure132:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic132:

jmp LexitIf38
Lelse38:

mov rax , const_tbl + 2
LexitIf38:
jmp LexitIf37
Lelse37:

mov rax , const_tbl + 2
LexitIf37:
jmp LexitIf36
Lelse36:

mov rax , const_tbl + 2
LexitIf36:
 cmp rax, const_tbl+2
 jne LexitOr3



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 10]


cmp byte [rax], 9
jne NotAClosure144

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic144

NotAClosure144:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic144:

cmp rax, const_tbl+2
je Lelse39



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 10]


cmp byte [rax], 9
jne NotAClosure143

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic143

NotAClosure143:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic143:

cmp rax, const_tbl+2
je Lelse40



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 16]


cmp byte [rax], 9
jne NotAClosure141

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic141

NotAClosure141:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic141:

 push rax


 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 16]


cmp byte [rax], 9
jne NotAClosure142

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic142

NotAClosure142:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic142:

 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 1]


cmp byte [rax], 9
jne NotAClosure140

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic140

NotAClosure140:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic140:

jmp LexitIf40
Lelse40:

mov rax , const_tbl + 2
LexitIf40:
jmp LexitIf39
Lelse39:

mov rax , const_tbl + 2
LexitIf39:
 cmp rax, const_tbl+2
 jne LexitOr3



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 11]


cmp byte [rax], 9
jne NotAClosure147

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic147

NotAClosure147:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic147:

cmp rax, const_tbl+2
je Lelse41



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 11]


cmp byte [rax], 9
jne NotAClosure146

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic146

NotAClosure146:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic146:

cmp rax, const_tbl+2
je Lelse42


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 3]

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 4]

 push rax

 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 4

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure145

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic145

NotAClosure145:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic145:

jmp LexitIf42
Lelse42:

mov rax , const_tbl + 2
LexitIf42:
jmp LexitIf41
Lelse41:

mov rax , const_tbl + 2
LexitIf41:
 cmp rax, const_tbl+2
 jne LexitOr3



 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 12]


cmp byte [rax], 9
jne NotAClosure150

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic150

NotAClosure150:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic150:

cmp rax, const_tbl+2
je Lelse43



 mov rax, qword [rbp + 8*(4 + 1)]
 push rax
push 1

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 12]


cmp byte [rax], 9
jne NotAClosure149

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic149

NotAClosure149:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic149:

cmp rax, const_tbl+2
je Lelse44


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 6]

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 5]

 push rax

 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 4

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]


cmp byte [rax], 9
jne NotAClosure148

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic148

NotAClosure148:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic148:

jmp LexitIf44
Lelse44:

mov rax , const_tbl + 2
LexitIf44:
jmp LexitIf43
Lelse43:

mov rax , const_tbl + 2
LexitIf43:
 cmp rax, const_tbl+2
 jne LexitOr3


 mov rax, qword [rbp + 8*(4 + 1)]
 push rax

 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 1]
mov rax, qword [rax + 8 * 13]

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP49

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP49:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP49

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP49:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

 cmp rax, const_tbl+2
 jne LexitOr3
LexitOr3:

leave
ret
Lcont53:

leave
ret
Lcont52:

mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP48

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
LoopTP48:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP48

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP48:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont51:


cmp byte [rax], 9
jne NotAClosure125

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic125

NotAClosure125:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic125:

mov qword [fvar_tbl+368], rax
mov rax, const_tbl+0
 call write_sob_if_not_void




 add qword [malloc_pointer], 1+8*2
%line 12513+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], Lcode57
%line 12514+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont57
Lcode57:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 12520+0 ./Project_Test/Tests/test_0/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 12521+1 ./Project_Test/Tests/test_0/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword r8, [rbx + 0]
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3]
shl r13, 3
 add qword [malloc_pointer], r13
%line 12528+0 ./Project_Test/Tests/test_0/test.s
 push r13
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 12529+1 ./Project_Test/Tests/test_0/test.s
mov rcx, qword [rbp+3*8]
 mov r12, 0
 copyParamsLoopSimple50:
 cmp rcx, 0
 je copyParamsEndLoopSimple50
mov r13, r12
 add r13, 4
 mov rbx, [rbp + 8*r13]
 mov [rdx + 8*r12], rbx
 inc r12
 dec rcx
 jmp copyParamsLoopSimple50
copyParamsEndLoopSimple50:

mov qword [r9], rdx
 add qword [malloc_pointer], 1+8*2
%line 12544+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode58
%line 12545+1 ./Project_Test/Tests/test_0/test.s
jmp Lcont58
Lcode58:
 push rbp
mov rbp, rsp




mov rax , const_tbl + 1
 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]

 push rax
push 2

mov rax, qword [fvar_tbl+256]

cmp byte [rax], 9
jne NotAClosure162

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic162

NotAClosure162:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic162:

 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]

 push rax
push 2

mov rax, qword [fvar_tbl+256]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP53

push qword [rax + 1]
push qword [rbp + 8*1]
mov qword r10, [rbp]
mov r11, qword [rbp+3*8]

push rax
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
LoopTP53:
dec rax
mov r8, rbp


shl r12, 3
sub r8, r12
shr r12, 3

mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jnz LoopTP53

pop rax



add r11, 4
shl r11,3
add rsp, r11



mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP53:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont58:

leave
ret
Lcont57:

mov qword [fvar_tbl+376], rax
mov rax, const_tbl+0
 call write_sob_if_not_void



push 0


mov rax , const_tbl + 118
 push rax

mov rax , const_tbl + 41
 push rax
push 2

mov rax, qword [fvar_tbl+376]

cmp byte [rax], 9
jne NotAClosure164

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic164

NotAClosure164:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic164:


cmp byte [rax], 9
jne NotAClosure163

push qword [rax+1]
call [rax+1+8]


add rsp, 8*1
pop rbx
shl rbx, 3
add rsp, rbx
jmp FinishedApplic163

NotAClosure163:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall
FinishedApplic163:

 call write_sob_if_not_void
leave
 ret
apply:
 push rbp
 mov rbp, rsp
 mov r12, 0
 mov r11 , qword [rbp+3*8]
 sub r11, 1
 mov r10, qword [rbp+(4+r11)*8]
 .pushListToStack:
 cmp byte [r10], 2
 je .endPushList
 mov r9, qword [r10+1]
 mov r10, qword [r10+1+8]
 push r9
 add r12, 1
 jmp .pushListToStack

.endPushList:
 mov r8, 0
 mov r9 , r12
 dec r9

.reverseStack:
 cmp r9, r8
 jle .endReverse
 mov r15, [rsp + 8 * r9]
 mov r14, [rsp + 8 * r8]
 mov [rsp + 8 * r9], r14
 mov [rsp + 8 * r8], r15
 dec r9
 inc r8
 jmp .reverseStack

.endReverse:
 mov rcx , qword [rbp + 8*3]
 dec rcx
 dec rcx
.pushRestArgs:
 cmp rcx, 0
 jle .finishPushRest
 push qword [rbp+(4+rcx)*8]
 sub rcx, 1
 jmp .pushRestArgs

.finishPushRest:
 add r12, qword [rbp+8*3]
 sub r12, 2
 push r12
 mov rax, qword [rbp + 8*4]
 cmp byte [rax], 9
 jne .exit
 mov rdi, qword [rax+1]
 push rdi
 mov r15, qword [rbp]
 push qword [rbp + 8]


 .shift_frame:
 add r12 , 4
push rax
 mov rax, qword [rbp+3*8]
 add rax, 4
 mov r10, rax
 shl r10, 3
 mov rcx, r12
 mov r9, 1

 .loopLabel:
 cmp rcx, 0
 je .cleanStack
 dec rcx
 dec rax
 mov r8, rbp
 mov rdi, r9
 shl rdi, 3
 sub r8, rdi
 mov r8, [r8]
 mov [rbp + 8*rax], r8
 inc r9
 jne .loopLabel

 .cleanStack:
pop rax
 add rsp, r10
 mov rbp, rsp

 .end:
 mov rbp,r15
 jmp qword [rax+1+8]





.exit:
mov rdi, 0
mov rax, 60
syscall





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
%line 13000+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13001+1 ./Project_Test/Tests/test_0/test.s

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
%line 13017+0 ./Project_Test/Tests/test_0/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 13018+1 ./Project_Test/Tests/test_0/test.s

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
%line 13052+0 ./Project_Test/Tests/test_0/test.s
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
..@432.str_loop:
 jz ..@432.str_loop_end
 dec rcx
 mov byte [rax+rcx], dil
 jmp ..@432.str_loop
..@432.str_loop_end:
 pop rcx
 sub rax, 8+1
%line 13053+1 ./Project_Test/Tests/test_0/test.s

 leave
 ret

vector_length:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 add qword [malloc_pointer], 1+8
%line 13063+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13064+1 ./Project_Test/Tests/test_0/test.s

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
%line 13112+0 ./Project_Test/Tests/test_0/test.s
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
..@442.vec_loop:
 jz ..@442.vec_loop_end
 dec rcx
 mov qword [rax+rcx*8], rdi
 jmp ..@442.vec_loop
..@442.vec_loop_end:
 sub rax, 8+1
 pop rcx
%line 13113+1 ./Project_Test/Tests/test_0/test.s

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
%line 13132+0 ./Project_Test/Tests/test_0/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], dil
%line 13133+1 ./Project_Test/Tests/test_0/test.s
 push rax
 add qword [malloc_pointer], 1+8
%line 13134+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rcx
%line 13135+1 ./Project_Test/Tests/test_0/test.s
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
%line 13169+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13170+1 ./Project_Test/Tests/test_0/test.s

 leave
 ret

integer_to_char:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 and rsi, 255
 add qword [malloc_pointer], 1+1
%line 13182+0 ./Project_Test/Tests/test_0/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 13183+1 ./Project_Test/Tests/test_0/test.s

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
%line 13274+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13275+1 ./Project_Test/Tests/test_0/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 13279+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 13280+1 ./Project_Test/Tests/test_0/test.s

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
%line 13354+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13355+1 ./Project_Test/Tests/test_0/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 13359+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 13360+1 ./Project_Test/Tests/test_0/test.s

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
%line 13434+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13435+1 ./Project_Test/Tests/test_0/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 13439+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 13440+1 ./Project_Test/Tests/test_0/test.s

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
%line 13514+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13515+1 ./Project_Test/Tests/test_0/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 13519+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 13520+1 ./Project_Test/Tests/test_0/test.s

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
%line 13594+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13595+1 ./Project_Test/Tests/test_0/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 13599+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 13600+1 ./Project_Test/Tests/test_0/test.s

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
%line 13686+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 13687+1 ./Project_Test/Tests/test_0/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 13691+0 ./Project_Test/Tests/test_0/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 13692+1 ./Project_Test/Tests/test_0/test.s

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
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rdi, qword [rbp+(4+1)*8]

 mov qword [rsi + 1], rdi
 mov rax, const_tbl+0

 leave
 ret

set_cdr:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rdi, qword [rbp+(4+1)*8]

 mov qword [rsi + 1 + 8], rdi
 mov rax, const_tbl+0

 leave
 ret

cons:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rdi, qword [rbp+(4+1)*8]
 add qword [malloc_pointer], 1+8*2
%line 13762+0 ./Project_Test/Tests/test_0/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 10
 mov qword [rax+1], rsi
 mov qword [rax+1+8], rdi
%line 13763+1 ./Project_Test/Tests/test_0/test.s

 leave
 ret
