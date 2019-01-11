(* tag-parser.ml
 * A compiler from Scheme to CISC
 *
 * Programmer: Mayer Goldberg, 2018
 *)


#use "reader.ml";;
#use "tag-parser.ml";;

type var = 
  | VarFree of string
  | VarParam of string * int
  | VarBound of string * int * int;;

type expr' =
  | Const' of constant
  | Var' of var
  | Box' of var
  | BoxGet' of var
  | BoxSet' of var * expr'
  | If' of expr' * expr' * expr'
  | Seq' of expr' list
  | Set' of expr' * expr'
  | Def' of expr' * expr'
  | Or' of expr' list
  | LambdaSimple' of string list * expr'
  | LambdaOpt' of string list * string * expr'
  | Applic' of expr' * (expr' list)
  | ApplicTP' of expr' * (expr' list);;

let rec expr'_eq e1 e2 =
  match e1, e2 with
  | Const' Void, Const' Void -> true
  | Const'(Sexpr s1), Const'(Sexpr s2) -> sexpr_eq s1 s2
  | Var'(VarFree v1), Var'(VarFree v2) -> String.equal v1 v2
  | Var'(VarParam (v1,mn1)), Var'(VarParam (v2,mn2)) -> String.equal v1 v2 && mn1 = mn2
  | Var'(VarBound (v1,mj1,mn1)), Var'(VarBound (v2,mj2,mn2)) -> String.equal v1 v2 && mj1 = mj2  && mn1 = mn2
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
	
                       
exception X_syntax_error;;

module type SEMANTICS = sig
  val run_semantics : expr -> expr'
  val annotate_lexical_addresses : expr -> expr'
  val annotate_tail_calls : expr' -> expr'
  val box_set : expr' -> expr'
end;;

module Semantics : SEMANTICS = struct

(* ************************    Utilities ****************************************************************** *)

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
    | head :: tail -> (print_sexpr head) ^ "," ^ (print_sexprs tail)

and 

print_sexprs_as_list = fun sexprList ->
  let sexprsString = print_sexprs sexprList in
    "[ " ^ sexprsString ^ " ]"

and
print_expr = fun exprObj ->
  match exprObj  with
    | Const'(Void) -> "Const(Void)"
    | Const'(Sexpr(x)) -> Printf.sprintf "Const(Sexpr(%s))" (print_sexpr x)
    | Var'(VarParam(x, indx)) -> Printf.sprintf "VarParam(\"%s\", %d)" x indx
    | Var'(VarBound(x, indx, level)) -> Printf.sprintf "VarBound(\"%s\" %d %d)" x indx level
    | Var'(VarFree(x)) -> Printf.sprintf "VarFree(\"%s\" )" x
    | If'(test,dit,dif) -> Printf.sprintf "If(%s,%s,%s)" (print_expr test) (print_expr dit) (print_expr dif)
    | Seq'(ls) -> Printf.sprintf "Seq(%s)" (print_exprs_as_list ls)
    | Set'(var,value) -> Printf.sprintf "Set(%s,%s)" (print_expr var) (print_expr value)
    | Def'(var,value) -> Printf.sprintf "Def(%s,%s)" (print_expr var) (print_expr value)
    | Or'(ls) -> Printf.sprintf "Or(%s)" (print_exprs_as_list ls)
    | LambdaSimple'(args,body) -> Printf.sprintf "LambdaSimple(%s,%s)" (print_strings_as_list args) (print_expr body)
    | LambdaOpt'(args,option_arg,body) -> Printf.sprintf "LambdaOpt(%s,%s,%s)" (print_strings_as_list args) option_arg (print_expr body)
    | Applic'(proc,params) -> Printf.sprintf "Applic(%s,%s)" (print_expr proc) (print_exprs_as_list params) 
    | ApplicTP'(proc,params) -> Printf.sprintf "ApplicTP(%s,%s)" (print_expr proc) (print_exprs_as_list params) 
    | Box'(variable) -> Printf.sprintf "Box'(\"%s\" )" (print_var variable)
    | BoxGet'(variable) -> Printf.sprintf "BoxGet'(\"%s\" )" (print_var variable)
    | BoxSet'(variable, expr) -> Printf.sprintf "BoxSet'(\"%s\", %s )" (print_var variable) (print_expr expr)

and print_var = fun x ->
	match x with
	| VarFree(str) -> Printf.sprintf "VarFree(%s)" str
	| VarParam(str, int1) -> Printf.sprintf "VarParam(%s)" str
	| VarBound(str, int1, int2) -> Printf.sprintf "VarBound(%s)" str
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


(* returns pair of last element and the rest *)
let cartesian l l' = 
  List.concat (List.map (fun e -> List.map (fun e' -> (e,e')) l') l)

(*list of pairs of vars [(a,b), (c,d), (f,b)] *)
let rec isBoxNeeded lst = match lst with 
	| [] -> false
	| (a,b) :: tail -> if a==b then (isBoxNeeded tail) else true;;

let diff l1 l2 = List.filter (fun x -> not (List.mem x l2)) l1;;

let rec printIntList = function 
[] -> ()
| e::l -> print_int e ; print_string " " ; printIntList l

let rec printStringList = function 
[] -> ()
| e::l -> print_string e ; print_string " " ; printStringList l

let rec printThreesomesList lst =
	match lst with
		| [] -> ()
		| (name, reads, writes)::cdr -> print_string "varName: " ; print_string name ; print_string " readlist: " ; printIntList reads ; print_string " writeList: " ; printIntList writes ; printThreesomesList cdr;;

let printIsEmptyList lst =
	match lst with
		| [] -> print_string "list is empty\n"
		| _ -> print_string "not empty\n";;

let getVarName variable =  match variable with
	| VarParam(name, minor) -> name
	| VarFree(name) -> name
	| VarBound(name, major, minor) -> name;;

let getElementIndex name lst = 
	let rec f rest i = match rest with 
		| [] -> -1
		| head :: tail -> if (compare head name == 0) then i else (f tail (i+1)) in
	f lst 0;;

let separateList lst = 
	let reversed = (List.rev lst) in
	let last = (List.hd reversed) in
	let rest = (List.rev (List.tl reversed)) in
	(last, rest);;


let varLocInEnv env variable = 
	let rec getInd i env = 
		match env with 
		| [] -> -1
		| head :: tail ->  if (compare head variable == 0) then i else (getInd (i+1) tail)
	in (getInd 0 env);;

let getBoundVar boundEnv name = 
	let rec f restEnv = match restEnv with
		| [] -> Const'(Sexpr(Nil))
		| Var'(VarBound(variable, major, minor)) :: tail -> 
		if ((compare variable name)==0) 
			then Var'(VarBound(variable, major, minor))
		else (f tail)
		| _ -> raise X_syntax_error
	in (f boundEnv);; 

let makeBoundEnv params = 
	let rec f indx rest = 
		match rest with
			| [] -> []
			| [head] -> [Var'(VarBound(head,0,indx))]
			| head :: tail -> [Var'(VarBound(head,0,indx))] @ (f (indx+1) tail) in
		(f 0 params);;

let rec premoteBoundVar boundVar =
	match boundVar with 
		| Var'(VarBound(name, major, minor)) -> Var'(VarBound(name, (major+1), minor))
		| _ -> raise X_syntax_error;; 

let varHandler name paramsEnv boundEnv = 
	let indx = (varLocInEnv paramsEnv name) in
		if (indx != -1) 
			then Var'(VarParam (name, indx))
			else let var_bound = (getBoundVar boundEnv name) in
		if (expr'_eq var_bound (Const'(Sexpr(Nil)))) 
			then Var'(VarFree(name))
		else var_bound;;


let rec lambdaBodyHandler expr paramsEnv boundEnv = 
let applyRec e = (lambdaBodyHandler e paramsEnv boundEnv ) in
match expr with
	| Const(e) -> Const'(e)
	| Var (name)-> (varHandler name paramsEnv boundEnv )
	| If (test ,dit , dif) -> If' ((applyRec test),(applyRec dit) ,(applyRec dif))
	| Seq (lst) -> Seq' (List.map applyRec lst)
	| Set (variable, value) -> Set' ((applyRec variable), (applyRec value))
	| Def (variable, value) -> Def' ((applyRec variable), (applyRec value))
	| Or (lst) -> Or' (List.map applyRec lst)
	| LambdaSimple (params, body) -> LambdaSimple' (params, (lambdaBodyHandler body params ((makeBoundEnv paramsEnv) @(List.map premoteBoundVar boundEnv) )))
	| LambdaOpt (params, opt,body) -> LambdaOpt' (params, opt, (lambdaBodyHandler body (params @[opt]) ((makeBoundEnv paramsEnv) @(List.map premoteBoundVar boundEnv) )))
	| Applic (app, args) -> Applic' ((applyRec app), (List.map applyRec args));;

let rec annotate e = match e with 
	| Const(expr) -> Const'(expr)
	| Var(name) -> Var'(VarFree(name))
	| If (test ,dit , dif) -> If' ((annotate test),(annotate dit) ,(annotate dif))
	| Seq (lst) -> Seq' (List.map annotate lst)
	| Set (variable, value) -> Set' ((annotate variable), (annotate value))
	| Def (variable, value) -> Def' ((annotate variable), (annotate value))
	| Or (lst) -> Or' ((List.map annotate lst))
	| LambdaSimple (params, body) -> LambdaSimple' (params, (lambdaBodyHandler body params []))
	| LambdaOpt (params, opt ,body) -> LambdaOpt' (params, opt, (lambdaBodyHandler body (params @[opt]) []))
	| Applic (expr, args) -> Applic' ((annotate expr),(List.map annotate args));;

let annotate_lexical_addresses e = annotate e;;


let rec tail_calls e isTail = match e with
	| Const'(expr) -> Const'(expr)
	| Var'(name) -> Var'(name)
	| If' (test ,dit , dif) -> If' ((tail_calls test false),(tail_calls dit isTail) ,(tail_calls dif isTail))
	| Seq' (lst) ->  Seq'(seqOrHandler lst isTail)
	| Set' (variable, value) -> Set' ((tail_calls variable false), (tail_calls value false))
	| Def' (variable, value) -> Def' ((tail_calls variable false), (tail_calls value false))
	| Or' (lst) -> Or' (seqOrHandler lst isTail)
	| LambdaSimple' (params, body) -> LambdaSimple' (params, (tail_calls body true))
	| LambdaOpt' (params, opt ,body) -> LambdaOpt' (params, opt, (tail_calls body true))
	| Applic' (app, args) -> (applicHandler app args isTail)
	| _ -> raise X_syntax_error

and seqOrHandler lst isTail= 
	let (last,rest) = separateList lst in 
	let f exp = tail_calls exp false in 
	((List.map f rest) @ [tail_calls last isTail])

and applicHandler app args isTail=
 let f exp = tail_calls exp false in
 if isTail 
 	then ApplicTP'((f app),(List.map f args)) (*check if false is correct for app expr *)
 	else Applic'((f app),(List.map f args));;


let annotate_tail_calls e = tail_calls e false;;

let counter = ref 0 ;; (*maybe box *)

let appendReadWrites lst = 
	let rec f lst reads writes = match lst with
	| [] -> (reads, writes)
	| (param, read,write) :: tail ->  f tail (reads @ read) (writes @ write)
in (f lst [] []);;

let rec checkBodyReadWrites inner_body params param reads writes f localCounter= 
    let boxed_inner_body = lambdaBoxHandler inner_body params in 
    if (List.mem param params) 
        then (param, reads, writes) 
    else 
        let (name, body_reads, body_writes) = (f boxed_inner_body) in 
        let toRetReads = ref reads in
        let toRetWrites = ref writes in
            if (List.length body_reads >0) then 
                toRetReads := !toRetReads @ [localCounter]; 
            if (List.length body_writes >0) then 
                toRetWrites := !toRetWrites @ [localCounter];
            (param, !toRetReads, !toRetWrites)


(*params:[x] body: (LambdaSimple([  ],VarBound("x" 0 0)) reads [] writes []*)
and boxHandler body param reads writes localCounter =(* print_string "entered boxHandler\n";*)
	let f expr = (boxHandler expr param reads writes localCounter) in
	let f2 lst = let (reads_, writes_) = appendReadWrites (List.map f lst) in (param, reads_, writes_) in
	match body with
	| Const'(expr) -> (param, reads, writes)
	| Var'(VarFree(expr)) -> (param, reads, writes)
	| Var'(VarParam(expr, pos)) -> if (compare expr param) == 0 then (param, [-1], writes) else (param, reads, writes)
	| Var'(VarBound(expr, major, minor)) -> if ((compare expr param) == 0 (*&& major == 0*)) then (param,[-1], writes) else (param,reads, writes)
	| If' (test ,dit , dif) -> (f2 [test;dit;dif])
	| Seq' (lst) -> (f2 lst)
	| Set' (Var'(variable), value) ->  let (param, reads_val, writes_val) = (f value) in if (compare (getVarName variable) param) == 0 then (param, reads_val, [-1])  else (param, reads_val, writes_val) 
	| Def' (variable, value) -> (f2 [variable;value])
	| Or' (lst) -> (f2 lst)
	| LambdaSimple' (params, inner_body) -> counter := !counter + 1; (checkBodyReadWrites inner_body params param reads writes f !counter)
	| LambdaOpt' (params, opt ,inner_body) ->  counter :=  !counter + 1; (checkBodyReadWrites inner_body (params@[opt]) param reads writes f !counter)
	| Applic' (expr, args) -> f2 ([expr] @ args)
	| ApplicTP'(expr, args)-> f2 ([expr] @ args)
	| Box'(variable) -> (param,reads, writes)
    | BoxGet'(variable) -> (param,reads, writes)
    | BoxSet'(variable, expr) -> (param,reads, writes)
    | _ -> raise X_syntax_error

(*body: VarBound("x" 0 0)) namesToBox: []*)
and boxBody body namesToBox =
	let f expr = boxBody expr namesToBox in 
	match body with
	| Const'(expr) ->Const'(expr)
	| Var'(VarFree(expr)) -> Var'(VarFree(expr))
	| Var'(VarParam(name, pos)) -> if (List.mem name namesToBox) then BoxGet'(VarParam(name, pos)) else Var'(VarParam(name, pos))
	| Var'(VarBound(name, major, minor)) -> if (List.mem name namesToBox) then BoxGet'(VarBound(name, major, minor)) else Var'(VarBound(name, major, minor))
	| If' (test ,dit , dif) -> If'( (f test), (f dit), (f dif))
	| Seq'(lst) -> Seq'(List.map f lst)
	| Set' (Var'(variable), value) -> if (List.mem (getVarName variable) namesToBox) then BoxSet'(variable, (f value)) else Set'(Var'(variable), (f value))
	| Def' (Var'(variable), value) -> let newNamesToBox = (diff namesToBox [(getVarName variable)]) in Def'(Var'(variable), (boxBody value newNamesToBox))
	| Or' (lst) -> Or'(List.map f lst)
	| LambdaSimple' (params, inner_body) -> let newVarsToBox = (diff namesToBox params) in LambdaSimple' (params, (boxBody inner_body newVarsToBox))
	(* attention! - newVarsToBox take care of shadowing variables in nested lambdas *)
	| LambdaOpt' (params, opt ,inner_body) ->   let newVarsToBox = (diff namesToBox (params @ [opt])) in LambdaOpt' (params, opt, (boxBody inner_body newVarsToBox))
	| Applic' (expr, args) -> Applic'((f expr),(List.map f args))
	| ApplicTP'(expr, args)-> ApplicTP'((f expr),(List.map f args))
	| Box'(variable) -> Box'(variable)
    | BoxGet'(variable) -> BoxGet'(variable)
    | BoxSet'(variable, expr) -> BoxSet'(variable, expr)
	| _ -> raise X_syntax_error

and generateSetStatement name minor = Set'(Var'(VarParam(name, minor)), Box'(VarParam(name, minor))) 


(*params:[] body: VarBound("x" 0 0)*)
and lambdaBoxHandler body params = 
(*print_string "entered lambda_box_handler\n";*)
	let f param = (boxHandler body param [] [] counter) in (*check if box is needed *)
 	let f2 threesome = match threesome with
 		| (name, reads, writes) -> let guard = isBoxNeeded (cartesian reads writes) in if guard then name else "" in
 	let f4 nameToBox = (generateSetStatement nameToBox (getElementIndex nameToBox params)) in
 	let readWritesLists = List.map f params in (*list of pairs of reads and writes for each param - [(n,[1;2],[3;4;5]); (u,[4;5],[])] *)
	(*printThreesomesList readWritesLists; *)(*TODO: delete this. for DEBUG*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*) 
	let namesToBox = List.map f2 readWritesLists in
	let filteredNames = List.filter (function(x) -> (compare x "") != 0) namesToBox in
	(*print_string "\n filtered names(vars to box): ";printStringList filteredNames; print_string "\n";  
	printIsEmptyList filteredNames;*)
	if (List.length filteredNames == 0) then (box_set body) else let boxedBody = boxBody body filteredNames in Seq'((List.map f4 filteredNames) @ [boxedBody])



and box_set e =
match e with 
	| Const'(expr) ->  Const'(expr)
	| Var'(name) -> Var'(name)
	| If' (test ,dit , dif) -> If' ((box_set test),(box_set dit) ,(box_set dif))
	| Seq' (lst) ->  Seq' (List.map box_set lst)
	| Set' (variable, value) -> Set' ((box_set variable), (box_set value))
	| Def' (variable, value) ->  Def' ((box_set variable), (box_set value))
	| Or' (lst) ->  Or' ((List.map box_set lst))
	| LambdaSimple' (params, body) -> LambdaSimple' (params, (lambdaBoxHandler body params))
	| LambdaOpt' (params, opt ,body) -> LambdaOpt' (params, opt, (lambdaBoxHandler body (params @[opt]) ))
	| Applic' (expr, args) -> Applic' ((box_set expr),(List.map box_set args))
	| ApplicTP'(expr, args)-> ApplicTP' ((box_set expr),(List.map box_set args))
	| _ -> raise X_syntax_error;;
	(*todo: maybe add box *)


let run_semantics expr =
  box_set
    (annotate_tail_calls
       (annotate_lexical_addresses expr));;

List.map run_semantics (Tag_Parser.tag_parse_expressions
                            (Reader.read_sexprs "1"));;

end;; (* struct Semantics *)
