#use "semantic-analyser.ml";;

exception X_for_testing;;

(*functions for using also in compiler.ml *)
let constant_eq s1 s2 = match s1, s2 with
	| Sexpr(s1), Sexpr(s2) -> sexpr_eq s1 s2
	| Void, Void -> true
	| _ -> false;;

let varFree_eq v1 v2 = match v1,v2 with
	| VarFree(s1), VarFree(s2) -> if (compare s1 s2 ==0 ) then true else false
	| _ -> false;;

let const_address const consts_tbl = 
	let filtered = List.filter (fun ((c, (addr, representation))) -> constant_eq const c) consts_tbl in   (*filtered =  [(a, (b, c))] *)
        let (a, (addr, b)) = List.hd filtered in
           string_of_int addr;;

let fvar_address constString fvars_tbl = 
	let filtered = List.filter (fun ((varName, addr)) -> String.equal constString varName) fvars_tbl in   (*filtered =  [(a, b))] *)
        let (a, addr) = List.hd filtered in
            string_of_int addr;;

module type CODE_GEN = sig
  val make_consts_tbl : expr' list -> (constant * (int * string)) list 
  val make_fvars_tbl : expr' list -> (string * int) list
  val generate : (constant * (int * string)) list -> (string * int) list -> expr' -> string
end;;

module Code_Gen : CODE_GEN = struct

let removeDuplicates lst pred = 
	let rec f origList reducedList = match origList with 
  		| [] -> reducedList
  		| car :: cdr -> if (List.exists (fun (sexp) -> pred car sexp) reducedList) then f cdr reducedList  else f cdr (reducedList@[car]) in
  	f lst [];;

let removeDuplicatesConstList lst = 
  	removeDuplicates lst constant_eq;;

