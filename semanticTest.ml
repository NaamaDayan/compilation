(* semanticTest.ml
* Tests for semantic-analyser.ml
* Programmer: Nitsan Soffair and Amir Abramovich, 2018
*)

#use "semantic-analyser.ml";;

open Semantics;;
open Tag_Parser;;
open Reader;;
open PC;;

(* Colors for print *)
let red = "\027[38;5;196m";;
let grn = "\027[38;5;082m";;
let yel = "\027[38;5;226m";;
let mag = "\027[38;5;201m";;
let purple = "\027[0;35m";;
let cyan = "\027[0;36m";;
let reset = "\027[0m";;

(* Print # number of test that failed *)
let printFail failed = List.map (fun (n, b) -> Printf.printf "test %s %d %s failed\n" red n reset) failed;;

(* Got list of test that failed *)
let getFailed tests = List.filter (fun (n, e) -> e = false) tests;;

(* Print summary *)
let printSum color typ nfailed nsuccess = 
    (Printf.printf "\n%s%s tests: %s \nfailed- %s%d%s\npassed- %s%d%s\n\n" color typ reset red nfailed reset grn nsuccess reset);;

(* Helper function for test, print sum *)
let testSum color typ list = 
    let sum = List.length list in
    let failed = (getFailed list) in
    let nfailed = List.length failed in
    let nsuccess = sum - nfailed in
    (printSum color typ nfailed nsuccess);;

(* Helper function for test, print test that failed *)
let testFailed list = 
    let failed = (getFailed list) in
    (printFail failed);;

let allPassed color list = 
  let failed = (getFailed list) in
  if failed = [] then (Printf.printf "%sALL TESTS PASSED\n%s" color reset);;

(* Print message *)
let print color txt = (Printf.printf "%s*************************** %s *******************************%s\n" color txt reset);;

(* Compare expr', add support for Box *)
let rec expr'_eq e1 e2 =
  match e1, e2 with
    | Const' Void, Const' Void -> true
    | Const'(Sexpr s1), Const'(Sexpr s2) -> sexpr_eq s1 s2
    | Var'(VarFree v1), Var'(VarFree v2) -> String.equal v1 v2
    | Var'(VarParam (v1,mn1)), Var'(VarParam (v2,mn2)) -> String.equal v1 v2 && mn1 = mn2
    | Var'(VarBound (v1,mj1,mn1)), Var'(VarBound (v2,mj2,mn2)) -> String.equal v1 v2 && mj1 = mj2  && mn1 = mn2
    | Box' (VarFree v1), Box' (VarFree v2) | BoxGet' (VarFree v1), Box' (VarFree v2) ->  String.equal v1 v2
    | Box' (VarParam (v1,mn1)), Box' (VarParam (v2,mn2)) 
    | BoxGet' (VarParam (v1,mn1)), BoxGet' (VarParam (v2,mn2)) -> String.equal v1 v2 && mn1 = mn2
    | Box' (VarBound (v1,mj1,mn1)), Box' (VarBound (v2,mj2,mn2)) 
    | BoxGet' (VarBound (v1,mj1,mn1)), BoxGet'(VarBound (v2,mj2,mn2))-> String.equal v1 v2 && mj1 = mj2  && mn1 = mn2

    | BoxSet'(VarFree v1, e1), BoxSet'(VarFree v2, e2) -> expr'_eq e1 e2 && String.equal v1 v2
    | BoxSet'(VarParam (v1,mn1), e1), BoxSet'(VarParam (v2,mn2), e2) -> expr'_eq e1 e2 && String.equal v1 v2 && mn1 = mn2
    | BoxSet'(VarBound (v1,mj1,mn1), e1), BoxSet'(VarBound (v2,mj2,mn2), e2) -> 
      expr'_eq e1 e2 && String.equal v1 v2 && mj1 = mj2  && mn1 = mn2
    | If'(t1, th1, el1), If'(t2, th2, el2) -> (expr'_eq t1 t2) &&
                                              (expr'_eq th1 th2) &&
                                                (expr'_eq el1 el2)
    | (Seq'(l1), Seq'(l2)
    | Or'(l1), Or'(l2)) -> List.for_all2 expr'_eq l1 l2
    | (Set'(var1, val1), Set'(var2, val2)
    | Def'(var1, val1), Def'(var2, val2)) -> (expr'_eq var1 var2) &&
                                              (expr'_eq val1 val2)
    | LambdaSimple'(vars1, body1), LambdaSimple'(vars2, body2) ->
      (List.for_all2 String.equal vars1 vars2) &&
        (expr'_eq body1 body2)
    | LambdaOpt'(vars1, var1, body1), LambdaOpt'(vars2, var2, body2) ->
      (String.equal var1 var2) &&
        (List.for_all2 String.equal vars1 vars2) &&
          (expr'_eq body1 body2)
    | Applic'(e1, args1), Applic'(e2, args2)
    | ApplicTP'(e1, args1), ApplicTP'(e2, args2) ->
    (expr'_eq e1 e2) &&
      (List.for_all2 expr'_eq args1 args2)
    | _ -> false;;

print grn "START TESTS";;
 
 
(* Lexical address tests *)
let a1 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x)
    (list (lambda () x)
          (lambda (y) 
            (set! x y))))"))) (  LambdaSimple' (["x"],
                                Applic' (Var' (VarFree "list"),
                                [LambdaSimple' ([], Var' (VarBound ("x", 0, 0)));
                                  LambdaSimple' (["y"],
                                  Set' (Var' (VarBound ("x", 0, 0)), Var' (VarParam ("y", 0))))])));;
                                  
let a2 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y) (+ x y))"))) (  LambdaSimple' (["x"; "y"],
                                Applic' (Var' (VarFree "+"),
                                [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1))])));;

let a3 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z) (+ x y z))"))) (  LambdaSimple' (["x"; "y"; "z"],
                                Applic' (Var' (VarFree "+"),
                                [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1));
                                  Var' (VarParam ("z", 2))])));;

let a4 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z) (+ x y (lambda (z)(+ z 1))))"))) (LambdaSimple' (["x"; "y"; "z"],
                                                  Applic' (Var' (VarFree "+"),
                                                    [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1));
                                                    LambdaSimple' (["z"],
                                                      Applic' (Var' (VarFree "+"),
                                                      [Var' (VarParam ("z", 0)); Const' (Sexpr (Number (Int 1)))]))])));;

let a5 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z)
    (+ x y (lambda (z)
              (+ z x))))"))) (  LambdaSimple' (["x"; "y"; "z"],
                                                    Applic' (Var' (VarFree "+"),
                                                    [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1));
                                                      LambdaSimple' (["z"],
                                                      Applic' (Var' (VarFree "+"),
                                                        [Var' (VarParam ("z", 0)); Var' (VarBound ("x", 0, 0))]))])));;
 
