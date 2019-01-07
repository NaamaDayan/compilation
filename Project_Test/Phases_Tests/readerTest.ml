(* reader.ml
 * A compiler from Scheme to x86/64
 *
 * Programmer: Yehonatan Peleg And Meytal Rose, 2018
 *)

#use "reader.ml";;

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

let rec sexpr_eq s1 s2 =
  match s1, s2 with
  | Bool(b1), Bool(b2) -> b1 = b2
  | Nil, Nil -> true
  | Number(Float f1), Number(Float f2) -> abs_float(f1 -. f2) < 0.001
  | Number(Int n1), Number(Int n2) -> n1 = n2
  | Char(c1), Char(c2) -> c1 = c2
  | String(s1), String(s2) -> s1 = s2
  | Symbol(s1), Symbol(s2) -> s1 = s2
  | Pair(car1, cdr1), Pair(car2, cdr2) -> (sexpr_eq car1 car2) && (sexpr_eq cdr1 cdr2)
  | Vector(l1), Vector(l2) -> List.for_all2 sexpr_eq l1 l2
  | _ -> false;;

let rec sexpr_eq_as_list sexprList1 sexprList2 = 
   match sexprList1, sexprList2 with
   | [] , [] -> true
   | [] , head2 :: tail2 -> false
   | head1 :: tail1 , [] -> false
   | head1 :: tail1 , head2 :: tail2 -> (sexpr_eq head1 head2) && (sexpr_eq_as_list tail1 tail2)

let prompt = fun title -> Printf.printf "%s*******************************************\n             %s                  \n*******************************************\n%s" mag title mag;;

let start_prompt = fun () -> prompt "Start Of Reader Test"; Printf.printf "\n";;

let end_prompt = fun () -> Printf.printf "\n"; prompt "End Of Reader Test"; Printf.printf "%sGreen: %d%s%s Red: %d%s\n" grn !green_tests reset red !red_tests reset;;

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

let execute_read_sexpr = fun string ->
  let return = try (Reader.read_sexpr string)
               with PC.X_no_match -> failure_info := "with " ^ string ^ " as X_no_match"; String "test failed" in
  (got := print_sexpr return;
  return);;

let execute_expected = fun sexprObj -> 
  expected := print_sexpr sexprObj;
  sexprObj;;

let execute_read_sexprs_as_list = fun string ->
  let return = try (Reader.read_sexprs string)
               with PC.X_no_match -> failure_info := "with " ^ string ^ " as X_no_match"; [String("test failed")] in
  (got := print_sexprs_as_list return;
  return);;

let execute_expected_as_list = fun sexprObj -> 
  expected := print_sexprs_as_list sexprObj;
  sexprObj;;

let test_Boolean_ = fun () ->
    current_test := "test_Boolean_";
    test 1 (sexpr_eq (execute_read_sexpr "#t") (execute_expected(Bool true)));
    test 2 (sexpr_eq (execute_read_sexpr "#f") (execute_expected(Bool false)));
    test 3 (sexpr_eq (execute_read_sexpr " #F") (execute_expected(Bool false)));
    test 4 (sexpr_eq (execute_read_sexpr " #t") (execute_expected(Bool true)));
    test 5 (sexpr_eq (execute_read_sexpr " #T ") (execute_expected(Bool true)));
    test 6 (sexpr_eq (execute_read_sexpr " #f ") (execute_expected(Bool false)));
    ;;

let test_Char_ = fun () ->
    current_test := "test_Char_";
    test 1 (sexpr_eq (execute_read_sexpr "#\\a") (execute_expected(Char 'a')));
    test 2 (sexpr_eq (execute_read_sexpr "#\\g") (execute_expected(Char 'g')));
    test 3 (sexpr_eq (execute_read_sexpr "#\\4") (execute_expected(Char '4')));
    test 4 (sexpr_eq (execute_read_sexpr "#\\#") (execute_expected(Char '#')));
    test 5 (sexpr_eq (execute_read_sexpr "#\\newline") (execute_expected(Char '\n')));
    test 6 (sexpr_eq (execute_read_sexpr "#\\nul") (execute_expected(Char (Char.chr 0))));
    test 7 (sexpr_eq (execute_read_sexpr "#\\return") (execute_expected(Char '\r')));
    test 8 (sexpr_eq (execute_read_sexpr "#\\space") (execute_expected(Char ' ')));
    test 9 (sexpr_eq (execute_read_sexpr "#\\tab") (execute_expected(Char '\t')));
    test 10 (sexpr_eq (execute_read_sexpr "#\\X2B") (execute_expected(Char '+')));
    test 11 (sexpr_eq (execute_read_sexpr "#\\x51") (execute_expected(Char 'Q')));
    test 12 (sexpr_eq (execute_read_sexpr "#\\X20") (execute_expected(Char ' ')));
    test 13 (sexpr_eq (execute_read_sexpr "#\\A") (execute_expected(Char 'A')));
    test 14 (sexpr_eq (execute_read_sexpr "#\\Z") (execute_expected(Char 'Z')));
    test 15 (sexpr_eq (execute_read_sexpr "#\\z") (execute_expected(Char 'z')));
    test 16 (sexpr_eq (execute_read_sexpr "#\\O") (execute_expected(Char 'O')));
    test 17 (sexpr_eq (execute_read_sexpr "#\\X4b") (execute_expected(Char 'K')));
  ;;

let test_Number_ = fun () ->
    current_test := "test_Number_";
    test 1 (sexpr_eq (execute_read_sexpr "4") (execute_expected(Number (Int 4))));
    test 2 (sexpr_eq (execute_read_sexpr "10") (execute_expected(Number (Int 10))));
    test 3 (sexpr_eq (execute_read_sexpr "+10") (execute_expected(Number (Int 10))));
    test 4 (sexpr_eq (execute_read_sexpr "-10") (execute_expected(Number (Int (-10)))));
    test 5 (sexpr_eq (execute_read_sexpr "-34324324324324") (execute_expected(Number (Int (-34324324324324)))));
    test 6 (sexpr_eq (execute_read_sexpr "-10.99") (execute_expected(Number (Float (-10.99)))));
    test 7 (sexpr_eq (execute_read_sexpr "#x-10.99") (execute_expected(Number (Float (-1.0 *. float_of_string "0x10.99")))));
    test 8 (sexpr_eq (execute_read_sexpr "#X10.99") (execute_expected(Number (Float (float_of_string "0x10.99")))));
    test 9 (sexpr_eq (execute_read_sexpr "10.99") (execute_expected(Number (Float (10.99)))));
    test 10 (sexpr_eq (execute_read_sexpr "#XA.A") (execute_expected(Number (Float (10.625)))));
    test 11 (sexpr_eq (execute_read_sexpr "#XAaBdE") (execute_expected(Number (Int (699358)))));
    test 12 (sexpr_eq (execute_read_sexpr "#XAaBdE.adEf") (execute_expected(Number (Float (699358.6794281005859375)))));
    test 13 (sexpr_eq (execute_read_sexpr "-0.4321") (execute_expected(Number (Float (-0.4321)))));
    test 14 (sexpr_eq (execute_read_sexpr "#X-0.AaBdE") (execute_expected(Number (Float (-0.666959762573242188)))));
    test 15 (sexpr_eq (execute_read_sexpr "-0.32123") (execute_expected(Number (Float (-0.32123)))));
    test 16 (sexpr_eq (execute_read_sexpr "-40.32123") (execute_expected(Number (Float (-40.32123)))));
    test 17 (sexpr_eq (execute_read_sexpr "40.32123") (execute_expected(Number (Float (40.32123)))));
    ;;

let test_String_ = fun () ->
    current_test := "test_String_";
    test 1 (sexpr_eq (execute_read_sexpr "\"This is a string\"") (execute_expected(String "This is a string")));
    test 2 (sexpr_eq (execute_read_sexpr "\"This is a string with \\\\ \"") (execute_expected(String "This is a string with \\ ")));
    test 3 (sexpr_eq (execute_read_sexpr "\"This is a string with \\\" \"") ((execute_expected(String "This is a string with \" "))));
    test 4 (sexpr_eq (execute_read_sexpr "\"This is a string with \\t \"") ((execute_expected(String "This is a string with \t "))));
    test 5 (sexpr_eq (execute_read_sexpr "\"This is a string with \\f \"") ((execute_expected(String (Printf.sprintf "This is a string with %c " (Char.chr 12))))));
    test 6 (sexpr_eq (execute_read_sexpr "\"This is a string with \\r \"") ((execute_expected(String "This is a string with \r "))));
    test 7 (sexpr_eq (execute_read_sexpr "\"This is a string with \\n \"") ((execute_expected(String "This is a string with \n "))));
    test 8 (sexpr_eq (execute_read_sexpr "\"This is a string with \\x4A; \"") ((execute_expected(String "This is a string with J "))));
    test 9 (sexpr_eq (execute_read_sexpr "\"This is a string with \\x2e; \"") ((execute_expected(String "This is a string with . "))));
    test 10 (sexpr_eq (execute_read_sexpr "\"This is a string with \\x25; \"") ((execute_expected(String "This is a string with % "))));
    test 10 (sexpr_eq (execute_read_sexpr "\"This is a string with \\x7A; \"") ((execute_expected(String "This is a string with z "))));
    test 11 (sexpr_eq (execute_read_sexpr "\"This is a string with \\X7A; \"") ((execute_expected(String "This is a string with z "))));
    test 12 (sexpr_eq (execute_read_sexpr "\"This is a string with \\X7d; \"") ((execute_expected(String "This is a string with } "))));
    test 13 (sexpr_eq (execute_read_sexpr "\"This is a string with \\X7d;\\X5E;\"") ((execute_expected(String "This is a string with }^"))));
    ;;

(* (0 | · · · | 9) | (a | · · · | z) | (A | · · · | Z) | ! | $
| ^ | * | - | _ | = | + | < | > | ? | / | : *)
let test_Symbol_ = fun () ->
    current_test := "test_Symbol_";
    test 1 (sexpr_eq (execute_read_sexpr "a") (execute_expected(Symbol "a")));
    test 2 (sexpr_eq (execute_read_sexpr "aaaa") (execute_expected(Symbol "aaaa")));
    test 3 (sexpr_eq (execute_read_sexpr "bbbb") (execute_expected(Symbol "bbbb")));
    test 4 (sexpr_eq (execute_read_sexpr "abcdef") (execute_expected(Symbol "abcdef")));
    test 5 (sexpr_eq (execute_read_sexpr "abcdefghijklmnop") (execute_expected(Symbol "abcdefghijklmnop")));
    test 6 (sexpr_eq (execute_read_sexpr "abcdefghijklmnopqrstuvwxyz") (execute_expected(Symbol "abcdefghijklmnopqrstuvwxyz")));
    test 7 (sexpr_eq (execute_read_sexpr "abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Symbol "abcdefghijklmnopqrstuvwxyz0123456789")));
    test 8 (sexpr_eq (execute_read_sexpr "!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Symbol "!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789")));
    test 9 (sexpr_eq (execute_read_sexpr "!$^*-_=+<>?/:ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") (execute_expected(Symbol "!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789")));
    test 10 (sexpr_eq (execute_read_sexpr "ZzZzZzZz0123456789") (execute_expected(Symbol "zzzzzzzz0123456789")));
    test 11 (sexpr_eq (execute_read_sexpr "aBhThKtUlKyGtGBVFN") (execute_expected(Symbol "abhthktulkygtgbvfn")));
    test 12 (sexpr_eq (execute_read_sexpr "!$^*-_=+<>?/:0123456789aBcDeFgHiJK") (execute_expected(Symbol "!$^*-_=+<>?/:0123456789abcdefghijk")));
    ;;

let test_List_ = fun () ->
    current_test := "test_List_";
    test 1 (sexpr_eq (execute_read_sexpr "()") (execute_expected(Nil)));
    test 2 (sexpr_eq (execute_read_sexpr "( #t )") (execute_expected(Pair(Bool(true), Nil))));
    test 3 (sexpr_eq (execute_read_sexpr "( \"this\" )") (execute_expected(Pair(String("this"), Nil))));
    test 4 (sexpr_eq (execute_read_sexpr "( 37392 )") (execute_expected(Pair(Number(Int(37392)), Nil))));
    test 5 (sexpr_eq (execute_read_sexpr "( 37392.39382 )") (execute_expected(Pair(Number(Float(37392.39382)), Nil))));
    test 6 (sexpr_eq (execute_read_sexpr "( #\\c )") (execute_expected(Pair(Char('c'), Nil))));
    test 7 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Nil)))));
    test 8 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 37392 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Nil))))));
    test 9 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 37392 \"this\" )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))))));
    test 10 (sexpr_eq (execute_read_sexpr "(#\\c 37392.39382 37392 \"this\" #t)") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))))));
    test 11 (sexpr_eq (execute_read_sexpr "(#\\c [37392.39382] 37392 \"this\" #t)") (execute_expected(Pair(Char('c'), Pair(Pair(Number(Float(37392.39382)),Nil), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))))));
    test 12 (sexpr_eq (execute_read_sexpr "(#\\c [37392.39382] [37392 \"this\"] #t)") (execute_expected(Pair(Char('c'), Pair(Pair(Number(Float(37392.39382)),Nil), Pair(Pair(Number(Int(37392)), Pair(String("this"),Nil)), Pair(Bool(true), Nil)))))));
    test 13 (sexpr_eq (execute_read_sexpr "(    )") (execute_expected(Nil)));
    ;;

let test_DottedList_ = fun () ->
    current_test := "test_DottedList_";
    test 1 (sexpr_eq (execute_read_sexpr "(#t . #f)") (execute_expected(Pair(Bool(true),Bool(false)))));
    test 2 (sexpr_eq (execute_read_sexpr "(#t . asfsfdsfa)") (execute_expected(Pair(Bool(true),Symbol("asfsfdsfa")))));
    test 3 (sexpr_eq (execute_read_sexpr "(#t . #xA)") (execute_expected(Pair(Bool(true),Number(Int(10))))));
    test 4 (sexpr_eq (execute_read_sexpr "(#t . #xA.A)") (execute_expected(Pair(Bool(true),Number(Float(10.625))))));
    test 5 (sexpr_eq (execute_read_sexpr "( #\\c . 37392.39382 )") (execute_expected(Pair(Char('c'), Number(Float(37392.39382))))));
    test 6 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 . 37392 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Number(Int(37392)))))));
    test 7 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 37392 . \"this\" )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), String("this")))))));
    test 8 (sexpr_eq (execute_read_sexpr "[#\\c (37392.39382) 37392 \"this\" . #t]") (execute_expected(Pair(Char('c'), Pair(Pair(Number(Float(37392.39382)),Nil), Pair(Number(Int(37392)), Pair(String("this"), Bool(true))))))));
    test 9 (sexpr_eq (execute_read_sexpr "( #\\c [37392.39382 . 37392] . \"this\" )") (execute_expected(Pair(Char('c'), Pair(Pair(Number(Float(37392.39382)), Number(Int(37392))), String("this"))))));
    ;;

