(* reader.ml
 * A compiler from Scheme to x86/64
 *
 * Programmer: Yehonatan Peleg And Meytal Rose, 2018
 *)

#use "tag-parser.ml";;

let  red =    "\027[38;5;196m"
let  grn =  "\027[38;5;082m"
let yel  = "\027[38;5;226m"
let mag  = "\027[38;5;201m"
let reset =  "\027[0m"

exception Fatal_error of string;;
exception TestException of string;;

let green_tests = ref 0
let red_tests = ref 0
let current_test = ref "No Current Test"
let failure_info = ref "as not as expected"
let got = ref "Not A Real Got"
let expected = ref "Not A Real Expected"

let rec expr_eq_as_list exprList1 exprList2 = 
   match exprList1, exprList2 with
   | [] , [] -> true
   | [] , head2 :: tail2 -> false
   | head1 :: tail1 , [] -> false
   | head1 :: tail1 , head2 :: tail2 -> (expr_eq head1 head2) && (expr_eq_as_list tail1 tail2)

let initialize = fun () ->
  Printexc.record_backtrace true;;

let prompt = fun title -> Printf.printf "%s*******************************************\n          %s                  \n*******************************************\n%s" mag title mag;;

let start_prompt = fun () -> prompt "Start Of Tag-Parser Test"; Printf.printf "\n";;

let end_prompt = fun () -> Printf.printf "\n"; prompt "End Of Tag-Parser Test"; Printf.printf "%sGreen: %d%s%s Red: %d%s\n" grn !green_tests reset red !red_tests reset;;

let test = fun test_number equal_test -> 
    if equal_test 
        then 
            green_tests := !green_tests + 1 
        else
            (red_tests := !red_tests + 1;
            (if !failure_info = "as not as expected" then failure_info := Printf.sprintf "with got %s while expected %s" !got !expected);
            Printf.printf "%s%s number %d Failed %s !!!%s\n" red !current_test test_number !failure_info red);
            failure_info := "as not as expected";;

let rec print_sexpr = fun sexprObj ->
  match sexprObj  with
    | Bool(true) -> "Bool(true)"
    | Bool(false) -> "Bool(false)"
    | Nil -> "Nil"
    | Number(Int(e)) -> Printf.sprintf "Number(Int(%d))" e
    | Number(Float(e)) -> Printf.sprintf "Number(Float(%f))" e
    | Char(e) -> Printf.sprintf "Char(%c)" e
    | String(e) -> Printf.sprintf "String(\"%s\")" e
    | Symbol(e) -> Printf.sprintf "Symbol(\"%s\")" e
    | Pair(e,s) -> Printf.sprintf "Pair(%s,%s)" (print_sexpr e) (print_sexpr s) 
    | Vector(list)-> Printf.sprintf "Vector(%s)" (print_sexprs_as_list list)

and 

print_sexprs = fun sexprList -> 
  match sexprList with
    | [] -> ""
    | head :: tail -> (print_sexpr head) ^ ";" ^ (print_sexprs tail)

and 

print_sexprs_as_list = fun sexprList ->
  let sexprsString = print_sexprs sexprList in
    "[ " ^ sexprsString ^ " ]"

and

print_expr = fun exprObj ->
  match exprObj  with
    | Const(Void) -> "Const(Void)"
    | Const(Sexpr(x)) -> Printf.sprintf "Const(Sexpr(%s))" (print_sexpr x)
    | Var(x) -> Printf.sprintf "Var(\"%s\")" x
    | If(test,dit,dif) -> Printf.sprintf "If(%s,%s,%s)" (print_expr test) (print_expr dit) (print_expr dif)
    | Seq(ls) -> Printf.sprintf "Seq(%s)" (print_exprs_as_list ls)
    | Set(var,value) -> Printf.sprintf "Set(%s,%s)" (print_expr var) (print_expr value)
    | Def(var,value) -> Printf.sprintf "Def(%s,%s)" (print_expr var) (print_expr value)
    | Or(ls) -> Printf.sprintf "Or(%s)" (print_exprs_as_list ls)
    | LambdaSimple(args,body) -> Printf.sprintf "LambdaSimple(%s,%s)" (print_strings_as_list args) (print_expr body)
    | LambdaOpt(args,option_arg,body) -> Printf.sprintf "LambdaOpt(%s,%s,%s)" (print_strings_as_list args) option_arg (print_expr body)
    | Applic(proc,params) -> Printf.sprintf "Applic(%s,%s)" (print_expr proc) (print_exprs_as_list params)

and 

print_exprs = fun exprList -> 
  match exprList with
    | [] -> ""
    | head :: [] -> (print_expr head) 
    | head :: tail -> (print_expr head) ^ "; " ^ (print_exprs tail)

and

print_exprs_as_list = fun exprList ->
  let exprsString = print_exprs exprList in
    "[ " ^ exprsString ^ " ]"

and

print_strings = fun stringList -> 
  match stringList with
    | [] -> ""
    | head :: [] -> head 
    | head :: tail -> head ^ "; " ^ (print_strings tail)

and

print_strings_as_list = fun stringList ->
  let stringList = print_strings stringList in
    "[ " ^ stringList ^ " ]";;

let create_got = fun string ->
  yel ^ string ^ reset ^ red

let create_expected = fun string ->
  grn ^ string ^ reset ^ red

let execute_tag_parse_expression = fun sexpr ->
  let return = try (Tag_Parser.tag_parse_expression sexpr) with 
               | exn -> 
                 let error = (Printexc.to_string exn) in 
                 failure_info := "with " ^ (print_sexpr sexpr) ^ " as " ^ error; Var ("test failed with " ^ error)  in
  (got := create_got (print_expr return);
  return);;

let execute_expected = fun exprObj -> 
  expected := create_expected (print_expr exprObj);
  exprObj;;

let execute_tag_parse_expressions_as_list = fun sexprs ->
   let return = try (Tag_Parser.tag_parse_expressions sexprs) with 
               | exn -> 
                 let error = (Printexc.to_string exn) in 
                 failure_info := "with " ^ (print_sexprs_as_list sexprs) ^ " as " ^ error; [Var ("test failed with " ^ error)]  in
  (got := create_got (print_exprs_as_list return);
  return);;

let execute_expected_as_list = fun exprObj -> 
  expected := create_expected (print_exprs_as_list exprObj);
  exprObj;;

