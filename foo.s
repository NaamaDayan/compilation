
;;; All the macros and the scheme-object printing procedure
;;; are defined in compiler.s
%include "compiler.s"

section .bss
malloc_pointer:
    resq 1
    

section .data

%define WORD_BYTES 8

%macro MAKE_LITERAL 2
db %1
%2
%endmacro

%macro MAKE_LITERAL_INT 1 
	MAKE_LITERAL T_INTEGER, dq %1
%endmacro

%macro MAKE_LITERAL_CHAR 1
	MAKE_LITERAL T_CHAR, db %1
%endmacro

%macro MAKE_LITERAL_FLOAT 1 
	MAKE_LITERAL T_FLOAT, dq %1
%endmacro

%macro MAKE_LITERAL_SYMBOL 1 
	MAKE_LITERAL T_SYMBOL, dq %1
%endmacro

%define MAKE_NIL db T_NIL
%define MAKE_VOID db T_VOID
%define MAKE_BOOL (val) MAKE_LITERAL T_BOOL, db val




%define MAKE_INT(r,val) MAKE_LONG_VALUE r, val, T_INTEGER
%define MAKE_FLOAT(r,val) MAKE_LONG_VALUE r, val, T_FLOAT
%define MAKE_CHAR(r,val) MAKE_CHAR_VALUE r, val

%macro MAKE_LITERAL_STRING 0-*
db T_STRING
dq %0
%rep %0
db %1
%rotate 1
%endrep
%endmacro

%define TYPE(r) byte [r]
%define DATA(r) [r+TYPE_SIZE]

%define INT_DATA(r) qword DATA(r)
%define FLOAT_DATA(r) qword DATA(r)
%define CHAR_DATA(r) byte DATA(r)
%define BOOL_DATA(r) byte DATA(r)

%define STR_LEN(r) qword DATA(r)
%define STR_DATA_PTR(r) r + WORD_BYTES+ TYPE_SIZE
%define STRING_REF(r,i) byte [r+WORD_BYTES+ TYPE_SIZE + i]

%define LOWER_DATA(sob) qword [sob+ TYPE_SIZE]
%define UPPER_DATA(sob) qword [sob+WORD_BYTES +TYPE_SIZE]
%define CAR LOWER_DATA
%define CDR UPPER_DATA
%define ENV LOWER_DATA
%define BODY UPPER_DATA
%define VECTOR_LEN LOWER_DATA
%define VECTOR_REF(r,i) qword [r+TYPE_SIZE+WORD_BYTES+i*WORD_BYTES]

%define PARAM_COUNT qword [rbp+3*WORD_SIZE]

%macro SHIFT_FRAME 1
  push rax
  mov rax, PARAM_COUNT
  add rax, 4
%assign i 1
%rep %1
  dec rax
  mov r8, rbp
  sub qword r8, WORD_BYTES*i
  mov r8, [r8]  
  mov [rbp+WORD_BYTES*rax], r8
% assign i i+1
%endrep
  pop rax
%endmacro

;%1 = param count in old frame
%macro CLEAN_STACK 1
  add rsp, WORD_BYTES * (4+%1)
%endmacro

;;end self written macros!!!


notACLosureError: ;;there was a dot before this line!
	db "Error: trying to apply not-a-closure", 0
const_tbl:
MAKE_VOID
MAKE_NIL
MAKE_LITERAL T_BOOL, db 0
MAKE_LITERAL T_BOOL, db 1
MAKE_LITERAL_INT 5
MAKE_LITERAL_INT 0
;;
;;; These macro definitions are required for the primitive
;;; definitions in the epilogue to work properly
%define SOB_VOID_ADDRESS const_tbl+0
%define SOB_NIL_ADDRESS const_tbl+1
%define SOB_FALSE_ADDRESS const_tbl+2
%define SOB_TRUE_ADDRESS const_tbl+4



