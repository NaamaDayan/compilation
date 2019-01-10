%line 1+1 ./Project_Test/Tests/test_1/test.s



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
%line 5+1 ./Project_Test/Tests/test_1/test.s

[section .bss]
malloc_pointer:
 resq 1


[section .data]



%line 19+1 ./Project_Test/Tests/test_1/test.s

%line 23+1 ./Project_Test/Tests/test_1/test.s

%line 27+1 ./Project_Test/Tests/test_1/test.s

%line 31+1 ./Project_Test/Tests/test_1/test.s

%line 35+1 ./Project_Test/Tests/test_1/test.s

%line 39+1 ./Project_Test/Tests/test_1/test.s




%line 46+1 ./Project_Test/Tests/test_1/test.s

%line 55+1 ./Project_Test/Tests/test_1/test.s

%line 58+1 ./Project_Test/Tests/test_1/test.s

%line 63+1 ./Project_Test/Tests/test_1/test.s

%line 67+1 ./Project_Test/Tests/test_1/test.s

%line 76+1 ./Project_Test/Tests/test_1/test.s



%line 94+1 ./Project_Test/Tests/test_1/test.s


%line 99+1 ./Project_Test/Tests/test_1/test.s




notACLosureError:
 db "Error: trying to apply not-a-closure", 0
const_tbl:
db 1
db 2
db 5
%line 108+0 ./Project_Test/Tests/test_1/test.s
db 0
%line 109+1 ./Project_Test/Tests/test_1/test.s
db 5
%line 109+0 ./Project_Test/Tests/test_1/test.s
db 1
%line 110+1 ./Project_Test/Tests/test_1/test.s



%line 117+1 ./Project_Test/Tests/test_1/test.s



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
%line 187+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_boolean
%line 188+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 0], rax
 add qword [malloc_pointer], 1+8*2
%line 189+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_float
%line 190+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 8], rax
 add qword [malloc_pointer], 1+8*2
%line 191+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_integer
%line 192+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 16], rax
 add qword [malloc_pointer], 1+8*2
%line 193+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_pair
%line 194+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 24], rax
 add qword [malloc_pointer], 1+8*2
%line 195+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_null
%line 196+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 32], rax
 add qword [malloc_pointer], 1+8*2
%line 197+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_char
%line 198+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 40], rax
 add qword [malloc_pointer], 1+8*2
%line 199+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_vector
%line 200+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 48], rax
 add qword [malloc_pointer], 1+8*2
%line 201+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_string
%line 202+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 56], rax
 add qword [malloc_pointer], 1+8*2
%line 203+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_procedure
%line 204+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 64], rax
 add qword [malloc_pointer], 1+8*2
%line 205+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_symbol
%line 206+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 72], rax
 add qword [malloc_pointer], 1+8*2
%line 207+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_length
%line 208+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 80], rax
 add qword [malloc_pointer], 1+8*2
%line 209+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_ref
%line 210+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 88], rax
 add qword [malloc_pointer], 1+8*2
%line 211+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], string_set
%line 212+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 96], rax
 add qword [malloc_pointer], 1+8*2
%line 213+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], make_string
%line 214+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 104], rax
 add qword [malloc_pointer], 1+8*2
%line 215+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_length
%line 216+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 112], rax
 add qword [malloc_pointer], 1+8*2
%line 217+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_ref
%line 218+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 120], rax
 add qword [malloc_pointer], 1+8*2
%line 219+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], vector_set
%line 220+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 128], rax
 add qword [malloc_pointer], 1+8*2
%line 221+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], make_vector
%line 222+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 136], rax
 add qword [malloc_pointer], 1+8*2
%line 223+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], symbol_to_string
%line 224+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 144], rax
 add qword [malloc_pointer], 1+8*2
%line 225+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], char_to_integer
%line 226+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 152], rax
 add qword [malloc_pointer], 1+8*2
%line 227+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], integer_to_char
%line 228+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 160], rax
 add qword [malloc_pointer], 1+8*2
%line 229+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], is_eq
%line 230+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 168], rax
 add qword [malloc_pointer], 1+8*2
%line 231+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_add
%line 232+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 176], rax
 add qword [malloc_pointer], 1+8*2
