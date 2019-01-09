#use "code-gen.ml";;

let file_to_string f =
  let ic = open_in f in
  let s = really_input_string ic (in_channel_length ic) in
  close_in ic;
  s;;

let string_to_asts s = List.map Semantics.run_semantics
                         (Tag_Parser.tag_parse_expressions
                            (Reader.read_sexprs s));;

let primitive_names_to_labels = 
  ["boolean?", "is_boolean"; "float?", "is_float"; "integer?", "is_integer"; "pair?", "is_pair";
   "null?", "is_null"; "char?", "is_char"; "vector?", "is_vector"; "string?", "is_string";
   "procedure?", "is_procedure"; "symbol?", "is_symbol"; "string-length", "string_length";
   "string-ref", "string_ref"; "string-set!", "string_set"; "make-string", "make_string";
   "vector-length", "vector_length"; "vector-ref", "vector_ref"; "vector-set!", "vector_set";
   "make-vector", "make_vector"; "symbol->string", "symbol_to_string"; 
   "char->integer", "char_to_integer"; "integer->char", "integer_to_char"; "eq?", "is_eq";
   "+", "bin_add"; "*", "bin_mul"; "-", "bin_sub"; "/", "bin_div"; "<", "bin_lt"; "=", "bin_equ";
   "car", "car"; "cdr", "cdr"; "set-car!", "set_car"; "set-cdr!", "set_cdr"; "cons", "cons"
(* todo: add apply implementation *)];;

let make_prologue consts_tbl fvars_tbl =
  let get_const_address const = const_address const consts_tbl in
  let get_fvar_address constString = fvar_address constString fvars_tbl in
  let make_primitive_closure (prim, label) =
"    MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, " ^ label  ^ ")
    mov [fvar_tbl + " ^ (get_fvar_address prim)  ^ "], rax" in
  let make_constant (c, (a, s)) = s in
  
"
;;; All the macros and the scheme-object printing procedure
;;; are defined in compiler.s
%include \"compiler.s\"

section .bss
malloc_pointer:
    resq 1
    

section .data


;;macros we added:
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


%macro MAKE_LITERAL_VECTOR 0-*
	db T_VECTOR
	dq %0
%rep %0
	dq %1
%rotate 1
%endrep
%endmacro

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
	db \"Error: trying to apply not-a-closure\", 0
const_tbl:
" ^ (String.concat "\n" (List.map make_constant consts_tbl)) ^ "
;;
;;; These macro definitions are required for the primitive
;;; definitions in the epilogue to work properly
%define SOB_VOID_ADDRESS " ^ get_const_address Void ^ "
%define SOB_NIL_ADDRESS " ^ get_const_address (Sexpr Nil) ^ "
%define SOB_FALSE_ADDRESS " ^ get_const_address (Sexpr (Bool true)) ^ "
%define SOB_TRUE_ADDRESS " ^ get_const_address (Sexpr (Bool false)) ^ "



fvar_tbl:
" ^ (String.concat "\n" (List.map (fun _ -> "dq T_UNDEFINED") fvars_tbl)) ^ "
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
    push qword 0502636308 ;;SOB_NIL_ADDRESS
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
" ^ (String.concat "\n" (List.map make_primitive_closure primitive_names_to_labels)) ^ "
 ;;add rsp, 4*8
 ;;pop rbp
 ;;ret
 
";;

let epilogue = (*TODO: implement apply*)
"car:
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
    ;push rbp
    ;mov rbp, rsp

    ;mov rsi, PVAR(0) 
    ;mov rdi, PVAR(1)
    ;MAKE_PAIR rax, rsi, rdi ;todo: check if need to be [rsi], [rdi]
    ;;make_pair puts the result in rax
    ;leave
    ;ret";;

exception X_missing_input_file;;

try
  let infile = Sys.argv.(1) in
  let code =  (*(file_to_string "stdlib.scm") ^*) (file_to_string infile) in
  let asts = string_to_asts code in
  let consts_tbl = Code_Gen.make_consts_tbl asts in
  let fvars_tbl = Code_Gen.make_fvars_tbl asts in
  let generate = Code_Gen.generate consts_tbl fvars_tbl in
  let code_fragment = String.concat "\n\n"
                        (List.map
                           (fun ast -> (generate ast) ^ "\n    call write_sob_if_not_void\n")
                           asts) in
  let provided_primitives = file_to_string "prims.s" in                  
  print_string ((make_prologue consts_tbl fvars_tbl)  ^
                  code_fragment ^ "leave\n ret\n" ^
                    provided_primitives ^ "\n" ^ epilogue)

with Invalid_argument(x) -> raise X_missing_input_file;;