fvar_tbl:
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
dq T_UNDEFINED
global main
section .text
main:
  push rbp
  mov rbp, rsp
    ;; set up the heap
    mov rdi, GB(4)
    call malloc
    mov [malloc_pointer], rax

    ;; Set up the dummy activation frame
    ;; The dummy return address is T_UNDEFINED
    ;; (which a is a macro for 0) so that returning
    ;; from the top level (which SHOULD NOT HAPPEN
    ;; AND IS A BUG) will cause a segfault.
    push 0
    push qword 7 ;SOB_NIL_ADDRESS
    push qword T_UNDEFINED
    push rsp

    call code_fragment ;;was jmp before!! 
    add rsp, 4*8
    leave
    ret

code_fragment:
push rbp
mov rbp, rsp
    ;; Set up the primitive stdlib fvars:
    ;; Since the primtive procedures are defined in assembly,
    ;; they are not generated by scheme (define ...) expressions.
    ;; This is where we emulate the missing (define ...) expressions
    ;; for all the primitive procedures.
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_boolean)
    mov [fvar_tbl + 0], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_float)
    mov [fvar_tbl + 8], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_integer)
    mov [fvar_tbl + 16], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_pair)
    mov [fvar_tbl + 24], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_null)
    mov [fvar_tbl + 32], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_char)
    mov [fvar_tbl + 40], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_vector)
    mov [fvar_tbl + 48], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_string)
    mov [fvar_tbl + 56], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_procedure)
    mov [fvar_tbl + 64], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_symbol)
    mov [fvar_tbl + 72], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, string_length)
    mov [fvar_tbl + 80], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, string_ref)
    mov [fvar_tbl + 88], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, string_set)
    mov [fvar_tbl + 96], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, make_string)
    mov [fvar_tbl + 104], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, vector_length)
    mov [fvar_tbl + 112], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, vector_ref)
    mov [fvar_tbl + 120], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, vector_set)
    mov [fvar_tbl + 128], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, make_vector)
    mov [fvar_tbl + 136], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, symbol_to_string)
    mov [fvar_tbl + 144], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, char_to_integer)
    mov [fvar_tbl + 152], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, integer_to_char)
    mov [fvar_tbl + 160], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, is_eq)
    mov [fvar_tbl + 168], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, bin_add)
    mov [fvar_tbl + 176], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, bin_mul)
    mov [fvar_tbl + 184], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, bin_sub)
    mov [fvar_tbl + 192], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, bin_div)
    mov [fvar_tbl + 200], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, bin_lt)
    mov [fvar_tbl + 208], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, bin_equ)
    mov [fvar_tbl + 216], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, car)
    mov [fvar_tbl + 224], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, cdr)
    mov [fvar_tbl + 232], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, set_car)
    mov [fvar_tbl + 240], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, set_cdr)
    mov [fvar_tbl + 248], rax
    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, cons)
    mov [fvar_tbl + 256], rax
 ;;add rsp, 4*8
 ;;pop rbp
 ;;ret
 
 forDebug:
;define(Var'(VarFree))
;applic
;varFree
mov rax, qword [fvar_tbl+256]
 push rax
;varFree
mov rax, qword [fvar_tbl+232]
 push rax
;varFree
mov rax, qword [fvar_tbl+224]
 push rax
;varFree
mov rax, qword [fvar_tbl+32]
 push rax
push 4
;lambdaSimple
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, Lcode0)
jmp Lcont0
Lcode0:
 push rbp
mov rbp, rsp
;const
mov rax    , const_tbl + 6
leave
ret
Lcont0:
 
;check if closure 
cmp byte [rax], T_CLOSURE
jne NotAClosure0

push qword [rax+TYPE_SIZE]  ;push env:
call [rax+TYPE_SIZE+WORD_SIZE] ;call closure_code:

;cleaning the stack 
add rsp, 8*1 ; pop env
pop rbx ; pop arg count
shl rbx, 3 ; rbx = rbx * 8
add rsp, rbx; pop args
jmp FinishedApplic0

NotAClosure0:
	mov rdi, notACLosureError
	call print_string
	mov rax, 1
	syscall
FinishedApplic0:

mov qword [fvar_tbl+264], rax
mov rax, SOB_VOID_ADDRESS
    call write_sob_if_not_void


;define(Var'(VarFree))
;applic
;varFree
mov rax, qword [fvar_tbl+216]
 push rax
push 1
;lambdaSimple
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, Lcode1)
jmp Lcont1
Lcode1:
 push rbp