let a6 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z) (+ x y (lambda (z)(+ z (lambda (z)(+ z y))))))"))) (  LambdaSimple' (["x"; "y"; "z"],
                                                                  Applic' (Var' (VarFree "+"),
                                                                  [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1));
                                                                    LambdaSimple' (["z"],
                                                                    Applic' (Var' (VarFree "+"),
                                                                      [Var' (VarParam ("z", 0));
                                                                      LambdaSimple' (["z"],
                                                                        Applic' (Var' (VarFree "+"),
                                                                        [Var' (VarParam ("z", 0)); Var' (VarBound ("y", 1, 1))]))]))])));;

let a7 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z) (+ x y (lambda (z)(+ z (lambda (x)(+ x y))))))"))) (  LambdaSimple' (["x"; "y"; "z"],
                                                                      Applic' (Var' (VarFree "+"),
                                                                      [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1));
                                                                        LambdaSimple' (["z"],
                                                                        Applic' (Var' (VarFree "+"),
                                                                          [Var' (VarParam ("z", 0));
                                                                          LambdaSimple' (["x"],
                                                                            Applic' (Var' (VarFree "+"),
                                                                            [Var' (VarParam ("x", 0)); Var' (VarBound ("y", 1, 1))]))]))])));;

let a8 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z) (+ x y (lambda (z)(+ z (lambda ()(+ x y))))))"))) (  LambdaSimple' (["x"; "y"; "z"],
                                                                    Applic' (Var' (VarFree "+"),
                                                                    [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1));
                                                                      LambdaSimple' (["z"],
                                                                      Applic' (Var' (VarFree "+"),
                                                                        [Var' (VarParam ("z", 0));
                                                                        LambdaSimple' ([],
                                                                          Applic' (Var' (VarFree "+"),
                                                                          [Var' (VarBound ("x", 1, 0)); Var' (VarBound ("y", 1, 1))]))]))])));;

let a9 = expr'_eq (annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z) (+ x y (lambda (z)(+ x y z (lambda ()(+ x y z))))))"))) (  LambdaSimple' (["x"; "y"; "z"],
                                                                          Applic' (Var' (VarFree "+"),
                                                                          [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1));
                                                                            LambdaSimple' (["z"],
                                                                            Applic' (Var' (VarFree "+"),
                                                                              [Var' (VarBound ("x", 0, 0)); Var' (VarBound ("y", 0, 1));
                                                                              Var' (VarParam ("z", 0));
                                                                              LambdaSimple' ([],
                                                                                Applic' (Var' (VarFree "+"),
                                                                                [Var' (VarBound ("x", 1, 0)); Var' (VarBound ("y", 1, 1));
                                                                                  Var' (VarBound ("z", 0, 0))]))]))])));;
 
let annotate_test = [(1, a1); (2, a2); (3, a3); (4, a4); (5, a5); (6, a6); (7, a7); (8, a8); (9, a9); ];;
(testSum mag "Annotate lexical" annotate_test);;
(testFailed annotate_test);;


(* Tail calls tests *)
let t1 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x) (f (g (g x))))")))) (  LambdaSimple' (["x"],
                                  ApplicTP' (Var' (VarFree "f"),
                                  [Applic' (Var' (VarFree "g"),
                                    [Applic' (Var' (VarFree "g"), [Var' (VarParam ("x", 0))])])])));;

let t2 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x) (f (lambda (y) (g x y))))")))) (  LambdaSimple' (["x"],
                                              ApplicTP' (Var' (VarFree "f"),
                                              [LambdaSimple' (["y"],
                                                ApplicTP' (Var' (VarFree "g"),
                                                  [Var' (VarBound ("x", 0, 0)); Var' (VarParam ("y", 0))]))])));;

let t3 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z w)(if (foo? x)(goo y)(boo (doo z))))")))) (  LambdaSimple' (["x"; "y"; "z"; "w"],
                                                          If' (Applic' (Var' (VarFree "foo?"), [Var' (VarParam ("x", 0))]),
                                                          ApplicTP' (Var' (VarFree "goo"), [Var' (VarParam ("y", 1))]),
                                                          ApplicTP' (Var' (VarFree "boo"),
                                                            [Applic' (Var' (VarFree "doo"), [Var' (VarParam ("z", 2))])]))));;

let t4 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z)(f (if (g? x)(h y)(w z))))")))) (  LambdaSimple' (["x"; "y"; "z"],
                                                ApplicTP' (Var' (VarFree "f"),
                                                [If' (Applic' (Var' (VarFree "g?"), [Var' (VarParam ("x", 0))]),
                                                  Applic' (Var' (VarFree "h"), [Var' (VarParam ("y", 1))]),
                                                  Applic' (Var' (VarFree "w"), [Var' (VarParam ("z", 2))]))])));;

let t5 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (a b)(f a)(g a b)(display \"done!\\n\"))")))) (  LambdaSimple' (["a"; "b"],
                                                        Seq'
                                                        [Applic' (Var' (VarFree "f"), [Var' (VarParam ("a", 0))]);
                                                          Applic' (Var' (VarFree "g"),
                                                          [Var' (VarParam ("a", 0)); Var' (VarParam ("b", 1))]);
                                                          ApplicTP' (Var' (VarFree "display"),
                                                          [Const' (Sexpr (String "done!\n"))])]));;

let t6 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda () (and (f x) (g y) (h z)))")))) (  LambdaSimple' ([],
                                              If' (Applic' (Var' (VarFree "f"), [Var' (VarFree "x")]),
                                              If' (Applic' (Var' (VarFree "g"), [Var' (VarFree "y")]),
                                                ApplicTP' (Var' (VarFree "h"), [Var' (VarFree "z")]),
                                                Const' (Sexpr (Bool false))),
                                              Const' (Sexpr (Bool false)))));;

let t7 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda () (or (f (g x)) y))")))) (  LambdaSimple' ([],
                                      Or'
                                      [Applic' (Var' (VarFree "f"),
                                        [Applic' (Var' (VarFree "g"), [Var' (VarFree "x")])]);
                                        Var' (VarFree "y")]));;

let t8 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda () 
    (set! x (f y)))")))) (  LambdaSimple' ([],
                                      Set' (Var' (VarFree "x"),
                                      Applic' (Var' (VarFree "f"), [Var' (VarFree "y")]))));;

let t9 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda () 
    (set! x (f (lambda (y)
                  (g x y)))))")))) (  LambdaSimple' ([],
                                          Set' (Var' (VarFree "x"),
                                          Applic' (Var' (VarFree "f"),
                                            [LambdaSimple' (["y"],
                                              ApplicTP' (Var' (VarFree "g"),
                                              [Var' (VarFree "x"); Var' (VarParam ("y", 0))]))]))));;