let test_Self_Evaluated = fun () ->
    current_test := "test_self_evaluated";
    test 1 (expr_eq (execute_tag_parse_expression (Number(Int 5))) (execute_expected(Const(Sexpr(Number(Int(5)))))));
    (*test 2 (expr_eq (execute_tag_parse_expression (Number(Float 5.5))) (execute_expected(Const(Sexpr(Number(Float(5.5)))))));
    test 3 (expr_eq (execute_tag_parse_expression (Bool true)) (execute_expected(Const(Sexpr(Bool true)))));
    test 4 (expr_eq (execute_tag_parse_expression (Bool false)) (execute_expected(Const(Sexpr(Bool false)))));
    test 5 (expr_eq (execute_tag_parse_expression (Char 'c')) (execute_expected(Const(Sexpr(Char 'c')))));
    test 6 (expr_eq (execute_tag_parse_expression (Char '\t')) (execute_expected(Const(Sexpr(Char '\t')))));
    test 7 (expr_eq (execute_tag_parse_expression (String "hello")) (execute_expected(Const(Sexpr(String "hello")))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol("quote"),Pair(Char('#'),Nil)))) (execute_expected(Const(Sexpr(Char('#'))))));
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol("quote"),Pair(String("This is a string with . "),Nil)))) (execute_expected(Const(Sexpr(String("This is a string with . "))))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))),Nil)))) (execute_expected(Const(Sexpr(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))))))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol("quote"),Pair(Char('#'),Pair(Char('x'),Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 12 (expr_eq (execute_tag_parse_expression (Pair(Symbol("quote"),Pair(Char('#'),Symbol("x"))))) (execute_expected(Var("test failed with X_syntax_error"))));
    *);;

let test_Variable = fun () ->
    current_test := "test_variable";
    test 1 (expr_eq (execute_tag_parse_expression (Symbol("variable"))) (execute_expected(Var("variable"))));
  (*   test 2 (expr_eq (execute_tag_parse_expression (Symbol("!$^*-_=+<>?/:0123456789abcdefghijk"))) (execute_expected(Var("!$^*-_=+<>?/:0123456789abcdefghijk"))));
    test 3 (expr_eq (execute_tag_parse_expression (Symbol("zzzzzzzz0123456789"))) (execute_expected(Var("zzzzzzzz0123456789"))));
    test 4 (expr_eq (execute_tag_parse_expression (Symbol("and"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 5 (expr_eq (execute_tag_parse_expression (Symbol("cond"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 6 (expr_eq (execute_tag_parse_expression (Symbol("define"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 7 (expr_eq (execute_tag_parse_expression (Symbol("else"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 8 (expr_eq (execute_tag_parse_expression (Symbol("if"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 9 (expr_eq (execute_tag_parse_expression (Symbol("lambda"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 10 (expr_eq (execute_tag_parse_expression (Symbol("let"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 11 (expr_eq (execute_tag_parse_expression (Symbol("let*"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 12 (expr_eq (execute_tag_parse_expression (Symbol("letrec"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 13 (expr_eq (execute_tag_parse_expression (Symbol("or"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 14 (expr_eq (execute_tag_parse_expression (Symbol("quasiquote"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 15 (expr_eq (execute_tag_parse_expression (Symbol("quote"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 16 (expr_eq (execute_tag_parse_expression (Symbol("set!"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 17 (expr_eq (execute_tag_parse_expression (Symbol("unquote"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 18 (expr_eq (execute_tag_parse_expression (Symbol("unquote-splicing"))) (execute_expected(Var("test failed with X_syntax_error"))));
     *);;

let test_Conditionals = fun () ->
    current_test := "test_Conditionals";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(Number(Int 5), Pair(Number(Int 4), Pair(Number(Int 3), Nil)))))) (execute_expected(If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))))));
   (*  test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(String "a", Pair(Char 'c', Pair(Symbol "h", Nil)))))) (execute_expected(If(Const(Sexpr(String "a")),Const(Sexpr(Char 'c')),Var("h")))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(Symbol "g", Pair(Char 'c', Pair(Symbol "h", Nil)))))) (execute_expected(If(Var("g"),Const(Sexpr(Char 'c')),Var("h")))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(Symbol "g", Pair(Pair(Symbol "quote", Pair(Symbol "g", Nil)), Pair(Symbol "h", Nil)))))) (execute_expected(If(Var("g"),Const(Sexpr(Symbol "g")),Var("h")))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(Symbol "g", Pair(Pair(Symbol "quote", Pair(Symbol "g", Nil)), Pair(Char 'x', Nil)))))) (execute_expected(If(Var("g"),Const(Sexpr(Symbol "g")),Const(Sexpr(Char 'x'))))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(String "a", Pair(Symbol "h", Nil))))) (execute_expected(If(Const(Sexpr(String "a")),Var("h"),Const(Void)))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(Pair(Symbol "quote", Pair(Symbol "g", Nil)), Pair(Symbol "h", Nil))))) (execute_expected(If(Const(Sexpr(Symbol "g")),Var("h"),Const(Void)))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(Pair(Symbol "quote", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "quote", Pair(String "hello", Nil)), Nil))))) (execute_expected(If(Const(Sexpr(Symbol "g")),Const(Sexpr(String "hello")),Const(Void)))));
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(String "a", Nil)))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(String "a", Pair(Char 'c', Pair(Char 'a',Pair(Symbol "g", Nil))))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "if", Pair(String "a", Char 'c')))) (execute_expected(Var("test failed with X_syntax_error"))));
    *) ;;

let test_Lambda_Expressions = fun () ->
    current_test := "test_Lambda_Expressions";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Nil, Pair(Symbol "x", Nil))))) (execute_expected(LambdaSimple([],Var("x")))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Nil), Pair(Symbol "x", Nil))))) (execute_expected(LambdaSimple(["a"],Var("x")))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Nil)), Pair(Symbol "x", Nil))))) (execute_expected(LambdaSimple(["a"; "b"],Var("x")))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Nil)), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Nil))))) (execute_expected(LambdaSimple(["a"; "b"],If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3))))))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Nil)), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Nil)))))) (execute_expected(LambdaSimple(["a"; "b"],Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s"))])))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Nil))), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Pair(Symbol "g", Nil))))))) (execute_expected(LambdaSimple(["a"; "b"; "c"],Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s")); Var("g")])))));
    
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Symbol "b"), Pair(Symbol "x", Nil))))) (execute_expected(LambdaOpt(["a"],"b",Var("x")))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Symbol "c")), Pair(Symbol "x", Nil))))) (execute_expected(LambdaOpt(["a"; "b"],"c",Var("x")))));
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c",Symbol "d"))), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Nil))))) (execute_expected(LambdaOpt(["a"; "b"; "c"],"d",If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3))))))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c",Symbol "d"))), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Nil)))))) (execute_expected(LambdaOpt(["a"; "b"; "c"],"d",Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s"))])))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c",Symbol "d"))), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Pair(Symbol "g", Nil))))))) (execute_expected(LambdaOpt(["a"; "b"; "c"],"d",Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s")); Var("g")])))));

    test 12 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Symbol("vs"), Pair(Symbol "x", Nil))))) (execute_expected(LambdaOpt([],"vs",Var("x")))));
    test 13 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Symbol("vvvvvs"), Pair(Symbol "x", Nil))))) (execute_expected(LambdaOpt([],"vvvvvs",Var("x")))));
    test 14 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Symbol("f"), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Nil))))) (execute_expected(LambdaOpt([],"f",If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3))))))));
    test 15 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Symbol("5g3dc"), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Nil)))))) (execute_expected(LambdaOpt([],"5g3dc",Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s"))])))));
    test 16 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Symbol("!$^*-_=+<>?/:0123456789abcdefghijk"), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Pair(Symbol "g", Nil))))))) (execute_expected(LambdaOpt([],"!$^*-_=+<>?/:0123456789abcdefghijk",Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s")); Var("g")])))));

    test 17 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Nil), Nil)))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 18 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Nil), String("f"))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 19 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Pair(Symbol "a", Nil))))))), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 20 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Pair(Symbol "c", Nil))))))), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 21 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Symbol "d")))))), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 22 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Symbol "f")))))), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 23 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Nil, Pair(Symbol "x", Pair(Symbol "if", Pair(Number(Int 5), Pair(Number(Int 4), Pair(Number(Int 3), Nil))))))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 24 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "x",Symbol "y"), Pair(Symbol "x", Pair(Symbol "if", Pair(Number(Int 5), Pair(Number(Int 4), Pair(Number(Int 3), Nil))))))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 25 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(String "s", Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 26 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Number(Int(4)), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 27 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Char('\n'), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 28 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "hello", Pair(Symbol "hello", Nil)), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 29 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "g", Pair(Symbol "g", Nil)), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 30 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))))) (execute_expected(LambdaOpt([],"s",Var("x")))));
    
    test 31 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda",Nil))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 32 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Symbol "s"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 33 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda",Pair(Symbol "s", String "b")))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 34 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda",Pair(Pair(Symbol "a", Nil), String "b")))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 35 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Number(Int(4)), Pair(Symbol "b", Nil)), Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 36 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Pair(Pair(Symbol "if", Pair(Number(Int 5), Pair(Number(Int 4), Pair(Number(Int 3), Nil)))), Nil))), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Pair(Symbol "g", Nil))))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 37 (expr_eq (execute_tag_parse_expression (Pair(Symbol "lambda", Pair(String "not_sym", Pair(Symbol "x", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
     *);;

let test_Applications = fun () ->
    current_test := "test_Applications";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "+", Nil))) (execute_expected(Applic(Var("+"),[]))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "+", Pair(Number (Int 5), Nil)))) (execute_expected(Applic(Var("+"),[Const(Sexpr(Number(Int 5)))]))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Nil))))) (execute_expected(Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4)))]))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Float 4.4), Nil))))) (execute_expected(Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Float 4.4)))]))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "hello", Pair(Number(Int 5), Pair(Number (Int 4),Pair(Pair(Symbol "lambda", Pair(Symbol("!$^*-_=+<>?/:0123456789abcdefghijk"), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Pair(Symbol "g", Nil))))), Nil)))))) (execute_expected(Applic(Var("hello"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4))); LambdaOpt([],"!$^*-_=+<>?/:0123456789abcdefghijk",Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s")); Var("g")]))]))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(String "not a symbol but ok", Pair(Pair(Symbol "if", Pair(Pair(Symbol "quote", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "quote", Pair(String "hello", Nil)), Nil))), Pair(Number (Int 4),Pair(Pair(Symbol "lambda", Pair(Symbol("!$^*-_=+<>?/:0123456789abcdefghijk"), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Pair(Symbol "g", Nil))))), Nil)))))) (execute_expected(Applic(Const(Sexpr(String "not a symbol but ok")),[If(Const(Sexpr(Symbol "g")),Const(Sexpr(String "hello")),Const(Void)); Const(Sexpr(Number(Int 4))); LambdaOpt([],"!$^*-_=+<>?/:0123456789abcdefghijk",Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s")); Var("g")]))]))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Number(Int(3)) , Nil))) (execute_expected(Applic(Const(Sexpr(Number(Int(3)))),[]))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Pair(Symbol "if", Pair(Symbol "g", Pair(Char 'c', Pair(Symbol "h", Nil)))) , Nil))) (execute_expected(Applic(If(Var("g"),Const(Sexpr(Char 'c')),Var("h")),[]))));
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "+", Symbol "+"))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Number (Int 2)))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "hello", Pair(Number(Int 5), Pair(Number (Int 4),Pair(Pair(Symbol "lambda", Pair(Symbol("!$^*-_=+<>?/:0123456789abcdefghijk"), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Pair(Symbol "g", Nil))))), Pair(Symbol "if", Pair(Number(Int 5), Pair(Number(Int 4), Pair(Number(Int 3), Nil)))))))))) (execute_expected(Var("test failed with X_syntax_error"))));
     *);;

let test_Disjunctions = fun () ->
    current_test := "test_Disjunctions";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Nil))) (execute_expected(Const(Sexpr(Bool(false))))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Symbol "hello", Nil)))) (execute_expected(Var "hello")));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Number(Int(3)), Nil)))) (execute_expected(Const(Sexpr(Number(Int(3)))))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Char '\t', Nil)))) (execute_expected(Const(Sexpr(Char '\t')))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))),Nil)), Nil)))) (execute_expected(Const(Sexpr(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))))))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Nil))), Nil)))) (execute_expected(Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4)))]))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Symbol "hello", Pair(String "hello", Nil))))) (execute_expected(Or([Var("hello"); Const(Sexpr(String "hello"))]))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Number (Int 54), Pair(Char 'j', Pair(String "do it", Nil)))))) (execute_expected(Or([Const(Sexpr(Number (Int 54))); Const(Sexpr(Char 'j')); Const(Sexpr(String "do it"))]))));
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Nil))), Pair(Pair(Symbol "lambda", Pair(Pair(Symbol "a", Pair(Symbol "b", Nil)), Pair(Symbol "x", Nil))), Pair(Pair(Symbol "if", Pair(Pair(Symbol "quote", Pair(Symbol "g", Nil)), Pair(Symbol "h", Nil))), Nil)))))) (execute_expected(Or([Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4)))]); LambdaSimple(["a"; "b"],Var("x"));  If(Const(Sexpr(Symbol "g")),Var("h"),Const(Void))]))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Number (Int 54)))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "or", Pair(Number (Int 54), Char 'j')))) (execute_expected(Var("test failed with X_syntax_error"))));
     *);;