mov rbp, rsp
;lambdaSimple
MALLOC r9, 16 ;r9 = extEnv pointer
MAKE_CLOSURE (rax, r9, Lcode2)
mov qword rbx, [rbp + 8 * 2] ;rbx is lexical env pointer
;copyEnvLoop - r9[i+1] = rbx[i]:
mov qword r8, [rbx + 0] ;go to lexical env , tmp val is in r8
mov qword [r9 + 8], r8

mov r13, qword [rbp+8*3] 
MALLOC rdx, r13 ;number of params of prev env * 8
mov rcx, qword [rbp+3*8] ; rcx = param count
	    	mov r12, 0 ; r12 = i 
	       copyParamsLoop1:
	    		mov r13, r12
	    		add r13, 4
	    		mov rbx, [rbp + 8*r13] ;rbx = param(i)
	    		mov [rdx + 8*r12], rbx ;rdx = extEnv[0], rdx[i] = rbx
	    		inc r12
	    		dec rcx
	    		jne copyParamsLoop1
mov qword [r9], rdx
 ;rdx is the params vector
jmp Lcont2
Lcode2:
 push rbp
mov rbp, rsp
;applicTP
;const
mov rax    , const_tbl + 15
 push rax
;varParam
 mov rax, qword [rbp + 8*(4 + 0)]
 push rax
push 2
;varBound
 mov rax, qword[rbp + 8*2]
mov rax, qword [rax + 8 * 0]
mov rax, qword [rax + 8 * 0]
mov r13, rax ;save closure
cmp byte [rax], T_CLOSURE
jne NotAClosureTP0
push qword [rax + TYPE_SIZE] ;push env
push qword [rbp + WORD_BYTES*1] ;old ret address
mov qword r10, [rbp] ; r10 = old old rbp
mov r11, PARAM_COUNT ; save old param count 
push rax
mov rax, PARAM_COUNT
add rax, 4
mov rcx, 5 ;;check! maybe add 4 instead
mov r12, 1
Loop0:
dec rax
mov r8, rbp
push rax
mov rax, WORD_SIZE
mul r12
sub r8, rax
pop rax
mov r8, [r8]  
mov [rbp+WORD_BYTES*rax], r8
inc r12
dec rcx
jne Loop0

pop rax
;clean stack: add rsp , WORD_BYTES*(r11+4)
;push rax
;mov rax, WORD_SIZE
add r11, 4
shl r11,3
add rsp, r11
;pop rax

;pop rax
mov rbp, r10 ;risky line!!!!!  maybe save in rbp instead (brama) , save old old rbp
jmp [r13 + TYPE_SIZE + WORD_BYTES]
NotAClosureTP0:
	mov rdi, notACLosureError
	call print_string
	mov rax, 1
	syscall

leave
ret
Lcont2:
 
leave
ret
Lcont1:
 
;check if closure 
cmp byte [rax], T_CLOSURE
jne NotAClosure1

push qword [rax+TYPE_SIZE]  ;push env:
call [rax+TYPE_SIZE+WORD_SIZE] ;call closure_code:

;cleaning the stack 
add rsp, 8*1 ; pop env
pop rbx ; pop arg count
shl rbx, 3 ; rbx = rbx * 8
add rsp, rbx; pop args
jmp FinishedApplic1

NotAClosure1:
	mov rdi, notACLosureError
	call print_string
	mov rax, 1
	syscall
FinishedApplic1:

mov qword [fvar_tbl+272], rax
mov rax, SOB_VOID_ADDRESS
    call write_sob_if_not_void
leave
 ret

is_boolean:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_BOOL
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_float:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_FLOAT
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_integer:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_INTEGER
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_pair:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_PAIR
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_null:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_NIL
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_char:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_CHAR
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_vector:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_VECTOR
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_string:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_STRING
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_procedure:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_CLOSURE
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

is_symbol:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov sil, byte [rsi]

    cmp sil, T_SYMBOL
    jne .wrong_type
    mov rax, SOB_TRUE_ADDRESS
    jmp .return

.wrong_type:
    mov rax, SOB_FALSE_ADDRESS
.return:
    leave
    ret

string_length:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    STRING_LENGTH rsi, rsi
    MAKE_INT(rax, rsi)

    leave
    ret