let removeDuplicatesVarFreeList lst = 
  	removeDuplicates lst varFree_eq;; 	

  (*makes the initial constatnt list -without duplicates- which is gonna be expanded to the consts table*)
  let make_consts_list exprTag_lst = 
  	let rec findConstsInExpr' exp' = 
  		let buildConstsList accList =
		  	match exp' with
		  		| Const'(Sexpr(sexp)) -> accList @ [Sexpr(sexp)]
		  		| Const'(Void) -> accList (*check this!*)
		  		| Var'(v) -> accList
				| Box'(v)-> accList
				| BoxGet'(v) -> accList
				| BoxSet'(v, setExp') -> accList @ findConstsInExpr' setExp' 
				| If' (test, dit, dif) -> accList @ ((findConstsInExpr' test) @ (findConstsInExpr' dit) @ (findConstsInExpr' dif))
				| Seq'(exprTags) -> accList @ (List.flatten (List.map findConstsInExpr' exprTags))
				| Set'(var, ex') -> accList @ ((findConstsInExpr' var) @ (findConstsInExpr' ex'))
				| Def'(var, ex') -> accList @ ((findConstsInExpr' var) @ (findConstsInExpr' ex'))
				| Or'(exprTags) -> accList @ (List.flatten (List.map findConstsInExpr' exprTags))
				| LambdaSimple'(params, body) -> accList @ (findConstsInExpr' body)
				| LambdaOpt'(params, opt, body) -> accList @ (findConstsInExpr' body)
				| Applic'(proc, argsList) -> accList @ (List.flatten (List.map findConstsInExpr' ([proc] @ argsList)))
				| ApplicTP'(proc, argsList) ->  accList @ (List.flatten (List.map findConstsInExpr' ([proc] @ argsList))) in
	buildConstsList [] in
  let sexpsList = List.flatten (List.map findConstsInExpr' exprTag_lst) in
  let withInitialConstants = [Void;Sexpr(Nil);Sexpr(Bool(false));Sexpr(Bool(true))] @ sexpsList in
	removeDuplicatesConstList withInitialConstants;;


let make_fvars_list exprTag_lst = 
  	let rec findFreeVarsInExpr' exp' = 
  		let buildFreeVarList accList =
		  	match exp' with
		  		| Const'(x) -> accList
		  		| Var'(VarFree(x)) -> accList @ [VarFree(x)]
		  		| Var'(x) -> accList 
				| Box'(v)-> accList
				| BoxGet'(v) -> accList
				| BoxSet'(v, setExp') -> accList @ findFreeVarsInExpr' setExp' 
				| If' (test, dit, dif) -> accList @ ((findFreeVarsInExpr' test) @ (findFreeVarsInExpr' dit) @ (findFreeVarsInExpr' dif))
				| Seq'(exprTags) -> accList @ (List.flatten (List.map findFreeVarsInExpr' exprTags))
				| Set'(var, ex') -> accList @ ((findFreeVarsInExpr' var) @ (findFreeVarsInExpr' ex'))
				| Def'(var, ex') -> accList @ ((findFreeVarsInExpr' var) @ (findFreeVarsInExpr' ex'))
				| Or'(exprTags) -> accList @ (List.flatten (List.map findFreeVarsInExpr' exprTags))
				| LambdaSimple'(params, body) -> accList @ (findFreeVarsInExpr' body)
				| LambdaOpt'(params, opt, body) -> accList @ (findFreeVarsInExpr' body)
				| Applic'(proc, argsList) -> accList @ (List.flatten (List.map findFreeVarsInExpr' ([proc] @ argsList)))
				| ApplicTP'(proc, argsList) ->  accList @ (List.flatten (List.map findFreeVarsInExpr' ([proc] @ argsList))) in
	buildFreeVarList [] in
  let freeVarsList = List.flatten (List.map findFreeVarsInExpr' exprTag_lst) in

(*TODO:: maybe remove the initial values from here! *)
  let withInitialfreeVars= [VarFree("boolean?"); VarFree("float?"); VarFree("integer?"); VarFree("pair?");
   VarFree("null?"); VarFree("char?"); VarFree("vector?"); VarFree("string?");
   VarFree("procedure?"); VarFree("symbol?"); VarFree("string-length");
   VarFree("string-ref"); VarFree("string-set!"); VarFree("make-string");
   VarFree("vector-length"); VarFree("vector-ref"); VarFree("vector-set!");
   VarFree("make-vector"); VarFree("symbol->string"); 
   VarFree("char->integer"); VarFree("integer->char"); VarFree("eq?");
   VarFree("+"); VarFree("*"); VarFree("-"); VarFree("/"); VarFree("<"); VarFree("=");
   VarFree("car"); VarFree("cdr"); VarFree("set-car!"); VarFree("set-cdr!"); VarFree("cons")] @ freeVarsList in
	removeDuplicatesVarFreeList withInitialfreeVars;;

let undefined = "MAKE_UNDEF";;
let runtimeFrameworkLabels = ["car";"cdr"; "map"];;
(*let make_fvars_tbl_helper fvarsList = 
	let rec f lst i = match lst with
		| VarFree(head) :: tail -> if (List.mem head runtimeFrameworkLabels) then let pred x = (compare head x) ==0 in [(head,i,List.find pred runtimeFrameworkLabels)] @ (f tail (i+1)) else [(head, i, undefined)] @ (f tail (i+1))
		| _ -> []  in
		f fvarsList 0;;
*)

let make_fvars_tbl_helper fvarsList = 
	let rec f lst i = match lst with
		| VarFree(head) :: tail -> [(head,i)] @ (f tail (i+8))
		| _ -> []  
	in f fvarsList 0;;


(*the folding function of expandCOnstList*)
let rec expandConstant const accResult = match const with
	| Sexpr(Symbol(str)) -> [Sexpr(String(str));const] @ accResult
	| Sexpr(Pair(car, cdr)) -> expandConstant (Sexpr(car)) (expandConstant (Sexpr(cdr)) ([(Sexpr(car));(Sexpr(cdr));const] @ accResult))
	| Sexpr(Vector(lst)) -> (expandConstList (List.map (fun (a) -> Sexpr(a)) lst)) @ ([const] @ accResult) (*TODO: check if this brings the desired output!!!!!!!!!!!!!!!!!!!!!!!!!!1*)
	| _ -> [const] @ accResult

and expandConstList constList = removeDuplicatesConstList (List.fold_right expandConstant constList []);;

let sizeOfSexpr sexpr = match sexpr with
	| Nil -> 1
	| Char(c) -> 2
	| Bool(b) -> 2
	| Number(Int(a)) -> 9
	| Number(Float(a)) -> 9
	| String(str) -> 9 + (String.length str)
	| Symbol(s) -> 9
	| Vector(lst) -> 9 + ((List.length lst) * 8)
	| Pair(car, cdr) -> 1 + 8 + 8;;

let sizeOfConst const = match const with
	| Void -> 1
	| Sexpr(s) -> sizeOfSexpr s;;

let rec consts_to_pair lst offset = match lst with
	| [] -> []
	| head :: tail -> [(head,offset)] @ (consts_to_pair tail (offset + (sizeOfConst head)));;

let rec findStringOffset sexprs_offset sexpr = match sexprs_offset with
	| [] -> -1
	| (Sexpr(s), index) :: tail -> if (sexpr_eq s sexpr) then index else (findStringOffset tail sexpr)
	| head :: tail -> (findStringOffset tail sexpr);;

let stringToAsciiList str = List.map (fun (ch) -> (int_of_char ch)) (string_to_list str);;

let listToString lst = 
	let rec accumFun list str = match list with 
	| [] -> str
	| [last] -> str ^ (string_of_int last)
	| car :: cdr -> (accumFun cdr (str ^ (string_of_int car) ^ ", ")) in
accumFun lst "";;

let prepareString str = (listToString (stringToAsciiList str));;

let rec sexpr_to_tuple sexpr offset sexprs_offset= 
	let toTuple str = (Sexpr(sexpr),(offset, str)) in match sexpr with 
	| Nil -> toTuple "MAKE_NIL"
	| Char(c) -> toTuple ("MAKE_LITERAL_CHAR "^(string_of_int ((int_of_char c))))
	| Bool(b) -> if b then toTuple "MAKE_LITERAL T_BOOL, db 1" (*"MAKE_BOOL(1)"*) else toTuple "MAKE_LITERAL T_BOOL, db 0"
	| Number(Int(a)) -> toTuple ("MAKE_LITERAL_INT "^(string_of_int a))
	| Number(Float(a)) -> toTuple ("MAKE_LITERAL_FLOAT "^(string_of_float a)) (*TODO:: check this!! *)
	| String(str) -> toTuple ("MAKE_LITERAL_STRING "^(prepareString str)^" ")
	| Symbol(s) -> toTuple ("MAKE_LITERAL_SYMBOL(const_tbl+"^(string_of_int (findStringOffset sexprs_offset (String s)))^")")
	| Vector(lst) -> let f acc sexpr = acc ^ "dq const_tbl+" ^ (string_of_int (findStringOffset sexprs_offset sexpr)) ^ "\n" in
					 let vectorString = List.fold_left f "" lst in
					 toTuple ("db T_VECTOR\n dq " ^ (string_of_int (List.length lst)) ^ "\n" ^ vectorString)
	| Pair(car, cdr) -> toTuple ("MAKE_LITERAL_PAIR(const_tbl+" ^(string_of_int (findStringOffset sexprs_offset car))^ ", const_tbl+"^(string_of_int (findStringOffset sexprs_offset cdr))^")") ;;(*not implemented yet *)

let rec const_to_tuple const offset sexprs_offset = 
	match const with 
	| Void -> (Void, (0, "MAKE_VOID"))
	| Sexpr (x) -> (sexpr_to_tuple x offset sexprs_offset);;

 let populateConstList constList =
 	let consts_with_offsets = (consts_to_pair constList 0) in 
 	let rec consts_to_tuple lst = 
 	match lst with 
 		| [] -> []
 		| (constant,offset) :: tail -> [(const_to_tuple constant offset consts_with_offsets)] @ (consts_to_tuple tail) in
 	consts_to_tuple consts_with_offsets;;


(*---------print functions - only for tests - delete this----------*)
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

and print_const = fun const ->
  match const with
    | Void -> "Void"
    | Sexpr(s) -> print_sexpr s

and print_sexprs = fun sexprList -> 
  match sexprList with
    | [] -> ""
    | head :: tail -> (print_sexpr head) ^ "," ^ (print_sexprs tail)

and print_consts = fun constsList -> 
  match constsList with
    | [] -> ""
    | head :: tail -> (print_const head) ^ "," ^ (print_consts tail)

and print_sexprs_as_list = fun sexprList ->
  let sexprsString = print_sexprs sexprList in
    "[ " ^ sexprsString ^ " ]"

and print_consts_as_list = fun constsList ->
  let constString = print_consts constsList in
    "[ " ^ constString ^ " ]"

and print_vars = fun varList ->
	match varList with
	| [] -> ""
	| head:: tail -> (print_var head) ^ ", " ^ (print_vars tail)

and print_varfree_as_list = fun varfreeList ->
  let varString = print_vars varfreeList in
    "[ " ^ varString ^ " ]"

and print_expr = fun exprObj ->
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

and print_exprs_as_list = fun exprList ->
  let exprsString = print_exprs exprList in
    "[ " ^ exprsString ^ " ]"

and print_strings = fun stringList -> 
  match stringList with
    | [] -> ""
    | head :: [] -> head 
    | head :: tail -> head ^ "; " ^ (print_strings tail)

and print_strings_as_list = fun stringList ->
  let stringList = print_strings stringList in
    "[ " ^ stringList ^ " ]";;

let rec printThreesomesList lst =
  match lst with
    | [] -> ()
    | (name, (index, str))::cdr -> print_string (print_const name); print_string " , "; print_int index ; print_string (" "^str^" \n"); printThreesomesList cdr;;

(*Mayers main functions*)
let make_consts_tbl asts = populateConstList(expandConstList (make_consts_list asts));;

let make_fvars_tbl asts = make_fvars_tbl_helper (make_fvars_list asts);;

let orCounter = ref 0;;
let ifCounter = ref 0;;
let applicCounter = ref 0;;
let applicTPCounter = ref 0;;
let lambdaCounter = ref 0;;
let lambdaOptCounter = ref 0;;

let incCounter counterRef = counterRef := !counterRef + 1 ; "";;

let makeNumberedLabel label num = 
	label ^ (string_of_int num);;

let generate consts fvars e = 
let rec genCode exp deepCounter= match exp with
		| Const'(c) -> ";const\nmov rax    , const_tbl + " ^ const_address c consts(*todo: check this????*)
	    | Var'(VarParam(_, minor)) -> ";varParam\n mov rax, qword [rbp + 8*(4 + " ^ (string_of_int minor) ^ ")]"
	    | Set'(Var'(VarParam(_, minor)), exp) -> ";set(vatParam)\n" ^ (genCode exp deepCounter) ^ "\n" ^
	    										  "mov qword [rbp + 8*(4 + " ^ (string_of_int minor) ^ ")], rax\n" ^
	    										  "mov rax, SOB_VOID_ADDRESS"
	    | Var'(VarBound(_, major, minor)) -> ";varBound\n mov rax, qword[rbp + 8*2]\n" ^
	    									 "mov rax, qword [rax + 8 * " ^ (string_of_int major) ^ "]\n" ^
	    									 "mov rax, qword [rax + 8 * " ^ (string_of_int minor) ^ "]"
		| Set'(Var'(VarBound(_, major, minor)), exp) ->";set(VarBound)\n" ^ (genCode exp deepCounter) ^ "\n" ^
												  "mov rbx, qword[rbp + 8*2]\n" ^
												  "mov rbx, qword [rbx + 8 * " ^ (string_of_int major) ^ "]\n" ^
												  "mov qword [rbx + 8 * " ^ (string_of_int minor) ^ "], rax\n" ^
	    										  "mov rax, SOB_VOID_ADDRESS"
	    | Var'(VarFree(x)) -> ";varFree\nmov rax, qword [fvar_tbl+" ^ (fvar_address x fvars) ^ "]" (*todo: check this????*)
	    | Set'(Var'(VarFree(v)), exp) -> ";set(Var(VarFree))\n" ^ (genCode exp deepCounter) ^ "\n" ^
	    							   "mov qword [fvar_tbl+" ^ (fvar_address v fvars) ^ "], rax\n" ^
	    							   "mov rax, SOB_VOID_ADDRESS"
		| Seq'(lst) -> let f acc expr = ";seq\n" ^(acc ^ (genCode expr deepCounter) ^ "\n") in (List.fold_left f ""  lst)
	 	| Or'(lst) ->  let exitLabel = (makeNumberedLabel "Lexit" !orCounter) in
	 					let f  acc expr = acc ^ ((genCode expr deepCounter)^"\n cmp rax, SOB_FALSE_ADDRESS\n jne " ^ exitLabel ^ "\n") in
	  						";or\n" ^ (List.fold_left f "" lst) ^ exitLabel ^ ":\n" ^ (incCounter orCounter)
	    | If'(test,dit,dif) -> let exitLabel = (makeNumberedLabel "Lexit" !ifCounter) in
	    					   let elseLabel = (makeNumberedLabel "Lelse" !ifCounter) in
		    					   ";if\n" ^ 
		    					   (genCode test deepCounter) ^ "\n" ^
		    					   "cmp rax, SOB_FALSE_ADDRESS\n" ^
		    					   "je " ^ elseLabel ^ "\n" ^
		    					   (genCode dit deepCounter) ^ "\n" ^
		    					   "jmp " ^ exitLabel ^ "\n" ^
		    					   elseLabel ^ ":\n" ^
		    					   (genCode dif deepCounter) ^ "\n" ^
		    					   exitLabel ^ ":" ^ (incCounter ifCounter)
		| BoxGet'(v) -> ";boxGet\n" ^(genCode (Var'(v)) deepCounter) ^ "\n" ^
	  						  "mov rax, qword [rax]"
	    | BoxSet'(v, expr) -> ";boxSet\n" ^(genCode expr deepCounter) ^ "\n" ^
	    							"push rax\n" ^
	    							(genCode (Var' v) deepCounter) ^ "\n" ^
	    							"pop qword [rax]\n" ^
	    							"mov rax, SOB_VOID"
		| Applic'(proc,argList) -> ";applic\n" ^ (applicCodeGen proc argList deepCounter)
	    | ApplicTP'(proc,params) -> ";applicTP\n" ^ (applicTPCodeGen proc params deepCounter) (*raise X_not_yet_implemented*)
	    | LambdaSimple'(argNames,body) -> ";lambdaSimple\n" ^ (lambdaCodeGen argNames body deepCounter)
	    | LambdaOpt'(args,option_arg,body) ->";LambdaOpt\n" ^ (lambdaOptCodeGen (args@[option_arg]) body deepCounter)
	    | Def'(Var'(VarFree(v)), value) -> ";define(Var'(VarFree))\n" ^ (genCode value deepCounter) ^ "\n" ^
	    							   "mov qword [fvar_tbl+" ^ (fvar_address v fvars) ^ "], rax\n" ^
	    							   "mov rax, SOB_VOID_ADDRESS"
	 	| Box'(variable) -> ";Box(var)\n" ^ 
	 						(genCode (Var'(variable)) deepCounter) ^ "\n" ^
	 						"push rbx\n" ^ 
	 						"MALLOC rbx, WORD_BYTES\n" ^
	 						"mov [rbx], rax\n" ^
	 						"mov rax, rbx\n" ^
	 						"pop rbx"
	    | _ -> raise X_not_yet_implemented
	    

	    and lambdaCodeGen args body envSize =
	    let lcodeLabel = (makeNumberedLabel "Lcode" !lambdaCounter) in
	    let lcontLabel = (makeNumberedLabel "Lcont" !lambdaCounter) in 
	    "MALLOC r9, "^ (string_of_int ((envSize+1)*8)) ^ " ;r9 = extEnv pointer\n" ^
	    "mov qword rbx, [rbp + 8 * 2] ;lexical env pointer\n" ^
	    (copyEnvLoop 0 1 envSize "") ^ "\n" ^ 
	    "MALLOC rdx, "^ (string_of_int ((List.length args)*8)) ^" ;number of params\n" ^ 
	    "mov qword [r9], rdx\n" ^
	    (copyParams 0 (List.length args) "") ^ "\n" ^
	    "MAKE_CLOSURE (rax, r9, "^lcodeLabel^")\n"^
	    ";mov rax, [rax]\n"^
	    "jmp " ^ lcontLabel ^ "\n" ^
	    lcodeLabel ^ ":\n "^
	    "push rbp\n" ^
	    "mov rbp, rsp\n" ^
	    (genCode body (envSize+1)) ^ "\n" ^
	    "leave\n" ^
	    "ret\n" ^ 
	    lcontLabel ^ ":\n " ^ (incCounter lambdaCounter)

	    and copyParams i n str = 
	    	if i<n then
	    		";copyParamsLoop:\n" ^(copyParams (i+1) n (str ^ 
	    			"mov qword rdx, [r9]\n" ^
	    			"mov rbx, [rbp + 8*(4 + "^ (string_of_int (i*8)) ^ ")] ;rbx = param(i)\n"^ 
	    			"mov [rdx + " ^ (string_of_int (i*8)) ^ "], rbx ;rdx = extEnv[0], rdx[i] = rbx \n"
	    		))
	    	else str 
	    
	    and copyEnvLoop i j envSize str = 
	    if i < envSize then 
	    	";copyENvLoop:\n" ^ (copyEnvLoop (i+1) (j+1) envSize (str ^
	    	"mov qword rdx, [rbx + "^ (string_of_int (i*8)) ^ "] ;go to lexical env , tmp val is in rdx\n" ^ 
	    	"mov qword [r9 + "^ (string_of_int (j*8)) ^"], rdx\n")) (*check if it is + or - *)
	    else
	    	str

	    and lambdaOptCodeGen args body envSize =
	    let lcodeLabel = (makeNumberedLabel "LOptcode" !lambdaOptCounter) in
	    let lcontLabel = (makeNumberedLabel "LOptcont" !lambdaOptCounter) in 
	    "MALLOC r9, "^ (string_of_int ((envSize+1)*8)) ^ " ;r9 = extEnv pointer\n" ^
	    "mov qword rbx, [rbp + 8 * 2] ;lexical env pointer\n" ^
	    (copyEnvLoop 0 1 envSize "") ^ "\n" ^ 
	    "MALLOC rdx, "^ (string_of_int ((List.length args)*8)) ^" ;number of params\n" ^ 
	    "mov qword [r9], rdx\n" ^
	    (copyParams 0 (List.length args) "") ^ "\n" ^
	    "MAKE_CLOSURE (rax, r9, "^lcodeLabel^")\n"^
	    ";mov rax, [rax]\n"^
	    "jmp " ^ lcontLabel ^ "\n" ^
	    lcodeLabel ^ ":\n "^
	    (fixStack args) ^
	    "push rbp\n" ^
	    "mov rbp, rsp\n" ^
	    (genCode body (envSize+1)) ^ "\n" ^
	    "leave\n" ^
	    "ret\n" ^ 
	    lcontLabel ^ ":\n " ^ (incCounter lambdaOptCounter)


	    and fixStack args = 
	    let fixedParamsCount = (List.length args) in
	    let shiftStackAndPushNil = (makeNumberedLabel "shiftStackAndPushNil" !lambdaOptCounter) in
	   	let optToListLoop = (makeNumberedLabel "optToListLoop" !lambdaOptCounter) in
	    let shiftStack = (makeNumberedLabel "shiftStack" !lambdaOptCounter) in
	    let shiftStack_nil = (makeNumberedLabel "shiftStack_nil" !lambdaOptCounter) in
	    let fixN = (makeNumberedLabel "fixN" !lambdaOptCounter) in 
	    "
	    ;rax = num of opt params
	    mov rax, qword [rbp + 3*8]
	    sub rax, "^ (string_of_int fixedParamsCount)^"
	    cmp rax, 0
	    je "^ shiftStackAndPushNil ^"

	    ;generate opt list
	    mov rdx, SOB_NIL_ADDRESS ; rdx = list
	    mov rcx, rax ; rcx = num of opt params
	    mov r9, qword [rbp + 8*3]
	    "^ optToListLoop ^":
	    	mov rbx, qword [rbp + 8*(r9+3)] ; rbx = OPTi
	    	MAKE_PAIR (r10, rbx, rdx) ;r10 = Pair(rbx, rdx)
	    	mov rdx, r10
	    	dec r9
	    	dec rcx
	    	jne " ^ optToListLoop ^ "

	    ;override last OPT with the opt list:"
	    ^ (overrideLastOptWith "rdx") ^ "

	    ;shift frame - shift size is (optCount - 1)
	    push rcx
	    push r12
	    push r8
	    mov rcx, 4 + "^ (string_of_int fixedParamsCount)^";rcx = frame size
	    mov r12, 1 ; r12 = i
	    mov r10, qword [rbp + 8*3]
	    sub r10, -1 + " ^ (string_of_int fixedParamsCount) ^" ; r10 = optCount - 1
	    "^ shiftStack ^ ":
	    	mov r8, qword [rbp+r12*8]
	    	push r12
	    	add r12 , r10
	       	mov [rbp+ 8*r12], r8
	       	pop r12
	    	inc r12 
	    	dec rcx
	    	jne " ^ shiftStack ^ "
	    pop r8
	    pop r12
	    pop rcx

	    mov rax, r10
	    mov rbx, 8
	    mul rbx
	    add rbp, rax
	    add rsp, rax 

	    jmp " ^fixN ^ "

	    " ^ shiftStackAndPushNil ^ ":
	    push rcx
	    push r12
	    push r8
	    mov rcx, 4 + "^ (string_of_int fixedParamsCount)^";rcx = frame size
	    mov r12, 1 ; r12 = i
	    " ^ shiftStack_nil ^ ":
	    	mov r8, qword [rbp+r12*8]
	       	mov [rbp+ 8*r12 - 8], r8
	    	inc r12 
	    	dec rcx
	    	jne " ^ shiftStack_nil ^ "
	    pop r8
	    pop r12
	    pop rcx

	    sub rbp, 8
	    sub rsp, 8

	    ;;push nil -- > check this!
	    mov r8, [SOB_NIL_ADDRESS] \n"
	    ^ (overrideLastOptWith "r8")^


	    ";fix n to be fixedParamsCount + 1:
	  	"^ fixN ^ ":
	 	mov qword [rbp + 3*8], " ^ (string_of_int (fixedParamsCount + 1)) ^ "\n"
	   

	    and overrideLastOptWith val_ =  
	    	"mov r9, qword [rbp + 8 *3]
	    	add r9, 3 ;;r9 = [rbp + 3*8] + 3  = index of last opt
	   	 	mov qword [rbp + 8*r9], "^ val_ ^"\n"

(*   			(* r = [rbp +- 8*i] , sign = sub/add*)
  		and init_register_with_rbp_val reg i sign = 
  			"mov "^ reg^", rbp
  			push rax
  			mov rax, WORD_SIZE
  			mul "^i ^"\n"^
  			sign ^ reg ^ ", rax
  			pop rax
  			mov "^ reg ^", ["^reg^"] \n" *)
  		

	    and applicCodeGen proc argList deepCounter=
	    let notAClosureLabel = (makeNumberedLabel "NotAClosure" !applicCounter) in
	    let finishedApplicLabel = (makeNumberedLabel "FinishedApplic" !applicCounter) in
	    let f argExpr acc = acc ^ ((genCode argExpr deepCounter)^"\n push rax\n") in 
	    	(List.fold_right f argList "") ^ (*pushing the args last to first*)
	    	"push " ^ (string_of_int (List.length argList)) ^ "\n" ^ (*num of args*)
	    	(genCode proc deepCounter) ^ "\n" ^
	    	
	    	";check if closure \n"^
	    	"cmp byte [rax], T_CLOSURE\n" ^
	    	"jne " ^ notAClosureLabel ^ "\n\n" ^

	    	"push qword [rax+TYPE_SIZE]  ;push env:\n"^
	    	"call [rax+TYPE_SIZE+WORD_SIZE] ;call closure_code:\n\n"^
	    	
			";cleaning the stack \n"^
			"add rsp, 8*1 ; pop env\n"^
			"pop rbx ; pop arg count\n"^
			"shl rbx, 3 ; rbx = rbx * 8\n"^
			"add rsp, rbx; pop args\n"^
	    	"jmp " ^ finishedApplicLabel ^ "\n\n" ^

	    	notAClosureLabel ^ ":\n" ^
	    	"\tmov rdi, notACLosureError\n" ^
	    	"\tcall print_string\n" ^
	    	"\tmov rax, 1\n" ^
	    	"\tsyscall\n" ^
	    	finishedApplicLabel ^ ":\n" ^ (incCounter applicCounter)


	     and applicTPCodeGen proc argList deepCounter=
	    let notAClosureLabel = (makeNumberedLabel "NotAClosureTP" !applicTPCounter) in
	    let loopLabel = (makeNumberedLabel "Loop" !applicTPCounter) in
	    let f argExpr acc = acc ^ ((genCode argExpr deepCounter)^"\n push rax\n") in 
	    	(List.fold_right f argList "") ^ (*pushing the args last to first*)
	    	"push " ^ (string_of_int (List.length argList)) ^ "\n" ^ (*num of args*)
	    	(genCode proc deepCounter) ^ "\n" ^
	    	"mov r13, rax ;save closure\n"^
	    	"cmp byte [rax], T_CLOSURE\n" ^
	    	"jne " ^ notAClosureLabel ^ "\n" ^
	    	"push qword [rax + TYPE_SIZE] ;push env\n" ^ 
	    	"push qword [rbp + WORD_BYTES*1] ;old ret address\n" ^
	    	"mov qword r10, [rbp] ; r10 = old old rbp\n"^
	    	"mov r11, PARAM_COUNT ; save old param count \n"^

  			"push rax\n"^
  			"push rbx\n"^
  		  	"mov rbx, 8\n"^
  			"mov rax, PARAM_COUNT\n"^
  			"add rax, 4\n"^
  			"mov rcx, "^(string_of_int (3+(List.length argList)))^"\n"^
  			"mov r12, 1\n"^
  			loopLabel ^ ":\n"^
  			"dec rax\n"^
  			"mov r8, rbp\n"^
  			"push rax\n"^
  			"mov rax, WORD_SIZE\n"^
  			"mul r12\n"^
  			"sub r8, rax\n"^
  			"pop rax\n"^
  			"mov r8, [r8]  \n"^
 	  		"mov [rbp+WORD_BYTES*rax], r8\n"^
  			"inc r12\n"^
  			"dec rcx\n"^
  			"jne " ^ loopLabel ^ "\n\n"^

  			";clean stack: add rsp , WORD_BYTES*(r11+4)\n"^
  			"push rax\n"^
  			"mov rax, WORD_SIZE\n"^
  			"add r11, 4\n"^
  			"mul r11\n"^
  			"add rsp, rax\n"^
  			"pop rax\n\n"^
  			"pop rbx\n"^
  			"pop rax\n"^

	    	"mov rbp, r10 ;risky line!!!!!  maybe save in rbp instead (brama) , save old old rbp\n"^
	    	"jmp [r13 + TYPE_SIZE + WORD_BYTES]\n" ^(*call proc-body*)
	    	notAClosureLabel ^ ":\n" ^
	    	"\tmov rdi, notACLosureError\n" ^
	    	"\tcall print_string\n" ^
	    	"\tmov rax, 1\n" ^
	    	"\tsyscall\n" ^ (incCounter applicTPCounter)


	   in genCode e 0;;
	    	



(*Tests*)
(* - make_const_list test *)
(*
(printThreesomesList (make_consts_tbl [Const'(Sexpr(Number(Int(1))))]));;
(print_string "\n");;


(print_string (print_consts_as_list (make_consts_list [Const'(Sexpr(Pair(Number (Int 1), Nil))); Const'(Sexpr(Pair(Bool true, Nil))); Const'(Sexpr(Pair(Number (Int 1), Nil)))])));;
(print_string "\n");;

(print_string (print_consts_as_list (make_consts_list [LambdaSimple' ([], Set' (Var' (VarParam ("x", 0)), Box' (VarParam ("x", 0))))])));;
(print_string "\n");;


(print_string (print_consts_as_list (expandConstList (make_consts_list [Applic' (Var' (VarFree "list"),
 [Const' (Sexpr (String "ab"));
  Const' (Sexpr (Pair (Number (Int 1), Pair (Number (Int 2), Nil))));
  Const' (Sexpr (Symbol "c")); Const' (Sexpr (Symbol "ab"))])]))));;
(print_string "\n");;

(*  '#(1 '(5 6)) *)
(print_string (print_consts_as_list (expandConstList (make_consts_list [Const'
 (Sexpr
   (Vector
     [Number (Int 1);
      Pair (Symbol "quote",
       Pair (Pair (Number (Int 5), Pair (Number (Int 6), Nil)), Nil))]))]))));;
(print_string "\n");;
 *)

(*
printThreesomesList (populateConstList(expandConstList (make_consts_list  [Applic' (Var' (VarFree "list"),
 [
   Const'(Sexpr(Pair(Number(Int 1),Pair(Number(Int 2),Nil))));
   Var'(VarFree "list"); Const' (Sexpr (Symbol "ab"))])])));;
*)

(* LambdaSimple' ([], Const' (Sexpr (Number (Int (1)))))])])));;
*)

end;;