let t10 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(lambda (x y z) 
    (cond ((f? x) (g y)) 
          ((g? x) (f x) (f y)) 
          (else (h x) (f y) (g (f x)))))")))) (LambdaSimple' (["x"; "y"; "z"],
                                                If' (Applic' (Var' (VarFree "f?"), 
                                                [Var' (VarParam ("x", 0))]),
                                                  ApplicTP' (Var' (VarFree "g"),
                                                    [Var' (VarParam ("y", 1))]),
                                                        If' (Applic' (Var' (VarFree "g?"),
                                                          [Var' (VarParam ("x", 0))]),
                                                            Seq' [Applic' (Var' (VarFree "f"), 
                                                            [Var' (VarParam ("x", 0))]);
                                                              ApplicTP' (Var' (VarFree "f"), 
                                                              [Var' (VarParam ("y", 1))])],
                                                              Seq' [Applic' 
                                                              (Var' (VarFree "h"),
                                                                  [Var' (VarParam ("x", 0))]);
                                                            Applic' (Var' (VarFree "f"),
                                                              [Var' (VarParam ("y", 1))]);
                                                            ApplicTP' (Var' (VarFree "g"),
                                                              [Applic' 
                                                              (Var' (VarFree "f"),
                                                              [Var' (VarParam ("x", 0))])])]))));;

let t11 = expr'_eq (annotate_tail_calls(annotate_lexical_addresses (tag_parse_expression (read_sexpr 
"(let ((x (f y))
      (y (g x))) 
        (goo (boo x) y))")))) (  Applic'
                                                    (LambdaSimple' (["x"; "y"],
                                                      ApplicTP' (Var' (VarFree "goo"),
                                                      [Applic' (Var' (VarFree "boo"), [Var' (VarParam ("x", 0))]);
                                                        Var' (VarParam ("y", 1))])),
                                                    [Applic' (Var' (VarFree "f"), [Var' (VarFree "y")]);
                                                    Applic' (Var' (VarFree "g"), [Var' (VarFree "x")])]));;
 
let tailcalls_test = [(1, t1); (2, t2); (3, t3); (4, t4); (5, t5); (6, t6); (7, t7); (8, t8); (9, t9); (10, t10); (11, t11);];;
(testSum cyan "Tail calls" tailcalls_test);;
(testFailed tailcalls_test);;


(* Box set tests *)
let b1 = (expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define foo1 (lambda (x)
                          (list (lambda () x)
                                (lambda (y) 
                                  (set! x y)))))"))) 
          (Def' (Var' (VarFree "foo1"),
            LambdaSimple' (["x"],
              Seq'
              [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                ApplicTP' (Var' (VarFree "list"),
                [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
                  LambdaSimple' (["y"],
                  BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("y", 0))))])]))));;

let b2 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define foo2 (lambda (x y)
                          (set! x (* x y))))")))
          (Def' (Var' (VarFree "foo2"),
            LambdaSimple' (["x"; "y"],
              Set' (Var' (VarParam ("x", 0)),
              Applic' (Var' (VarFree "*"),
                [Var' (VarParam ("x", 0)); Var' (VarParam ("y", 1))])))));;

let b3 =  expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
              (define foo3 (lambda (x y) 
                              (lambda () x) 
                              (lambda () y)
                              (lambda () (set! x y))))")))
                              (  Def' (Var' (VarFree "foo3"),
                              LambdaSimple' (["x"; "y"],
                              Seq'
                                [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                Seq'
                                  [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
                                  LambdaSimple' ([], Var' (VarBound ("y", 0, 1)));
                                  LambdaSimple' ([],
                                    BoxSet' (VarBound ("x", 0, 0), Var' (VarBound ("y", 0, 1))))]])));;
                        
let b4 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define foo4 (lambda (x y)
                          (if x (lambda ()
                                  (set! y x))
                              (lambda (z) (set! x z)))))")))
          (Def' (Var' (VarFree "foo4"),
        LambdaSimple' (["x"; "y"],
          Seq'
          [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
            If' (BoxGet' (VarParam ("x", 0)),
            LambdaSimple' ([],
              Set' (Var' (VarBound ("y", 0, 1)), BoxGet' (VarBound ("x", 0, 0)))),
            LambdaSimple' (["z"],
              BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("z", 0)))))])));;

let b5 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define foo5
                (lambda (x y)
                  (list (lambda () 
                          (set! x (+ x 1)))
                    (lambda () y))))" )))
          ( Def' (Var' (VarFree "foo5"),
          LambdaSimple' (["x"; "y"],
          ApplicTP' (Var' (VarFree "list"),
            [LambdaSimple' ([],
              Set' (Var' (VarBound ("x", 0, 0)),
              Applic' (Var' (VarFree "+"),
                [Var' (VarBound ("x", 0, 0)); Const' (Sexpr (Number (Int 1)))])));
            LambdaSimple' ([], Var' (VarBound ("y", 0, 1)))]))));;