string_ref:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0) 
    STRING_ELEMENTS rsi, rsi
    mov rdi, PVAR(1)
    INT_VAL rdi, rdi
    shl rdi, 0
    add rsi, rdi

    mov sil, byte [rsi]
    MAKE_CHAR(rax, sil)

    leave
    ret

string_set:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0) 
    STRING_ELEMENTS rsi, rsi
    mov rdi, PVAR(1)
    INT_VAL rdi, rdi
    shl rdi, 0
    add rsi, rdi

    mov rax, PVAR(2)
    CHAR_VAL rax, rax
    mov byte [rsi], al
    mov rax, SOB_VOID_ADDRESS

    leave
    ret

make_string:
    push rbp
    mov rbp, rsp

    
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    mov rdi, PVAR(1)
    CHAR_VAL rdi, rdi
    and rdi, 255

    MAKE_STRING rax, rsi, dil

    leave
    ret

vector_length:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    VECTOR_LENGTH rsi, rsi
    MAKE_INT(rax, rsi)

    leave
    ret

vector_ref:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0) 
    VECTOR_ELEMENTS rsi, rsi
    mov rdi, PVAR(1)
    INT_VAL rdi, rdi
    shl rdi, 3
    add rsi, rdi

    mov rax, [rsi]

    leave
    ret

vector_set:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0) 
    VECTOR_ELEMENTS rsi, rsi
    mov rdi, PVAR(1)
    INT_VAL rdi, rdi
    shl rdi, 3
    add rsi, rdi

    mov rdi, PVAR(2)
    mov [rsi], rdi
    mov rax, SOB_VOID_ADDRESS

    leave
    ret

make_vector:
    push rbp
    mov rbp, rsp

    
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    mov rdi, PVAR(1)
    

    MAKE_VECTOR rax, rsi, rdi

    leave
    ret

symbol_to_string:
    push rbp
    mov rbp, rsp

    
    mov rsi, PVAR(0)
    SYMBOL_VAL rsi, rsi
    
    STRING_LENGTH rcx, rsi
    STRING_ELEMENTS rdi, rsi

    push rcx
    push rdi

    mov dil, byte [rdi]
    MAKE_CHAR(rax, dil)
    push rax
    MAKE_INT(rax, rcx)
    push rax
    push 2
    push SOB_NIL_ADDRESS
    call make_string
    add rsp, 4*8

    STRING_ELEMENTS rsi, rax

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

    
    mov rsi, PVAR(0)
    CHAR_VAL rsi, rsi
    and rsi, 255
    MAKE_INT(rax, rsi)

    leave
    ret

integer_to_char:
    push rbp
    mov rbp, rsp

    
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    and rsi, 255
    MAKE_CHAR(rax, sil)

    leave
    ret

is_eq:
    push rbp
    mov rbp, rsp

    
    mov rsi, PVAR(0)
    mov rdi, PVAR(1)
    cmp rsi, rdi
    je .true
    mov rax, SOB_FALSE_ADDRESS
    jmp .return

.true:
    mov rax, SOB_TRUE_ADDRESS

.return:
    leave
    ret

bin_add:
    push rbp
    mov rbp, rsp

    mov r8, 0

    mov rsi, PVAR(0)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .test_next
    or r8, 1

.test_next:

    mov rsi, PVAR(1)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .load_numbers
    or r8, 2

.load_numbers:
    push r8

    shr r8, 1
    jc .first_arg_int
    mov rsi, PVAR(0)
    FLOAT_VAL rsi, rsi 
    movq xmm0, rsi
    jmp .load_next_float

.first_arg_int:
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    cvtsi2sd xmm0, rsi

.load_next_float:
    shr r8, 1
    jc .second_arg_int
    mov rsi, PVAR(1)
    FLOAT_VAL rsi, rsi
    movq xmm1, rsi
    jmp .perform_float_op

.second_arg_int:
    mov rsi, PVAR(1)
    INT_VAL rsi, rsi
    cvtsi2sd xmm1, rsi

.perform_float_op:
    addsd xmm0, xmm1

    pop r8
    cmp r8, 3
    jne .return_float

    cvttsd2si rsi, xmm0
    MAKE_INT(rax, rsi)
    jmp .return