let test_Vector_ = fun () ->
    current_test := "test_Vector_";
    test 1 (sexpr_eq (execute_read_sexpr "#()") (execute_expected(Vector([]))));
    test 2 (sexpr_eq (execute_read_sexpr "#( #t )") (execute_expected(Vector([Bool(true);]))));
    test 3 (sexpr_eq (execute_read_sexpr "#( \"this\" )") (execute_expected(Vector([String("this");]))));
    test 4 (sexpr_eq (execute_read_sexpr "#( 37392 )") (execute_expected(Vector([Number(Int(37392));]))));
    test 5 (sexpr_eq (execute_read_sexpr "#( 37392.39382 )") (execute_expected(Vector([Number(Float(37392.39382));]))));
    test 6 (sexpr_eq (execute_read_sexpr "#( #\\c )") (execute_expected(Vector([Char('c');]))));
    test 7 (sexpr_eq (execute_read_sexpr "#( #\\c 37392.39382 )") (execute_expected(Vector([Char('c'); Number(Float(37392.39382));]))));
    test 8 (sexpr_eq (execute_read_sexpr "#( #\\c 37392.39382 37392 )") (execute_expected(Vector([Char('c'); Number(Float(37392.39382)); Number(Int(37392));]))));
    test 9 (sexpr_eq (execute_read_sexpr "#( #\\c 37392.39382 37392 \"this\" )") (execute_expected(Vector([Char('c'); Number(Float(37392.39382)); Number(Int(37392)); String("this")]))));
    test 10 (sexpr_eq (execute_read_sexpr "#(#\\c 37392.39382 37392 \"this\" #t)") (execute_expected(Vector([Char('c'); Number(Float(37392.39382)); Number(Int(37392)); String("this"); Bool(true);]))));
    test 11 (sexpr_eq (execute_read_sexpr "#(#\\c [37392.39382] 37392 \"this\" #t)") (execute_expected(Vector([Char('c'); Pair(Number(Float(37392.39382)),Nil); Number(Int(37392)); String("this"); Bool(true);]))));
    test 12 (sexpr_eq (execute_read_sexpr "#(#\\c [37392.39382] [37392 \"this\"] #t)") (execute_expected(Vector([Char('c');Pair(Number(Float(37392.39382)),Nil); Pair(Number(Int(37392)), Pair(String("this"),Nil)); Bool(true);]))));
    test 13 (sexpr_eq (execute_read_sexpr "#(   )") (execute_expected(Vector([]))));
    ;;