let b6 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define foo6
            (lambda (x)
            (lambda (op)
            (cond ((eq? op 'read) (lambda () x))
            ((eq? op 'write) (lambda (val) (set! x val)))))))")))
            ( Def' (Var' (VarFree "foo6"),
            LambdaSimple' (["x"],
            LambdaSimple' (["op"],
              If'
              (Applic' (Var' (VarFree "eq?"),
                [Var' (VarParam ("op", 0)); Const' (Sexpr (Symbol "read"))]),
              LambdaSimple' ([], Var' (VarBound ("x", 1, 0))),
              If'
                (Applic' (Var' (VarFree "eq?"),
                  [Var' (VarParam ("op", 0)); Const' (Sexpr (Symbol "write"))]),
                LambdaSimple' (["val"],
                Set' (Var' (VarBound ("x", 1, 0)), Var' (VarParam ("val", 0)))),
                Const' Void))))));;

let b7 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define foo7 ( lambda ( x)
            (let ((y 1)) 
            `(,(lambda () x) ,(set!  x y ))))) ")))
            (  Def' (Var' (VarFree "foo7"),
            LambdaSimple' (["x"],
            ApplicTP'
              (LambdaSimple' (["y"],
                ApplicTP' (Var' (VarFree "cons"),
                [LambdaSimple' ([], Var' (VarBound ("x", 1, 0)));
                  Applic' (Var' (VarFree "cons"),
                  [Set' (Var' (VarBound ("x", 0, 0)), Var' (VarParam ("y", 0)));
                    Const' (Sexpr Nil)])])),
              [Const' (Sexpr (Number (Int 1)))]))));;

let b8 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
      "(define foo8 (lambda (x y) 
                        (cons x (lambda () 
                                  (set! x y)))))")))
      (Def' (Var' (VarFree "foo8"),
          LambdaSimple' (["x"; "y"],
          Seq'
            [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
            ApplicTP' (Var' (VarFree "cons"),
              [BoxGet' (VarParam ("x", 0));
              LambdaSimple' ([],
                BoxSet' (VarBound ("x", 0, 0), Var' (VarBound ("y", 0, 1))))])])));;
 
let b9 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define foo9 (lambda (x y z)
                          (list (lambda ()
                                  (list (lambda (x) 
                                          (set! x z))
                                    (lambda ()
                                      (set! x z))
                                        x))
                              (lambda (y) 
                                (set! x y)))))")))
          (Def' (Var' (VarFree "foo9"),
          LambdaSimple' (["x"; "y"; "z"],
            Seq'
            [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
              ApplicTP' (Var' (VarFree "list"),
              [LambdaSimple' ([],
                ApplicTP' (Var' (VarFree "list"),
                  [LambdaSimple' (["x"],
                    Set' (Var' (VarParam ("x", 0)), Var' (VarBound ("z", 1, 2))));
                  LambdaSimple' ([],
                    BoxSet' (VarBound ("x", 1, 0), Var' (VarBound ("z", 1, 2))));
                  BoxGet' (VarBound ("x", 0, 0))]));
                LambdaSimple' (["y"],
                BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("y", 0))))])])));;
 
let b10 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
            (lambda (x y)
              (list (lambda () x)
              (lambda () y)
              (lambda (z) (set! x z))))
            ")))
            (  LambdaSimple' (["x"; "y"],
            Seq'
            [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
              ApplicTP' (Var' (VarFree "list"),
              [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
                LambdaSimple' ([], Var' (VarBound ("y", 0, 1)));
                LambdaSimple' (["z"],
                BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("z", 0))))])]));;
 
let b11 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
            (lambda (x y)
              (list (lambda () x)
              (lambda (z) (set! y z))
              (lambda (z) (set! x z))))")))
            (LambdaSimple' (["x"; "y"],
            Seq'
            [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
              ApplicTP' (Var' (VarFree "list"),
              [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
                LambdaSimple' (["z"],
                Set' (Var' (VarBound ("y", 0, 1)), Var' (VarParam ("z", 0))));
                LambdaSimple' (["z"],
                BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("z", 0))))])]));;
 
let b12 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
            (lambda (x y)
            (list (lambda () x) (lambda () y)
            (lambda (z) (set! y z))
            (lambda (z) (set! x z))))
            ")))
        (  LambdaSimple' (["x"; "y"],
        Seq'
          [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
          Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
          ApplicTP' (Var' (VarFree "list"),
            [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
            LambdaSimple' ([], BoxGet' (VarBound ("y", 0, 1)));
            LambdaSimple' (["z"],
              BoxSet' (VarBound ("y", 0, 1), Var' (VarParam ("z", 0))));
            LambdaSimple' (["z"],
              BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("z", 0))))])]));;

let b13 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
      (define (func .  x)
                (list (lambda () x)
                      (lambda (z) (set! x z))
                (lambda (z) 
                  (set! x z))))")))
                  (Def' (Var' (VarFree "func"),
                  LambdaOpt' ([], "x",
                  Seq'
                    [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                    ApplicTP' (Var' (VarFree "list"),
                      [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
                      LambdaSimple' (["z"],
                        BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("z", 0))));
                      LambdaSimple' (["z"],
                        BoxSet' (VarBound ("x", 0, 0), Var' (VarParam ("z", 0))))])])));;
 
let b14 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
            (define (func .  x)
                      (lambda (sameRib)
                        (list (lambda () x)
                              (lambda (z)
                                  (set! x z)))))")))
                                  (Def' (Var' (VarFree "func"),
                                  LambdaOpt' ([], "x",
                                  LambdaSimple' (["samerib"],
                                    ApplicTP' (Var' (VarFree "list"),
                                    [LambdaSimple' ([], Var' (VarBound ("x", 1, 0)));
                                      LambdaSimple' (["z"],
                                      Set' (Var' (VarBound ("x", 1, 0)), Var' (VarParam ("z", 0))))])))));;
 
let b15 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "
          (define func (lambda (x y z w)
                          (list (lambda () x)
                                (lambda () y)
                                (lambda () z)
                                (lambda () w)
                                (lambda () (set! x 0))
                                (lambda () (set! y 1))
                                (lambda () (set! z 2))
                                (lambda () (set! w 3)))))")))
                (  Def' (Var' (VarFree "func"),
                LambdaSimple' (["x"; "y"; "z"; "w"],
                  Seq'
                  [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                    Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
                    Set' (Var' (VarParam ("z", 2)), Box' (VarParam ("z", 2)));
                    Set' (Var' (VarParam ("w", 3)), Box' (VarParam ("w", 3)));
                    ApplicTP' (Var' (VarFree "list"),
                    [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
                      LambdaSimple' ([], BoxGet' (VarBound ("y", 0, 1)));
                      LambdaSimple' ([], BoxGet' (VarBound ("z", 0, 2)));
                      LambdaSimple' ([], BoxGet' (VarBound ("w", 0, 3)));
                      LambdaSimple' ([],
                      BoxSet' (VarBound ("x", 0, 0), Const' (Sexpr (Number (Int 0)))));
                      LambdaSimple' ([],
                      BoxSet' (VarBound ("y", 0, 1), Const' (Sexpr (Number (Int 1)))));
                      LambdaSimple' ([],
                      BoxSet' (VarBound ("z", 0, 2), Const' (Sexpr (Number (Int 2)))));
                      LambdaSimple' ([],
                      BoxSet' (VarBound ("w", 0, 3), Const' (Sexpr (Number (Int 3)))))])])));;

let boxSet_test = [(1, b1); (2, b2); (3, b3); (4, b4); (5, b5); (6, b6); (7, b7); (8, b8); (9, b9); (10, b10); (11, b11); 
                  (12, b12); (13, b13); (14, b14); (15, b15)];;
(testSum purple "Box set" boxSet_test);;
(testFailed boxSet_test);;
 

(* Box tests *) 
(* added Gilad tests *)
let b_1 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "(define t (lambda (x) (lambda () x) (lambda () (set! x 1))))")))
(Def' (Var' (VarFree "t"),
  LambdaSimple' (["x"],
   Seq'
    [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
     Seq'
      [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
       LambdaSimple' ([],
        BoxSet' (VarBound ("x", 0, 0), Const' (Sexpr (Number (Int 1)))))]])));;

let b_2 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr "(lambda () x)"))) (LambdaSimple' ([], Var' (VarFree "x")));;

let b_3 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
      "(lambda (x y) 
      (lambda () x) 
      (lambda () y)
      (lambda () (set! x y)))")))
        (LambdaSimple' (["x"; "y"],
        Seq'
          [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
          Seq'
            [LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)));
            LambdaSimple' ([], Var' (VarBound ("y", 0, 1)));
            LambdaSimple' ([],
              BoxSet' (VarBound ("x", 0, 0), Var' (VarBound ("y", 0, 1))))]]));;

let b_4 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
        "(lambda (z)
          (lambda () (lambda () (set! z (+ z 2))))
          (lambda () (lambda () (set! z (+ z 2)))))")))
                (LambdaSimple' (["z"],
                  Seq'
                  [Set' (Var' (VarParam ("z", 0)), Box' (VarParam ("z", 0)));
                    Seq'
                    [LambdaSimple' ([],
                      LambdaSimple' ([],
                        BoxSet' (VarBound ("z", 1, 0),
                        Applic' (Var' (VarFree "+"),
                          [BoxGet' (VarBound ("z", 1, 0)); Const' (Sexpr (Number (Int 2)))]))));
                      LambdaSimple' ([],
                      LambdaSimple' ([],
                        BoxSet' (VarBound ("z", 1, 0),
                        Applic' (Var' (VarFree "+"),
                          [BoxGet' (VarBound ("z", 1, 0)); Const' (Sexpr (Number (Int 2)))]))))]]));;

let b_5 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda (a b c d)
      (lambda (a b c) (lambda () (lambda () (set! d (+ d 1)) (set! c (2)))))
      (lambda () c)
      (lambda () (set! d 1)))")))
    (LambdaSimple' (["a"; "b"; "c"; "d"],
    Seq'
      [Set' (Var' (VarParam ("d", 3)), Box' (VarParam ("d", 3)));
      Seq'
        [LambdaSimple' (["a"; "b"; "c"],
          LambdaSimple' ([],
          LambdaSimple' ([],
            Seq'
            [BoxSet' (VarBound ("d", 2, 3),
              Applic' (Var' (VarFree "+"),
                [BoxGet' (VarBound ("d", 2, 3)); Const' (Sexpr (Number (Int 1)))]));
              Set' (Var' (VarBound ("c", 1, 2)),
              Applic' (Const' (Sexpr (Number (Int 2))), []))])));
        LambdaSimple' ([], Var' (VarBound ("c", 0, 2)));
        LambdaSimple' ([],
          BoxSet' (VarBound ("d", 0, 3), Const' (Sexpr (Number (Int 1)))))]]));;

let b_6 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda ()
      (lambda ()
        (lambda (x y)
          (lambda ()
            (lambda () (set! x 4))
            (lambda () (set! x (lambda () x)) (set! y (lambda () y)))
          )
          (lambda () (lambda () (set! y 0)))
        )
      )
    )")))
      (LambdaSimple' ([],
        LambdaSimple' ([],
        LambdaSimple' (["x"; "y"],
          Seq'
          [Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
            Seq'
            [LambdaSimple' ([],
              Seq'
                [LambdaSimple' ([],
                  Set' (Var' (VarBound ("x", 1, 0)),
                  Const' (Sexpr (Number (Int 4)))));
                LambdaSimple' ([],
                  Seq'
                  [Set' (Var' (VarBound ("x", 1, 0)),
                    LambdaSimple' ([], Var' (VarBound ("x", 2, 0))));
                    BoxSet' (VarBound ("y", 1, 1),
                    LambdaSimple' ([], BoxGet' (VarBound ("y", 2, 1))))])]);
              LambdaSimple' ([],
              LambdaSimple' ([],
                BoxSet' (VarBound ("y", 1, 1), Const' (Sexpr (Number (Int 0))))))]]))));;

let b_7 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda ()
      (lambda ()
        (lambda (x y)
          (if (set! x (lambda () x y))
              (lambda () (set! y 4))
          )
        )
      )
    )")))
    (LambdaSimple' ([],
      LambdaSimple' ([],
      LambdaSimple' (["x"; "y"],
        Seq'
        [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
          Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
          If'
          (BoxSet' (VarParam ("x", 0),
            LambdaSimple' ([],
              Seq'
              [BoxGet' (VarBound ("x", 0, 0)); BoxGet' (VarBound ("y", 0, 1))])),
          LambdaSimple' ([],
            BoxSet' (VarBound ("y", 0, 1), Const' (Sexpr (Number (Int 4))))),
          Const' Void)]))));;

let b_8 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda (x y)
        (lambda ()
         (lambda ()
            (if (set! x 5)
                (set! y 4)
         )
        )
       )
      y
     )")))
(LambdaSimple' (["x"; "y"],
  Seq'
   [Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
    Seq'
     [LambdaSimple' ([],
       LambdaSimple' ([],
        If'
         (Set' (Var' (VarBound ("x", 1, 0)), Const' (Sexpr (Number (Int 5)))),
         BoxSet' (VarBound ("y", 1, 1), Const' (Sexpr (Number (Int 4)))),
         Const' Void)));
      BoxGet' (VarParam ("y", 1))]]));;

let b_9 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda ()
      (lambda (x y z)
        (lambda () (set! x y))
        (lambda () (set! y (+ x z)) (set! z 5))
      )
    )")))
    (LambdaSimple' ([],
      LambdaSimple' (["x"; "y"; "z"],
      Seq'
        [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
        Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
        Seq'
          [LambdaSimple' ([],
            BoxSet' (VarBound ("x", 0, 0), BoxGet' (VarBound ("y", 0, 1))));
          LambdaSimple' ([],
            Seq'
            [BoxSet' (VarBound ("y", 0, 1),
              Applic' (Var' (VarFree "+"),
                [BoxGet' (VarBound ("x", 0, 0)); Var' (VarBound ("z", 0, 2))]));
              Set' (Var' (VarBound ("z", 0, 2)), Const' (Sexpr (Number (Int 5))))])]])));;

let b_10 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda (a b . c)
      (lambda ()
        (set! c (+ c a))
        c
      )
      (lambda () (set! b (lambda () (set! a 5))))
    )")))
    (LambdaOpt' (["a"; "b"], "c",
      Seq'
      [Set' (Var' (VarParam ("a", 0)), Box' (VarParam ("a", 0)));
        Seq'
        [LambdaSimple' ([],
          Seq'
            [Set' (Var' (VarBound ("c", 0, 2)),
              Applic' (Var' (VarFree "+"),
              [Var' (VarBound ("c", 0, 2)); BoxGet' (VarBound ("a", 0, 0))]));
            Var' (VarBound ("c", 0, 2))]);
          LambdaSimple' ([],
          Set' (Var' (VarBound ("b", 0, 1)),
            LambdaSimple' ([],
            BoxSet' (VarBound ("a", 1, 0), Const' (Sexpr (Number (Int 5)))))))]]));;

let b_11 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda (a b . c)
      (lambda ()
        (set! a (+ a a))
        c
      )
      (lambda () (set! b (lambda () (set! c 5))))
    )")))
    (LambdaOpt' (["a"; "b"], "c",
      Seq'
      [Set' (Var' (VarParam ("c", 2)), Box' (VarParam ("c", 2)));
        Seq'
        [LambdaSimple' ([],
          Seq'
            [Set' (Var' (VarBound ("a", 0, 0)),
              Applic' (Var' (VarFree "+"),
              [Var' (VarBound ("a", 0, 0)); Var' (VarBound ("a", 0, 0))]));
            BoxGet' (VarBound ("c", 0, 2))]);
          LambdaSimple' ([],
          Set' (Var' (VarBound ("b", 0, 1)),
            LambdaSimple' ([],
            BoxSet' (VarBound ("c", 1, 2), Const' (Sexpr (Number (Int 5)))))))]]));;

let b_12 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(begin
      (lambda (x)
        (or (lambda () (set! x (+ x 0)))
            (set! a (+ x 1))
        )
      )
      (lambda (x)
        (lambda ()
          (or (set! x (+ x 2))
              (set! x (+ x 3))  
          )
        )
      )
    )")))
    (Seq'
      [LambdaSimple' (["x"],
        Seq'
        [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
          Or'
          [LambdaSimple' ([],
            BoxSet' (VarBound ("x", 0, 0),
              Applic' (Var' (VarFree "+"),
              [BoxGet' (VarBound ("x", 0, 0)); Const' (Sexpr (Number (Int 0)))])));
            Set' (Var' (VarFree "a"),
            Applic' (Var' (VarFree "+"),
              [BoxGet' (VarParam ("x", 0)); Const' (Sexpr (Number (Int 1)))]))]]);
      LambdaSimple' (["x"],
        LambdaSimple' ([],
        Or'
          [Set' (Var' (VarBound ("x", 0, 0)),
            Applic' (Var' (VarFree "+"),
            [Var' (VarBound ("x", 0, 0)); Const' (Sexpr (Number (Int 2)))]));
          Set' (Var' (VarBound ("x", 0, 0)),
            Applic' (Var' (VarFree "+"),
            [Var' (VarBound ("x", 0, 0)); Const' (Sexpr (Number (Int 3)))]))]))]);;

let b_13 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(begin
      (lambda (x)
        (lambda ()
          (set! x (set! x 4))
        )
        (lambda ()
          (set! x 5)
        )
      )
      (lambda (x)
        (or (set! x (+ x 2))
            (set! x (+ x 3))
            x
        )
      )
    )")))
(Seq'
  [LambdaSimple' (["x"],
    Seq'
     [LambdaSimple' ([],
       Set' (Var' (VarBound ("x", 0, 0)),
        Set' (Var' (VarBound ("x", 0, 0)), Const' (Sexpr (Number (Int 4))))));
      LambdaSimple' ([],
       Set' (Var' (VarBound ("x", 0, 0)), Const' (Sexpr (Number (Int 5)))))]);
   LambdaSimple' (["x"],
    Or'
     [Set' (Var' (VarParam ("x", 0)),
       Applic' (Var' (VarFree "+"),
        [Var' (VarParam ("x", 0)); Const' (Sexpr (Number (Int 2)))]));
      Set' (Var' (VarParam ("x", 0)),
       Applic' (Var' (VarFree "+"),
        [Var' (VarParam ("x", 0)); Const' (Sexpr (Number (Int 3)))]));
      Var' (VarParam ("x", 0))])]);;

let b_14 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda (x y z)
      (lambda (z x y)
        (lambda (y z x)
          (set! x x)
          (begin x x x)
        )
        (lambda () (set! x x))
        x
      )
      (lambda () (lambda () x))
      (set! x 0)
    )")))
    (LambdaSimple' (["x"; "y"; "z"],
      Seq'
      [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
        Seq'
        [LambdaSimple' (["z"; "x"; "y"],
          Seq'
            [Set' (Var' (VarParam ("x", 1)), Box' (VarParam ("x", 1)));
            Seq'
              [LambdaSimple' (["y"; "z"; "x"],
                Seq'
                [Set' (Var' (VarParam ("x", 2)), Var' (VarParam ("x", 2)));
                  Seq'
                  [Var' (VarParam ("x", 2)); Var' (VarParam ("x", 2));
                    Var' (VarParam ("x", 2))]]);
              LambdaSimple' ([],
                BoxSet' (VarBound ("x", 0, 1), BoxGet' (VarBound ("x", 0, 1))));
              BoxGet' (VarParam ("x", 1))]]);
          LambdaSimple' ([], LambdaSimple' ([], BoxGet' (VarBound ("x", 1, 0))));
          BoxSet' (VarParam ("x", 0), Const' (Sexpr (Number (Int 0))))]]));;

let b_15 = expr'_eq (run_semantics (tag_parse_expression (read_sexpr
    "(lambda (x)
      (set! x
        (lambda ()
          (set! x
            (lambda()
              (set! x
                (lambda () x)
              ) 
            )
          )
        )
      )
    )")))
    (LambdaSimple' (["x"],
      Seq'
      [Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
        BoxSet' (VarParam ("x", 0),
        LambdaSimple' ([],
          BoxSet' (VarBound ("x", 0, 0),
          LambdaSimple' ([],
            BoxSet' (VarBound ("x", 1, 0),
            LambdaSimple' ([], BoxGet' (VarBound ("x", 2, 0))))))))]));;

let box_test = [(1, b_1); (2, b_2); (3, b_3); (4, b_4); (5, b_5); (6, b_6); (7, b_7); (8, b_8); (9, b_9); (10, b_10); (11, b_11); 
                (12, b_12); (13, b_13); (14, b_14); (15, b_15)];;
(testSum mag "Box" box_test);;
(testFailed box_test);;


(* Course tests *)
(* Add David code from facebook *)
let c1 = (expr'_eq (run_semantics (LambdaSimple ([], Const (Sexpr (Number (Int 1)))))))
                                  (LambdaSimple' ([], Const' (Sexpr (Number (Int (1))))));;

let c2 = expr'_eq (run_semantics (Const
          (Sexpr (Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil),
              Pair (Symbol "x", Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Pair (Symbol "set!", Pair (Symbol "x",
               Pair (Number (Int 1), Nil))), Nil))), Nil)))), Nil))), Nil)))))
          (Const' (Sexpr (Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Pair (Symbol "lambda", Pair (Pair (Symbol "x", Nil), 
              Pair (Symbol "x", Pair (Pair (Symbol "lambda", Pair (Nil, Pair (Pair (Symbol "set!", 
                Pair (Symbol "x", Pair (Number (Int (1)), Nil))), Nil))), Nil)))), Nil))), Nil))));;

let c3 = expr'_eq (run_semantics (Applic
              (LambdaSimple (["x"],
                  If (Applic (Var "x", [Const (Sexpr (Number (Int 1)))]),
                  Applic (Var "x", [Const (Sexpr (Number (Int 2)))]),
                  Applic
                  (LambdaSimple (["x"], Set (Var "x", Const (Sexpr (Number (Int 0))))),
                  [Const (Sexpr (Number (Int 3)))]))),
                  [LambdaSimple (["x"], Var "x")])))
                (Applic' (LambdaSimple' (["x"], 
                    Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                      If' (Applic' (BoxGet' (VarParam ("x", 0)), [Const' (Sexpr (Number (Int (1))))]), 
                      ApplicTP' (BoxGet' (VarParam ("x", 0)), [Const' (Sexpr (Number (Int (2))))]), ApplicTP' (LambdaSimple' (["x"], 
                      Set' (Var' (VarParam ("x", 0)), Const' (Sexpr (Number (Int (0)))))), 
                      [Const' (Sexpr (Number (Int (3))))]))])), [LambdaSimple' (["x"], Var' (VarParam ("x", 0)))]));;

let c4 = expr'_eq (run_semantics (LambdaSimple (["x"],
      Or [Applic (LambdaOpt (["y"], "z", Applic (LambdaSimple ([], Applic (LambdaSimple ([], 
          Applic (Var "+", [Var "x"; Var "z"])), [])), [])), [Var "x"; Const (Sexpr (Number (Int 1)))]); 
          LambdaSimple ([], Set (Var "x", Var "w")); Applic (Var "w", [Var "w"])])))
      (LambdaSimple' (["x"], Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
      Or' ([Applic' (LambdaOpt' (["y"], "z", ApplicTP' (LambdaSimple' ([], ApplicTP' (LambdaSimple' ([], 
      ApplicTP' (Var' (VarFree "+"), [BoxGet' (VarBound ("x", 2, 0));Var' (VarBound ("z", 1, 1))])), [])), [])),
      [BoxGet' (VarParam ("x", 0));Const' (Sexpr (Number (Int (1))))]);LambdaSimple' ([], BoxSet' (VarBound ("x", 0, 0), 
      Var' (VarFree "w")));ApplicTP' (Var' (VarFree "w"), [Var' (VarFree "w")])])])));;

let c5 = expr'_eq (run_semantics (If (Applic (LambdaSimple (["y"], Var "x"), []),
        Applic (LambdaSimple (["x"], Seq [Set (Var "x", Var "y");
          LambdaSimple ([], Set (Var "x", Const (Sexpr (Number (Int 1)))))]),
          [Const (Sexpr (Symbol "a"))]), LambdaSimple (["x"], Set (Var "x", Var "y")))))
      (If' (Applic' (LambdaSimple' (["y"], Var' (VarFree "x")), []),
        Applic' (LambdaSimple' (["x"], Seq' ([Set' (Var' (VarParam ("x", 0)), 
        Var' (VarFree "y"));LambdaSimple' ([], Set' (Var' (VarBound ("x", 0, 0)), 
        Const' (Sexpr (Number (Int (1))))))])), [Const' (Sexpr (Symbol "a"))]), 
        LambdaSimple' (["x"], Set' (Var' (VarParam ("x", 0)), Var' (VarFree "y")))));;

let c6 = expr'_eq (run_semantics (
        LambdaOpt (["x"; "y"; "z"], "w", Seq [Var "z"; Applic (LambdaSimple ([], Seq [Set (Var "w", Var "w"); 
            Applic (Applic (Var "y", [Var "x"]), [])]), [])])))
        (LambdaOpt' (["x";"y";"z"], "w", Seq' ([Var' (VarParam ("z", 2)); 
            ApplicTP' (LambdaSimple' ([], Seq' ([Set' (Var' (VarBound ("w", 0, 3)), Var' (VarBound ("w", 0, 3)));
            ApplicTP' (Applic' (Var' (VarBound ("y", 0, 1)), [Var' (VarBound ("x", 0, 0))]), [])])), [])])));;

let c7 = expr'_eq (run_semantics (Def (Var "a", Applic (LambdaSimple ([], LambdaOpt ([], "x", Seq
                                      [Var "x"; LambdaOpt ([], "y", Set (Var "y", Const (Sexpr (Number (Int 1)))))])), []))))
                                 (Def' (Var' (VarFree "a"), Applic' (LambdaSimple' ([], LambdaOpt' ([], "x", 
                                      Seq' ([Var' (VarParam ("x", 0));LambdaOpt' ([], "y", Set' (Var' (VarParam ("y", 0)), 
                                      Const' (Sexpr (Number (Int (1))))))]))), [])));;

let c8 = expr'_eq (run_semantics (LambdaSimple (["x"; "y"],
                                      Seq [Applic (Var "x", [Var "y"]); LambdaSimple ([], LambdaSimple ([], LambdaSimple ([],
                                      Set (Var "x", Applic (LambdaSimple (["z"], Set (Var "y", Var "x")), [Var "y"])))))])))
                                 (LambdaSimple' (["x";"y"], Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                      Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
                                      Seq' ([Applic' (BoxGet' (VarParam ("x", 0)), [BoxGet' (VarParam ("y", 1))]);
                                      LambdaSimple' ([], LambdaSimple' ([], LambdaSimple' ([], BoxSet' (VarBound ("x", 2, 0), 
                                      Applic' (LambdaSimple' (["z"], BoxSet' (VarBound ("y", 3, 1), BoxGet' (VarBound ("x", 3, 0)))), 
                                      [BoxGet' (VarBound ("y", 2, 1))])))))])])));;

let c9 = expr'_eq (run_semantics (LambdaSimple ([], Seq [Applic (LambdaSimple ([], Var "x"), []); Applic
                                      (LambdaSimple (["x"], Seq [Set (Var "x", Const (Sexpr (Number (Int 1))));
                                        LambdaSimple ([], Var "x")]),
                                        [Const (Sexpr (Number (Int 2)))]);
                                        Applic (LambdaOpt ([], "x", Var "x"), [Const (Sexpr (Number (Int 3)))])])))
                                  (LambdaSimple' ([], Seq' ([Applic' (LambdaSimple' ([], Var' (VarFree "x")), []);
                                      Applic' (LambdaSimple' (["x"], Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                      Seq' ([BoxSet' (VarParam ("x", 0), Const' (Sexpr (Number (Int (1)))));
                                      LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)))])])), [Const' (Sexpr (Number (Int (2))))]);
                                      ApplicTP' (LambdaOpt' ([], "x", Var' (VarParam ("x", 0))), [Const' (Sexpr (Number (Int (3))))])])));;

let c10 = expr'_eq (run_semantics (LambdaSimple (["x"; "y"; "z"],
                                      Seq
                                      [LambdaSimple (["y"],
                                      Seq
                                      [Set (Var "x", Const (Sexpr (Number (Int 5))));
                                      Applic (Var "+", [Var "x"; Var "y"])]);
                                      Applic (Var "+", [Var "x"; Var "y"; Var "z"])])))
                                  (LambdaSimple' (["x";"y";"z"], Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                      Seq' ([LambdaSimple' (["y"], Seq' ([BoxSet' (VarBound ("x", 0, 0), Const' (Sexpr (Number (Int (5)))));
                                      ApplicTP' (Var' (VarFree "+"), [BoxGet' (VarBound ("x", 0, 0));Var' (VarParam ("y", 0))])]));
                                      ApplicTP' (Var' (VarFree "+"), [BoxGet' (VarParam ("x", 0));Var' (VarParam ("y", 1));
                                      Var' (VarParam ("z", 2))])])])));;

let c11 = expr'_eq (run_semantics (LambdaSimple (["x"], Set (Var "x", Applic (LambdaSimple ([], Var "x"), [])))))
                                  (LambdaSimple' (["x"], Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                   BoxSet' (VarParam ("x", 0), Applic' (LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0))), []))])));;

let c12 = expr'_eq (run_semantics (Applic (Var "y", [LambdaSimple (["y"], Seq [Set (Var "a", LambdaSimple (["b"], 
                                          Applic (Var "a", [Var "b"]))); Set (Var "t", LambdaSimple (["x"], 
                                          Seq [Set (Var "y",  LambdaSimple (["j"], Applic (Var "x", [Var "j"; Var "x"])));
                                           Var "h"])); Applic (Var "y", [Var "a"])])])))
                                  (Applic' (Var' (VarFree "y"), [LambdaSimple' (["y"], Seq' ([Set' (Var' (VarParam ("y", 0)), 
                                        Box' (VarParam ("y", 0)));Seq' ([Set' (Var' (VarFree "a"), LambdaSimple' (["b"], 
                                        ApplicTP' (Var' (VarFree "a"), [Var' (VarParam ("b", 0))])));
                                        Set' (Var' (VarFree "t"), LambdaSimple' (["x"], Seq' ([BoxSet' (VarBound ("y", 0, 0), 
                                        LambdaSimple' (["j"], ApplicTP' (Var' (VarBound ("x", 0, 0)), [Var' (VarParam ("j", 0));
                                        Var' (VarBound ("x", 0, 0))])));Var' (VarFree "h")])));
                                        ApplicTP' (BoxGet' (VarParam ("y", 0)), [Var' (VarFree "a")])])]))]));;

let c13 = expr'_eq (run_semantics (LambdaSimple (["x"], Seq [LambdaSimple (["x"], Set (Var "x", Var "x"));
                                      LambdaSimple (["x"], Set (Var "x", Var "x"))])))
                                  (LambdaSimple' (["x"], Seq' ([LambdaSimple' (["x"], Set' (Var' (VarParam ("x", 0)), 
                                       Var' (VarParam ("x", 0))));
                                      LambdaSimple' (["x"], Set' (Var' (VarParam ("x", 0)), Var' (VarParam ("x", 0))))])));;

let c14 = expr'_eq (run_semantics (LambdaSimple (["x"; "y"], Seq [LambdaSimple ([], Set (Var "x", Var "y"));
                                      LambdaSimple ([], Set (Var "y", Var "x"))])))
                                  (LambdaSimple' (["x";"y"], Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                      Set' (Var' (VarParam ("y", 1)), Box' (VarParam ("y", 1)));
                                      Seq' ([LambdaSimple' ([], BoxSet' (VarBound ("x", 0, 0), BoxGet' (VarBound ("y", 0, 1))));
                                      LambdaSimple' ([], BoxSet' (VarBound ("y", 0, 1), BoxGet' (VarBound ("x", 0, 0))))])])));;
                                     
let c15 = expr'_eq (run_semantics (LambdaOpt ([], "x", Seq
                                        [LambdaSimple (["x"], Set (Var "x", Const (Sexpr (Number (Int 1)))));
                                        Applic (Var "car", [Var "x"])])))
                                  (LambdaOpt' ([], "x", Seq' ([LambdaSimple' (["x"], Set' (Var' (VarParam ("x", 0)), 
                                      Const' (Sexpr (Number (Int (1))))));
                                      ApplicTP' (Var' (VarFree "car"), [Var' (VarParam ("x", 0))])])));;

let c16 = expr'_eq (run_semantics (If (Var "x", Applic (Var "x", []), Var "x")))
                                  (If' (Var' (VarFree "x"), Applic' (Var' (VarFree "x"), []), Var' (VarFree "x")));;

let c17 = expr'_eq (run_semantics (LambdaSimple ([],
                                      If (Var "x", Applic (Var "x", []), Applic (Var "not", [Var "x"])))))
                                  (LambdaSimple' ([], If' (Var' (VarFree "x"), ApplicTP' (Var' (VarFree "x"), []), 
                                      ApplicTP' (Var' (VarFree "not"), [Var' (VarFree "x")]))));;

let c18 = expr'_eq (run_semantics (LambdaSimple (["a"; "b"; "c"; "d"; "e"],
                                      Applic (Var "a", [Applic (Var "b", [Var "c"]); Applic (Var "c", [Var "b"; Var "d"]);
                                      Applic (Var "a", [Applic (Var "b", [Applic (Var "c", [Applic (Var "d", [Var "e"])])])])]))))
                                  (LambdaSimple' (["a";"b";"c";"d";"e"], ApplicTP' (Var' (VarParam ("a", 0)), 
                                      [Applic' (Var' (VarParam ("b", 1)), [Var' (VarParam ("c", 2))]);
                                      Applic' (Var' (VarParam ("c", 2)), [Var' (VarParam ("b", 1));Var' (VarParam ("d", 3))]);
                                      Applic' (Var' (VarParam ("a", 0)), [Applic' (Var' (VarParam ("b", 1)),
                                      [Applic' (Var' (VarParam ("c", 2)), [Applic' (Var' (VarParam ("d", 3)), 
                                      [Var' (VarParam ("e", 4))])])])])])));;

let c19 = expr'_eq (run_semantics (LambdaSimple (["x"], Seq [Applic (Var "x", []); Set (Var "x", Applic (Var "x", []))])))
                                  (LambdaSimple' (["x"], Seq' ([Applic' (Var' (VarParam ("x", 0)), []);
                                      Set' (Var' (VarParam ("x", 0)), Applic' (Var' (VarParam ("x", 0)), []))])));;

let c20 = expr'_eq (run_semantics (LambdaSimple (["x"], Applic (LambdaSimple (["y"],
                                      Seq [Set (Var "x", Applic (Var "y", [])); Const (Sexpr (Number (Int 2)))]), []))))
                                  (LambdaSimple' (["x"], ApplicTP' (LambdaSimple' (["y"], Seq' ([Set' (Var' (VarBound ("x", 0, 0)), 
                                      Applic' (Var' (VarParam ("y", 0)), []));Const' (Sexpr (Number (Int (2))))])), [])));;

let c21 = expr'_eq (run_semantics (Const(Void)))
                                  (Const' (Void));;

let c22 = expr'_eq (run_semantics (LambdaSimple (["x"], Seq [Var "x"; LambdaSimple (["x"], 
                                      Seq [Set (Var "x", Const (Sexpr (Number (Int 1)))); LambdaSimple ([], Var "x")]);
                                      LambdaSimple ([], Set (Var "x", Var "x"))])))
                                  (LambdaSimple' (["x"], Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                        Seq' ([BoxGet' (VarParam ("x", 0));LambdaSimple' (["x"], 
                                        Seq' ([Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0)));
                                        Seq' ([BoxSet' (VarParam ("x", 0), 
                                        Const' (Sexpr (Number (Int (1)))));
                                        LambdaSimple' ([], BoxGet' (VarBound ("x", 0, 0)))])]));
                                        LambdaSimple' ([], BoxSet' (VarBound ("x", 0, 0), BoxGet' (VarBound ("x", 0, 0))))])])));;

let c23 = expr'_eq (run_semantics (LambdaSimple (["x"], Seq [Var "x"; LambdaSimple (["x"],
                                      Seq [Set (Var "y", Var "x"); LambdaSimple ([], Var "x")]); 
                                      LambdaSimple ([], Set (Var "x", Var "x"))])))
                                  (LambdaSimple' (["x"], Seq' ([Var' (VarParam ("x", 0));
                                      LambdaSimple' (["x"], Seq' ([Set' (Var' (VarFree "y"), Var' (VarParam ("x", 0)));
                                      LambdaSimple' ([], Var' (VarBound ("x", 0, 0)))]));
                                      LambdaSimple' ([], Set' (Var' (VarBound ("x", 0, 0)), Var' (VarBound ("x", 0, 0))))])));;

let course_test = [(1, c1); (2, c2); (3, c3); (4, c4); (5, c5); (6, c6); (7, c7); (8, c8); (9, c9); (10, c10);
                   (11, c11); (12, c12); (13, c13); (14, c14); (15, c15); (16, c16); (17, c17); (18, c18); (19, c19); (20, c20); 
                   (21, c21); (22, c22); (23, c23)];;
(testSum cyan "Course" course_test);;
(testFailed course_test);;


(* All tests *)
let all_test = boxSet_test  @ box_test @ course_test ;;
(testSum yel "All" all_test);;
allPassed cyan all_test;;
 
 
print grn "END TESTS";;
 