let test_Definitions = fun () ->
    current_test := "test_Definitions";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "va", Pair(Char 'j', Nil))))) (execute_expected(Def(Var("va"),Const(Sexpr(Char 'j'))))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "g", Pair(Number(Float(3.2)), Nil))))) (execute_expected(Def(Var("g"),Const(Sexpr(Number(Float(3.2))))))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "tg55", Pair(Symbol "5.5.6", Nil))))) (execute_expected(Def(Var("tg55"),Var("5.5.6")))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "=", Pair(Pair(Symbol("quote"),Pair(Char('#'),Nil)), Nil))))) (execute_expected(Def(Var("="),Const(Sexpr(Char('#')))))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "this_is_a_variable", Pair(String "here", Nil))))) (execute_expected(Def(Var("this_is_a_variable"),Const(Sexpr(String "here"))))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "this_is_a_variable", Pair(Pair(Symbol "or", Nil), Nil))))) (execute_expected(Def(Var("this_is_a_variable"),Const(Sexpr(Bool(false)))))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "this_is_a_variable", Pair(Pair(Symbol "+", Pair(Number (Int 5), Nil)), Nil))))) (execute_expected(Def(Var("this_is_a_variable"),Applic(Var("+"),[Const(Sexpr(Number(Int 5)))])))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "this_is_a_variable", Pair(Pair(Symbol "lambda", Pair(Pair(Symbol "a", Symbol "b"), Pair(Symbol "x", Nil))), Nil))))) (execute_expected(Def(Var("this_is_a_variable"),LambdaOpt(["a"],"b",Var("x"))))));
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "this_is_a_variable", Pair(Pair(Symbol "if", Pair(Symbol "g", Pair(Char 'c', Pair(Symbol "h", Nil)))), Nil))))) (execute_expected(Def(Var("this_is_a_variable"),If(Var("g"),Const(Sexpr(Char 'c')),Var("h"))))));

    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Nil), Pair(Symbol "x", Nil))        ))) (execute_expected(Def(Var("func"),LambdaSimple([],Var("x"))))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Nil)), Pair(Symbol "x", Nil))        ))) (execute_expected(Def(Var("func"),LambdaSimple(["a"],Var("x"))))));
    test 12 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Nil))), Pair(Symbol "x", Nil))        ))) (execute_expected(Def(Var("func"),LambdaSimple(["a"; "b"],Var("x"))))));
    test 13 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Nil))), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))),Nil))        ))) (execute_expected(Def(Var("func"),LambdaSimple(["a"; "b"],If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))))))));
    test 14 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Nil))), Pair(Pair(Symbol "if", Pair(Number (Int 5), Pair(Number (Int 4), Pair(Number (Int 3), Nil)))), Pair(Pair(Symbol "quote", Pair(String "s", Nil)), Nil)))        ))) (execute_expected(Def(Var("func"),LambdaSimple(["a"; "b"],Seq([If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))); Const(Sexpr(String "s"))]))))));
    test 15 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Nil)))), Pair(Pair(Symbol "or", Pair(Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Nil))), Nil)),Pair(Pair(Symbol "if", Pair(String "a", Pair(Symbol "h", Nil))),Pair(Pair(Symbol "lambda", Pair(Nil, Pair(Symbol "x", Nil))) ,Nil))))        ))) (execute_expected(Def(Var("func"),LambdaSimple(["a"; "b"; "c"],Seq([Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4)))]); If(Const(Sexpr(String "a")),Var("h"),Const(Void)); LambdaSimple([],Var("x"))]))))));
    
    test 16 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Symbol "b")), Pair(Symbol "x", Nil))        ))) (execute_expected(Def(Var("func"),LambdaOpt(["a"],"b",Var("x"))))));
    test 17 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Symbol "c"))), Pair(Symbol "x",Pair(Symbol "y", Nil)))        ))) (execute_expected(Def(Var("func"),LambdaOpt(["a"; "b"],"c",Seq([Var("x"); Var("y")]))))));
    test 18 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c",Symbol "d")))), Pair(Symbol "x",Pair(Symbol "y",Pair(Symbol "z", Nil))))        ))) (execute_expected(Def(Var("func"),LambdaOpt(["a"; "b"; "c"],"d",Seq([Var("x"); Var("y"); Var("z")]))))));
    test 19 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c",Symbol "d")))), Pair(Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Nil))),Pair(Pair(Symbol "or", Pair(Symbol "hello", Pair(String "hello", Nil))),Pair(Symbol "z", Nil))))        ))) (execute_expected(Def(Var("func"),LambdaOpt(["a"; "b"; "c"],"d",Seq([Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4)))]); Or([Var "hello"; Const(Sexpr(String "hello"))]); Var("z")]))))));
    
    test 20 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Symbol("vs")), Pair(Symbol "x", Nil))        ))) (execute_expected(Def(Var("func"),LambdaOpt([],"vs",Var("x"))))));
    test 21 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Symbol("vs")), Pair(Symbol "x",Pair(Symbol "y", Nil)))        ))) (execute_expected(Def(Var("func"),LambdaOpt([],"vs",Seq([Var("x"); Var("y")]))))));
    test 22 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Symbol("vs")), Pair(Symbol "x",Pair(Symbol "y",Pair(Symbol "z", Nil))))        ))) (execute_expected(Def(Var("func"),LambdaOpt([],"vs",Seq([Var("x"); Var("y"); Var("z")]))))));
    test 23 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Symbol("vs")), Pair(Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Nil))),Pair(Pair(Symbol "or", Pair(Symbol "hello", Pair(String "hello", Nil))),Pair(Symbol "z", Nil))))        ))) (execute_expected(Def(Var("func"),LambdaOpt([],"vs",Seq([Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4)))]); Or([Var "hello"; Const(Sexpr(String "hello"))]); Var("z")]))))));
  
    test 24 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Nil))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 25 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "var", Nil)))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 26 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Number (Int 66), Pair(Number (Int 55), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 27 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(String "hello", Pair(Number (Int 55), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 28 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Char 'c', Pair(Number (Int 55), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 29 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "if", Pair(Number (Int 4), Pair(Number (Int 4), Pair(Number (Int 4), Nil)))), Pair(Number (Int 55), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 30 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "var", Number (Int 55))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 31 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "var", String "hello")))) (execute_expected(Var("test failed with X_syntax_error"))));
    
    test 32 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Symbol "func", Nil)        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 33 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Nil),  Nil)        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 34 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Nil),Pair(Symbol "x",Symbol "y"))       ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 35 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(String "s", Nil), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 36 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Number(Float(4.3)), Nil), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 37 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Char '\n', Nil), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 38 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Pair(Symbol "or", Nil), Nil), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 39 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", String "not_ok"), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 40 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "h", Pair(Symbol "h", Nil))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 41 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(String "+", Nil)), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 42 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Number(Int(4)), Pair(Symbol "b", Nil))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 43 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Number (Int 5), Nil))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 44 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Number (Int 5))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 45 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Number (Int 5), Pair(Symbol "a", Nil))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 46 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Number (Int 5), Symbol "a")), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 47 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Pair(Symbol "a", Nil)))))))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 48 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Pair(Symbol "d", Nil)))))))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 49 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func",     Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Symbol "d"))))))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 50 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Symbol "f"))))))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 51 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", String "s"))))))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 52 (expr_eq (execute_tag_parse_expression (Pair(Symbol "define", Pair(Pair(Symbol "func", Pair(Symbol "a", Pair(Symbol "b", Pair(Symbol "c", Pair(Symbol "d", Pair(Symbol "e", Pair(Symbol "f", Pair(String "s", Nil)))))))), Pair(Symbol "x", Nil))        ))) (execute_expected(Var("test failed with X_syntax_error"))));
     *);;

let test_Assignments = fun () ->
    current_test := "test_Assignments";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Pair(Number (Int 5), Nil))))) (execute_expected(Set(Var("var"),Const(Sexpr(Number (Int 5)))))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "hello", Pair(String "hello", Nil))))) (execute_expected(Set(Var("hello"),Const(Sexpr(String "hello"))))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "!$^*-_=+<>?/:0123456789abcdefghijk", Pair(Char '\r', Nil))))) (execute_expected(Set(Var("!$^*-_=+<>?/:0123456789abcdefghijk"),Const(Sexpr(Char '\r'))))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Pair(Pair(Symbol("quote"),Pair(Char('#'),Nil)), Nil))))) (execute_expected(Set(Var("var"),Const(Sexpr(Char('#')))))));
    
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Pair(Pair(Symbol "lambda", Pair(Nil, Pair(Symbol "x", Nil))), Nil))))) (execute_expected(Set(Var("var"),LambdaSimple([],Var("x"))))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Pair(Pair(Symbol "if", Pair(String "a", Pair(Symbol "h", Nil))), Nil))))) (execute_expected(Set(Var("var"),If(Const(Sexpr(String "a")),Var("h"),Const(Void))))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Pair(Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Float 4.4), Nil))), Nil))))) (execute_expected(Set(Var("var"),Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Float 4.4)))])))));

    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(String "var", Pair(Number (Int 5), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Char 'c', Pair(String "hello", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Number(Int(20)), Pair(Char '\r', Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Pair(Symbol("quote"),Pair(Char('#'),Nil)), Pair(Pair(Symbol("quote"),Pair(Char('#'),Nil)), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 12 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Pair(Symbol "lambda", Pair(Pair(Symbol "a", Symbol "b"), Pair(Symbol "x", Nil))), Pair(Pair(Symbol "lambda", Pair(Nil, Pair(Symbol "x", Nil))), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));

    test 13 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Nil))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 14 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Nil)))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 15 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Pair(Number (Int 5), Pair(Number (Int 5), Nil)))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 16 (expr_eq (execute_tag_parse_expression (Pair(Symbol "set!", Pair(Symbol "var", Pair(String "hello", Pair(Char 'g', Pair(Number (Float 6.6), Nil))))))) (execute_expected(Var("test failed with X_syntax_error"))));
     *);;