.return_float:
    movq rsi, xmm0
    MAKE_FLOAT(rax, rsi)

.return:

    leave
    ret

bin_mul:
    push rbp
    mov rbp, rsp

    mov r8, 0

    mov rsi, PVAR(0)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .test_next
    or r8, 1

.test_next:

    mov rsi, PVAR(1)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .load_numbers
    or r8, 2

.load_numbers:
    push r8

    shr r8, 1
    jc .first_arg_int
    mov rsi, PVAR(0)
    FLOAT_VAL rsi, rsi 
    movq xmm0, rsi
    jmp .load_next_float

.first_arg_int:
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    cvtsi2sd xmm0, rsi

.load_next_float:
    shr r8, 1
    jc .second_arg_int
    mov rsi, PVAR(1)
    FLOAT_VAL rsi, rsi
    movq xmm1, rsi
    jmp .perform_float_op

.second_arg_int:
    mov rsi, PVAR(1)
    INT_VAL rsi, rsi
    cvtsi2sd xmm1, rsi

.perform_float_op:
    mulsd xmm0, xmm1

    pop r8
    cmp r8, 3
    jne .return_float

    cvttsd2si rsi, xmm0
    MAKE_INT(rax, rsi)
    jmp .return

.return_float:
    movq rsi, xmm0
    MAKE_FLOAT(rax, rsi)

.return:

    leave
    ret

bin_sub:
    push rbp
    mov rbp, rsp

    mov r8, 0

    mov rsi, PVAR(0)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .test_next
    or r8, 1

.test_next:

    mov rsi, PVAR(1)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .load_numbers
    or r8, 2

.load_numbers:
    push r8

    shr r8, 1
    jc .first_arg_int
    mov rsi, PVAR(0)
    FLOAT_VAL rsi, rsi 
    movq xmm0, rsi
    jmp .load_next_float

.first_arg_int:
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    cvtsi2sd xmm0, rsi

.load_next_float:
    shr r8, 1
    jc .second_arg_int
    mov rsi, PVAR(1)
    FLOAT_VAL rsi, rsi
    movq xmm1, rsi
    jmp .perform_float_op

.second_arg_int:
    mov rsi, PVAR(1)
    INT_VAL rsi, rsi
    cvtsi2sd xmm1, rsi

.perform_float_op:
    subsd xmm0, xmm1

    pop r8
    cmp r8, 3
    jne .return_float

    cvttsd2si rsi, xmm0
    MAKE_INT(rax, rsi)
    jmp .return

.return_float:
    movq rsi, xmm0
    MAKE_FLOAT(rax, rsi)

.return:

    leave
    ret

bin_div:
    push rbp
    mov rbp, rsp

    mov r8, 0

    mov rsi, PVAR(0)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .test_next
    or r8, 1

.test_next:

    mov rsi, PVAR(1)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .load_numbers
    or r8, 2

.load_numbers:
    push r8

    shr r8, 1
    jc .first_arg_int
    mov rsi, PVAR(0)
    FLOAT_VAL rsi, rsi 
    movq xmm0, rsi
    jmp .load_next_float

.first_arg_int:
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    cvtsi2sd xmm0, rsi

.load_next_float:
    shr r8, 1
    jc .second_arg_int
    mov rsi, PVAR(1)
    FLOAT_VAL rsi, rsi
    movq xmm1, rsi
    jmp .perform_float_op

.second_arg_int:
    mov rsi, PVAR(1)
    INT_VAL rsi, rsi
    cvtsi2sd xmm1, rsi

.perform_float_op:
    divsd xmm0, xmm1

    pop r8
    cmp r8, 3
    jne .return_float

    cvttsd2si rsi, xmm0
    MAKE_INT(rax, rsi)
    jmp .return

.return_float:
    movq rsi, xmm0
    MAKE_FLOAT(rax, rsi)

.return:

    leave
    ret

bin_lt:
    push rbp
    mov rbp, rsp

    mov r8, 0

    mov rsi, PVAR(0)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .test_next
    or r8, 1

.test_next:

    mov rsi, PVAR(1)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .load_numbers
    or r8, 2