%line 233+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_mul
%line 234+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 184], rax
 add qword [malloc_pointer], 1+8*2
%line 235+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_sub
%line 236+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 192], rax
 add qword [malloc_pointer], 1+8*2
%line 237+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_div
%line 238+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 200], rax
 add qword [malloc_pointer], 1+8*2
%line 239+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_lt
%line 240+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 208], rax
 add qword [malloc_pointer], 1+8*2
%line 241+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], bin_equ
%line 242+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 216], rax
 add qword [malloc_pointer], 1+8*2
%line 243+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], car
%line 244+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 224], rax
 add qword [malloc_pointer], 1+8*2
%line 245+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], cdr
%line 246+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 232], rax
 add qword [malloc_pointer], 1+8*2
%line 247+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], set_car
%line 248+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 240], rax
 add qword [malloc_pointer], 1+8*2
%line 249+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], set_cdr
%line 250+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 248], rax
 add qword [malloc_pointer], 1+8*2
%line 251+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], const_tbl+1
 mov qword [rax+1+8], cons
%line 252+1 ./Project_Test/Tests/test_1/test.s
 mov [fvar_tbl + 256], rax




 forDebug:


 add qword [malloc_pointer], 8
%line 260+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 261+1 ./Project_Test/Tests/test_1/test.s
mov qword rbx, [rbp + 8 * 2]

 add qword [malloc_pointer], 16
%line 263+0 ./Project_Test/Tests/test_1/test.s
 push 16
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 264+1 ./Project_Test/Tests/test_1/test.s
mov qword [r9], rdx


mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 0)]
mov [rdx + 0], rbx
mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 8)]
mov [rdx + 8], rbx

 add qword [malloc_pointer], 1+8*2
%line 274+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode6
%line 275+1 ./Project_Test/Tests/test_1/test.s

jmp Lcont6
Lcode6:
 push rbp
mov rbp, rsp

 mov rax, qword [rbp + 8*(4 + 0)]
leave
ret
Lcont6:

 push rax
push 1


 add qword [malloc_pointer], 8
%line 290+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 291+1 ./Project_Test/Tests/test_1/test.s
mov qword rbx, [rbp + 8 * 2]

 add qword [malloc_pointer], 8
%line 293+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 294+1 ./Project_Test/Tests/test_1/test.s
mov qword [r9], rdx

mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 0)]
mov [rdx + 0], rbx

 add qword [malloc_pointer], 1+8*2
%line 300+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode5
%line 301+1 ./Project_Test/Tests/test_1/test.s

jmp Lcont5
Lcode5:
 push rbp
mov rbp, rsp


mov rax , const_tbl + 2
 push rax

mov rax , const_tbl + 4
 push rax
push 2

 mov rax, qword [rbp + 8*(4 + 0)]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP2
push qword [rax + 1]
push qword [rbp + 8*1]

mov qword r10, [rbp]
mov r11, qword [rbp+3*8]
push rax
push rbx
mov rbx, 8
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
Loop2:
dec rax
mov r8, rbp
push rax
mov rax, 8
mul r12
sub r8, rax
pop rax
mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jne Loop2


push rax
mov rax, 8
add r11, 4
mul r11
add rsp, rax
pop rax

pop rbx
pop rax
mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP2:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont5:

 push rax
push 1


 add qword [malloc_pointer], 8
%line 371+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 372+1 ./Project_Test/Tests/test_1/test.s
mov qword rbx, [rbp + 8 * 2]

 add qword [malloc_pointer], 8
%line 374+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 375+1 ./Project_Test/Tests/test_1/test.s
mov qword [r9], rdx

mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 0)]
mov [rdx + 0], rbx

 add qword [malloc_pointer], 1+8*2
%line 381+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode2
%line 382+1 ./Project_Test/Tests/test_1/test.s

jmp Lcont2
Lcode2:
 push rbp
mov rbp, rsp


 add qword [malloc_pointer], 16
%line 389+0 ./Project_Test/Tests/test_1/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 390+1 ./Project_Test/Tests/test_1/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword rdx, [rbx + 0]
mov qword [r9 + 8], rdx

 add qword [malloc_pointer], 16
%line 395+0 ./Project_Test/Tests/test_1/test.s
 push 16
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 396+1 ./Project_Test/Tests/test_1/test.s
mov qword [r9], rdx


mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 0)]
mov [rdx + 0], rbx
mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 8)]
mov [rdx + 8], rbx

 add qword [malloc_pointer], 1+8*2
%line 406+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode3
%line 407+1 ./Project_Test/Tests/test_1/test.s

jmp Lcont3
Lcode3:
 push rbp
mov rbp, rsp

 add qword [malloc_pointer], 24
%line 413+0 ./Project_Test/Tests/test_1/test.s
 push 24
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 414+1 ./Project_Test/Tests/test_1/test.s
mov qword rbx, [rbp + 8 * 2]


mov qword rdx, [rbx + 0]
mov qword [r9 + 8], rdx
mov qword rdx, [rbx + 8]
mov qword [r9 + 16], rdx

 add qword [malloc_pointer], 8
%line 422+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 423+1 ./Project_Test/Tests/test_1/test.s
mov qword [r9], rdx

mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 0)]
mov [rdx + 0], rbx

 add qword [malloc_pointer], 1+8*2
%line 429+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode4
%line 430+1 ./Project_Test/Tests/test_1/test.s

jmp Lcont4
Lcode4:
 push rbp
mov rbp, rsp


 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]
 push rax

 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 1]
 push rax
push 2

 mov rax, qword [rbp + 8*(4 + 0)]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP1
push qword [rax + 1]
push qword [rbp + 8*1]

mov qword r10, [rbp]
mov r11, qword [rbp+3*8]
push rax
push rbx
mov rbx, 8
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 5
mov r12, 1
Loop1:
dec rax
mov r8, rbp
push rax
mov rax, 8
mul r12
sub r8, rax
pop rax
mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jne Loop1


push rax
mov rax, 8
add r11, 4
mul r11
add rsp, rax
pop rax

pop rbx
pop rax
mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP1:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont4:

leave
ret
Lcont3:

 push rax
push 1

 mov rax, qword [rbp + 8*(4 + 0)]
mov r13, rax
cmp byte [rax], 9
jne NotAClosureTP0
push qword [rax + 1]
push qword [rbp + 8*1]

mov qword r10, [rbp]
mov r11, qword [rbp+3*8]
push rax
push rbx
mov rbx, 8
mov rax, qword [rbp+3*8]
add rax, 4
mov rcx, 4
mov r12, 1
Loop0:
dec rax
mov r8, rbp
push rax
mov rax, 8
mul r12
sub r8, rax
pop rax
mov r8, [r8]
mov [rbp+8*rax], r8
inc r12
dec rcx
jne Loop0


push rax
mov rax, 8
add r11, 4
mul r11
add rsp, rax
pop rax

pop rbx
pop rax
mov rbp, r10
jmp [r13 + 1 + 8]
NotAClosureTP0:
 mov rdi, notACLosureError
 call print_string
 mov rax, 1
 syscall

leave
ret
Lcont2:

 push rax
push 1

 add qword [malloc_pointer], 8
%line 562+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 563+1 ./Project_Test/Tests/test_1/test.s
mov qword rbx, [rbp + 8 * 2]

 add qword [malloc_pointer], 8
%line 565+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 566+1 ./Project_Test/Tests/test_1/test.s
mov qword [r9], rdx

mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 0)]
mov [rdx + 0], rbx

 add qword [malloc_pointer], 1+8*2
%line 572+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode0
%line 573+1 ./Project_Test/Tests/test_1/test.s

jmp Lcont0
Lcode0:
 push rbp
mov rbp, rsp

 add qword [malloc_pointer], 16
%line 579+0 ./Project_Test/Tests/test_1/test.s
 push 16
 mov r9, qword [malloc_pointer]
 sub r9, [rsp]
 add rsp, 8
%line 580+1 ./Project_Test/Tests/test_1/test.s
mov qword rbx, [rbp + 8 * 2]

mov qword rdx, [rbx + 0]
mov qword [r9 + 8], rdx

 add qword [malloc_pointer], 8
%line 585+0 ./Project_Test/Tests/test_1/test.s
 push 8
 mov rdx, qword [malloc_pointer]
 sub rdx, [rsp]
 add rsp, 8
%line 586+1 ./Project_Test/Tests/test_1/test.s
mov qword [r9], rdx