let test_Quoted_ = fun () ->
    current_test := "test_Quoted_";
    test 1 (sexpr_eq (execute_read_sexpr "'#t") (execute_expected(Pair(Symbol("quote"),Pair(Bool(true),Nil)))));
    test 2 (sexpr_eq (execute_read_sexpr "'#f") (execute_expected(Pair(Symbol("quote"),Pair(Bool(false),Nil)))));
    test 3 (sexpr_eq (execute_read_sexpr "'#\\a") (execute_expected(Pair(Symbol("quote"),Pair(Char('a'),Nil)))));
    test 4 (sexpr_eq (execute_read_sexpr "'#\\g") (execute_expected(Pair(Symbol("quote"),Pair(Char('g'),Nil)))));
    test 5 (sexpr_eq (execute_read_sexpr "'#\\4") (execute_expected(Pair(Symbol("quote"),Pair(Char('4'),Nil)))));
    test 6 (sexpr_eq (execute_read_sexpr "'#\\#") (execute_expected(Pair(Symbol("quote"),Pair(Char('#'),Nil)))));
    test 7 (sexpr_eq (execute_read_sexpr "'#\\newline") (execute_expected(Pair(Symbol("quote"),Pair(Char('\n'),Nil)))));
    test 8 (sexpr_eq (execute_read_sexpr "'#\\nul") (execute_expected(Pair(Symbol("quote"),Pair(Char(Char.chr 0),Nil)))));
    test 9 (sexpr_eq (execute_read_sexpr "'#\\return") (execute_expected(Pair(Symbol("quote"),Pair(Char('\r'),Nil)))));
    test 10 (sexpr_eq (execute_read_sexpr "'#\\space") (execute_expected(Pair(Symbol("quote"),Pair(Char(' '),Nil)))));
    test 11 (sexpr_eq (execute_read_sexpr "'#\\tab") (execute_expected(Pair(Symbol("quote"),Pair(Char('\t'),Nil)))));
    test 12 (sexpr_eq (execute_read_sexpr "'#\\x2B") (execute_expected(Pair(Symbol("quote"),Pair(Char('+'),Nil)))));
    test 13 (sexpr_eq (execute_read_sexpr "'#\\x51") (execute_expected(Pair(Symbol("quote"),Pair(Char('Q'),Nil)))));
    test 14 (sexpr_eq (execute_read_sexpr "'#\\x20") (execute_expected(Pair(Symbol("quote"),Pair(Char(' '),Nil)))));
    test 15 (sexpr_eq (execute_read_sexpr "'4") (execute_expected(Pair(Symbol("quote"),Pair(Number(Int 4),Nil)))));
    test 16 (sexpr_eq (execute_read_sexpr "'10") (execute_expected(Pair(Symbol("quote"),Pair(Number (Int 10),Nil)))));
    test 17 (sexpr_eq (execute_read_sexpr "'+10") (execute_expected(Pair(Symbol("quote"),Pair(Number (Int 10),Nil)))));
    test 18 (sexpr_eq (execute_read_sexpr "'-10") (execute_expected(Pair(Symbol("quote"),Pair(Number(Int(-10)),Nil)))));
    test 19 (sexpr_eq (execute_read_sexpr "'-34324324324324") (execute_expected(Pair(Symbol("quote"),Pair(Number(Int(-34324324324324)),Nil)))));
    test 20 (sexpr_eq (execute_read_sexpr "'-10.99") (execute_expected(Pair(Symbol("quote"),Pair(Number(Float(-10.99)),Nil)))));
    test 21 (sexpr_eq (execute_read_sexpr "'#x-10.99") (execute_expected(Pair(Symbol("quote"),Pair(Number(Float(-1.0 *. float_of_string "0x10.99")),Nil)))));
    test 22 (sexpr_eq (execute_read_sexpr "'#x10.99") (execute_expected(Pair(Symbol("quote"),Pair(Number(Float(float_of_string "0x10.99")),Nil)))));
    test 23 (sexpr_eq (execute_read_sexpr "'10.99") (execute_expected(Pair(Symbol("quote"),Pair(Number(Float(10.99)),Nil)))));
    test 24 (sexpr_eq (execute_read_sexpr "'#xA.A") (execute_expected(Pair(Symbol("quote"),Pair(Number(Float(10.625)),Nil)))));
    test 25 (sexpr_eq (execute_read_sexpr "'\"This is a string\"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string"),Nil)))));
    test 26 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\\\ \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with \\ "),Nil)))));
    test 27 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\\" \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with \" "),Nil)))));
    test 28 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\t \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with \t "),Nil)))));
    test 29 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\f \"") (execute_expected(Pair(Symbol("quote"),Pair(String(Printf.sprintf "This is a string with %c " (Char.chr 12)),Nil)))));
    test 30 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\r \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with \r "),Nil)))));
    test 31 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\n \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with \n "),Nil)))));
    test 32 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\x4A; \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with J "),Nil)))));
    test 33 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\x2e; \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with . "),Nil)))));
    test 34 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\x25; \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with % "),Nil)))));
    test 35 (sexpr_eq (execute_read_sexpr "'\"This is a string with \\x7A; \"") (execute_expected(Pair(Symbol("quote"),Pair(String("This is a string with z "),Nil)))));
    test 36 (sexpr_eq (execute_read_sexpr "'a") (execute_expected(Pair(Symbol("quote"),Pair(Symbol("a"),Nil)))));
    test 37 (sexpr_eq (execute_read_sexpr "'aaaa") (execute_expected(Pair(Symbol("quote"),Pair(Symbol("aaaa"),Nil)))));
    test 38 (sexpr_eq (execute_read_sexpr "'bbbb") (execute_expected(Pair(Symbol("quote"),Pair(Symbol("bbbb"),Nil)))));
    test 39 (sexpr_eq (execute_read_sexpr "'abcdef") (execute_expected(Pair(Symbol("quote"),Pair(Symbol("abcdef"),Nil)))));
    test 40 (sexpr_eq (execute_read_sexpr "'abcdefghijklmnop") (execute_expected(Pair(Symbol("quote"),Pair(Symbol("abcdefghijklmnop"),Nil)))));
    test 41 (sexpr_eq (execute_read_sexpr "'abcdefghijklmnopqrstuvwxyz") (execute_expected(Pair(Symbol("quote"),Pair((Symbol("abcdefghijklmnopqrstuvwxyz"),Nil))))));
    test 42 (sexpr_eq (execute_read_sexpr "'abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("quote"),Pair(Symbol("abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 43 (sexpr_eq (execute_read_sexpr "'!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("quote"),Pair(Symbol("!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 44 (sexpr_eq (execute_read_sexpr "'()") (execute_expected(Pair(Symbol("quote"),Pair(Nil,Nil)))));
    test 45 (sexpr_eq (execute_read_sexpr "'( #t )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Bool(true), Nil),Nil)))));
    test 46 (sexpr_eq (execute_read_sexpr "'( \"this\" )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(String("this"),Nil),Nil)))));
    test 47 (sexpr_eq (execute_read_sexpr "'( 37392 )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Number(Int(37392)),Nil),Nil)))));
    test 48 (sexpr_eq (execute_read_sexpr "'( 37392.39382 )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Number(Float(37392.39382)),Nil),Nil)))));
    test 49 (sexpr_eq (execute_read_sexpr "'( #\\c )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Nil),Nil)))));
    test 50 (sexpr_eq (execute_read_sexpr "'( #\\c 37392.39382 )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Nil)),Nil)))));
    test 51 (sexpr_eq (execute_read_sexpr "'( #\\c 37392.39382 37392 )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Nil))),Nil)))));
    test 52 (sexpr_eq (execute_read_sexpr "'( #\\c 37392.39382 37392 \"this\" )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))),Nil)))));
    test 53 (sexpr_eq (execute_read_sexpr "'(#\\c 37392.39382 37392 \"this\" #t)") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))),Nil)))));
    test 54 (sexpr_eq (execute_read_sexpr "'(#t . #f)") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Bool(true),Bool(false)),Nil)))));
    test 55 (sexpr_eq (execute_read_sexpr "'(#t . asfsfdsfa)") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Bool(true),Symbol("asfsfdsfa")),Nil)))));
    test 56 (sexpr_eq (execute_read_sexpr "'(#t . #xA)") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Bool(true),Number(Int(10))),Nil)))));
    test 57 (sexpr_eq (execute_read_sexpr "'(#t . #xA.A)") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Bool(true),Number(Float(10.625))),Nil)))));
    test 58 (sexpr_eq (execute_read_sexpr "'( #\\c . 37392.39382 )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Number(Float(37392.39382))),Nil)))));
    test 59 (sexpr_eq (execute_read_sexpr "'( #\\c 37392.39382 . 37392 )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Number(Int(37392)))),Nil)))));
    test 60 (sexpr_eq (execute_read_sexpr "'( #\\c 37392.39382 37392 . \"this\" )") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), String("this")))),Nil)))));
    test 61 (sexpr_eq (execute_read_sexpr "'(#\\c 37392.39382 37392 \"this\" . #t)") (execute_expected(Pair(Symbol("quote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Bool(true))))),Nil)))));
    ;;

let test_QuasiQuoted_ = fun () ->
    current_test := "test_QuasiQuoted_";
    test 1 (sexpr_eq (execute_read_sexpr "`#t") (execute_expected(Pair(Symbol("quasiquote"),Pair(Bool(true),Nil)))));
    test 2 (sexpr_eq (execute_read_sexpr "`#f") (execute_expected(Pair(Symbol("quasiquote"),Pair(Bool(false),Nil)))));
    test 3 (sexpr_eq (execute_read_sexpr "`#\\a") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('a'),Nil)))));
    test 4 (sexpr_eq (execute_read_sexpr "`#\\g") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('g'),Nil)))));
    test 5 (sexpr_eq (execute_read_sexpr "`#\\4") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('4'),Nil)))));
    test 6 (sexpr_eq (execute_read_sexpr "`#\\#") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('#'),Nil)))));
    test 7 (sexpr_eq (execute_read_sexpr "`#\\newline") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('\n'),Nil)))));
    test 8 (sexpr_eq (execute_read_sexpr "`#\\nul") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char(Char.chr 0),Nil)))));
    test 9 (sexpr_eq (execute_read_sexpr "`#\\return") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('\r'),Nil)))));
    test 10 (sexpr_eq (execute_read_sexpr "`#\\space") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char(' '),Nil)))));
    test 11 (sexpr_eq (execute_read_sexpr "`#\\tab") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('\t'),Nil)))));
    test 12 (sexpr_eq (execute_read_sexpr "`#\\x2B") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('+'),Nil)))));
    test 13 (sexpr_eq (execute_read_sexpr "`#\\x51") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char('Q'),Nil)))));
    test 14 (sexpr_eq (execute_read_sexpr "`#\\x20") (execute_expected(Pair(Symbol("quasiquote"),Pair(Char(' '),Nil)))));
    test 15 (sexpr_eq (execute_read_sexpr "`4") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Int 4),Nil)))));
    test 16 (sexpr_eq (execute_read_sexpr "`10") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number (Int 10),Nil)))));
    test 17 (sexpr_eq (execute_read_sexpr "`+10") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number (Int 10),Nil)))));
    test 18 (sexpr_eq (execute_read_sexpr "`-10") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Int(-10)),Nil)))));
    test 19 (sexpr_eq (execute_read_sexpr "`-34324324324324") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Int(-34324324324324)),Nil)))));
    test 20 (sexpr_eq (execute_read_sexpr "`-10.99") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Float(-10.99)),Nil)))));
    test 21 (sexpr_eq (execute_read_sexpr "`#x-10.99") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Float(-1.0 *. float_of_string "0x10.99")),Nil)))));
    test 22 (sexpr_eq (execute_read_sexpr "`#x10.99") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Float(float_of_string "0x10.99")),Nil)))));
    test 23 (sexpr_eq (execute_read_sexpr "`10.99") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Float(10.99)),Nil)))));
    test 24 (sexpr_eq (execute_read_sexpr "`#xA.A") (execute_expected(Pair(Symbol("quasiquote"),Pair(Number(Float(10.625)),Nil)))));
    test 25 (sexpr_eq (execute_read_sexpr "`\"This is a string\"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string"),Nil)))));
    test 26 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\\\ \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with \\ "),Nil)))));
    test 27 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\\" \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with \" "),Nil)))));
    test 28 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\t \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with \t "),Nil)))));
    test 29 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\f \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String(Printf.sprintf "This is a string with %c " (Char.chr 12)),Nil)))));
    test 30 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\r \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with \r "),Nil)))));
    test 31 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\n \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with \n "),Nil)))));
    test 32 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\x4A; \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with J "),Nil)))));
    test 33 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\x2e; \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with . "),Nil)))));
    test 34 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\x25; \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with % "),Nil)))));
    test 35 (sexpr_eq (execute_read_sexpr "`\"This is a string with \\x7A; \"") (execute_expected(Pair(Symbol("quasiquote"),Pair(String("This is a string with z "),Nil)))));
    test 36 (sexpr_eq (execute_read_sexpr "`a") (execute_expected(Pair(Symbol("quasiquote"),Pair(Symbol("a"),Nil)))));
    test 37 (sexpr_eq (execute_read_sexpr "`aaaa") (execute_expected(Pair(Symbol("quasiquote"),Pair(Symbol("aaaa"),Nil)))));
    test 38 (sexpr_eq (execute_read_sexpr "`bbbb") (execute_expected(Pair(Symbol("quasiquote"),Pair(Symbol("bbbb"),Nil)))));
    test 39 (sexpr_eq (execute_read_sexpr "`abcdef") (execute_expected(Pair(Symbol("quasiquote"),Pair(Symbol("abcdef"),Nil)))));
    test 40 (sexpr_eq (execute_read_sexpr "`abcdefghijklmnop") (execute_expected(Pair(Symbol("quasiquote"),Pair(Symbol("abcdefghijklmnop"),Nil)))));
    test 41 (sexpr_eq (execute_read_sexpr "`abcdefghijklmnopqrstuvwxyz") (execute_expected(Pair(Symbol("quasiquote"),Pair((Symbol("abcdefghijklmnopqrstuvwxyz"),Nil))))));
    test 42 (sexpr_eq (execute_read_sexpr "`abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("quasiquote"),Pair(Symbol("abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 43 (sexpr_eq (execute_read_sexpr "`!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("quasiquote"),Pair(Symbol("!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 44 (sexpr_eq (execute_read_sexpr "`()") (execute_expected(Pair(Symbol("quasiquote"),Pair(Nil,Nil)))));
    test 45 (sexpr_eq (execute_read_sexpr "`( #t )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Bool(true), Nil),Nil)))));
    test 46 (sexpr_eq (execute_read_sexpr "`( \"this\" )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(String("this"),Nil),Nil)))));
    test 47 (sexpr_eq (execute_read_sexpr "`( 37392 )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Number(Int(37392)),Nil),Nil)))));
    test 48 (sexpr_eq (execute_read_sexpr "`( 37392.39382 )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Number(Float(37392.39382)),Nil),Nil)))));
    test 49 (sexpr_eq (execute_read_sexpr "`( #\\c )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Nil),Nil)))));
    test 50 (sexpr_eq (execute_read_sexpr "`( #\\c 37392.39382 )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Nil)),Nil)))));
    test 51 (sexpr_eq (execute_read_sexpr "`( #\\c 37392.39382 37392 )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Nil))),Nil)))));
    test 52 (sexpr_eq (execute_read_sexpr "`( #\\c 37392.39382 37392 \"this\" )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))),Nil)))));
    test 53 (sexpr_eq (execute_read_sexpr "`(#\\c 37392.39382 37392 \"this\" #t)") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))),Nil)))));
    test 54 (sexpr_eq (execute_read_sexpr "`(#t . #f)") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Bool(true),Bool(false)),Nil)))));
    test 55 (sexpr_eq (execute_read_sexpr "`(#t . asfsfdsfa)") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Bool(true),Symbol("asfsfdsfa")),Nil)))));
    test 56 (sexpr_eq (execute_read_sexpr "`(#t . #xA)") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Bool(true),Number(Int(10))),Nil)))));
    test 57 (sexpr_eq (execute_read_sexpr "`(#t . #xA.A)") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Bool(true),Number(Float(10.625))),Nil)))));
    test 58 (sexpr_eq (execute_read_sexpr "`( #\\c . 37392.39382 )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Number(Float(37392.39382))),Nil)))));
    test 59 (sexpr_eq (execute_read_sexpr "`( #\\c 37392.39382 . 37392 )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Number(Int(37392)))),Nil)))));
    test 60 (sexpr_eq (execute_read_sexpr "`( #\\c 37392.39382 37392 . \"this\" )") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), String("this")))),Nil)))));
    test 61 (sexpr_eq (execute_read_sexpr "`(#\\c 37392.39382 37392 \"this\" . #t)") (execute_expected(Pair(Symbol("quasiquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Bool(true))))),Nil)))));
    ;;

    let test_Unquoted_ = fun () ->
    current_test := "test_Unquoted_";
    test 1 (sexpr_eq (execute_read_sexpr ",#t") (execute_expected(Pair(Symbol("unquote"),Pair(Bool(true),Nil)))));
    test 2 (sexpr_eq (execute_read_sexpr ",#f") (execute_expected(Pair(Symbol("unquote"),Pair(Bool(false),Nil)))));
    test 3 (sexpr_eq (execute_read_sexpr ",#\\a") (execute_expected(Pair(Symbol("unquote"),Pair(Char('a'),Nil)))));
    test 4 (sexpr_eq (execute_read_sexpr ",#\\g") (execute_expected(Pair(Symbol("unquote"),Pair(Char('g'),Nil)))));
    test 5 (sexpr_eq (execute_read_sexpr ",#\\4") (execute_expected(Pair(Symbol("unquote"),Pair(Char('4'),Nil)))));
    test 6 (sexpr_eq (execute_read_sexpr ",#\\#") (execute_expected(Pair(Symbol("unquote"),Pair(Char('#'),Nil)))));
    test 7 (sexpr_eq (execute_read_sexpr ",#\\newline") (execute_expected(Pair(Symbol("unquote"),Pair(Char('\n'),Nil)))));
    test 8 (sexpr_eq (execute_read_sexpr ",#\\nul") (execute_expected(Pair(Symbol("unquote"),Pair(Char(Char.chr 0),Nil)))));
    test 9 (sexpr_eq (execute_read_sexpr ",#\\return") (execute_expected(Pair(Symbol("unquote"),Pair(Char('\r'),Nil)))));
    test 10 (sexpr_eq (execute_read_sexpr ",#\\space") (execute_expected(Pair(Symbol("unquote"),Pair(Char(' '),Nil)))));
    test 11 (sexpr_eq (execute_read_sexpr ",#\\tab") (execute_expected(Pair(Symbol("unquote"),Pair(Char('\t'),Nil)))));
    test 12 (sexpr_eq (execute_read_sexpr ",#\\x2B") (execute_expected(Pair(Symbol("unquote"),Pair(Char('+'),Nil)))));
    test 13 (sexpr_eq (execute_read_sexpr ",#\\x51") (execute_expected(Pair(Symbol("unquote"),Pair(Char('Q'),Nil)))));
    test 14 (sexpr_eq (execute_read_sexpr ",#\\x20") (execute_expected(Pair(Symbol("unquote"),Pair(Char(' '),Nil)))));
    test 15 (sexpr_eq (execute_read_sexpr ",4") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Int 4),Nil)))));
    test 16 (sexpr_eq (execute_read_sexpr ",10") (execute_expected(Pair(Symbol("unquote"),Pair(Number (Int 10),Nil)))));
    test 17 (sexpr_eq (execute_read_sexpr ",+10") (execute_expected(Pair(Symbol("unquote"),Pair(Number (Int 10),Nil)))));
    test 18 (sexpr_eq (execute_read_sexpr ",-10") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Int(-10)),Nil)))));
    test 19 (sexpr_eq (execute_read_sexpr ",-34324324324324") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Int(-34324324324324)),Nil)))));
    test 20 (sexpr_eq (execute_read_sexpr ",-10.99") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Float(-10.99)),Nil)))));
    test 21 (sexpr_eq (execute_read_sexpr ",#x-10.99") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Float(-1.0 *. float_of_string "0x10.99")),Nil)))));
    test 22 (sexpr_eq (execute_read_sexpr ",#x10.99") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Float(float_of_string "0x10.99")),Nil)))));
    test 23 (sexpr_eq (execute_read_sexpr ",10.99") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Float(10.99)),Nil)))));
    test 24 (sexpr_eq (execute_read_sexpr ",#xA.A") (execute_expected(Pair(Symbol("unquote"),Pair(Number(Float(10.625)),Nil)))));
    test 25 (sexpr_eq (execute_read_sexpr ",\"This is a string\"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string"),Nil)))));
    test 26 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\\\ \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with \\ "),Nil)))));
    test 27 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\\" \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with \" "),Nil)))));
    test 28 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\t \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with \t "),Nil)))));
    test 29 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\f \"") (execute_expected(Pair(Symbol("unquote"),Pair(String(Printf.sprintf "This is a string with %c " (Char.chr 12)),Nil)))));
    test 30 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\r \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with \r "),Nil)))));
    test 31 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\n \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with \n "),Nil)))));
    test 32 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\x4A; \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with J "),Nil)))));
    test 33 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\x2e; \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with . "),Nil)))));
    test 34 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\x25; \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with % "),Nil)))));
    test 35 (sexpr_eq (execute_read_sexpr ",\"This is a string with \\x7A; \"") (execute_expected(Pair(Symbol("unquote"),Pair(String("This is a string with z "),Nil)))));
    test 36 (sexpr_eq (execute_read_sexpr ",a") (execute_expected(Pair(Symbol("unquote"),Pair(Symbol("a"),Nil)))));
    test 37 (sexpr_eq (execute_read_sexpr ",aaaa") (execute_expected(Pair(Symbol("unquote"),Pair(Symbol("aaaa"),Nil)))));
    test 38 (sexpr_eq (execute_read_sexpr ",bbbb") (execute_expected(Pair(Symbol("unquote"),Pair(Symbol("bbbb"),Nil)))));
    test 39 (sexpr_eq (execute_read_sexpr ",abcdef") (execute_expected(Pair(Symbol("unquote"),Pair(Symbol("abcdef"),Nil)))));
    test 40 (sexpr_eq (execute_read_sexpr ",abcdefghijklmnop") (execute_expected(Pair(Symbol("unquote"),Pair(Symbol("abcdefghijklmnop"),Nil)))));
    test 41 (sexpr_eq (execute_read_sexpr ",abcdefghijklmnopqrstuvwxyz") (execute_expected(Pair(Symbol("unquote"),Pair((Symbol("abcdefghijklmnopqrstuvwxyz"),Nil))))));
    test 42 (sexpr_eq (execute_read_sexpr ",abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("unquote"),Pair(Symbol("abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 43 (sexpr_eq (execute_read_sexpr ",!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("unquote"),Pair(Symbol("!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 44 (sexpr_eq (execute_read_sexpr ",()") (execute_expected(Pair(Symbol("unquote"),Pair(Nil,Nil)))));
    test 45 (sexpr_eq (execute_read_sexpr ",( #t )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Bool(true), Nil),Nil)))));
    test 46 (sexpr_eq (execute_read_sexpr ",( \"this\" )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(String("this"),Nil),Nil)))));
    test 47 (sexpr_eq (execute_read_sexpr ",( 37392 )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Number(Int(37392)),Nil),Nil)))));
    test 48 (sexpr_eq (execute_read_sexpr ",( 37392.39382 )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Number(Float(37392.39382)),Nil),Nil)))));
    test 49 (sexpr_eq (execute_read_sexpr ",( #\\c )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Nil),Nil)))));
    test 50 (sexpr_eq (execute_read_sexpr ",( #\\c 37392.39382 )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Nil)),Nil)))));
    test 51 (sexpr_eq (execute_read_sexpr ",( #\\c 37392.39382 37392 )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Nil))),Nil)))));
    test 52 (sexpr_eq (execute_read_sexpr ",( #\\c 37392.39382 37392 \"this\" )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))),Nil)))));
    test 53 (sexpr_eq (execute_read_sexpr ",(#\\c 37392.39382 37392 \"this\" #t)") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))),Nil)))));
    test 54 (sexpr_eq (execute_read_sexpr ",(#t . #f)") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Bool(true),Bool(false)),Nil)))));
    test 55 (sexpr_eq (execute_read_sexpr ",(#t . asfsfdsfa)") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Bool(true),Symbol("asfsfdsfa")),Nil)))));
    test 56 (sexpr_eq (execute_read_sexpr ",(#t . #xA)") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Bool(true),Number(Int(10))),Nil)))));
    test 57 (sexpr_eq (execute_read_sexpr ",(#t . #xA.A)") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Bool(true),Number(Float(10.625))),Nil)))));
    test 58 (sexpr_eq (execute_read_sexpr ",( #\\c . 37392.39382 )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Number(Float(37392.39382))),Nil)))));
    test 59 (sexpr_eq (execute_read_sexpr ",( #\\c 37392.39382 . 37392 )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Number(Int(37392)))),Nil)))));
    test 60 (sexpr_eq (execute_read_sexpr ",( #\\c 37392.39382 37392 . \"this\" )") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), String("this")))),Nil)))));
    test 61 (sexpr_eq (execute_read_sexpr ",(#\\c 37392.39382 37392 \"this\" . #t)") (execute_expected(Pair(Symbol("unquote"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Bool(true))))),Nil)))));
    ;;

      let test_UnquotedSpliced_ = fun () ->
    current_test := "test_UnquotedSpliced_";
    test 1 (sexpr_eq (execute_read_sexpr ",@#t") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Bool(true),Nil)))));
    test 2 (sexpr_eq (execute_read_sexpr ",@#f") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Bool(false),Nil)))));
    test 3 (sexpr_eq (execute_read_sexpr ",@#\\a") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('a'),Nil)))));
    test 4 (sexpr_eq (execute_read_sexpr ",@#\\g") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('g'),Nil)))));
    test 5 (sexpr_eq (execute_read_sexpr ",@#\\4") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('4'),Nil)))));
    test 6 (sexpr_eq (execute_read_sexpr ",@#\\#") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('#'),Nil)))));
    test 7 (sexpr_eq (execute_read_sexpr ",@#\\newline") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('\n'),Nil)))));
    test 8 (sexpr_eq (execute_read_sexpr ",@#\\nul") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char(Char.chr 0),Nil)))));
    test 9 (sexpr_eq (execute_read_sexpr ",@#\\return") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('\r'),Nil)))));
    test 10 (sexpr_eq (execute_read_sexpr ",@#\\space") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char(' '),Nil)))));
    test 11 (sexpr_eq (execute_read_sexpr ",@#\\tab") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('\t'),Nil)))));
    test 12 (sexpr_eq (execute_read_sexpr ",@#\\x2B") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('+'),Nil)))));
    test 13 (sexpr_eq (execute_read_sexpr ",@#\\x51") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char('Q'),Nil)))));
    test 14 (sexpr_eq (execute_read_sexpr ",@#\\x20") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Char(' '),Nil)))));
    test 15 (sexpr_eq (execute_read_sexpr ",@4") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Int 4),Nil)))));
    test 16 (sexpr_eq (execute_read_sexpr ",@10") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number (Int 10),Nil)))));
    test 17 (sexpr_eq (execute_read_sexpr ",@+10") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number (Int 10),Nil)))));
    test 18 (sexpr_eq (execute_read_sexpr ",@-10") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Int(-10)),Nil)))));
    test 19 (sexpr_eq (execute_read_sexpr ",@-34324324324324") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Int(-34324324324324)),Nil)))));
    test 20 (sexpr_eq (execute_read_sexpr ",@-10.99") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Float(-10.99)),Nil)))));
    test 21 (sexpr_eq (execute_read_sexpr ",@#x-10.99") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Float(-1.0 *. float_of_string "0x10.99")),Nil)))));
    test 22 (sexpr_eq (execute_read_sexpr ",@#x10.99") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Float(float_of_string "0x10.99")),Nil)))));
    test 23 (sexpr_eq (execute_read_sexpr ",@10.99") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Float(10.99)),Nil)))));
    test 24 (sexpr_eq (execute_read_sexpr ",@#xA.A") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Number(Float(10.625)),Nil)))));
    test 25 (sexpr_eq (execute_read_sexpr ",@\"This is a string\"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string"),Nil)))));
    test 26 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\\\ \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with \\ "),Nil)))));
    test 27 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\\" \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with \" "),Nil)))));
    test 28 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\t \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with \t "),Nil)))));
    test 29 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\f \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String(Printf.sprintf "This is a string with %c " (Char.chr 12)),Nil)))));
    test 30 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\r \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with \r "),Nil)))));
    test 31 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\n \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with \n "),Nil)))));
    test 32 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\x4A; \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with J "),Nil)))));
    test 33 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\x2e; \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with . "),Nil)))));
    test 34 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\x25; \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with % "),Nil)))));
    test 35 (sexpr_eq (execute_read_sexpr ",@\"This is a string with \\x7A; \"") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(String("This is a string with z "),Nil)))));
    test 36 (sexpr_eq (execute_read_sexpr ",@a") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Symbol("a"),Nil)))));
    test 37 (sexpr_eq (execute_read_sexpr ",@aaaa") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Symbol("aaaa"),Nil)))));
    test 38 (sexpr_eq (execute_read_sexpr ",@bbbb") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Symbol("bbbb"),Nil)))));
    test 39 (sexpr_eq (execute_read_sexpr ",@abcdef") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Symbol("abcdef"),Nil)))));
    test 40 (sexpr_eq (execute_read_sexpr ",@abcdefghijklmnop") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Symbol("abcdefghijklmnop"),Nil)))));
    test 41 (sexpr_eq (execute_read_sexpr ",@abcdefghijklmnopqrstuvwxyz") (execute_expected(Pair(Symbol("unquote-splicing"),Pair((Symbol("abcdefghijklmnopqrstuvwxyz"),Nil))))));
    test 42 (sexpr_eq (execute_read_sexpr ",@abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Symbol("abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 43 (sexpr_eq (execute_read_sexpr ",@!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Symbol("!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789"),Nil)))));
    test 44 (sexpr_eq (execute_read_sexpr ",@()") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Nil,Nil)))));
    test 45 (sexpr_eq (execute_read_sexpr ",@( #t )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Bool(true), Nil),Nil)))));
    test 46 (sexpr_eq (execute_read_sexpr ",@( \"this\" )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(String("this"),Nil),Nil)))));
    test 47 (sexpr_eq (execute_read_sexpr ",@( 37392 )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Number(Int(37392)),Nil),Nil)))));
    test 48 (sexpr_eq (execute_read_sexpr ",@( 37392.39382 )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Number(Float(37392.39382)),Nil),Nil)))));
    test 49 (sexpr_eq (execute_read_sexpr ",@( #\\c )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Nil),Nil)))));
    test 50 (sexpr_eq (execute_read_sexpr ",@( #\\c 37392.39382 )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Nil)),Nil)))));
    test 51 (sexpr_eq (execute_read_sexpr ",@( #\\c 37392.39382 37392 )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Nil))),Nil)))));
    test 52 (sexpr_eq (execute_read_sexpr ",@( #\\c 37392.39382 37392 \"this\" )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))),Nil)))));
    test 53 (sexpr_eq (execute_read_sexpr ",@(#\\c 37392.39382 37392 \"this\" #t)") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))),Nil)))));
    test 54 (sexpr_eq (execute_read_sexpr ",@(#t . #f)") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Bool(true),Bool(false)),Nil)))));
    test 55 (sexpr_eq (execute_read_sexpr ",@(#t . asfsfdsfa)") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Bool(true),Symbol("asfsfdsfa")),Nil)))));
    test 56 (sexpr_eq (execute_read_sexpr ",@(#t . #xA)") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Bool(true),Number(Int(10))),Nil)))));
    test 57 (sexpr_eq (execute_read_sexpr ",@(#t . #xA.A)") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Bool(true),Number(Float(10.625))),Nil)))));
    test 58 (sexpr_eq (execute_read_sexpr ",@( #\\c . 37392.39382 )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Number(Float(37392.39382))),Nil)))));
    test 59 (sexpr_eq (execute_read_sexpr ",@( #\\c 37392.39382 . 37392 )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Number(Int(37392)))),Nil)))));
    test 60 (sexpr_eq (execute_read_sexpr ",@( #\\c 37392.39382 37392 . \"this\" )") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), String("this")))),Nil)))));
    test 61 (sexpr_eq (execute_read_sexpr ",@(#\\c 37392.39382 37392 \"this\" . #t)") (execute_expected(Pair(Symbol("unquote-splicing"),Pair(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Bool(true))))),Nil)))));
    ;;