let test_Sequences = fun () ->
    current_test := "test_Sequences";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Nil))) (execute_expected(Const(Void))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Number (Int 5), Nil)))) (execute_expected(Const(Sexpr(Number (Int 5))))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(String "string", Nil)))) (execute_expected(Const(Sexpr(String "string")))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Char 'c', Nil)))) (execute_expected(Const(Sexpr(Char 'c')))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Pair(Symbol "quote", Pair(String "hello", Nil)),Nil)))) (execute_expected(Const(Sexpr(String "hello")))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Bool false, Nil)))) (execute_expected(Const(Sexpr(Bool false)))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Pair(Symbol "if", Pair(Symbol "g", Pair(Char 'c', Pair(Symbol "h", Nil)))),Nil)))) (execute_expected(If(Var("g"),Const(Sexpr(Char 'c')),Var("h")))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Pair(Symbol "lambda", Pair(Pair(Symbol "a", Symbol "b"), Pair(Symbol "x", Nil))),Nil)))) (execute_expected(LambdaOpt(["a"],"b",Var("x")))));
    
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Bool false, Pair(Number (Int 5), Nil))))) (execute_expected(Seq([Const(Sexpr(Bool false)); Const(Sexpr(Number (Int 5)))]))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Symbol "g", Pair(Bool false, Pair(Number (Int 5), Nil)))))) (execute_expected(Seq([Var "g"; Const(Sexpr(Bool false)); Const(Sexpr(Number (Int 5)))]))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Pair(Symbol "lambda", Pair(Symbol("vs"), Pair(Symbol "x", Nil))),Nil)))) (execute_expected(LambdaOpt([],"vs",Var("x")))));
    test 12 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Pair(Symbol "lambda", Pair(Symbol("vs"), Pair(Symbol "x", Nil))),Pair(Pair(Symbol "if", Pair(String "a", Pair(Char 'c', Pair(Symbol "h", Nil)))),Nil))))) (execute_expected(Seq([LambdaOpt([],"vs",Var("x")); If(Const(Sexpr(String("a"))),Const(Sexpr(Char 'c')),Var("h"))]))));
    test 13 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Pair(Pair(Symbol "lambda", Pair(Symbol("vs"), Pair(Symbol "x", Nil))),Pair(Pair(Symbol "if", Pair(String "a", Pair(Char 'c', Pair(Symbol "h", Nil)))),Pair(Pair(Symbol "+", Pair(Number(Int 5), Pair(Number (Int 4), Nil))),Nil)))))) (execute_expected(Seq([LambdaOpt([],"vs",Var("x")); If(Const(Sexpr(String("a"))),Const(Sexpr(Char 'c')),Var("h")); Applic(Var("+"),[Const(Sexpr(Number(Int 5))); Const(Sexpr(Number(Int 4)))])]))));

    test 14 (expr_eq (execute_tag_parse_expression (Pair(Symbol "begin", Symbol "g"))) (execute_expected(Var("test failed with X_syntax_error"))));
     *);;

let test_Quasiquoted_Macro_Expansion = fun () ->
    current_test := "test_Quasiquoted_Macro_Expansion";
    
    test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( String "string", Nil)))) (execute_expected(Const(Sexpr(String "string")))));
    (* test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Char '\n', Nil)))) (execute_expected(Const(Sexpr(Char '\n')))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Symbol("a_symbol"), Nil)))) (execute_expected(Const(Sexpr(Symbol("a_symbol"))))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair(Symbol "quote", Pair(Symbol "h", Nil)), Nil)))) (execute_expected(Applic(Var "cons",[Const(Sexpr(Symbol "quote")); Applic(Var "cons",[Const(Sexpr(Symbol "h")); Const(Sexpr(Nil))]) ]))));
    
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair(Symbol "unquote", Pair(Pair(Symbol "quote", Pair(Symbol "h", Nil)), Nil)), Nil)))) (execute_expected(Const(Sexpr(Symbol "h")))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair(Symbol "unquote", Pair(Symbol "h", Nil)), Nil)))) (execute_expected(Var("h"))));
    test 8 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair(Symbol "unquote", Pair(Number (Int 5), Nil)), Nil)))) (execute_expected(Const(Sexpr(Number (Int 5))))));
    
    test 9 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair(Symbol "unquote-splicing", Pair(Pair(Symbol "quote", Pair(Symbol "h", Nil)), Nil)), Nil)))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair(Symbol "unquote-splicing", Pair(Symbol "h", Nil)), Nil)))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair(Symbol "unquote-splicing", Pair(Number (Int 5), Nil)), Nil)))) (execute_expected(Var("test failed with X_syntax_error"))));
    
    test 12 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Number (Int 5), Nil)))) (execute_expected(Const(Sexpr(Number (Int 5))))));
    test 13 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(String "string", Nil)))) (execute_expected(Const(Sexpr(String "string")))));
    test 14 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Char '\n', Nil)))) (execute_expected(Const(Sexpr(Char '\n')))));
    test 15 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Symbol("a_symbol"), Nil)))) (execute_expected(Const(Sexpr(Symbol("a_symbol"))))));
    test 16 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "quote", Pair(Char 'h', Nil)), Nil)))) (execute_expected(Applic(Var "cons",[Const(Sexpr(Symbol "quote")); Applic(Var "cons",[Const(Sexpr(Char 'h')); Const(Sexpr(Nil))]) ]))));
    
    test 17 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair( Pair(Symbol "unquote", Pair(Pair(Symbol "quote", Pair(Symbol "h", Nil)), Nil)),Nil), Nil)))) (execute_expected(Applic(Var("cons"),[Const(Sexpr(Symbol "h"));Const(Sexpr(Nil))]))));
    test 18 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair( Pair(Symbol "unquote", Pair(Symbol "h", Nil)),Nil), Nil)))) (execute_expected(Applic(Var("cons"),[Var("h");Const(Sexpr(Nil))]))));
    test 19 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair( Pair(Symbol "unquote", Pair(Number (Int 5), Nil)),Nil), Nil)))) (execute_expected(Applic(Var("cons"),[Const(Sexpr(Number (Int 5)));Const(Sexpr(Nil))]))));
    
    test 20 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair( Pair(Symbol "unquote-splicing", Pair(Pair(Symbol "quote", Pair(Symbol "h", Nil)), Nil)),Nil), Nil)))) (execute_expected(Applic(Var("append"),[Const(Sexpr(Symbol "h"));Const(Sexpr(Nil))]))));
    test 21 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair( Pair(Symbol "unquote-splicing", Pair(Symbol "h", Nil)),Nil), Nil)))) (execute_expected(Applic(Var("append"),[Var("h");Const(Sexpr(Nil))]))));
    test 22 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Pair( Pair(Symbol "unquote-splicing", Pair(Number (Int 5), Nil)),Nil), Nil)))) (execute_expected(Applic(Var("append"),[Const(Sexpr(Number (Int 5)));Const(Sexpr(Nil))]))));

    test 23 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "a", Pair(Symbol "b", Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[Const(Sexpr(Symbol "a")); Applic(Var("cons"),[Const(Sexpr(Symbol "b")); Const(Sexpr(Nil))])]))));
    test 24 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Symbol "unquote", Pair(Symbol "a", Nil)), Pair(Symbol "b", Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[Var("a"); Applic(Var("cons"),[Const(Sexpr(Symbol "b")); Const(Sexpr(Nil))])]))));
    test 25 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "a", Pair(Pair(Symbol "unquote", Pair(Symbol "b", Nil)), Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[Const(Sexpr(Symbol "a")); Applic(Var("cons"),[Var("b"); Const(Sexpr(Nil))])]))));
    test 26 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Symbol "a", Nil)), Pair(Symbol "b", Nil)), Nil)))) (execute_expected(Applic(Var("append"),[Var("a"); Applic(Var("cons"),[Const(Sexpr(Symbol "b")); Const(Sexpr(Nil))])]))));
    test 27 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "a", Pair(Pair(Symbol "unquote-splicing", Pair(Symbol "b", Nil)), Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[Const(Sexpr(Symbol "a")); Applic(Var("append"),[Var("b"); Const(Sexpr(Nil))])]))));
    test 28 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Symbol "unquote", Pair(Symbol "a", Nil)), Pair(Pair(Symbol "unquote-splicing", Pair(Symbol "b", Nil)), Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[Var("a"); Applic(Var("append"),[Var("b"); Const(Sexpr(Nil))])]))));
    test 29 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Symbol "a", Nil)), Pair(Pair(Symbol "unquote-splicing", Pair(Symbol "b", Nil)), Nil)), Nil)))) (execute_expected(Applic(Var("append"),[Var("a"); Applic(Var("append"),[Var("b"); Const(Sexpr(Nil))])]))));
    test 30 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Symbol "a", Nil)), Pair(Symbol "unquote", Pair(Symbol "b", Nil))), Nil)))) (execute_expected(Applic(Var("append"),[Var("a");Var("b")]))));
    test 31 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Symbol "unquote", Pair(Symbol "a", Nil)), Pair(Symbol "unquote-splicing", Pair(Symbol "b", Nil))), Nil)))) (execute_expected(Applic(Var("cons"),[Var("a");Var("b")]))));
    test 32 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Symbol "a", Nil)), Nil), Nil), Nil), Nil)))) (execute_expected(Applic(Var("cons"),[Applic(Var("cons"),[Applic(Var("append"),[Var("a"); Const(Sexpr(Nil))]); Const(Sexpr(Nil))]); Const(Sexpr(Nil))]))));
    test 33 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Vector [Symbol "a" ; Pair(Symbol "unquote", Pair(Symbol "b", Nil)) ; Symbol "c" ; Pair(Symbol "unquote", Pair(Symbol "d", Nil))], Nil)))) (execute_expected(Applic(Var("vector"),([Const(Sexpr(Symbol("a"))); Var("b"); Const(Sexpr(Symbol("c"))); Var("d")])))));
    
    test 34 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair( Number (Int 5), Symbol("f"))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 35 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Nil))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 36 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", String("problem"))))  (execute_expected(Var("test failed with X_syntax_error"))));
    test 37 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Symbol "a", Pair(Symbol "b", Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    
    test 40 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "quote", Pair(Pair(Symbol "unquote", Pair(Number (Int 5), Nil)), Nil)), Nil)))) (execute_expected(Applic(Var "cons",[Const(Sexpr(Symbol "quote")); Applic(Var "cons",[Const(Sexpr(Number(Int(5)))); Const(Sexpr(Nil))]) ]))));
    test 41 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "quote", Pair(Pair(Symbol "unquote", Pair(Pair(Symbol "quote", Pair(Number (Int 5), Nil)), Nil)), Nil)), Nil)))) (execute_expected(Applic(Var "cons",[Const(Sexpr(Symbol "quote")) ; Applic(Var "cons", [Const(Sexpr(Number (Int 5))); Const(Sexpr(Nil))])]))));
    test 42 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "quote", Pair(Pair(Symbol "unquote-splicing", Pair(Pair(Symbol "quote", Pair(Number (Int 5), Nil)), Nil)), Nil)), Nil)))) (execute_expected(Applic(Var "cons",[Const(Sexpr(Symbol "quote")) ; Applic(Var "append", [Const(Sexpr(Number (Int 5))); Const(Sexpr(Nil))])]))));
    test 43 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "quote", Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Pair(Number (Int 5), Nil), Nil)), Nil), Nil)), Nil)))) (execute_expected(Applic(Var "cons",[Const(Sexpr(Symbol "quote")); Applic(Var "cons",[Applic(Var "append",[Applic(Const(Sexpr(Number(Int 5))),[]); Const(Sexpr(Nil))]); Const(Sexpr(Nil))])]))));

    test 44 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "unquote", Pair(Symbol "a", Nil)), Nil), Nil), Nil), Nil), Nil), Nil), Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Pair(Pair(Pair(Symbol "b", Nil), Nil), Nil), Nil)), Nil), Nil), Nil), Nil), Nil), Nil), Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Var("a");Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("append"),[ Applic(Applic(Applic(Var("b"),[  ]),[  ]),[  ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]);Const(Sexpr(Nil)) ]) ]))));
    test 45 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "unquote", Pair(Symbol "a", Nil)), Nil), Nil), Nil), Nil), Nil), Nil), Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Pair(Pair(Pair(Symbol "b", Nil), Nil), Nil), Nil)), Nil), Nil), Nil), Nil), Nil), Nil), Pair(Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Pair(Pair(Pair(String "hello", Pair(Number (Int 5), Pair(Pair(Symbol "quote", Pair(Symbol "g", Nil)), Nil))), Nil), Nil), Nil)), Nil), Nil), Nil))), Nil)))) (execute_expected(Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Var("a"); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("append"),[ Applic(Applic(Applic(Var("b"),[  ]),[  ]),[  ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("append"),[ Applic(Applic(Applic(Const(Sexpr(String("hello"))),[Const(Sexpr(Number(Int(5)))); Const(Sexpr(Symbol("g"))) ]),[  ]),[  ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]) ]) ]))));
    test 46 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Symbol "quote", Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "quote", Pair(Pair(Pair(Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Pair(Number (Int 5), Nil), Nil)), Nil), Nil), Nil), Nil), Nil)), Nil), Nil), Nil), Nil), Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "unquote", Pair(Pair(Symbol "quote", Pair(Pair(Pair(Pair(String "hello", Nil), Nil), Nil), Nil)), Nil)), Nil), Nil), Nil), Nil), Nil), Nil), Nil), Nil)), Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[ Const(Sexpr(Symbol("quote"))); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Const(Sexpr(Symbol("quote"))); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("append"),[ Applic(Const(Sexpr(Number(Int(5)))),[  ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Const(Sexpr(Pair(Pair(Pair(String("hello"),Nil),Nil),Nil))); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]) ]); Const(Sexpr(Nil)) ]) ]))));
    test 47 (expr_eq (execute_tag_parse_expression (Pair(Symbol "quasiquote", Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "quote", Pair(Pair(Pair(Pair(Pair(Pair(Symbol "unquote-splicing", Pair(Pair(Number (Int 5), Nil), Nil)), Nil), Nil), Nil), Nil), Nil)), Nil), Nil), Nil), Nil), Pair(Pair(Pair(Pair(Pair(Pair(Pair(Symbol "quote", Pair(Pair(Pair(Pair(Symbol "unquote", Pair(Pair(Pair(Pair(String "hello", Nil), Nil), Nil), Nil)), Nil), Nil), Nil)), Nil), Nil), Nil), Nil), Nil), Nil)), Nil)))) (execute_expected(Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Const(Sexpr(Symbol("quote"))); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("append"),[ Applic(Const(Sexpr(Number(Int(5)))),[  ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Const(Sexpr(Symbol("quote"))); Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Var("cons"),[ Applic(Applic(Applic(Const(Sexpr(String("hello"))),[  ]),[  ]),[  ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]); Const(Sexpr(Nil)) ]) ]))));
     *);;