.load_numbers:
    push r8

    shr r8, 1
    jc .first_arg_int
    mov rsi, PVAR(0)
    FLOAT_VAL rsi, rsi 
    movq xmm0, rsi
    jmp .load_next_float

.first_arg_int:
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    cvtsi2sd xmm0, rsi

.load_next_float:
    shr r8, 1
    jc .second_arg_int
    mov rsi, PVAR(1)
    FLOAT_VAL rsi, rsi
    movq xmm1, rsi
    jmp .perform_float_op

.second_arg_int:
    mov rsi, PVAR(1)
    INT_VAL rsi, rsi
    cvtsi2sd xmm1, rsi

.perform_float_op:
    cmpltsd xmm0, xmm1

    pop r8
    cmp r8, 3
    jne .return_float

    cvttsd2si rsi, xmm0
    MAKE_INT(rax, rsi)
    jmp .return

.return_float:
    movq rsi, xmm0
    MAKE_FLOAT(rax, rsi)

.return:

    INT_VAL rsi, rax
    cmp rsi, 0
    je .return_false
    mov rax, SOB_TRUE_ADDRESS
    jmp .final_return

.return_false:
    mov rax, SOB_FALSE_ADDRESS

.final_return:


    leave
    ret

bin_equ:
    push rbp
    mov rbp, rsp

    mov r8, 0

    mov rsi, PVAR(0)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .test_next
    or r8, 1

.test_next:

    mov rsi, PVAR(1)
    push rsi
    push 1
    push SOB_NIL_ADDRESS
    call is_float
    add rsp, 3*WORD_SIZE 


    cmp rax, SOB_TRUE_ADDRESS
    je .load_numbers
    or r8, 2

.load_numbers:
    push r8

    shr r8, 1
    jc .first_arg_int
    mov rsi, PVAR(0)
    FLOAT_VAL rsi, rsi 
    movq xmm0, rsi
    jmp .load_next_float

.first_arg_int:
    mov rsi, PVAR(0)
    INT_VAL rsi, rsi
    cvtsi2sd xmm0, rsi

.load_next_float:
    shr r8, 1
    jc .second_arg_int
    mov rsi, PVAR(1)
    FLOAT_VAL rsi, rsi
    movq xmm1, rsi
    jmp .perform_float_op

.second_arg_int:
    mov rsi, PVAR(1)
    INT_VAL rsi, rsi
    cvtsi2sd xmm1, rsi

.perform_float_op:
    cmpeqsd xmm0, xmm1

    pop r8
    cmp r8, 3
    jne .return_float

    cvttsd2si rsi, xmm0
    MAKE_INT(rax, rsi)
    jmp .return

.return_float:
    movq rsi, xmm0
    MAKE_FLOAT(rax, rsi)

.return:

    INT_VAL rsi, rax
    cmp rsi, 0
    je .return_false
    mov rax, SOB_TRUE_ADDRESS
    jmp .final_return

.return_false:
    mov rax, SOB_FALSE_ADDRESS

.final_return:


    leave
    ret

car:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov rax, qword [rsi + TYPE_SIZE]

    leave
    ret
    
cdr:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0)
    mov rax, qword [rsi + TYPE_SIZE + WORD_SIZE]

    leave
    ret
    
set_car:
 ;   push rbp
 ;   mov rbp, rsp

    ;mov rsi, PVAR(0) 
    ;CAR rsi, rsi
    ;mov rdi, PVAR(1) ;new car

    ;mov [rsi], rdi
    ;mov rax, SOB_VOID_ADDRESS

    ;leave
    ;ret
    
set_cdr:
    ;push rbp
    ;mov rbp, rsp

    ;mov rsi, PVAR(0) 
    ;CDR rsi, rsi
    ;mov rdi, PVAR(1) ;new cdr

    ;mov [rsi], rdi
    ;mov rax, SOB_VOID_ADDRESS

    ;leave
    ;ret
    
cons:
    push rbp
    mov rbp, rsp

    mov rsi, PVAR(0) 
    mov rdi, PVAR(1)
    MAKE_PAIR (rax, rsi, rdi) ;todo: check if need to be [rsi], [rdi]
    ;make_pair puts the result in rax
    leave
    ret