let test_LineComment_ = fun () ->
    current_test := "test_LineComment_";
    test 1 (sexpr_eq (execute_read_sexpr "; sdfdkerjdfk 4594359ksmdvc fdskfs\n#t") (execute_expected(Bool true)));
    test 2 (sexpr_eq (execute_read_sexpr "#f;sadasujnxjzcnjsaudj ij49fdsf") (execute_expected(Bool false)));
    test 3 (sexpr_eq (execute_read_sexpr " #f") (execute_expected(Bool false)));
    test 4 (sexpr_eq (execute_read_sexpr ";asdi39isksdkmkdsfkdskf\n #t") (execute_expected(Bool true)));
    test 5 (sexpr_eq (execute_read_sexpr "             ;dsfdsfertidrmdkmvdkgdgdffdg\n #t ") (execute_expected(Bool true)));
    test 6 (sexpr_eq (execute_read_sexpr " #f       ;dfkdsfjdisf dkfmk43rtmsdkfmzcpc3-33#@%#$^$##@#@!# ") (execute_expected(Bool false)));
    test 7 (sexpr_eq (execute_read_sexpr ";sfkdsfklsdkf\n ;dsflnjdsfhsdjkf\n #\\a") (execute_expected(Char 'a')));
    test 8 (sexpr_eq (execute_read_sexpr "#\\g         ;dsflksdf;ds;fk;sdf\n;dsf;sdflkjsdklfjdsf\n") (execute_expected(Char 'g')));
    test 9 (sexpr_eq (execute_read_sexpr ";asdjasdlasdjhasdjk   sadlsadld;sadklsaldklasd\n#\\4") (execute_expected(Char '4')));
    test 10 (sexpr_eq (execute_read_sexpr "#\\#          ;sadl;sakdlkdsallasdljasd\n") (execute_expected(Char '#')));
    test 11 (sexpr_eq (execute_read_sexpr ";sadsjdasdjashdjsad\n#\\newline") (execute_expected(Char '\n')));
    test 12 (sexpr_eq (execute_read_sexpr "#\\nul ;sadkjasdkjas;asdjkaskdjkasdj\n;sdfksdfkldskf\n") (execute_expected(Char (Char.chr 0))));
    test 13 (sexpr_eq (execute_read_sexpr "               ;sdajksafdkjsdkf\n ;sdjfksajksdfkjdsf\n     #\\return") (execute_expected(Char '\r')));
    test 14 (sexpr_eq (execute_read_sexpr "#\\space   ;\n") (execute_expected(Char ' ')));
    test 15 (sexpr_eq (execute_read_sexpr ";\n#\\tab") (execute_expected(Char '\t')));
    test 16 (sexpr_eq (execute_read_sexpr "#\\x2B;\n;\n;\n") (execute_expected(Char '+')));
    test 17 (sexpr_eq (execute_read_sexpr "                 #\\x51          ") (execute_expected(Char 'Q')));
    test 18 (sexpr_eq (execute_read_sexpr ";\n;\n\n\n\n\n\n#\\x20") (execute_expected(Char ' ')));
    test 19 (sexpr_eq (execute_read_sexpr "4               ;dsfdsfsdfdsf") (execute_expected(Number (Int 4))));
    test 20 (sexpr_eq (execute_read_sexpr "10              \n\n;dsfdsfdsfsdfdsf") (execute_expected(Number (Int 10))));
    test 21 (sexpr_eq (execute_read_sexpr "+10            ;") (execute_expected(Number (Int 10))));
    test 22 (sexpr_eq (execute_read_sexpr "-10") (execute_expected(Number (Int (-10)))));
    test 23 (sexpr_eq (execute_read_sexpr ";\n\n\n-34324324324324") (execute_expected(Number (Int (-34324324324324)))));
    test 24 (sexpr_eq (execute_read_sexpr "-10.99 ;sdsadasdsadasd\n\n") (execute_expected(Number (Float (-10.99)))));
    test 25 (sexpr_eq (execute_read_sexpr "\n\n\n\n\n\n;dfdsfsd\n#x-10.99") (execute_expected(Number (Float (-1.0 *. float_of_string "0x10.99")))));
    test 26 (sexpr_eq (execute_read_sexpr "#x10.99         \n\n\n\n") (execute_expected(Number (Float (float_of_string "0x10.99")))));
    test 27 (sexpr_eq (execute_read_sexpr "\n\n\n\n\n10.99\n\n\n\n") (execute_expected(Number (Float (10.99)))));
    test 28 (sexpr_eq (execute_read_sexpr ";\n;\n;\n        #xA.A") (execute_expected(Number (Float (10.625)))));
    test 29 (sexpr_eq (execute_read_sexpr "\"This is a string\";sdsfsdfsd\n") (execute_expected(String "This is a string")));
    test 30 (sexpr_eq (execute_read_sexpr "\"This is a string with \\\\ \";sadsdsadsadasdsda\n   ") (execute_expected(String "This is a string with \\ ")));
    test 31 (sexpr_eq (execute_read_sexpr ";sadsadsadas\n\"This is a string with \\\" \"") ((execute_expected(String "This is a string with \" "))));
    test 32 (sexpr_eq (execute_read_sexpr "\"This is a string with \\t \"       ;sdsadsadsadasd") ((execute_expected(String "This is a string with \t "))));
    test 33 (sexpr_eq (execute_read_sexpr "\"This is a string with \\f \"    ;\n\n\n") ((execute_expected(String (Printf.sprintf "This is a string with %c " (Char.chr 12))))));
    test 34 (sexpr_eq (execute_read_sexpr "\"This is a string with \\r \";sdsasasadsadsdsada\n") ((execute_expected(String "This is a string with \r "))));
    test 35 (sexpr_eq (execute_read_sexpr "\"This is a string with \\n \"\n\n\n\n\n\n") ((execute_expected(String "This is a string with \n "))));
    test 36 (sexpr_eq (execute_read_sexpr ";dsfsdfdsfsddsf\n\n\n\"This is a string with \\x4A; \"") ((execute_expected(String "This is a string with J "))));
    test 37 (sexpr_eq (execute_read_sexpr "\"This is a string with \\x2e; \";sdsdfsdfdsfdsfsdfs") ((execute_expected(String "This is a string with . "))));
    test 38 (sexpr_eq (execute_read_sexpr "\"This is a string with \\x25; \"\n\n\n\n\n") ((execute_expected(String "This is a string with % "))));
    test 39 (sexpr_eq (execute_read_sexpr ";fdsdsfdsfds\n\n\"This is a string with \\x7A; \"") ((execute_expected(String "This is a string with z "))));
    test 40 (sexpr_eq (execute_read_sexpr "a ;sfdsdfsdf\n\n") (execute_expected(Symbol "a")));
    test 41 (sexpr_eq (execute_read_sexpr "\n\n\n                         aaaa\n") (execute_expected(Symbol "aaaa")));
    test 42 (sexpr_eq (execute_read_sexpr "bbbb ;thisIsNotBeParsed") (execute_expected(Symbol "bbbb")));
    test 43 (sexpr_eq (execute_read_sexpr "abcdef ;dssadsadsadas\n\n") (execute_expected(Symbol "abcdef")));
    test 44 (sexpr_eq (execute_read_sexpr ";sdsasasad\n\n abcdefghijklmnop") (execute_expected(Symbol "abcdefghijklmnop")));
    test 45 (sexpr_eq (execute_read_sexpr "abcdefghijklmnopqrstuvwxyz ;dsadsadsadsasad\n\n") (execute_expected(Symbol "abcdefghijklmnopqrstuvwxyz")));
    test 46 (sexpr_eq (execute_read_sexpr "abcdefghijklmnopqrstuvwxyz0123456789 ;dsasdsa\n\n") (execute_expected(Symbol "abcdefghijklmnopqrstuvwxyz0123456789")));
    test 47 (sexpr_eq (execute_read_sexpr ";\n\n\n\n\n;dfdsfdsf\n !$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789") (execute_expected(Symbol "!$^*-_=+<>?/:abcdefghijklmnopqrstuvwxyz0123456789")));
    test 48 (sexpr_eq (execute_read_sexpr "()        ;fdsfdsfdsfds\n") (execute_expected(Nil)));
    test 49 (sexpr_eq (execute_read_sexpr ";sdsadasd\n ;dfdsfdsf\n ;sdfdsfdsf\n ;sdfdsdsfsdf\n ;'34324asd@##@$$^%$&%\n ( #t )") (execute_expected(Pair(Bool(true), Nil))));
    test 50 (sexpr_eq (execute_read_sexpr "( \"this\" ;dsfdsfdsfdsfsdfds\n )") (execute_expected(Pair(String("this"), Nil))));
    test 51 (sexpr_eq (execute_read_sexpr "( ;dfsfdsfdsfdsf\n 37392 ;dsfdsfdsfdse43#@$@#$\n )") (execute_expected(Pair(Number(Int(37392)), Nil))));
    test 52 (sexpr_eq (execute_read_sexpr ";sfdsf3#@#@$\n ( ;sdfsdfdsfdsfdsf\n 37392.39382 ;#$#@$\n ) ;dfsdfdsfsdfsd") (execute_expected(Pair(Number(Float(37392.39382)), Nil))));
    test 53 (sexpr_eq (execute_read_sexpr "( #\\c ;sdsadsadsadsa\n)") (execute_expected(Pair(Char('c'), Nil))));
    test 54 (sexpr_eq (execute_read_sexpr ";asdasdasdas\n ( #\\c 37392.39382 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Nil)))));
    test 55 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 ;#@$#@#@$#@DFDSC%DFfgdgdf\n 37392 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Nil))))));
    test 56 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 ;dsfds$#$%#%\n 37392 ;dsfds$#$%#%\n ;45435gfdfdg\n ;45435$%#%\n \"this\" )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))))));
    test 57 (sexpr_eq (execute_read_sexpr "(#\\c 37392.39382 37392 ;dsfds$#$%#%\n \"this\" #t)") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))))));
    test 58 (sexpr_eq (execute_read_sexpr "(#t . ;34324dfssfgfdg\n #f)") (execute_expected(Pair(Bool(true),Bool(false)))));
    test 59 (sexpr_eq (execute_read_sexpr "(#t . asfsfdsfa)") (execute_expected(Pair(Bool(true),Symbol("asfsfdsfa")))));
    test 60 (sexpr_eq (execute_read_sexpr "(#t ;sdfdsfdsfdsf\n . #xA)") (execute_expected(Pair(Bool(true),Number(Int(10))))));
    test 61 (sexpr_eq (execute_read_sexpr "   (#t . #xA.A) ;fdsdsfdsf\n\n\n ") (execute_expected(Pair(Bool(true),Number(Float(10.625))))));
    test 62 (sexpr_eq (execute_read_sexpr "( #\\c ;sfdsfdsf\n\n . 37392.39382 )") (execute_expected(Pair(Char('c'), Number(Float(37392.39382))))));
    test 63 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 . 37392 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Number(Int(37392)))))));
    test 64 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 37392 ;fsdfds#$#$#%$#\n . \"this\" )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), String("this")))))));
    test 65 (sexpr_eq (execute_read_sexpr "(#\\c 37392.39382 37392 \"this\" . ;324324DSFDSFSD\n #t)") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Bool(true))))))));
    ;;
  
  let test_SexprComment_ = fun () ->
    current_test := "test_SexprComment_";
    test 1 (sexpr_eq (execute_read_sexpr "#;#f #t") (execute_expected(Bool true)));
    test 2 (sexpr_eq (execute_read_sexpr "#;#f #f") (execute_expected(Bool false)));
    test 3 (sexpr_eq (execute_read_sexpr "#; #t #f ") (execute_expected(Bool false)));
    test 4 (sexpr_eq (execute_read_sexpr "#;#;#; #t #F #F #T") (execute_expected(Bool true)));
    test 5 (sexpr_eq (execute_read_sexpr "#;#; 3432432 3.45345 #t ") (execute_expected(Bool true)));
    test 6 (sexpr_eq (execute_read_sexpr " #; \"DSDSDD\" ;DSFSDFSDDSF\n #f ") (execute_expected(Bool false)));
    test 7 (sexpr_eq (execute_read_sexpr "#; #\\h #\\a") (execute_expected(Char 'a')));
    test 8 (sexpr_eq (execute_read_sexpr "#; \"dflk4dl#@EDS \" #;#x-10.99  -10") (execute_expected(Number (Int (-10)))));
    test 9 (sexpr_eq (execute_read_sexpr "#; #;   ;fddsfdsf\n #; 10 10.10 #xA.A -34324324324324") (execute_expected(Number (Int (-34324324324324)))));
    test 10 (sexpr_eq (execute_read_sexpr "#; \"Thisdssadsadis a string\" \"This is a string\"") (execute_expected(String "This is a string")));
    test 11 (sexpr_eq (execute_read_sexpr "#; \"This is a str#; #; ;ing with \\\\ \" \"This is a string with \\\\ \"") (execute_expected(String "This is a string with \\ ")));
    test 12 (sexpr_eq (execute_read_sexpr "a") (execute_expected(Symbol "a")));
    test 13 (sexpr_eq (execute_read_sexpr "#; dssdcve3232 #; vbvcc4gfdgd aaaa") (execute_expected(Symbol "aaaa")));
    test 14 (sexpr_eq (execute_read_sexpr "( #; dfdsfdsf #t )") (execute_expected(Pair(Bool(true), Nil))));
    test 15 (sexpr_eq (execute_read_sexpr "( #; #; #; #; a b c d \"this\" )") (execute_expected(Pair(String("this"), Nil))));
    test 16 (sexpr_eq (execute_read_sexpr "( #; 342342 #; \"dfdsf\" 37392.39382 )") (execute_expected(Pair(Number(Float(37392.39382)), Nil))));
    test 17 (sexpr_eq (execute_read_sexpr "( #; #F #; #T #\\c )") (execute_expected(Pair(Char('c'), Nil))));
    test 18 (sexpr_eq (execute_read_sexpr "( #\\c #; #\\5 37392.39382 #; 343242 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Nil)))));
    test 19 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 #;#;#; #xA \"this\" 10.10 37392 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Nil))))));
    test 20 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 #; #xA ;DSFDSFDSFDS\n 37392 \"this\" )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))))));
    test 21 (sexpr_eq (execute_read_sexpr "(#\\c 37392.39382 37392 #; \"thfdsdfdsdsfdsfs\" \"this\" ;dfdsfdsfdsf\n #t)") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Pair(Bool(true), Nil))))))));
    test 22 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 . 37392 )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Number(Int(37392)))))));
    test 23 (sexpr_eq (execute_read_sexpr "( #\\c 37392.39382 37392 ;fsdfds#$#$#%$#\n . #; 423423 #;24324 \"this\" )") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), String("this")))))));
    test 24 (sexpr_eq (execute_read_sexpr "(#\\c 37392.39382 37392 \"this\" . ;324324DSFDSFSD\n #; ;asdasdasd\n #F #t)") (execute_expected(Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Bool(true))))))));
    test 15 (sexpr_eq (execute_read_sexpr "(;dsadsadsadas\n)") (execute_expected(Nil)));
    ;;