let test_Cond_Macro_Expansion = fun () ->
    current_test := "test_Cond_Macro_Expansion";

    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Nil)))) (execute_expected(If(Var("f"),Var("g"),Const(Void)))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil)))) (execute_expected(If(Var("f"),Seq([Var("g");Var("hh")]),Const(Void)))));

    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))) (execute_expected(Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])))); 
    
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "else", Pair(Symbol "g", Nil)), Nil)))) (execute_expected(Var("g"))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil)))) (execute_expected(Seq([Var("g"); Var("hh")]))));



    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil))))) (execute_expected(If(Var("f"),Var("g"),    Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])))));
    test 7 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil))))) (execute_expected(If(Var("f"),Seq([Var("g"); Var("hh")]),    Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])))));


    test 10 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil))))) (execute_expected(If(Var("f"),Var("g"),Seq([Var("g"); Var("hh")])))));
    test 11 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil))))) (execute_expected(If(Var("f"),Seq([Var("g"); Var("hh")]),Seq([Var("g"); Var("hh")])))));




    test 12 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Nil))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),Var("g"),Const(Void)))]))));
    test 13 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),Seq([Var("g"); Var("hh")]),Const(Void)))]))));
    
    test 14 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "else", Pair(Symbol "g", Nil)), Nil))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],Var("g"))]))));
    test 15 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],Seq([Var("g"); Var("hh")]))]))));
    

  
    test 16 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));

    test 17 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "else", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))))(execute_expected(Var("test failed with X_syntax_error"))));
    test 18 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    


  
    test 19 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Nil)))))) (execute_expected(If(Var("f"),Var("g"),    Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),Var("g"),Const(Void)))])))));
    test 20 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil)))))) (execute_expected(If(Var("f"),Seq([Var("g"); Var("hh")]),    Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),Seq([Var("g"); Var("hh")]),Const(Void)))])))));


    test 21 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),Var("g"),Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])))]))));
    test 22 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),Seq([Var("g"); Var("hh")]),Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])))]))));
    



    test 23 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 24 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))))) (execute_expected(Var("test failed with X_syntax_error"))));


    test 25 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "else", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Pair(Pair(Symbol "f", Pair(Symbol "g", Pair(Symbol "hh", Nil))), Nil)))))) (execute_expected(Var("test failed with X_syntax_error"))));
    
    
    test 26 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Nil)))) (execute_expected(If(Var("f"),LambdaOpt([],"s",Var("x")),Const(Void)))));
    test 27 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil))))) (execute_expected(If(Var("f"),LambdaOpt([],"s",Var("x")),Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])))));
    test 28 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Pair(Pair(Symbol "else", Pair(Symbol "g", Nil)), Nil))))) (execute_expected(If(Var("f"),LambdaOpt([],"s",Var("x")),Var("g")))));
    test 29 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Nil))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),LambdaOpt([],"s",Var("x")),Const(Void)))]))));
    test 30 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "else", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Nil))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 31 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Nil)))))) (execute_expected(If(Var("f"),LambdaOpt([],"s",Var("x")),Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),LambdaOpt([],"s",Var("x")),Const(Void)))])))));
    test 32 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))))) (execute_expected(Applic(LambdaSimple(["value"; "f"; "rest"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Applic(Var("rest"),[]))),[Var("f");LambdaSimple([],Var("g")); LambdaSimple([],If(Var("f"),LambdaOpt([],"s",Var("x")),Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])))]))));                          
    test 33 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Pair(Pair(Symbol "else", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil)))))) (execute_expected(Var("test failed with X_syntax_error"))));
    test 34 (expr_eq (execute_tag_parse_expression (Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Pair(Pair(Symbol "else", Pair(Symbol "g", Nil)), Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Symbol "s", Pair(Symbol "x", Nil))),Nil)), Nil)))))) (execute_expected(Var("test failed with X_syntax_error"))));
 *)
    ;;
    
let test_Let_Macro_Expansion = fun () ->
    current_test := "test_Let_Macro_Expansion";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let", Pair(Nil, Pair(Symbol "g", Nil))))) (execute_expected(Applic(LambdaSimple([],Var("g")),[]))));
    (* test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let", Pair(Nil, Pair(Symbol "g", Pair(Symbol "f", Nil)))))) (execute_expected(Applic(LambdaSimple([],Seq([Var("g"); Var("f")])),[]))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Nil)))))) (execute_expected(Applic(LambdaSimple(["s"],Seq([Var("g"); Var("f")])),[Const(Sexpr(Number(Int(4))))]))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"],Seq([Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Number(Int(4))))]))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Pair(Pair(Symbol "y", Pair(String "s", Nil)), Nil)), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"; "y"],Seq([Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Number(Int(4)))); Const(Sexpr(String("s")))]))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Pair(Pair(Symbol "y", Pair(String "s", Nil)), Pair(Pair(Symbol "r", Pair(Char 'g', Nil)), Nil))), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"; "y"; "r"],Seq([Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Number(Int(4)))); Const(Sexpr(String("s"))); Const(Sexpr(Char('g')))]))));
    *) ;;

let test_Let_Star_Macro_Expansion = fun () ->
    current_test := "test_Let_Star_Macro_Expansion";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let*", Pair(Nil, Pair(Symbol "g", Nil))))) (execute_expected(Applic(LambdaSimple([],Var("g")),[]))));