mov qword rdx, [r9]
mov rbx, [rbp + 8*(4 + 0)]
mov [rdx + 0], rbx

 add qword [malloc_pointer], 1+8*2
%line 592+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 9
 mov qword [rax+1], r9
 mov qword [rax+1+8], Lcode1
%line 593+1 ./Project_Test/Tests/test_1/test.s

jmp Lcont1
Lcode1:
 push rbp
mov rbp, rsp

 mov rax, qword [rbp + 8*(4 + 0)]
leave
ret
Lcont1:

leave
ret
Lcont0:


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
%line 860+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 861+1 ./Project_Test/Tests/test_1/test.s

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
%line 877+0 ./Project_Test/Tests/test_1/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 878+1 ./Project_Test/Tests/test_1/test.s

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
%line 912+0 ./Project_Test/Tests/test_1/test.s
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
..@148.str_loop:
 jz ..@148.str_loop_end
 dec rcx
 mov byte [rax+rcx], dil
 jmp ..@148.str_loop
..@148.str_loop_end:
 pop rcx
 sub rax, 8+1
%line 913+1 ./Project_Test/Tests/test_1/test.s

 leave
 ret

vector_length:
 push rbp
 mov rbp, rsp

 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 add qword [malloc_pointer], 1+8
%line 923+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 924+1 ./Project_Test/Tests/test_1/test.s

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
%line 972+0 ./Project_Test/Tests/test_1/test.s
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
..@158.vec_loop:
 jz ..@158.vec_loop_end
 dec rcx
 mov qword [rax+rcx*8], rdi
 jmp ..@158.vec_loop
..@158.vec_loop_end:
 sub rax, 8+1
 pop rcx
%line 973+1 ./Project_Test/Tests/test_1/test.s

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
%line 992+0 ./Project_Test/Tests/test_1/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], dil
%line 993+1 ./Project_Test/Tests/test_1/test.s
 push rax
 add qword [malloc_pointer], 1+8
%line 994+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rcx
%line 995+1 ./Project_Test/Tests/test_1/test.s
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
%line 1029+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1030+1 ./Project_Test/Tests/test_1/test.s

 leave
 ret

integer_to_char:
 push rbp
 mov rbp, rsp


 mov rsi, qword [rbp+(4+0)*8]
 mov rsi, qword [rsi+1]
 and rsi, 255
 add qword [malloc_pointer], 1+1
%line 1042+0 ./Project_Test/Tests/test_1/test.s
 push 1+1
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 6
 mov byte [rax+1], sil
%line 1043+1 ./Project_Test/Tests/test_1/test.s

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
%line 1134+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1135+1 ./Project_Test/Tests/test_1/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1139+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1140+1 ./Project_Test/Tests/test_1/test.s

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
%line 1214+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1215+1 ./Project_Test/Tests/test_1/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1219+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1220+1 ./Project_Test/Tests/test_1/test.s

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
%line 1294+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1295+1 ./Project_Test/Tests/test_1/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1299+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1300+1 ./Project_Test/Tests/test_1/test.s

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
%line 1374+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1375+1 ./Project_Test/Tests/test_1/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1379+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1380+1 ./Project_Test/Tests/test_1/test.s

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
%line 1454+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1455+1 ./Project_Test/Tests/test_1/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1459+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1460+1 ./Project_Test/Tests/test_1/test.s

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
%line 1546+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 3
 mov qword [rax+1], rsi
%line 1547+1 ./Project_Test/Tests/test_1/test.s
 jmp .return

.return_float:
 movq rsi, xmm0
 add qword [malloc_pointer], 1+8
%line 1551+0 ./Project_Test/Tests/test_1/test.s
 push 1+8
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 4
 mov qword [rax+1], rsi
%line 1552+1 ./Project_Test/Tests/test_1/test.s

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
%line 1624+0 ./Project_Test/Tests/test_1/test.s
 push 1+8*2
 mov rax, qword [malloc_pointer]
 sub rax, [rsp]
 add rsp, 8
 mov byte [rax], 10
 mov qword [rax+1], rsi
 mov qword [rax+1+8], rdi
%line 1625+1 ./Project_Test/Tests/test_1/test.s

 leave
 ret