let test_ReadSexpr_ = fun () ->
    current_test := "test_ReadSexpr_";
    test 1 (sexpr_eq (execute_read_sexpr "#f #T #t") (execute_expected(String("test failed"))));
    test 2 (sexpr_eq (execute_read_sexpr "#t") (execute_expected(Bool(true))));
    test 3 (sexpr_eq (execute_read_sexpr ";asasdasfasf\n #t ;ffdsfdsfdsf") (execute_expected(Bool(true))));
    test 4 (sexpr_eq (execute_read_sexpr ";asasdasfasf\n #t ;ffdsfdsfdsf\n #f") (execute_expected(String("test failed"))));
    test 5 (sexpr_eq (execute_read_sexpr ";asasdasfasf\n #t ;ffdsfdsfdsf\n #; #f") (execute_expected(Bool(true))));
    ;;

let test_ReadSexprs_ = fun () ->
    current_test := "test_ReadSexprs_";
    test 1 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f #T #t") (execute_expected_as_list([Bool(false); Bool(true); Bool(true)])));
    test 2 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f 37392.39382 \"this\"") (execute_expected_as_list([Bool(false); Number(Float(37392.39382)); String("this")])));
    test 3 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f 37392.39382 \"this\" fdsdfdsedfgg4fdgfd") (execute_expected_as_list([Bool(false); Number(Float(37392.39382)); String("this"); Symbol("fdsdfdsedfgg4fdgfd")])));
    test 4 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f 37392.39382 \"this\" ;sfdsfdsfdsf\n fdsdfdsedfgg4fdgfd (#\\c 37392.39382 37392 \"this\" . ;324324DSFDSFSD\n #; ;asdasdasd\n #F #t)") (execute_expected_as_list([Bool(false); Number(Float(37392.39382)); String("this"); Symbol("fdsdfdsedfgg4fdgfd"); Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Bool(true)))))])));
    test 5 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f 37392.39382 \"this\" fdsdfdsedfgg4fdgfd [ #; #; #; #; a b c d \"this\" ]") (execute_expected_as_list([Bool(false); Number(Float(37392.39382)); String("this"); Symbol("fdsdfdsedfgg4fdgfd"); Pair(String("this"), Nil)])));
    test 6 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f 37392.39382 [ #\\c 37392.39382 #; #xA ;DSFDSFDSFDS\n 37392 \"this\" ] \"this\" ") (execute_expected_as_list([Bool(false); Number(Float(37392.39382)); Pair(Char('c'), Pair(Number(Float(37392.39382)), Pair(Number(Int(37392)), Pair(String("this"), Nil)))); String("this")])));
    test 7 (sexpr_eq_as_list (execute_read_sexprs_as_list "") (execute_expected_as_list([])));
    test 8 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f#t") (execute_expected_as_list([Bool(false); Bool(true)])));
    test 9 (sexpr_eq_as_list (execute_read_sexprs_as_list "123\"123\"") (execute_expected_as_list([Number(Int(123)); String("123")])));
    test 10 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f'a") (execute_expected_as_list([Bool(false);Pair(Symbol("quote"), Pair(Symbol("a"),Nil))])));
    test 11 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f`a") (execute_expected_as_list([Bool(false);Pair(Symbol("quasiquote"), Pair(Symbol("a"),Nil))])));
    test 12 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f,a") (execute_expected_as_list([Bool(false);Pair(Symbol("unquote"), Pair(Symbol("a"),Nil))])));
    test 13 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f,@a") (execute_expected_as_list([Bool(false);Pair(Symbol("unquote-splicing"), Pair(Symbol("a"),Nil))])));
    test 14 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f(1 . 1.0)") (execute_expected_as_list([Bool(false);Pair(Number(Int(1)), Number(Float(1.0)))])));
    test 15 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f(1 . 1.0)12345") (execute_expected_as_list([Bool(false);Pair(Number(Int(1)), Number(Float(1.0))); Number(Int(12345))])));
    test 16 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f[1 . 1.0]12345") (execute_expected_as_list([Bool(false);Pair(Number(Int(1)), Number(Float(1.0))); Number(Int(12345))])));
    test 17 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f(1 1.0)12345") (execute_expected_as_list([Bool(false);Pair(Number(Int(1)),Pair(Number(Float(1.0)),Nil)); Number(Int(12345))])));
    test 18 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f#(1 1.0)12345") (execute_expected_as_list([Bool(false); Vector([Number(Int(1)); Number(Float(1.0))]); Number(Int(12345))])));
    test 19 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f#(1 1.0)\"222\"") (execute_expected_as_list([Bool(false); Vector([Number(Int(1)); Number(Float(1.0))]); String("222")])));
    test 20 (sexpr_eq_as_list (execute_read_sexprs_as_list "#f#(1 1.0)#\\x3a") (execute_expected_as_list([Bool(false); Vector([Number(Int(1)); Number(Float(1.0))]); Char(':')])));
    ;;

let test_SceintificNotation_ = fun () ->
    current_test := "test_SceintificNotation_";
    test 1 (sexpr_eq (execute_read_sexpr "1e1") (execute_expected(Number (Float 10.0))));
    test 2 (sexpr_eq (execute_read_sexpr "10.0E2") (execute_expected(Number (Float 1000.0))));
    test 3 (sexpr_eq (execute_read_sexpr "1E+1") (execute_expected(Number (Float 10.0))));
    test 4 (sexpr_eq (execute_read_sexpr "10e-1") (execute_expected(Number (Float((1.0))))));
    test 5 (sexpr_eq (execute_read_sexpr "3.14e+9") (execute_expected(Number (Float (3140000000.0)))));
    test 6 (sexpr_eq (execute_read_sexpr "+000000012.3E00000002") (execute_expected(Number (Float (1230.0)))));
    test 7 (sexpr_eq (execute_read_sexpr "-5.000000000e-2") (execute_expected(Number (Float(-0.05)))));
    test 8 (sexpr_eq (execute_read_sexpr "50E-4") (execute_expected(Number (Float(0.005)))));
    test 9 (sexpr_eq (execute_read_sexpr "3.1234E+2") (execute_expected(Number (Float (312.34)))));
    test 10 (sexpr_eq (execute_read_sexpr "-50.345e+2") (execute_expected(Number (Float (-5034.5)))));
    test 11 (sexpr_eq (execute_read_sexpr "0.123E4") (execute_expected(Number (Float (1230.0)))));
    test 12 (sexpr_eq (execute_read_sexpr "-0.4321E-4") (execute_expected(Number (Float (-0.00004321)))));
    test 13 (sexpr_eq (execute_read_sexpr "-10.4321E-4") (execute_expected(Number (Float (-0.00104321)))));
    test 14 (sexpr_eq (execute_read_sexpr "-0.4321E-4") (execute_expected(Number (Float (-0.00004321)))));
    ;;

let test_ThreeDots_ = fun () ->
    current_test := "test_ThreeDots_";
    test 1 (sexpr_eq (execute_read_sexpr "(#f . #T ...") (execute_expected(Pair(Bool(false),Bool(true)))));
    test 2 (sexpr_eq (execute_read_sexpr "(#f . [#T . #F ...") (execute_expected(Pair(Bool(false),Pair(Bool(true),Bool(false))))));
    test 3 (sexpr_eq (execute_read_sexpr "(#f . [#T . #F ...") (execute_expected(Pair(Bool(false),Pair(Bool(true),Bool(false))))));
    test 4 (sexpr_eq (execute_read_sexpr "(let ([x 1] [y 2]) [lambda (z) (+ x y z) ...") (execute_expected(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("x"),Pair(Number(Int(1)),Nil)),Pair(Pair(Symbol("y"),Pair(Number(Int(2)),Nil)),Nil)),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("z"),Nil),Pair(Pair(Symbol("+"),Pair(Symbol("x"),Pair(Symbol("y"),Pair(Symbol("z"),Nil)))),Nil))),Nil))))));
    test 5 (sexpr_eq (execute_read_sexpr "(#t \"...\" . #F)") (execute_expected(Pair(Bool(true),Pair(String("..."),Bool(false))))));
    test 6 (sexpr_eq (execute_read_sexpr "(#t \"...\" . #F) ...") (execute_expected(Pair(Bool(true),Pair(String("..."),Bool(false))))));
    test 7 (sexpr_eq (execute_read_sexpr "(#t \"...\" . #F) ...") (execute_expected(Pair(Bool(true),Pair(String("..."),Bool(false))))));
    test 8 (sexpr_eq_as_list (execute_read_sexprs_as_list "  ... (\"...\") ... [1]") (execute_expected_as_list([Pair(String("..."),Nil); Pair(Number(Int(1)),Nil)])));
    test 9 (sexpr_eq_as_list (execute_read_sexprs_as_list "  ... (\"...\") ... [1] ...") (execute_expected_as_list([Pair(String("..."),Nil); Pair(Number(Int(1)),Nil)])));
    test 10 (sexpr_eq_as_list (execute_read_sexprs_as_list " ...  (\"...\") ... () ... [1] ...") (execute_expected_as_list([Pair(String("..."),Nil); Nil; Pair(Number(Int(1)),Nil)])));
    test 11 (sexpr_eq_as_list (execute_read_sexprs_as_list " ...  (\"...\") ... (;...\n) ... [1] ...") (execute_expected_as_list([Pair(String("..."),Nil); Nil; Pair(Number(Int(1)),Nil)])));
    test 12 (sexpr_eq_as_list (execute_read_sexprs_as_list " ...  (\"...\") ...  [#\\c . ;...\n #\\d] ... [1] ...") (execute_expected_as_list([Pair(String("..."),Nil); Pair(Char('c'),Char('d')); Pair(Number(Int(1)),Nil)])));
    test 13 (sexpr_eq_as_list (execute_read_sexprs_as_list " ...  (\"...\") ...  [([#\\c . ;...\n #\\d ... [1] ...") (execute_expected_as_list([Pair(String("..."),Nil); Pair(Pair(Pair(Char('c'),Char('d')),Nil),Nil); Pair(Number(Int(1)),Nil)])));
    ;;

let test_CS_DEPARTMENT_ = fun () ->
    current_test := "test_CS_DEPARTMENT_";
    test 1 (sexpr_eq_as_list (execute_read_sexprs_as_list "1") (execute_expected_as_list([Number (Int (1))])));
    test 2 (sexpr_eq_as_list (execute_read_sexprs_as_list "#t") (execute_expected_as_list([Bool true])));
    test 3 (sexpr_eq_as_list (execute_read_sexprs_as_list "(#\\f)") (execute_expected_as_list([Pair (Char 'f', Nil)])));
    test 4 (sexpr_eq_as_list (execute_read_sexprs_as_list "()") (execute_expected_as_list([Nil])));
    test 5 (sexpr_eq_as_list (execute_read_sexprs_as_list "\"a tab (\\t) followed by a \\xa;\"") (execute_expected_as_list([String "a tab (\t) followed by a \n"])));
    test 6 (sexpr_eq_as_list (execute_read_sexprs_as_list "0notanumber0") (execute_expected_as_list([Symbol "0notanumber0"])));
    test 7 (sexpr_eq_as_list (execute_read_sexprs_as_list "#(#\\n #\\space #\\x7e)") (execute_expected_as_list([Vector [Char 'n';Char ' ';Char '~']])));
    test 8 (sexpr_eq_as_list (execute_read_sexprs_as_list "(lambda (Param) \n;comment \n`(param) #\\P ...") (execute_expected_as_list([Pair (Symbol "lambda", Pair (Pair (Symbol "param", Nil), Pair (Pair (Symbol "quasiquote", Pair (Pair (Symbol "param", Nil), Nil)), Pair (Char 'P', Nil))))])));
    test 9 (sexpr_eq_as_list (execute_read_sexprs_as_list "(let ((x '(1 2 -3.2))) \n(+ (car x) ... ((cadr '(1 2)) (caddr (1 2 3)) ... ") (execute_expected_as_list([Pair (Symbol "let", Pair (Pair (Pair (Symbol "x", Pair (Pair (Symbol "quote", Pair (Pair (Number (Int (1)), Pair (Number (Int (2)), Pair (Number (Float (-3.200000)), Nil))), Nil)), Nil)), Nil), Pair (Pair (Symbol "+", Pair (Pair (Symbol "car", Pair (Symbol "x", Nil)), Nil)), Nil)));Pair (Pair (Symbol "cadr", Pair (Pair (Symbol "quote", Pair (Pair (Number (Int (1)), Pair (Number (Int (2)), Nil)), Nil)), Nil)), Pair (Pair (Symbol "caddr", Pair (Pair (Number (Int (1)), Pair (Number (Int (2)), Pair (Number (Int (3)), Nil))), Nil)), Nil))])));
    test 10 (sexpr_eq_as_list (execute_read_sexprs_as_list "(apply eq? `(,(+ 1 2) ,(list 2e5)))") (execute_expected_as_list([Pair (Symbol "apply", Pair (Symbol "eq?", Pair (Pair (Symbol "quasiquote", Pair (Pair (Pair (Symbol "unquote", Pair (Pair (Symbol "+", Pair (Number (Int (1)), Pair (Number (Int (2)), Nil))), Nil)), Pair (Pair (Symbol "unquote", Pair (Pair (Symbol "list", Pair (Number (Float (200000.000000)), Nil)), Nil)), Nil)), Nil)), Nil)))])));
    test 11 (sexpr_eq_as_list (execute_read_sexprs_as_list "(andmap (lambda (x) (= x 3)) `(3.0 ,(/ 6 2)))") (execute_expected_as_list([Pair (Symbol "andmap", Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), Pair (Pair (Symbol "=", Pair (Symbol "x", Pair (Number (Int (3)), Nil))), Nil))), Pair (Pair (Symbol "quasiquote", Pair (Pair (Number (Float (3.000000)), Pair (Pair (Symbol "unquote", Pair (Pair (Symbol "/", Pair (Number (Int (6)), Pair (Number (Int (2)), Nil))), Nil)), Nil)), Nil)), Nil)))])));
    test 12 (sexpr_eq_as_list (execute_read_sexprs_as_list "`(#;\"list of empty structures\" \n#() . (() \"\"))") (execute_expected_as_list([Pair (Symbol "quasiquote", Pair (Pair (Vector [], Pair (Nil, Pair (String "", Nil))), Nil))])));
    test 13 (sexpr_eq_as_list (execute_read_sexprs_as_list "(- 3 (- 9.1 6.12)) ...") (execute_expected_as_list([Pair (Symbol "-", Pair (Number (Int (3)), Pair (Pair (Symbol "-", Pair (Number (Float (9.100000)), Pair (Number (Float (6.120000)), Nil))), Nil)))])));
    test 14 (sexpr_eq_as_list (execute_read_sexprs_as_list "3e-3") (execute_expected_as_list([Number (Float (0.003000))])));
    test 15 (sexpr_eq_as_list (execute_read_sexprs_as_list "(almost-fact [fact])") (execute_expected_as_list([Pair (Symbol "almost-fact", Pair (Pair (Symbol "fact", Nil), Nil))])));
    test 16 (sexpr_eq_as_list (execute_read_sexprs_as_list "(define . (add1 .((lambda (x) \n(+ x -1/1) . ()))))") (execute_expected_as_list([Pair (Symbol "define", Pair (Symbol "add1", Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), Pair (Pair (Symbol "+", Pair (Symbol "x", Pair (Symbol "-1/1", Nil))), Nil))), Nil)))])));
    test 17 (sexpr_eq_as_list (execute_read_sexprs_as_list "(eq? `(,@(list x)) . `(x . ()))") (execute_expected_as_list([Pair (Symbol "eq?", Pair (Pair (Symbol "quasiquote", Pair (Pair (Pair (Symbol "unquote-splicing", Pair (Pair (Symbol "list", Pair (Symbol "x", Nil)), Nil)), Nil), Nil)), Pair (Symbol "quasiquote", Pair (Pair (Symbol "x", Nil), Nil))))])));
    test 18 (sexpr_eq_as_list (execute_read_sexprs_as_list "(+ 1.0 (* 2  [(3) ... 4e5 ...") (execute_expected_as_list([Pair (Symbol "+", Pair (Number (Float (1.000000)), Pair (Pair (Symbol "*", Pair (Number (Int (2)), Pair (Pair (Pair (Number (Int (3)), Nil), Nil), Nil))), Nil)));Number (Float (400000.000000))])));
    test 19 (sexpr_eq_as_list (execute_read_sexprs_as_list "(let ((x 1)) \n(eq? (add1 x) (add1 x)))") (execute_expected_as_list([Pair (Symbol "let", Pair (Pair (Pair (Symbol "x", Pair (Number (Int (1)), Nil)), Nil), Pair (Pair (Symbol "eq?", Pair (Pair (Symbol "add1", Pair (Symbol "x", Nil)), Pair (Pair (Symbol "add1", Pair (Symbol "x", Nil)), Nil))), Nil)))])));
    test 20 (sexpr_eq_as_list (execute_read_sexprs_as_list "[a . (b 1.2 1 . 2 ) ...") (execute_expected_as_list([Pair (Symbol "a", Pair (Symbol "b", Pair (Number (Float (1.200000)), Pair (Number (Int (1)), Number (Int (2))))))])));
    test 21 (sexpr_eq_as_list (execute_read_sexprs_as_list "(define foo \n(lambda (n) \n   (if [zero? 1]  [* n (foo (- n 1))])))") (execute_expected_as_list([Pair (Symbol "define", Pair (Symbol "foo", Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "n", Nil), Pair (Pair (Symbol "if", Pair (Pair (Symbol "zero?", Pair (Number (Int (1)), Nil)), Pair (Pair (Symbol "*", Pair (Symbol "n", Pair (Pair (Symbol "foo", Pair (Pair (Symbol "-", Pair (Symbol "n", Pair (Number (Int (1)), Nil))), Nil)), Nil))), Nil))), Nil))), Nil)))])));
    test 22 (sexpr_eq_as_list (execute_read_sexprs_as_list "(define  x '`(,`1))") (execute_expected_as_list([Pair (Symbol "define", Pair (Symbol "x", Pair (Pair (Symbol "quote", Pair (Pair (Symbol "quasiquote", Pair (Pair (Pair (Symbol "unquote", Pair (Pair (Symbol "quasiquote", Pair (Number (Int (1)), Nil)), Nil)), Nil), Nil)), Nil)), Nil)))])));
    test 23 (sexpr_eq_as_list (execute_read_sexprs_as_list "-1.2e3 2e+3 +3.4e5") (execute_expected_as_list([Number (Float (-1200.000000));Number (Float (2000.000000));Number (Float (340000.000000))])));
    test 24 (sexpr_eq_as_list (execute_read_sexprs_as_list "#(#\\( #\\x29)") (execute_expected_as_list([Vector [Char '(';Char ')']])));
    test 25 (sexpr_eq_as_list (execute_read_sexprs_as_list "[(foo (add1 x)) (- x 1 ...") (execute_expected_as_list([Pair (Pair (Symbol "foo", Pair (Pair (Symbol "add1", Pair (Symbol "x", Nil)), Nil)), Pair (Pair (Symbol "-", Pair (Symbol "x", Pair (Number (Int (1)), Nil))), Nil))])));
    test 26 (sexpr_eq_as_list (execute_read_sexprs_as_list "#;(this is a \n#;(nested sexpr comment)\n   followed by more comment\n    )#\\x26 39") (execute_expected_as_list([Char '&';Number (Int (39))])));
    test 27 (sexpr_eq_as_list (execute_read_sexprs_as_list "(-1.0 #;(not really here)2/4...") (execute_expected_as_list([Pair (Number (Float (-1.000000)), Pair (Symbol "2/4", Nil))])));
    test 28 (sexpr_eq_as_list (execute_read_sexprs_as_list "\"\\x3a 1 2\"") (execute_expected_as_list([String("test failed")])));
    test 29 (sexpr_eq_as_list (execute_read_sexprs_as_list "1e2a") (execute_expected_as_list([Symbol "1e2a"])));
    test 30 (sexpr_eq_as_list (execute_read_sexprs_as_list "(let ((result `(,4e+3 ,@e-3)))  \n  result)") (execute_expected_as_list([Pair (Symbol "let", Pair (Pair (Pair (Symbol "result", Pair (Pair (Symbol "quasiquote", Pair (Pair (Pair (Symbol "unquote", Pair (Number (Float (4000.000000)), Nil)), Pair (Pair (Symbol "unquote-splicing", Pair (Symbol "e-3", Nil)), Nil)), Nil)), Nil)), Nil), Pair (Symbol "result", Nil)))])));
    test 31 (sexpr_eq_as_list (execute_read_sexprs_as_list "[a[a[a[a 0.000000000000000000001]]]]") (execute_expected_as_list([Pair (Symbol "a", Pair (Pair (Symbol "a", Pair (Pair (Symbol "a", Pair (Pair (Symbol "a", Pair (Number (Float (0.000000)), Nil)), Nil)), Nil)), Nil))])));
    test 32 (sexpr_eq_as_list (execute_read_sexprs_as_list "(define pi -4e-1) atan(1 ...") (execute_expected_as_list([Pair (Symbol "define", Pair (Symbol "pi", Pair (Number (Float (-0.400000)), Nil)));Symbol "atan";Pair (Number (Int (1)), Nil)])));
    test 33 (sexpr_eq_as_list (execute_read_sexprs_as_list "'(#x2f #\\x30 #xa #\\xa)") (execute_expected_as_list([Pair (Symbol "quote", Pair (Pair (Number (Int (47)), Pair (Char '0', Pair (Number (Int (10)), Pair (Char '\n', Nil)))), Nil))])));
    test 34 (sexpr_eq_as_list (execute_read_sexprs_as_list "(+ 2 #;3 8)") (execute_expected_as_list([Pair (Symbol "+", Pair (Number (Int (2)), Pair (Number (Int (8)), Nil)))])));
    test 35 (sexpr_eq_as_list (execute_read_sexprs_as_list "the answer is: (* 2 (+ 3 (* 4 5 ... and this is the rest of the list") (execute_expected_as_list([Symbol "the";Symbol "answer";Symbol "is:";Pair (Symbol "*", Pair (Number (Int (2)), Pair (Pair (Symbol "+", Pair (Number (Int (3)), Pair (Pair (Symbol "*", Pair (Number (Int (4)), Pair (Number (Int (5)), Nil))), Nil))), Nil)));Symbol "and";Symbol "this";Symbol "is";Symbol "the";Symbol "rest";Symbol "of";Symbol "the";Symbol "list"])));
    test 36 (sexpr_eq_as_list (execute_read_sexprs_as_list "(foo -x 4 +y)") (execute_expected_as_list([Pair (Symbol "foo", Pair (Symbol "-x", Pair (Number (Int (4)), Pair (Symbol "+y", Nil))))])));
    test 37 (sexpr_eq_as_list (execute_read_sexprs_as_list "#x5\n#x6.a\n#x7E3") (execute_expected_as_list([Number (Int (5));Number (Float (6.625000));Number (Int (2019))])));
    test 38 (sexpr_eq_as_list (execute_read_sexprs_as_list "(+ 1 \n(1.(a 1.12345678901234567 (a.1))) \n\n(third argument) \n(fourth argument) \n[fifth argument]\n)") (execute_expected_as_list([Pair (Symbol "+", Pair (Number (Int (1)), Pair (Pair (Number (Int (1)), Pair (Symbol "a", Pair (Number (Float (1.123457)), Pair (Pair (Symbol "a", Number (Int (1))), Nil)))), Pair (Pair (Symbol "third", Pair (Symbol "argument", Nil)), Pair (Pair (Symbol "fourth", Pair (Symbol "argument", Nil)), Pair (Pair (Symbol "fifth", Pair (Symbol "argument", Nil)), Nil))))))])));
    test 39 (sexpr_eq_as_list (execute_read_sexprs_as_list "(#\\newline #\\page #\\return #\\space #\\tab #\\newLINe #\\paGE #\\retURN #\\spACE #\\TaB)") (execute_expected_as_list([Pair (Char '\n', Pair (Char (Char.chr 12), Pair (Char '\r', Pair (Char ' ', Pair (Char '\t', Pair (Char '\n', Pair (Char (Char.chr 12), Pair (Char '\r', Pair (Char ' ', Pair (Char '\t', Nil))))))))))])));
    ;;