(*test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let*", Pair(Nil, Pair(Symbol "g", Pair(Symbol "f", Nil)))))) (execute_expected(Applic(LambdaSimple([],Seq([Var("g"); Var("f")])),[])))); 
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let*", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Nil)))))) (execute_expected(Applic(LambdaSimple(["s"],Seq([Var("g"); Var("f")])),[Const(Sexpr(Number(Int(4))))])))); 
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let*", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"],Seq([Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Number(Int(4))))])))); 
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let*", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Pair(Pair(Symbol "y", Pair(String "s", Nil)), Nil)), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"],Applic(LambdaSimple(["y"],Seq([Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(String("s")))])),[Const(Sexpr(Number(Int(4))))]))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "let*", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Pair(Pair(Symbol "y", Pair(String "s", Nil)), Pair(Pair(Symbol "r", Pair(Char 'g', Nil)), Nil))), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"],Applic(LambdaSimple(["y"], Applic(LambdaSimple(["r"],Seq([Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Char('g')))])),[Const(Sexpr(String("s")))])),[Const(Sexpr(Number(Int(4))))]))));
    *);;

let test_Let_Rec_Macro_Expansion = fun () ->
    current_test := "test_Let_Rec_Macro_Expansion";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "letrec", Pair(Nil, Pair(Symbol "g", Nil))))) (execute_expected(Applic(LambdaSimple([],Var("g")),[]))));
    (*test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "letrec", Pair(Nil, Pair(Symbol "g", Pair(Symbol "f", Nil)))))) (execute_expected(Applic(LambdaSimple([],Seq([Var("g"); Var("f")])),[])))); 
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "letrec", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Nil)))))) (execute_expected(Applic(LambdaSimple(["s"],Seq([Set(Var("s"), Const(Sexpr(Number(Int(4))))); Var("g"); Var("f")])),[Const(Sexpr(Symbol "whatever"))]))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "letrec", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"],Seq([Set(Var("s"), Const(Sexpr(Number(Int(4))))); Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Symbol "whatever"))]))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "letrec", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Pair(Pair(Symbol "y", Pair(String "s", Nil)), Nil)), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"; "y"],Seq([Set(Var("s"), Const(Sexpr(Number(Int(4))))); Set(Var("y"), Const(Sexpr(String("s")))); Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Symbol "whatever")); Const(Sexpr(Symbol "whatever"))]))));
    test 6 (expr_eq (execute_tag_parse_expression (Pair(Symbol "letrec", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Pair(Pair(Symbol "y", Pair(String "s", Nil)), Pair(Pair(Symbol "r", Pair(Char 'g', Nil)), Nil))), Pair(Symbol "g", Pair(Symbol "f", Pair(Number (Int 3), Nil))))))) (execute_expected(Applic(LambdaSimple(["s"; "y"; "r"],Seq([Set(Var("s"), Const(Sexpr(Number(Int(4))))); Set(Var("y"), Const(Sexpr(String("s")))); Set(Var("r"), Const(Sexpr(Char('g')))); Var("g"); Var("f"); Const(Sexpr(Number (Int 3)))])),[Const(Sexpr(Symbol "whatever")); Const(Sexpr(Symbol "whatever")); Const(Sexpr(Symbol "whatever"))]))));
    *);;

let test_And_Macro_Expansion = fun () ->
    current_test := "test_And_Macro_Expansion";
    test 1 (expr_eq (execute_tag_parse_expression (Pair(Symbol "and", Nil))) (execute_expected(Const(Sexpr(Bool(true))))));
    (*test 2 (expr_eq (execute_tag_parse_expression (Pair(Symbol "and", Pair(Symbol "g", Nil)))) (execute_expected(Var("g"))));
    test 3 (expr_eq (execute_tag_parse_expression (Pair(Symbol "and", Pair(String "hello", Pair(Symbol "v", Nil))))) (execute_expected(If(Const(Sexpr(String("hello"))),Var("v"),Const(Sexpr(Bool(false)))))));
    test 4 (expr_eq (execute_tag_parse_expression (Pair(Symbol "and", Pair(String "hello", Pair(Symbol "v", Pair(Char('\n') , Nil)))))) (execute_expected(If(Const(Sexpr(String("hello"))),If(Var("v"),Const(Sexpr(Char('\n'))), Const(Sexpr(Bool(false)))),Const(Sexpr(Bool(false)))))));
    test 5 (expr_eq (execute_tag_parse_expression (Pair(Symbol "and", Pair(String "hello", Pair(Symbol "v", Pair(Char('\n') , Pair(Pair(Symbol "if", Pair(Number(Int 5), Pair(Number(Int 4), Pair(Number(Int 3), Nil)))),Nil))))))) (execute_expected(If(Const(Sexpr(String("hello"))),If(Var("v"),If(Const(Sexpr(Char('\n'))),If(Const(Sexpr(Number(Int 5))),Const(Sexpr(Number(Int 4))),Const(Sexpr(Number(Int 3)))) , Const(Sexpr(Bool(false)))), Const(Sexpr(Bool(false)))), Const(Sexpr(Bool(false)))))));
    *);;

let test_Tag_Parse_Expressions = fun () ->
    current_test := "test_Tag_Parse_Expressions";
    test 1 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([])) (execute_expected_as_list([])));
    (*test 2 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair(Symbol "and", Pair(String "hello", Pair(Symbol "v", Nil)))])) (execute_expected_as_list([If(Const(Sexpr(String("hello"))),Var("v"),Const(Sexpr(Bool(false))))])));
    test 3 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair(Symbol "and", Pair(String "hello", Pair(Symbol "v", Nil))); Pair(Symbol "letrec", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Nil))))])) (execute_expected_as_list([If(Const(Sexpr(String("hello"))),Var("v"),Const(Sexpr(Bool(false)))); Applic(LambdaSimple(["s"],Seq([Set(Var("s"), Const(Sexpr(Number(Int(4))))); Var("g"); Var("f")])),[Const(Sexpr(Symbol "whatever"))])])));
    test 4 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair(Symbol "and", Pair(String "hello", Pair(Symbol "v", Nil))); Pair(Symbol "letrec", Pair(Pair(Pair(Symbol "s", Pair(Number (Int 4), Nil)), Nil), Pair(Symbol "g", Pair(Symbol "f", Nil)))); Pair(Symbol "cond", Pair(Pair(Symbol "f", Pair(Symbol "=>", Pair(Symbol "g", Nil))), Nil))])) (execute_expected_as_list([If(Const(Sexpr(String("hello"))),Var("v"),Const(Sexpr(Bool(false)))); Applic(LambdaSimple(["s"],Seq([Set(Var("s"), Const(Sexpr(Number(Int(4))))); Var("g"); Var("f")])),[Const(Sexpr(Symbol "whatever"))]); Applic(LambdaSimple(["value"; "f"],If(Var("value"),Applic(Applic(Var("f"),[]),[Var("value")]),Const(Void))),[Var("f");LambdaSimple([],Var("g"))])])));
    *);;   

let test_CS_DEPARTMENT = fun () ->
    current_test := "test_Tag_Parse_Expressions";
    test 1 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Number (Int (1))])) (execute_expected_as_list([Const (Sexpr (Number (Int (1))))])));
    (*test 2 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "quote", Pair (Nil, Nil))])) (execute_expected_as_list([Const (Sexpr (Nil))])));
    test 3 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "quote", Pair (Pair (String "strin", Pair (Char 'g', Nil)), Nil))])) (execute_expected_as_list([Const (Sexpr (Pair (String "strin", Pair (Char 'g', Nil))))])));
    test 4 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Symbol "1x"])) (execute_expected_as_list([Var "1x"])));
    test 5 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "and", Pair (Pair (Symbol "quote", Pair (Vector [Bool false;Symbol "x"], Nil)), Pair (Pair (Symbol "quote", Pair (Vector [Bool true;Symbol "x"], Nil)), Nil)))])) (execute_expected_as_list([If (Const (Sexpr (Vector ([Bool false;Symbol "x"]))), Const (Sexpr (Vector ([Bool true;Symbol "x"]))), Const (Sexpr (Bool false)))])));
    test 6 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "lambda", Pair (Nil, Pair (Pair (Symbol "quote", Pair (Pair (Number (Int (1)), Pair (Number (Int (2)), Nil)), Nil)), Pair (Number (Int (2)), Nil))))])) (execute_expected_as_list([LambdaSimple ([], Seq ([Const (Sexpr (Pair (Number (Int (1)), Pair (Number (Int (2)), Nil))));Const (Sexpr (Number (Int (2))))]))])));
    test 7 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "define", Pair (Symbol "x", Pair (Number (Int (1)), Nil)))])) (execute_expected_as_list([Def (Var "x", Const (Sexpr (Number (Int (1)))))])));
    test 8 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "define", Pair (Symbol "123x", Pair (Number (Int (123)), Nil)))])) (execute_expected_as_list([Def (Var "123x", Const (Sexpr (Number (Int (123)))))])));
    test 9 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), Pair (Pair (Symbol "if", Pair (Symbol "x", Pair (Symbol "x", Pair (Bool false, Nil)))), Nil)))])) (execute_expected_as_list([LambdaSimple (["x"], If (Var "x", Var "x", Const (Sexpr (Bool false))))])));
    test 10 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "let", Pair (Pair (Pair (Symbol "x", Pair (Pair (Symbol "if", Pair (Symbol "x", Pair (Symbol "x", Nil))), Nil)), Pair (Pair (Symbol "y", Pair (Pair (Symbol "void", Nil), Nil)), Nil)), Pair (Pair (Symbol "eq?", Pair (Symbol "x", Pair (Symbol "y", Nil))), Nil)))])) (execute_expected_as_list([Applic (LambdaSimple (["x";"y"], Applic (Var "eq?", [Var "x";Var "y"])), [If (Var "x", Var "x", Const (Void));Applic (Var "void", [])])])));
    test 11 (expr_eq_as_list (execute_tag_parse_expressions_as_list (([Pair(Symbol "let", Pair(Nil, Pair(Pair(Symbol "letrec", Pair(Pair(Pair(Symbol "loop", Pair(Pair(Symbol "lambda", Pair(Pair(Symbol "x", Nil), Pair(Pair(Symbol "if", Pair(Pair(Symbol "null?", Pair(Symbol "x", Nil)), Pair(Pair(Symbol "quote", Pair(Symbol "done", Nil)), Pair(Pair(Symbol "loop", Pair(Pair(Symbol "cdr", Pair(Symbol "x", Nil)), Nil)), Nil)))), Nil))), Nil)), Nil), Pair(Pair(Symbol "loop", Pair(Pair(Symbol "quasiquote", Pair(Pair(Pair(Symbol "unquote", Pair(Symbol "a", Nil)), Pair(Pair(Symbol "unquote", Pair(Symbol "b", Nil)), Pair(Pair(Symbol "unquote", Pair(Symbol "c", Nil)), Nil))), Nil)), Nil)), Nil))), Nil)))]))) (execute_expected_as_list([Applic (LambdaSimple ([], Applic (LambdaSimple (["loop"], Seq ([Set (Var "loop", LambdaSimple (["x"], If (Applic (Var "null?", [Var "x"]), Const (Sexpr (Symbol "done")), Applic (Var "loop", [Applic (Var "cdr", [Var "x"])]))));Applic (Var "loop", [Applic (Var "cons", [Var "a";Applic (Var "cons", [Var "b";Applic (Var "cons", [Var "c";Const (Sexpr (Nil))])])])])])), [Const (Sexpr (Symbol "whatever"))])), [])])));
    test 12 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Pair (Symbol "or", Pair (Pair (Symbol "and", Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Symbol "<test>", Nil))), Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Symbol "<then>", Nil))), Nil))), Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Symbol "<else>", Nil))), Nil))), Nil)])) (execute_expected_as_list([Applic (Or ([If (LambdaSimple ([], Var "<test>"), LambdaSimple ([], Var "<then>"), Const (Sexpr (Bool false)));LambdaSimple ([], Var "<else>")]), [])])));
    test 13 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "let*", Pair (Pair (Pair (Symbol "x", Pair (Pair (Symbol "quasiquote", Pair (Pair (Symbol "a", Pair (Symbol "=", Pair (Pair (Symbol "unquote-splicing", Pair (Symbol "a", Nil)), Nil))), Nil)), Nil)), Pair (Pair (Symbol "y", Pair (Pair (Symbol "car", Pair (Symbol "x", Nil)), Nil)), Nil)), Pair (Pair (Symbol "quasiquote", Pair (Pair (Symbol "y", Pair (Pair (Symbol "unquote", Pair (Pair (Symbol "cdr", Pair (Symbol "x", Nil)), Nil)), Nil)), Nil)), Nil)))])) (execute_expected_as_list([Applic (LambdaSimple (["x"], Applic (LambdaSimple (["y"], Applic (Var "cons", [Const (Sexpr (Symbol "y"));Applic (Var "cons", [Applic (Var "cdr", [Var "x"]);Const (Sexpr (Nil))])])), [Applic (Var "car", [Var "x"])])), [Applic (Var "cons", [Const (Sexpr (Symbol "a"));Applic (Var "cons", [Const (Sexpr (Symbol "="));Applic (Var "append", [Var "a";Const (Sexpr (Nil))])])])])])));
    test 14 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), Pair (Pair (Symbol "let", Pair (Nil, Pair (Pair (Symbol "set!", Pair (Symbol "x", Pair (Symbol "y", Nil))), Nil))), Nil)))])) (execute_expected_as_list([LambdaSimple (["x"], Applic (LambdaSimple ([], Set (Var "x", Var "y")), []))])));
    test 15 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "define", Pair (Pair (Symbol "x", Pair (Symbol "y", Symbol "z")), Pair (Pair (Symbol "eq?", Pair (String "y", Pair (Symbol "y", Nil))), Nil)))])) (execute_expected_as_list([Def (Var "x", LambdaOpt (["y"], "z", Applic (Var "eq?", [Const (Sexpr (String "y"));Var "y"])))])));
    test 16 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "define", Pair (Pair (Symbol "x", Symbol "z"), Pair (Pair (Symbol "eq?", Pair (Char 'y', Pair (Pair (Symbol "car", Pair (Symbol "z", Nil)), Nil))), Nil)))])) (execute_expected_as_list([Def (Var "x", LambdaOpt ([], "z", Applic (Var "eq?", [Const (Sexpr (Char 'y'));Applic (Var "car", [Var "z"])])))])));
    test 17 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "define", Pair (Pair (Symbol "x", Symbol "y"), Pair (Pair (Symbol "eq?", Pair (Pair (Symbol "quote", Pair (Nil, Nil)), Pair (Symbol "y", Nil))), Nil)))])) (execute_expected_as_list([Def (Var "x", LambdaOpt ([], "y", Applic (Var "eq?", [Const (Sexpr (Nil));Var "y"])))])));
    test 18 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "letrec", Pair (Pair (Pair (Symbol "loop", Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), Pair (Pair (Symbol "if", Pair (Symbol "x", Pair (Pair (Symbol "set!", Pair (Symbol "y", Pair (Bool true, Nil))), Pair (Pair (Symbol "loop", Pair (Symbol "y", Nil)), Nil)))), Nil))), Nil)), Nil), Pair (Pair (Symbol "loop", Pair (Symbol "x", Nil)), Nil)))])) (execute_expected_as_list([Applic (LambdaSimple (["loop"], Seq ([Set (Var "loop", LambdaSimple (["x"], If (Var "x", Set (Var "y", Const (Sexpr (Bool true))), Applic (Var "loop", [Var "y"]))));Applic (Var "loop", [Var "x"])])), [Const (Sexpr (Symbol "whatever"))])])));
    test 19 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "cond", Pair (Pair (Bool true, Pair (Number (Int (1)), Pair (Number (Int (2)), Pair (Number (Int (3)), Nil)))), Nil))])) (execute_expected_as_list([If (Const (Sexpr (Bool true)), Seq ([Const (Sexpr (Number (Int (1))));Const (Sexpr (Number (Int (2))));Const (Sexpr (Number (Int (3))))]), Const (Void))])));
    test 20 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "let*", Pair (Pair (Pair (Symbol "x", Pair (Number (Int (1)), Nil)), Pair (Pair (Symbol "y", Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Symbol "x", Nil))), Nil)), Nil)), Pair (Symbol "x", Pair (Pair (Symbol "y", Nil), Nil))))])) (execute_expected_as_list([Applic (LambdaSimple (["x"], Applic (LambdaSimple (["y"], Seq [Var "x"; Applic (Var "y", [])]), [LambdaSimple ([], Var "x")])), [Const (Sexpr (Number (Int (1))))])])));
    test 21 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "if", Pair (Pair (Symbol "if", Pair (Symbol "a", Pair (Symbol "b", Pair (Char 'c', Nil)))), Pair (Pair (Symbol "quote", Pair (Symbol "x", Nil)), Pair (Pair (Symbol "quote", Pair (Pair (Symbol "+", Pair (Symbol "y", Pair (Symbol "z", Nil))), Nil)), Nil))))])) (execute_expected_as_list([If (If (Var "a", Var "b", Const (Sexpr (Char 'c'))), Const (Sexpr (Symbol "x")), Const (Sexpr (Pair (Symbol "+", Pair (Symbol "y", Pair (Symbol "z", Nil))))))])));
    test 22 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "or", Pair (Pair (Symbol "zero?", Pair (Symbol "x", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "y", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "z", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "w", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "v", Nil)), Nil))))))])) (execute_expected_as_list([Or ([Applic (Var "zero?", [Var "x"]);Applic (Var "zero?", [Var "y"]);Applic (Var "zero?", [Var "z"]);Applic (Var "zero?", [Var "w"]);Applic (Var "zero?", [Var "v"])])])));
    test 23 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "and", Pair (Pair (Symbol "zero?", Pair (Symbol "x", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "y", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "z", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "w", Nil)), Pair (Pair (Symbol "zero?", Pair (Symbol "v", Nil)), Nil))))))])) (execute_expected_as_list([If (Applic (Var "zero?", [Var "x"]), If (Applic (Var "zero?", [Var "y"]), If (Applic (Var "zero?", [Var "z"]), If (Applic (Var "zero?", [Var "w"]), Applic (Var "zero?", [Var "v"]), Const (Sexpr (Bool false))), Const (Sexpr (Bool false))), Const (Sexpr (Bool false))), Const (Sexpr (Bool false)))])));
    test 24 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "if", Pair (Pair (Symbol "begin", Pair (Number (Int (1)), Pair (Number (Int (2)), Pair (Number (Int (3)), Pair (Bool false, Nil))))), Pair (Number (Int (1)), Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Pair (Symbol "begin", Nil), Pair (Number (Int (1)), Pair (Number (Int (2)), Pair (Number (Int (3)), Pair (Bool false, Nil))))))), Nil))))])) (execute_expected_as_list([If (Seq ([Const (Sexpr (Number (Int (1))));Const (Sexpr (Number (Int (2))));Const (Sexpr (Number (Int (3))));Const (Sexpr (Bool false))]), Const (Sexpr (Number (Int (1)))), LambdaSimple ([], Seq ([Const (Void);Const (Sexpr (Number (Int (1))));Const (Sexpr (Number (Int (2))));Const (Sexpr (Number (Int (3))));Const (Sexpr (Bool false))])))])));
    test 25 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "list", Pair (Pair (Symbol "vector", Pair (Pair (Symbol "eq?", Pair (Number (Int (1)), Pair (Pair (Symbol "+", Pair (Number (Int (1)), Nil)), Nil))), Nil)), Pair (Pair (Symbol "quote", Pair (Vector [Bool true], Nil)), Nil)))])) (execute_expected_as_list([Applic (Var "list", [Applic (Var "vector", [Applic (Var "eq?", [Const (Sexpr (Number (Int (1))));Applic (Var "+", [Const (Sexpr (Number (Int (1))))])])]);Const (Sexpr (Vector ([Bool true])))])])));
    test 26 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "define", Pair (Pair (Symbol "foo", Pair (Symbol "x", Pair (Symbol "y", Nil))), Pair (Pair (Symbol "lambda", Pair (Symbol "y", Pair (Symbol "y", Pair (Symbol "y", Nil)))), Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "z", Symbol "w"), Pair (Symbol "z", Pair (Symbol "w", Nil)))), Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "z", Nil), Pair (Pair (Symbol "lambda", Pair (Symbol "w", Pair (Symbol "w", Nil))), Nil))), Nil)))))])) (execute_expected_as_list([Def (Var "foo", LambdaSimple (["x";"y"], Seq ([LambdaOpt ([], "y", Seq ([Var "y";Var "y"]));LambdaOpt (["z"], "w", Seq ([Var "z";Var "w"]));LambdaSimple (["z"], LambdaOpt ([], "w", Var "w"))])))])));
    test 27 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "quasiquote", Pair (Pair (Pair (Symbol "unquote", Pair (Symbol "a", Nil)), Pair (Symbol "b", Pair (Pair (Symbol "unquote-splicing", Pair (Symbol "c", Nil)), Nil))), Nil))])) (execute_expected_as_list([Applic (Var "cons", [Var "a";Applic (Var "cons", [Const (Sexpr (Symbol "b"));Applic (Var "append", [Var "c";Const (Sexpr (Nil))])])])])));
    test 28 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Pair (Symbol "quasiquote", Pair (Pair (Pair (Symbol "unquote-splicing", Pair (Symbol "x", Nil)), Pair (Pair (Symbol "unquote", Pair (Pair (Symbol "set!", Pair (Symbol "y", Pair (Pair (Symbol "car", Pair (Symbol "x", Nil)), Nil))), Nil)), Nil)), Nil)), Nil)])) (execute_expected_as_list([Applic (Applic (Var "append", [Var "x";Applic (Var "cons", [Set (Var "y", Applic (Var "car", [Var "x"]));Const (Sexpr (Nil))])]), [])])));
    test 29 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "let", Pair (Pair (Pair (Symbol "x", Pair (Pair (Symbol "let", Pair (Pair (Pair (Symbol "x", Pair (Number (Int (1)), Nil)), Nil), Pair (Pair (Symbol "let", Pair (Pair (Pair (Symbol "x", Pair (Number (Int (2)), Nil)), Nil), Pair (Symbol "x", Nil))), Nil))), Nil)), Nil), Pair (Pair (Symbol "set!", Pair (Symbol "x", Pair (Pair (Symbol "quote", Pair (Symbol "let", Nil)), Nil))), Nil)))])) (execute_expected_as_list([Applic (LambdaSimple (["x"], Set (Var "x", Const (Sexpr (Symbol "let")))), [Applic (LambdaSimple (["x"], Applic (LambdaSimple (["x"], Var "x"), [Const (Sexpr (Number (Int (2))))])), [Const (Sexpr (Number (Int (1))))])])])));
    test 30 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "cond", Pair (Pair (Symbol "x", Pair (Pair (Symbol "begin", Pair (Symbol "x", Nil)), Nil)), Pair (Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), Pair (Symbol "x", Nil))), Pair (Symbol "=>", Pair (Pair (Symbol "cond", Pair (Pair (Symbol "else", Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), Pair (Pair (Symbol "x", Nil), Nil))), Nil)), Nil)), Nil))), Pair (Pair (Symbol "else", Pair (Symbol "value", Nil)), Nil))))])) (execute_expected_as_list([If (Var "x", Var "x", Applic (LambdaSimple (["value";"f";"rest"], If (Var "value", Applic (Applic (Var "f", []), [Var "value"]), Applic (Var "rest", []))), [LambdaSimple (["x"], Var "x");LambdaSimple ([], LambdaSimple (["x"], Applic (Var "x", [])));LambdaSimple ([], Var "value")]))])));
    test 31 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "or", Pair (Pair (Symbol "begin", Nil), Pair (Pair (Symbol "and", Nil), Nil)))])) (execute_expected_as_list([Or ([Const (Void);Const (Sexpr (Bool true))])])));
    test 32 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "+", Pair (Pair (Symbol "and", Pair (Number (Int (1)), Nil)), Pair (Pair (Symbol "or", Pair (Number (Int (2)), Nil)), Nil)))])) (execute_expected_as_list([Applic (Var "+", [Const (Sexpr (Number (Int (1))));Const (Sexpr (Number (Int (2))))])])));
    test 33 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "quote", Pair (Pair (Symbol "cond", Pair (Pair (Symbol "let", Nil), Pair (Pair (Symbol "or", Pair (Symbol "and", Nil)), Nil))), Nil))])) (execute_expected_as_list([Const (Sexpr (Pair (Symbol "cond", Pair (Pair (Symbol "let", Nil), Pair (Pair (Symbol "or", Pair (Symbol "and", Nil)), Nil)))))])));
    test 34 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "begin", Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Pair (Symbol "begin", Pair (Pair (Symbol "quote", Pair (Symbol "a", Nil)), Pair (Pair (Symbol "quote", Pair (Symbol "b", Nil)), Nil))), Pair (Pair (Symbol "quote", Pair (Symbol "c", Nil)), Nil)))), Pair (Pair (Symbol "begin", Pair (Pair (Symbol "quote", Pair (Symbol "d", Nil)), Nil)), Nil)))])) (execute_expected_as_list([Seq ([LambdaSimple ([], Seq ([Seq ([Const (Sexpr (Symbol "a"));Const (Sexpr (Symbol "b"))]);Const (Sexpr (Symbol "c"))]));Const (Sexpr (Symbol "d"))])])));
    test 35 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "c", Nil), Pair (Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "a", Nil), Pair (Symbol "a", Pair (Pair (Symbol "quote", Pair (Symbol "b", Nil)), Nil)))), Pair (Symbol "c", Nil)), Nil))), Pair (Pair (Symbol "begin", Pair (Pair (Symbol "quote", Pair (Symbol "d", Nil)), Nil)), Nil))])) (execute_expected_as_list([Applic (LambdaSimple (["c"], Applic (LambdaSimple (["a"], Seq ([Var "a";Const (Sexpr (Symbol "b"))])), [Var "c"])), [Const (Sexpr (Symbol "d"))])])));
    test 36 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Number (Int 1); Number (Int 2); Symbol "x"; Symbol "y"; Symbol "z"])) (execute_expected_as_list([Const (Sexpr (Number (Int (1))));Const (Sexpr (Number (Int (2))));Var "x";Var "y";Var "z"])));
    test 37 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "define",Pair (Pair (Symbol "foo", Pair (Symbol "x", Nil)),Pair (Pair (Symbol "zero?", Pair (Symbol "x", Nil)), Nil)));Pair (Symbol "cond",Pair(Pair (Bool false, Pair (Symbol "=>", Pair (Symbol "foo", Nil))),Nil))])) (execute_expected_as_list([Def (Var "foo", LambdaSimple (["x"], Applic (Var "zero?", [Var "x"])));Applic (LambdaSimple (["value";"f"], If (Var "value", Applic (Applic (Var "f", []), [Var "value"]), Const (Void))), [Const (Sexpr (Bool false));LambdaSimple ([], Var "foo")])])));
    test 38 (expr_eq_as_list (execute_tag_parse_expressions_as_list ([Pair (Symbol "quasiquote",Pair(Pair (Vector [Number (Int 1); Number (Int 2); Number (Int 3)],Pair (Number (Int 4), Pair (Number (Int 5), Nil))),Nil));Pair (Symbol "quote",Pair(Pair (Vector [Number (Int 1); Number (Int 2); Number (Int 3)],Pair (Number (Int 4), Pair (Number (Int 5), Nil))),Nil));Pair (Symbol "quote",Pair (Vector [Symbol "a"; Symbol "b"; Symbol "c"], Nil))])) (execute_expected_as_list([Applic (Var "cons", [Applic (Var "vector", [Const (Sexpr (Number (Int (1))));Const (Sexpr (Number (Int (2))));Const (Sexpr (Number (Int (3))))]);Applic (Var "cons", [Const (Sexpr (Number (Int (4))));Applic (Var "cons", [Const (Sexpr (Number (Int (5))));Const (Sexpr (Nil))])])]);Const (Sexpr (Pair (Vector ([Number (Int (1));Number (Int (2));Number (Int (3))]), Pair (Number (Int (4)), Pair (Number (Int (5)), Nil)))));Const (Sexpr (Vector ([Symbol "a";Symbol "b";Symbol "c"])))])));
    *);;  
    
 let tests = test_Self_Evaluated :: test_Variable :: test_Conditionals :: test_Lambda_Expressions :: test_Applications :: test_Disjunctions :: test_Definitions :: test_Assignments :: test_Sequences :: test_Quasiquoted_Macro_Expansion :: test_Cond_Macro_Expansion :: test_Let_Macro_Expansion :: test_Let_Star_Macro_Expansion :: test_Let_Rec_Macro_Expansion :: test_And_Macro_Expansion :: test_Tag_Parse_Expressions :: test_CS_DEPARTMENT :: [];;
 
let rec start_tests = fun tests ->
    let print_info = fun exn stackTrace -> 
      Printf.printf "%s%s Failed with %s Exception\nStack Trace As Follows: %sLast got from test: %s\nLast expected from test: %s%s\n" red !current_test (Printexc.to_string exn) stackTrace !got !expected reset in
    match tests with 
    | curr_test :: [] -> (try curr_test () with exn -> print_info exn (Printexc.get_backtrace ()))
    | curr_test :: next_tests -> (try curr_test () with exn -> print_info exn (Printexc.get_backtrace ())); start_tests next_tests
    | _ -> raise (Fatal_error "unexpected problom in start_tests");;

initialize ();;

start_prompt ();;

start_tests tests;;

end_prompt ();;