let test_FINAL_PROJECT_STDLIB_ = fun () ->
    current_test := "test_FINAL_PROJECT_STDLIB_";
    test 1 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define append
      (let ((null? null?) (car car) (cdr cdr) (cons cons))
        (lambda args
          ((letrec ((f (lambda (ls args)
                        (if (null? args)
                            ls
                            ((letrec ((g (lambda (ls)
                                            (if (null? ls)
                                                (f (car args) (cdr args))
                                                (cons (car ls) (g (cdr ls)))))))
                                g) ls)))))
            f) '() args))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("append"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Pair(Pair(Symbol("cons"),Pair(Symbol("cons"),Nil)),Nil)))),Pair(Pair(Symbol("lambda"),Pair(Symbol("args"),Pair(Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("f"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("ls"),Pair(Symbol("args"),Nil)),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("args"),Nil)),Pair(Symbol("ls"),Pair(Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("g"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("ls"),Nil),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("ls"),Nil)),Pair(Pair(Symbol("f"),Pair(Pair(Symbol("car"),Pair(Symbol("args"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("args"),Nil)),Nil))),Pair(Pair(Symbol("cons"),Pair(Pair(Symbol("car"),Pair(Symbol("ls"),Nil)),Pair(Pair(Symbol("g"),Pair(Pair(Symbol("cdr"),Pair(Symbol("ls"),Nil)),Nil)),Nil))),Nil)))),Nil))),Nil)),Nil),Pair(Symbol("g"),Nil))),Pair(Symbol("ls"),Nil)),Nil)))),Nil))),Nil)),Nil),Pair(Symbol("f"),Nil))),Pair(Pair(Symbol("quote"),Pair(Nil,Nil)),Pair(Symbol("args"),Nil))),Nil))),Nil))),Nil))); ])));
  test 2 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define zero? 
      (let ((= =))
        (lambda (x) (= x 0))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("zero?"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("="),Pair(Symbol("="),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Nil),Pair(Pair(Symbol("="),Pair(Symbol("x"),Pair(Number(Int(0)),Nil))),Nil))),Nil))),Nil))); ])));
  test 3 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define list (lambda x x))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("list"),Pair(Pair(Symbol("lambda"),Pair(Symbol("x"),Pair(Symbol("x"),Nil))),Nil))); ])));
  test 4 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define list? 
      (let ((null? null?) (pair? pair?) (cdr cdr))
        (lambda (x)
          (or (null? x)
        (and (pair? x) (list? (cdr x)))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("list?"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("pair?"),Pair(Symbol("pair?"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil))),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Nil),Pair(Pair(Symbol("or"),Pair(Pair(Symbol("null?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("pair?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("list?"),Pair(Pair(Symbol("cdr"),Pair(Symbol("x"),Nil)),Nil)),Nil))),Nil))),Nil))),Nil))),Nil))); ])));
  test 5 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define length
      (let ((null? null?) (pair? pair?) (cdr cdr) (+ +))
        (lambda (x)
          (letrec ((count 0) (loop (lambda (lst count)
            (cond ((null? lst) count)
                  ((pair? lst) (loop (cdr lst) (+ 1 count)))
                  (else \"this should be an error, but you don't support exceptions\")))))
      (loop x 0)))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("length"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("pair?"),Pair(Symbol("pair?"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Pair(Pair(Symbol("+"),Pair(Symbol("+"),Nil)),Nil)))),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Nil),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("count"),Pair(Number(Int(0)),Nil)),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("lst"),Pair(Symbol("count"),Nil)),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(Symbol("count"),Nil)),Pair(Pair(Pair(Symbol("pair?"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("+"),Pair(Number(Int(1)),Pair(Symbol("count"),Nil))),Nil))),Nil)),Pair(Pair(Symbol("else"),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Nil)))),Nil))),Nil)),Nil)),Pair(Pair(Symbol("loop"),Pair(Symbol("x"),Pair(Number(Int(0)),Nil))),Nil))),Nil))),Nil))),Nil))); ])));
  test 6 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define make-string
      (let ((null? null?)(car car)(= =)(length length))
        (lambda (x . y)
          (cond ((null? y) (make-string x #\\nul))
          ((= 1 (length y)) (make-string x (car y)))
          (else \"this should be an error, but you don't support exceptions\")))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("make-string"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("="),Pair(Symbol("="),Nil)),Pair(Pair(Symbol("length"),Pair(Symbol("length"),Nil)),Nil)))),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Symbol("y")),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("make-string"),Pair(Symbol("x"),Pair(Char(char_of_int 0),Nil))),Nil)),Pair(Pair(Pair(Symbol("="),Pair(Number(Int(1)),Pair(Pair(Symbol("length"),Pair(Symbol("y"),Nil)),Nil))),Pair(Pair(Symbol("make-string"),Pair(Symbol("x"),Pair(Pair(Symbol("car"),Pair(Symbol("y"),Nil)),Nil))),Nil)),Pair(Pair(Symbol("else"),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Nil)))),Nil))),Nil))),Nil))); ])));
  test 7 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define make-vector
      (let ((length length) (car car)(null? null?))
        (lambda (x . y)
          (cond ((null? y) (make-vector x 0))
          ((= 1 (length y)) (make-vector x (car y)))
          (else \"this should be an error, but you don't support exceptions\")))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("make-vector"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("length"),Pair(Symbol("length"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Nil))),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Symbol("y")),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("make-vector"),Pair(Symbol("x"),Pair(Number(Int(0)),Nil))),Nil)),Pair(Pair(Pair(Symbol("="),Pair(Number(Int(1)),Pair(Pair(Symbol("length"),Pair(Symbol("y"),Nil)),Nil))),Pair(Pair(Symbol("make-vector"),Pair(Symbol("x"),Pair(Pair(Symbol("car"),Pair(Symbol("y"),Nil)),Nil))),Nil)),Pair(Pair(Symbol("else"),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Nil)))),Nil))),Nil))),Nil))); ])));
  test 8 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define not
      (let ((eq? eq?))
        (lambda (x)
          (if (eq? x #t) #f #t))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("not"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("eq?"),Pair(Symbol("eq?"),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Nil),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("eq?"),Pair(Symbol("x"),Pair(Bool(true),Nil))),Pair(Bool(false),Pair(Bool(true),Nil)))),Nil))),Nil))),Nil))); ])));
  test 9 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define number?
      (let ((float? float?) (integer? integer?))
        (lambda (x)
          (or (float? x) (integer? x)))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("number?"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("float?"),Pair(Symbol("float?"),Nil)),Pair(Pair(Symbol("integer?"),Pair(Symbol("integer?"),Nil)),Nil)),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Nil),Pair(Pair(Symbol("or"),Pair(Pair(Symbol("float?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("integer?"),Pair(Symbol("x"),Nil)),Nil))),Nil))),Nil))),Nil))); ])));
  test 10 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define map
      (let ((null? null?) (cons cons) (apply apply) (car car) (cdr cdr))
        (lambda (f ls . more)
          (if (null? more)
        (let ([ls ls])
          (letrec ((map1 (lambda (ls) 
              (if (null? ls)
            '()
            (cons (f (car ls))
                  (map1 (cdr ls)))) )))
            (map1 ls))
          )
        (let ([ls ls] [more more])
          (letrec ((map-more (lambda (ls more)
            (if (null? ls)
                '()
                (cons
                  (apply f (car ls) (map car more))
                  (map-more (cdr ls) (map cdr more)))))))
            (map-more ls more))
          )))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("map"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("cons"),Pair(Symbol("cons"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("apply"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil))))),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("f"),Pair(Symbol("ls"),Symbol("more"))),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("more"),Nil)),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("ls"),Pair(Symbol("ls"),Nil)),Nil),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("map1"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("ls"),Nil),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("ls"),Nil)),Pair(Pair(Symbol("quote"),Pair(Nil,Nil)),Pair(Pair(Symbol("cons"),Pair(Pair(Symbol("f"),Pair(Pair(Symbol("car"),Pair(Symbol("ls"),Nil)),Nil)),Pair(Pair(Symbol("map1"),Pair(Pair(Symbol("cdr"),Pair(Symbol("ls"),Nil)),Nil)),Nil))),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("map1"),Pair(Symbol("ls"),Nil)),Nil))),Nil))),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("ls"),Pair(Symbol("ls"),Nil)),Pair(Pair(Symbol("more"),Pair(Symbol("more"),Nil)),Nil)),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("map-more"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("ls"),Pair(Symbol("more"),Nil)),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("ls"),Nil)),Pair(Pair(Symbol("quote"),Pair(Nil,Nil)),Pair(Pair(Symbol("cons"),Pair(Pair(Symbol("apply"),Pair(Symbol("f"),Pair(Pair(Symbol("car"),Pair(Symbol("ls"),Nil)),Pair(Pair(Symbol("map"),Pair(Symbol("car"),Pair(Symbol("more"),Nil))),Nil)))),Pair(Pair(Symbol("map-more"),Pair(Pair(Symbol("cdr"),Pair(Symbol("ls"),Nil)),Pair(Pair(Symbol("map"),Pair(Symbol("cdr"),Pair(Symbol("more"),Nil))),Nil))),Nil))),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("map-more"),Pair(Symbol("ls"),Pair(Symbol("more"),Nil))),Nil))),Nil))),Nil)))),Nil))),Nil))),Nil))); ])));
  test 11 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define list->vector
      (let ((null? null?)(pair? pair?)(car car)(cdr cdr)(make-vector make-vector)(length length)(+ +))
        (lambda (lst)
          (letrec ((loop (lambda (lst vec count)
              (cond ((null? lst) vec)
              ((pair? lst) (loop (cdr lst) (begin (vector-set! vec count (car lst)) vec) (+ 1 count)))
              (else \"this should be an error, but you don't support exceptions\")))))
      (loop lst (make-vector (length lst)) 0)))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("list->vector"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("pair?"),Pair(Symbol("pair?"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Pair(Pair(Symbol("make-vector"),Pair(Symbol("make-vector"),Nil)),Pair(Pair(Symbol("length"),Pair(Symbol("length"),Nil)),Pair(Pair(Symbol("+"),Pair(Symbol("+"),Nil)),Nil))))))),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("lst"),Nil),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("lst"),Pair(Symbol("vec"),Pair(Symbol("count"),Nil))),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(Symbol("vec"),Nil)),Pair(Pair(Pair(Symbol("pair?"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("begin"),Pair(Pair(Symbol("vector-set!"),Pair(Symbol("vec"),Pair(Symbol("count"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Nil)))),Pair(Symbol("vec"),Nil))),Pair(Pair(Symbol("+"),Pair(Number(Int(1)),Pair(Symbol("count"),Nil))),Nil)))),Nil)),Pair(Pair(Symbol("else"),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("loop"),Pair(Symbol("lst"),Pair(Pair(Symbol("make-vector"),Pair(Pair(Symbol("length"),Pair(Symbol("lst"),Nil)),Nil)),Pair(Number(Int(0)),Nil)))),Nil))),Nil))),Nil))),Nil))); ])));
  test 12 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define vector->list
      (let ((< <)(vector-ref vector-ref)(cons cons)(vector-length vector-length)(- -))
        (lambda (vec)
          (letrec ((loop (lambda (vec lst count)
              (cond ((< count 0) lst)
              (else (loop vec (cons (vector-ref vec count) lst) (- count 1)))))))
      (loop vec '() (- (vector-length vec) 1))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("vector->list"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("<"),Pair(Symbol("<"),Nil)),Pair(Pair(Symbol("vector-ref"),Pair(Symbol("vector-ref"),Nil)),Pair(Pair(Symbol("cons"),Pair(Symbol("cons"),Nil)),Pair(Pair(Symbol("vector-length"),Pair(Symbol("vector-length"),Nil)),Pair(Pair(Symbol("-"),Pair(Symbol("-"),Nil)),Nil))))),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("vec"),Nil),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("vec"),Pair(Symbol("lst"),Pair(Symbol("count"),Nil))),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("<"),Pair(Symbol("count"),Pair(Number(Int(0)),Nil))),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("else"),Pair(Pair(Symbol("loop"),Pair(Symbol("vec"),Pair(Pair(Symbol("cons"),Pair(Pair(Symbol("vector-ref"),Pair(Symbol("vec"),Pair(Symbol("count"),Nil))),Pair(Symbol("lst"),Nil))),Pair(Pair(Symbol("-"),Pair(Symbol("count"),Pair(Number(Int(1)),Nil))),Nil)))),Nil)),Nil))),Nil))),Nil)),Nil),Pair(Pair(Symbol("loop"),Pair(Symbol("vec"),Pair(Pair(Symbol("quote"),Pair(Nil,Nil)),Pair(Pair(Symbol("-"),Pair(Pair(Symbol("vector-length"),Pair(Symbol("vec"),Nil)),Pair(Number(Int(1)),Nil))),Nil)))),Nil))),Nil))),Nil))),Nil))); ])));
  test 13 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define vector
      (let ((list->vector list->vector))
        (lambda x (list->vector x))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("vector"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("list->vector"),Pair(Symbol("list->vector"),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Symbol("x"),Pair(Pair(Symbol("list->vector"),Pair(Symbol("x"),Nil)),Nil))),Nil))),Nil))); ] )));
  test 14 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define +
      (let ((null? null?)(+ +)(car car)(apply apply)(cdr cdr))
        (letrec ((loop (lambda x (if (null? x) 0 (+ (car x) (apply loop (cdr x)))))))
          loop)))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("+"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("+"),Pair(Symbol("+"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("apply"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil))))),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Symbol("x"),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("x"),Nil)),Pair(Number(Int(0)),Pair(Pair(Symbol("+"),Pair(Pair(Symbol("car"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("loop"),Pair(Pair(Symbol("cdr"),Pair(Symbol("x"),Nil)),Nil))),Nil))),Nil)))),Nil))),Nil)),Nil),Pair(Symbol("loop"),Nil))),Nil))),Nil))); ])));
  test 15 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define *
      (let ((null? null?)(* *)(car car)(apply apply)(cdr cdr))
        (letrec ((loop (lambda x (if (null? x) 1 (* (car x) (apply loop (cdr x)))))))
          loop)))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("*"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("*"),Pair(Symbol("*"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("apply"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil))))),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Symbol("x"),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("x"),Nil)),Pair(Number(Int(1)),Pair(Pair(Symbol("*"),Pair(Pair(Symbol("car"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("loop"),Pair(Pair(Symbol("cdr"),Pair(Symbol("x"),Nil)),Nil))),Nil))),Nil)))),Nil))),Nil)),Nil),Pair(Symbol("loop"),Nil))),Nil))),Nil))); ])));
  test 16 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define -
      (let ((null? null?)(- -)(+ +)(car car)(apply apply)(length length)(cdr cdr))
        (letrec ((loop (lambda x (if (null? x) 0 (- (apply loop (cdr x)) (car x) )))))
          (lambda num
      (cond ((null? num) \"this should be an error, but you don't support exceptions\")
            ((= (length num) 1) (- 0 (car num)))
            (else (+ (car num) (apply loop (cdr num)))))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("-"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("-"),Pair(Symbol("-"),Nil)),Pair(Pair(Symbol("+"),Pair(Symbol("+"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("apply"),Nil)),Pair(Pair(Symbol("length"),Pair(Symbol("length"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil))))))),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Symbol("x"),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("x"),Nil)),Pair(Number(Int(0)),Pair(Pair(Symbol("-"),Pair(Pair(Symbol("apply"),Pair(Symbol("loop"),Pair(Pair(Symbol("cdr"),Pair(Symbol("x"),Nil)),Nil))),Pair(Pair(Symbol("car"),Pair(Symbol("x"),Nil)),Nil))),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Symbol("num"),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("num"),Nil)),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Pair(Pair(Pair(Symbol("="),Pair(Pair(Symbol("length"),Pair(Symbol("num"),Nil)),Pair(Number(Int(1)),Nil))),Pair(Pair(Symbol("-"),Pair(Number(Int(0)),Pair(Pair(Symbol("car"),Pair(Symbol("num"),Nil)),Nil))),Nil)),Pair(Pair(Symbol("else"),Pair(Pair(Symbol("+"),Pair(Pair(Symbol("car"),Pair(Symbol("num"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("loop"),Pair(Pair(Symbol("cdr"),Pair(Symbol("num"),Nil)),Nil))),Nil))),Nil)),Nil)))),Nil))),Nil))),Nil))),Nil))); ])));
  test 17 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define /
      (let ((null? null?)(/ /)(* *)(car car)(apply apply)(length length)(cdr cdr))
        (lambda num
          (cond ((null? num) \"this should be an error, but you don't support exceptions\")
          ((= (length num) 1) (/ 1 (car num)))
          (else (/ (car num) (apply * (cdr num))))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("/"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("/"),Pair(Symbol("/"),Nil)),Pair(Pair(Symbol("*"),Pair(Symbol("*"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("apply"),Nil)),Pair(Pair(Symbol("length"),Pair(Symbol("length"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil))))))),Pair(Pair(Symbol("lambda"),Pair(Symbol("num"),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("num"),Nil)),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Pair(Pair(Pair(Symbol("="),Pair(Pair(Symbol("length"),Pair(Symbol("num"),Nil)),Pair(Number(Int(1)),Nil))),Pair(Pair(Symbol("/"),Pair(Number(Int(1)),Pair(Pair(Symbol("car"),Pair(Symbol("num"),Nil)),Nil))),Nil)),Pair(Pair(Symbol("else"),Pair(Pair(Symbol("/"),Pair(Pair(Symbol("car"),Pair(Symbol("num"),Nil)),Pair(Pair(Symbol("apply"),Pair(Symbol("*"),Pair(Pair(Symbol("cdr"),Pair(Symbol("num"),Nil)),Nil))),Nil))),Nil)),Nil)))),Nil))),Nil))),Nil))); ])));    
  test 18 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define =
      (let ((null? null?)(= =)(car car)(cdr cdr))
        (letrec ((loop (lambda (element lst) (if 
                (null? lst) 
                #t 
                (if 
                (= element (car lst))
                (loop (car lst) (cdr lst))
                #f)
                ))))
          (lambda lst
      (cond ((null? lst) \"this should be an error, but you don't support exceptions\")
            (else (loop (car lst) (cdr lst))))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("="),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("="),Pair(Symbol("="),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil)))),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("element"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(Bool(true),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("="),Pair(Symbol("element"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Nil))),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Nil))),Pair(Bool(false),Nil)))),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Symbol("lst"),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Pair(Pair(Symbol("else"),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Nil))),Nil)),Nil))),Nil))),Nil))),Nil))),Nil))); ])));
  test 19 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define <
      (let ((null? null?)(< <)(car car)(cdr cdr))
        (letrec ((loop (lambda (element lst) (if 
                (null? lst) 
                #t 
                (if 
                (< element (car lst))
                (loop (car lst) (cdr lst))
                #f)
                ))))
          (lambda lst
      (cond ((null? lst) \"this should be an error, but you don't support exceptions\")
            (else (loop (car lst) (cdr lst))))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("<"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("<"),Pair(Symbol("<"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil)))),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("element"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(Bool(true),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("<"),Pair(Symbol("element"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Nil))),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Nil))),Pair(Bool(false),Nil)))),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Symbol("lst"),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Pair(Pair(Symbol("else"),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Nil))),Nil)),Nil))),Nil))),Nil))),Nil))),Nil))); ])));
  test 20 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define >
      (let ((null? null?)(< <)(= =)(not not)(car car)(cdr cdr))
        (letrec ((loop (lambda (element lst) (if 
                (null? lst) 
                #t 
                (if 
                (not (or (< element (car lst)) (= element (car lst))))
                (loop (car lst) (cdr lst))
                #f)
                ))))
          (lambda lst
      (cond ((null? lst) \"this should be an error, but you don't support exceptions\")
            (else (loop (car lst) (cdr lst))))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol(">"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("null?"),Nil)),Pair(Pair(Symbol("<"),Pair(Symbol("<"),Nil)),Pair(Pair(Symbol("="),Pair(Symbol("="),Nil)),Pair(Pair(Symbol("not"),Pair(Symbol("not"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Nil)))))),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("element"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(Bool(true),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("not"),Pair(Pair(Symbol("or"),Pair(Pair(Symbol("<"),Pair(Symbol("element"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Nil))),Pair(Pair(Symbol("="),Pair(Symbol("element"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Nil))),Nil))),Nil)),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Nil))),Pair(Bool(false),Nil)))),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Symbol("lst"),Pair(Pair(Symbol("cond"),Pair(Pair(Pair(Symbol("null?"),Pair(Symbol("lst"),Nil)),Pair(String("this should be an error, but you don't support exceptions"),Nil)),Pair(Pair(Symbol("else"),Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("car"),Pair(Symbol("lst"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("lst"),Nil)),Nil))),Nil)),Nil))),Nil))),Nil))),Nil))),Nil))); ])));
  test 21 (sexpr_eq_as_list (execute_read_sexprs_as_list 
    "(define equal?
      (let ((< <)(= =)(not not)(string-length string-length)(string-ref string-ref)(vector-ref vector-ref)(vector-length vector-length)(integer? integer?) (float? float?) (pair? pair?) (char? char?) (string? string?)(vector? vector?)(eq? eq?)(car car)(cdr cdr)(char->integer char->integer)(- -))
        (let ((compare-composite (lambda (container-1 container-2 container-ref-fun container-size-fun)
                (letrec ((loop (lambda (container-1 container-2 container-ref-fun 				index)
                (if (< index 0)
                    #t
                    (and (equal? (container-ref-fun container-1 index) (container-ref-fun container-2 index)) (loop container-1 container-2 container-ref-fun (- index 1)))))))
            (if (not (= (container-size-fun container-1) (container-size-fun container-2)))
                #f
                (loop container-1 container-2 container-ref-fun (- (container-size-fun container-1) 1)))))))
          
          (lambda (x y)
      (or 
      (and (integer? x) (integer? y) (= x y))
      (and (float? x) (float? y) (= x y))
      (and (pair? x) (pair? y) (equal? (car x) (car y)) (equal? (cdr x) (cdr y)))
      (and (char? x) (char? y) (= (char->integer x) (char->integer y)))
      (and (string? x) (string? y) (compare-composite x y string-ref string-length))
      (and (vector? x) (vector? y) (compare-composite x y vector-ref vector-length))
      (eq? x y))))))"
      ) (execute_expected_as_list([ Pair(Symbol("define"),Pair(Symbol("equal?"),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("<"),Pair(Symbol("<"),Nil)),Pair(Pair(Symbol("="),Pair(Symbol("="),Nil)),Pair(Pair(Symbol("not"),Pair(Symbol("not"),Nil)),Pair(Pair(Symbol("string-length"),Pair(Symbol("string-length"),Nil)),Pair(Pair(Symbol("string-ref"),Pair(Symbol("string-ref"),Nil)),Pair(Pair(Symbol("vector-ref"),Pair(Symbol("vector-ref"),Nil)),Pair(Pair(Symbol("vector-length"),Pair(Symbol("vector-length"),Nil)),Pair(Pair(Symbol("integer?"),Pair(Symbol("integer?"),Nil)),Pair(Pair(Symbol("float?"),Pair(Symbol("float?"),Nil)),Pair(Pair(Symbol("pair?"),Pair(Symbol("pair?"),Nil)),Pair(Pair(Symbol("char?"),Pair(Symbol("char?"),Nil)),Pair(Pair(Symbol("string?"),Pair(Symbol("string?"),Nil)),Pair(Pair(Symbol("vector?"),Pair(Symbol("vector?"),Nil)),Pair(Pair(Symbol("eq?"),Pair(Symbol("eq?"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("car"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("cdr"),Nil)),Pair(Pair(Symbol("char->integer"),Pair(Symbol("char->integer"),Nil)),Pair(Pair(Symbol("-"),Pair(Symbol("-"),Nil)),Nil)))))))))))))))))),Pair(Pair(Symbol("let"),Pair(Pair(Pair(Symbol("compare-composite"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("container-1"),Pair(Symbol("container-2"),Pair(Symbol("container-ref-fun"),Pair(Symbol("container-size-fun"),Nil)))),Pair(Pair(Symbol("letrec"),Pair(Pair(Pair(Symbol("loop"),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("container-1"),Pair(Symbol("container-2"),Pair(Symbol("container-ref-fun"),Pair(Symbol("index"),Nil)))),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("<"),Pair(Symbol("index"),Pair(Number(Int(0)),Nil))),Pair(Bool(true),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("equal?"),Pair(Pair(Symbol("container-ref-fun"),Pair(Symbol("container-1"),Pair(Symbol("index"),Nil))),Pair(Pair(Symbol("container-ref-fun"),Pair(Symbol("container-2"),Pair(Symbol("index"),Nil))),Nil))),Pair(Pair(Symbol("loop"),Pair(Symbol("container-1"),Pair(Symbol("container-2"),Pair(Symbol("container-ref-fun"),Pair(Pair(Symbol("-"),Pair(Symbol("index"),Pair(Number(Int(1)),Nil))),Nil))))),Nil))),Nil)))),Nil))),Nil)),Nil),Pair(Pair(Symbol("if"),Pair(Pair(Symbol("not"),Pair(Pair(Symbol("="),Pair(Pair(Symbol("container-size-fun"),Pair(Symbol("container-1"),Nil)),Pair(Pair(Symbol("container-size-fun"),Pair(Symbol("container-2"),Nil)),Nil))),Nil)),Pair(Bool(false),Pair(Pair(Symbol("loop"),Pair(Symbol("container-1"),Pair(Symbol("container-2"),Pair(Symbol("container-ref-fun"),Pair(Pair(Symbol("-"),Pair(Pair(Symbol("container-size-fun"),Pair(Symbol("container-1"),Nil)),Pair(Number(Int(1)),Nil))),Nil))))),Nil)))),Nil))),Nil))),Nil)),Nil),Pair(Pair(Symbol("lambda"),Pair(Pair(Symbol("x"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("or"),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("integer?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("integer?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("="),Pair(Symbol("x"),Pair(Symbol("y"),Nil))),Nil)))),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("float?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("float?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("="),Pair(Symbol("x"),Pair(Symbol("y"),Nil))),Nil)))),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("pair?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("pair?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("equal?"),Pair(Pair(Symbol("car"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("car"),Pair(Symbol("y"),Nil)),Nil))),Pair(Pair(Symbol("equal?"),Pair(Pair(Symbol("cdr"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("cdr"),Pair(Symbol("y"),Nil)),Nil))),Nil))))),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("char?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("char?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("="),Pair(Pair(Symbol("char->integer"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("char->integer"),Pair(Symbol("y"),Nil)),Nil))),Nil)))),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("string?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("string?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("compare-composite"),Pair(Symbol("x"),Pair(Symbol("y"),Pair(Symbol("string-ref"),Pair(Symbol("string-length"),Nil))))),Nil)))),Pair(Pair(Symbol("and"),Pair(Pair(Symbol("vector?"),Pair(Symbol("x"),Nil)),Pair(Pair(Symbol("vector?"),Pair(Symbol("y"),Nil)),Pair(Pair(Symbol("compare-composite"),Pair(Symbol("x"),Pair(Symbol("y"),Pair(Symbol("vector-ref"),Pair(Symbol("vector-length"),Nil))))),Nil)))),Pair(Pair(Symbol("eq?"),Pair(Symbol("x"),Pair(Symbol("y"),Nil))),Nil)))))))),Nil))),Nil))),Nil))),Nil))); ])));    
  ;;

let tests = test_Boolean_ :: test_Char_ :: test_Number_ :: test_String_ :: test_Symbol_ :: test_List_ :: test_DottedList_ :: test_Vector_ :: test_Quoted_ :: test_QuasiQuoted_ :: test_Unquoted_:: test_UnquotedSpliced_ :: test_LineComment_ :: test_SexprComment_ :: test_ReadSexpr_ :: test_ReadSexprs_ :: test_SceintificNotation_ :: test_ThreeDots_ :: test_CS_DEPARTMENT_ :: test_FINAL_PROJECT_STDLIB_ :: [];;

let rec start_tests = function 
    | curr_test :: [] -> (try curr_test () with exn -> Printf.printf "%s%s Failed with %s Exception%s\n" red !current_test (Printexc.to_string exn) reset)
    | curr_test :: next_tests -> (try curr_test () with exn -> Printf.printf "%s%s Failed with %s Exception%s\n" red !current_test (Printexc.to_string exn) reset); start_tests next_tests
    | _ -> raise (Fatal_error "unexpected problom in start_tests");;

start_prompt ();;

start_tests tests;;

end_prompt ();;







