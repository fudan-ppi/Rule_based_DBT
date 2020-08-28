module V = Vine
open Fragment_machine (* for register names *)
open Exec_options (* for architecture symbols *)
open ExtLib
open Imm_parser

(* Sample usage:

  ./exec_utils/insn_compare -input-map r2=ecx \
      -output-map r2=ecx -output-map r1=eax \
      -x86-insns 'ff 01 8b 01' \
      -arm-insns 'e5921000 e2811001 e5821000'

  ff 01    incl   (%ecx)
  8b 01    mov    (%ecx),%eax

  e5921000 ldr	  r1, [r2]
  e2811001 add    r1, r1, #1
  e5821000 str	  r1, [r2]
*)

(* An example that needs SMT solving:

  ./exec_utils/insn_compare -input-map r2=ebx \
      -output-map r1=eax \
      -x86-insns 'b1 09 0f b6 c9 8b c3 f7 e1' \
      -arm-insns 'e0821182' \
      -solver smtlib-batch -solver-path stp/stp

  b1 09      mov    $0x9,%cl
  0f b6 c9   movzbl %cl,%ecx
  8b c3      mov    %ebx,%eax
  f7 e1      mul    %ecx

  e0821182   add r1, r2, r2, lsl #3
*)

(* An example with extended memory verification

  ./exec_utils/insn_compare \
    -solver smtlib-batch \
    -solver-path stp/stp \
    -arm-insns 'e1d205ba e7917100 e2877001 e7817100' \
    -x86-insns '0f b7 44 73 5a ff 84 82 60 b1 00 00' \
    -init-map r2=ebx \
    -init-map 0=esi \
    -init-map 1=imm_101 \
    -init-map imm_000=imm_100 \
    -init-map r1=edx \
    -init-map '(1<<imm_001)'=imm_103 \
    -init-map 0=imm_102 \
    -mem-map '[r2, #90],imm_000'='0x5a(%ebx,%esi,2),imm_100,imm_101' \
    -mem-map '[r1, r0, lsl #2],imm_001'='0xb160(%edx,%eax,4),imm_102,imm_103' \
    -arm-def-reg 'r0, r7' \
    -x86-def-reg 'eax'

  ldrh  r0, [r2, #90]
  ldr r7, [r1, r0, lsl #2]
  add r7, r7, #1
  str r7, [r1, r0, lsl #2]

  movzwl  90(%ebx,%esi,2), %eax
  incl  45408(%edx,%eax,4)
*)

(* Memory location, generalized to: base + index * scale + offset 
   Here, only base must be present, and index, scale, and offset are optional*)
type memory_location =
  Fragment_machine.register_name * string * string * string

(* Mapping between arm and x86, including register, memory, or immediate.
   The format is:
     arm_string, arm_init exp, x86_string, x86_init_exp, type 
   For register mapping, different x86 (host) registers can be mapped to the same arm (guest) register, but not vise versa. *)
type i_mapping = (* parsed input mapping *) 
  | Reg2RegMapping of Fragment_machine.register_name list * Fragment_machine.register_name list * V.typ
  | Con2RegMapping of int * Fragment_machine.register_name * V.typ
  | Mem2MemMapping of string * string list * memory_location * string * string list * memory_location * V.typ
  | Imm2ImmMapping of string * string * V.typ
  | Con2ImmMapping of int * string

type s_mapping = (* mapping from immediate or memory to corresponding Vine exp or var *)
  | ARMImmMapping of string * V.var * string * V.typ (* imm string, vine var, vine var name, type *)
  | X86ImmMapping of string * V.exp * V.typ (* imm string, vine exp, type *)
  | MemMapping of string list * V.var * V.var * string * V.typ (* pc list, addr var, init var, init var name, type *)

type p_mapping = (* parameterize immediate values in non-memory instructions *)
  string * int * string (* instruction pc, integer constant, imm string *)

let char_list_of_string s =
  let l = ref [] in
    String.iter (fun c -> l := c :: !l) s;
    List.rev !l

let is_addr l =
  try
    ignore(V.label_to_addr l); true
  with V.VineError("label_to_addr given non address-like label") -> false

let check_for_next_eip sl =
  let next_eip = ref None in
    List.iter
      (function
         | V.Jmp(V.Name(l)) when is_addr l ->
             next_eip := Some (V.label_to_addr l)
         | _ -> ())
      sl;
    !next_eip

let pc_var = V.newvar "PC" V.REG_32 (* architecture independent name *)

let label_to_addr e =
  match e with
    | V.Name(s) when is_addr s ->
	V.Constant(V.Int(V.REG_32, (V.label_to_addr s)))
    | _ -> e

let convert_jumps (dl,sl) =
  let rec loop = function
    | V.Jmp(targ) :: rest ->
        V.Move(V.Temp(pc_var), (label_to_addr targ)) ::
          (loop rest)
    | V.CJmp(cond, t1, t2) :: rest ->
	loop (V.Jmp(V.Ite(cond, (label_to_addr t1), (label_to_addr t2))) ::
		rest)
    | st :: rest -> st :: (loop rest)
    | [] -> []
  in
    (dl, loop sl)

let string_of_execution_arch = function
  | X86 -> "x86"
  | ARM -> "arm"
  | X64 -> "x64"

let parse_reg str arch =
  let (reg, archs, ty) = match str with
    | "r0"  -> ( R0, [ARM], V.REG_32)
    | "r1"  -> ( R1, [ARM], V.REG_32)
    | "r2"  -> ( R2, [ARM], V.REG_32)
    | "r3"  -> ( R3, [ARM], V.REG_32)
    | "r4"  -> ( R4, [ARM], V.REG_32)
    | "r5"  -> ( R5, [ARM], V.REG_32)
    | "r6"  -> ( R6, [ARM], V.REG_32)
    | "r7"  -> ( R7, [ARM], V.REG_32)
    | "r8"  -> ( R8, [ARM], V.REG_32)
    | "r9"  -> ( R9, [ARM], V.REG_32)
    | "r10"|"sl" -> (R10, [ARM], V.REG_32)
    | "r11"|"fp" -> (R11, [ARM], V.REG_32)
    | "r12"|"ip" -> (R12, [ARM], V.REG_32)
    | "r13"|"sp" -> (R13, [ARM], V.REG_32)
    | "r14"|"lr" -> (R14, [ARM], V.REG_32)
    | "r15"|"pc" -> (R15, [ARM], V.REG_32)
    | "ebp" -> (R_EBP, [X86], V.REG_32)
    | "esp" -> (R_ESP, [X86], V.REG_32)
    | "esi" -> (R_ESI, [X86], V.REG_32)
    | "edi" -> (R_EDI, [X86], V.REG_32)
    | "eax" -> (R_EAX, [X86], V.REG_32)
    | "ebx" -> (R_EBX, [X86], V.REG_32)
    | "ecx" -> (R_ECX, [X86], V.REG_32)
    | "edx" -> (R_EDX, [X86], V.REG_32)
    | _ -> failwith ("Unrecognized register name " ^ str)
  in
    if not (List.mem arch archs) then
      failwith ("Register " ^ str ^ " is not an " ^
		  (string_of_execution_arch arch) ^ " register");
    (reg, ty)

let parse_init_mapping fm arm_s x86_s = 
  let arm_fc = arm_s.[0] in
  let x86_fc = x86_s.[0] in
  let err_msg = "Unsupported mapping: " ^ arm_s ^ "=" ^ x86_s in
  match arm_fc with
    | 'r' | 'l' | 's' -> (* arm register *)
      (match x86_fc with
        | 'e' -> (* x86 register *) 
          let (arm_reg, _) = parse_reg arm_s ARM in
          let (x86_reg, _) = parse_reg x86_s X86 in
          Reg2RegMapping([arm_reg], [x86_reg], V.REG_32)
        | _ -> failwith (err_msg))
    | '0' .. '9' -> (* arm constant *)
      let arm_const = int_of_string arm_s in
      (match x86_fc with
        | 'e' -> (* x86 register *)
          let (x86_reg, _) = parse_reg x86_s X86 in
          Con2RegMapping(arm_const, x86_reg, V.REG_32)
        | 'i' -> (* x86 immediate *)
          Con2ImmMapping(arm_const, x86_s)
        | _ -> failwith (err_msg))
    | 'i' | '-' | '~' -> (* arm immediate *)
      (match x86_fc with
        | 'i' -> (* x86 immediate *)
          Imm2ImmMapping(arm_s, x86_s, V.REG_32)
        | _ -> failwith (err_msg))
    | '(' -> (* arm immediate, but with operation, will be handled later *)
      let arm_imm = String.sub arm_s 1 ((String.length arm_s)-2) in
      (match x86_fc with
        | 'i' -> (* x86 immediate *)
          Imm2ImmMapping(arm_imm, x86_s, V.REG_32)
        | _ -> failwith (err_msg))
    | _ -> failwith (err_msg)

let merge_guest_reg_mapping map_t im =
  match map_t with
    | Reg2RegMapping(arm_l, x86_l, _) ->
      let arm_reg = List.nth arm_l 0 in
      let x86_reg = List.nth x86_l 0 in
      let merged = ref false in
      let rec do_merge im = match im with
        | m :: t -> (match m with
          | Reg2RegMapping(arm_l_pre, x86_l_pre, typ) -> 
            if List.exists (fun reg -> reg = arm_reg) arm_l_pre then (
              merged := true;
              let x86_l_pre = x86_reg :: x86_l_pre in
              Reg2RegMapping(arm_l_pre, x86_l_pre, typ) :: t
            ) else
              m :: do_merge t
          | _ -> m :: do_merge t)
        | [] -> []
      in
      let ret_im = List.rev (do_merge im) in
      if !merged then ret_im
      else map_t :: ret_im
    | _ -> map_t :: im

(* Split string into list using dc as seperator, not support ' ' as seperator *)
let split_str_to_list str dc =
  let rec aux acc_i acc_l str len =
    match len with
      | 0 -> acc_i :: acc_l
      | _ -> match str.[0] with
        | ' ' -> aux acc_i acc_l (String.sub str 1 (len-1)) (len-1)
        | c when c = dc -> aux "" (acc_i :: acc_l) (String.sub str 1 (len-1)) (len-1)
        | _ as c -> aux (acc_i ^ (String.make 1 c)) acc_l (String.sub str 1 (len-1)) (len-1)
  in
  List.rev (aux "" [] str (String.length str))

(* Parse memory operands.
   Currently, we only support the following syntax:
   1. ARM mem syntax: [reg0, reg1/#imm, lsl #imm], imm-xxx, 0x1000x
   2. X86 mem syntax: off(%reg0, %reg1, imm), imm-xxx, 0x804800x *)
let parse_mem str arch =
  let split_addr_imm_pc str arch =
    let split_imm_pc imm_pc_str =
      let rec do_split imm_pc_l =
        match imm_pc_l with
          | [] -> ([], [])
          | x :: l -> 
            let a, b = do_split l in
            if String.exists x "imm" then (x::a, b) else (a, x::b) in
      let new_str = match imm_pc_str.[0] with
          | ',' -> String.sub imm_pc_str 1 (String.length imm_pc_str - 1)
          | _ -> imm_pc_str in
      let imm_pc_l = split_str_to_list new_str ',' in
      let imm_l, pc_l = do_split imm_pc_l in
      (imm_l, pc_l) in
    let (addr_str, addr_l, imm_pc_str) = match arch with
      | ARM ->
          let (addr_str, imm_pc_str) = split_string ']' str in
          let addr_only = addr_str ^ "]" in
          let len = String.length addr_str in
          let addr_str = String.sub addr_str 1 (len - 1) in
          let addr_list = split_str_to_list addr_str ',' in
          (addr_only, addr_list, imm_pc_str)
      | X86 ->
          let (addr_str, imm_pc_str) = split_string ')' str in
          let addr_only = addr_str ^ ")" in
          let addr_l_1 = split_str_to_list addr_str '(' in
          let addr_l_2 = split_str_to_list (List.nth addr_l_1 1) ',' in
          let addr_list = (List.nth addr_l_1 0) :: addr_l_2 in
          (addr_only, addr_list, imm_pc_str)
      | _ -> failwith ("Unsupported architecture") in
    let imm_l, pc_l = split_imm_pc imm_pc_str in
    (addr_str, pc_l, addr_l, imm_l)
  in
  let (addr_str, pc_list, addr_list, imm_list) = split_addr_imm_pc str arch in
  let addr_len = List.length addr_list in
  let (base, index, scale, offset) = match arch with
    | ARM ->
      let (base, _) = parse_reg (List.nth addr_list 0) ARM in
      let addr_len = addr_len - 1 in
      let arm_m = match addr_len with
        | 0 -> (base, "", "", "")
        | 1 | 2 -> (* check it is an offset or idx *)
          let cur_str = List.nth addr_list 1 in
          let cur_fc = cur_str.[0] in
          (match cur_fc with
            | '#' -> (* offset *)
              let off = List.nth imm_list 0 in
              (base, "", "", off)
            | 'r' -> (* index *)
              let index = cur_str in
              let addr_len = addr_len - 1 in
              if addr_len == 1 then
                let scale = List.nth imm_list 0 in
                (base, index, scale, "")
              else
                (base, index, "", "") 
            | _ -> failwith ("Unknow type " ^ cur_str))
        | _ -> failwith ("Unknow address length")
      in
      arm_m
    | X86 ->
      let disp, imm_idx = match List.nth addr_list 0 with
        | "" -> "", 0
        | _ -> List.nth imm_list 0, 1 in
      let cur_str = List.nth addr_list 1 in
      let base_str = String.sub cur_str 1 (String.length cur_str - 1) in
      let (base, _) = parse_reg base_str X86 in
      let addr_len = addr_len - 2 in
      let x86_m = match addr_len with
        | 0 -> (base, "", "", disp)
        | 1 | 2 -> (* have index *)
          let cur_str = List.nth addr_list 2 in
          let len = String.length cur_str in
          let index = String.sub cur_str 1 (len - 1) in
          let addr_len = addr_len - 1 in
          if addr_len == 1 then
            let scale = List.nth imm_list imm_idx in
            (base, index, scale, disp)
          else
            (base, index, "", disp)
        | _ -> failwith ("[x86] too long addres length")
      in
      x86_m
    | _ -> failwith ("Unsupported architecture, more time")
  in
  (addr_str, pc_list, (base, index, scale, offset))

let parse_hex_bytes s =
  let bytes_l = ref [] in
  let byte_s = ref "" in
    for i = 0 to (String.length) s - 1 do
      let c = s.[i] in
	if c = ' ' then
	  () (* skip spaces *)
	else
	  (byte_s := !byte_s ^ (String.make 1 c);
	   if (String.length !byte_s) = 2 then
	     let b = int_of_string ("0x" ^ !byte_s) in
	       bytes_l := (Char.chr b) :: !bytes_l;
	       byte_s := ""
	  )
    done;
    String.concat "" (List.map (fun c -> String.make 1 c) (List.rev !bytes_l))

let pack_word_le w =
  let b0 = Int64.to_int (Int64.logand w 0xffL) and
      b1 = Int64.to_int (Int64.logand (Int64.shift_right w 8) 0xffL) and 
      b2 = Int64.to_int (Int64.logand (Int64.shift_right w 16) 0xffL) and 
      b3 = Int64.to_int (Int64.logand (Int64.shift_right w 24) 0xffL)
  in
  let s0 = String.make 1 (Char.chr b0) and
      s1 = String.make 1 (Char.chr b1) and
      s2 = String.make 1 (Char.chr b2) and
      s3 = String.make 1 (Char.chr b3)
  in
    s0 ^ s1 ^ s2 ^ s3

let parse_hex_words s =
  let word_strs = ref [] in
  let word_s = ref "" in
    for i = 0 to (String.length) s - 1 do
      let c = s.[i] in
	if c = ' ' then
	  () (* skip spaces *)
	else
	  (word_s := !word_s ^ (String.make 1 c);
	   if (String.length !word_s) = 8 then
	     let w = Int64.of_string ("0x" ^ !word_s) in
	       word_strs := (pack_word_le w) :: !word_strs;
	       word_s := ""
	  )
    done;
    String.concat "" (List.rev !word_strs)

(* Each mapping element is a RegMapping or MemMapping *)
let init_mapping = ref []
let internal_mapping = ref []
(*let input_mapping = ref []
let output_mapping = ref []*)
let output_reg = ref ([], []) (* (arm_out_reg, x86_out_reg) *)
let condition_mapping = ref []
let cc_mapping = ref []
let imm_para_mapping = ref []

let translate_str addr la_arch dl mem_var gamma str =
  let bytes_a = Array.of_list (char_list_of_string str) in
  let asmp = Libasmir.byte_insn_to_asmp la_arch addr bytes_a in
  match Asmir.asm_addr_to_vine gamma asmp addr with
    | [V.Block(dl, sl)] -> Frag_simplify.simplify_frag (dl, sl)
    | _ -> failwith "Unexpected translated format"

let translate_insns addr la_arch dl mem_var gamma str =
  let rec loop addr str =
    let (dl1, sl1) = translate_str addr la_arch dl mem_var gamma str in
    let block1 = V.Block(dl1, sl1) in
    match check_for_next_eip sl1 with
      | Some addr' when addr' = addr ->
	  [block1]
      | None ->
	  [block1]
      | Some addr2 ->
	  let len = Int64.to_int (Int64.sub addr2 addr) in
	  let remain_len = String.length str - len in
	    assert(remain_len >= 0);
	    if remain_len = 0 then
	      [block1]
	    else
	      let str' = String.sub str len remain_len in
		block1 :: (loop addr2 str')
  in
    loop addr str

let rec merge_blocks blocks =
  let rec loop blocks =
    match blocks with
      | [] -> ([], [])
      | V.Block(dl, sl) :: rest ->
	  let (dl_r, sl_r) = loop rest in
	    (dl @ dl_r, sl @ sl_r)
      | _ :: rest ->
	  failwith "Non-block in stmt list in merge_blocks"
  in
    (* convert_jumps *) (Frag_simplify.simplify_frag (loop blocks))

module SRFM = Sym_region_frag_machine.SymRegionFragMachineFunctor
  (Symbolic_domain.SymbolicDomain)

let var_idx = ref 0
let generate_var_name str =
  let name = str ^ (string_of_int !var_idx) in
  var_idx := !var_idx + 1;
  name

exception Not_Parsed
let select_map arch map flag =
  match (arch, map) with
    | (ARM, (arm_i, x86_i)) -> if flag then arm_i else x86_i
	  | (X86, (arm_i, x86_i)) -> if flag then x86_i else arm_i
	  | _ -> failwith "Bad architecture"

let init_reg_imm fm arch input_names =
  List.iter2 ( fun map var_name ->
    let rec find_imm_var imm_s im = 
      match im with
        | MemMapping(_) :: l | X86ImmMapping(_) :: l -> find_imm_var imm_s l
        | ARMImmMapping(s, var, name, _) :: l -> if (s = imm_s) then (var, name) else find_imm_var imm_s l
        | _ -> raise Not_Parsed 
    in
    match map with
      | Reg2RegMapping(arm_reg_l, x86_reg_l, ty) -> (* arm and x86 registers have the same values *)
        let reg_l = select_map arch (arm_reg_l, x86_reg_l) true in
        List.iter (fun reg -> fm#set_word_reg_symbolic reg var_name) reg_l
      | Con2RegMapping(value, x86_reg, ty) -> (* set a x86 register to constant *)
        if arch == X86 then fm#set_word_reg_constant x86_reg value
      | Imm2ImmMapping(arm_s, x86_s, ty) -> (* Mapping between arm and x86 immediates, arm_s might have operations *)
        let arm_ast = Imm_parser.parse_from_str arm_s in
        let x86_ast = Imm_parser.parse_from_str x86_s in
        (* We set the initial typ to V.REG_32. It might be changed to V.REG_8 *)
        let rec parse_to_vine_exp ast typ =
          match ast with
            | Ast.Int(value) -> V.Constant(V.Int(typ, Int64.of_int value)), typ
            | Ast.Var(name) -> (* We need to generate an initialized variable *)
              let ve =
                try
                  let (var, v_name) = find_imm_var name !internal_mapping in
                  fm#declare_initialized_var var v_name;
                  V.Lval(V.Temp(var))
                with Not_Parsed -> (* if not parsed_before we need to generate new exp *)
                  let v_name = generate_var_name "imm_init_" in
                  let var = fm#generate_initialized_var v_name typ in
                  internal_mapping := ARMImmMapping(name, var, v_name, typ) :: !internal_mapping;
                  V.Lval(V.Temp(var))
              in
              ve, typ
            | Ast.Not(a) ->
              let ve, vt = parse_to_vine_exp a typ in
              V.UnOp(V.NOT, ve), vt
            | Ast.Neg(a) ->
              let ve, vt = parse_to_vine_exp a typ in
              V.UnOp(V.NEG, ve), vt
            | Ast.Lshift(a1, a2) ->
              let ve1, vt1 = parse_to_vine_exp a1 V.REG_8 in
              let ve2, vt2 = parse_to_vine_exp a2 V.REG_8 in
              assert (vt1 = vt2);
              V.BinOp(V.LSHIFT, ve1, ve2), vt1
            | Ast.Or(a1, a2) ->
              let ve1, vt1 = parse_to_vine_exp a1 typ in
              let ve2, vt2 = parse_to_vine_exp a2 typ in
              assert (vt1 = vt2);
              V.BinOp(V.BITOR, ve1, ve2), vt1
            | Ast.Add(a1, a2) ->
              let ve1, vt1 = parse_to_vine_exp a1 typ in
              let ve2, vt2 = parse_to_vine_exp a2 typ in
              assert (vt1 = vt2);
              V.BinOp(V.PLUS, ve1, ve2), vt1
            | Ast.Sub(a1, a2) ->
              let ve1, vt1 = parse_to_vine_exp a1 typ in
              let ve2, vt2 = parse_to_vine_exp a2 typ in
              assert (vt1 = vt2);
              V.BinOp(V.MINUS, ve1, ve2), vt1
        in
        let v_exp, typ = parse_to_vine_exp arm_ast V.REG_32 in
        (match x86_ast with
          | Ast.Var(name) ->
            (try
              ignore (find_imm_var name !internal_mapping)
            with Not_Parsed -> (* if not parsed_before then we need to generate new exp *)
              internal_mapping := X86ImmMapping(name, v_exp, V.REG_32) :: !internal_mapping)
          | _ -> failwith ("Unsupported immediate mapping for x86 " ^ x86_s))
      | Con2ImmMapping(value, imm_s) -> (* set a x86 immediate to constant *)
        (try
          ignore (find_imm_var imm_s !internal_mapping)
        with Not_Parsed -> 
          let exp = V.Constant(V.Int(V.REG_32, (Int64.of_int value))) in
          internal_mapping := X86ImmMapping(imm_s, exp, V.REG_32) :: !internal_mapping)
      | _ -> ()
  ) !init_mapping input_names

let rec find_imm_exp imm_s imapping =
  match imapping with
    | MemMapping(_) :: l -> find_imm_exp imm_s l
    | ARMImmMapping(s, var, _, _) :: l -> if (s = imm_s) then V.Lval(V.Temp(var)) else find_imm_exp imm_s l
    | X86ImmMapping(s, exp, _) :: l -> if (s = imm_s) then exp else find_imm_exp imm_s l
    | _ -> failwith ("Cannot find expression for this imm: " ^ imm_s)

let parameterize_imm prog =
  let (decl, stmt) = prog in
  let nst = ref [] in
  nst := stmt;
  List.iter (fun map ->
    let (insn_pc, const, imm_str) = map in
    let new_exp = find_imm_exp imm_str !internal_mapping in
    let revise_vine_ir st = 
      let rec get_exp_typ exp =
        match exp with
          | V.BinOp(op, e1, e2) -> 
            let ty1 = get_exp_typ e1 and ty2 = get_exp_typ e2 in 
            (match op with
              | V.PLUS | V.MINUS | V.TIMES | V.DIVIDE | V.SDIVIDE 
              | V.MOD | V.SMOD | V.BITAND | V.BITOR | V.XOR -> assert(ty1 = ty2); ty1
              | V.LSHIFT | V.RSHIFT | V.ARSHIFT -> ty1
              | V.EQ | V.NEQ | V.LT | V.LE | V.SLT | V.SLE -> assert(ty1 = ty2); V.REG_1)
          | V.UnOp(_, exp) -> get_exp_typ exp
          | V.Cast(_, typ, _) -> typ
          | V.Constant(V.Int(typ, _)) -> typ
          | V.Lval(lv) -> (
            match lv with
              | V.Temp(_, _, typ) -> typ
              | V.Mem(_, _, typ) -> typ)
          | _ -> failwith ("Unsupported exp when get the type of the exp.") in
      (* The "rtype" parameter is used to indicate what kind of revision of new_exp we can perform when match the constants.
         0: no revision is allowed (reserved, not used now)
         1: only lsl revision is allowed (for scale)
         2: any revision is allowed
         Basically, if the constant is used for shift-like operation, the constant should be matched exactly,
         This is a heuristic approach, so it will be changed later. *)
      let rec do_revise_exp exp rtype =
        let exp_typ = get_exp_typ exp in
        let exp_n = match exp with
          | V.BinOp(binop, exp1, exp2) -> (match binop with
            | V.LSHIFT | V.RSHIFT | V.ARSHIFT -> V.BinOp(binop, (do_revise_exp exp1 1), (do_revise_exp exp2 1))
            | _ -> V.BinOp(binop, (do_revise_exp exp1 rtype), (do_revise_exp exp2 rtype)))
          | V.UnOp(unop, exp) -> V.UnOp(unop, (do_revise_exp exp rtype))
          | V.Cast(ct, t, exp) -> V.Cast(ct, t, (do_revise_exp exp rtype))
          | V.Constant(c) as oexp ->
            (match c with
              | V.Int(typ, cval) ->
                let cal_int = Int64.to_int cval in
                if (cal_int = const) then new_exp
                else (
                  if rtype = 2 || rtype = 1 then (
                    if (1 lsl cal_int = const) then (
                      match new_exp with
                        | V.BinOp(V.LSHIFT, e1, e2) -> 
                          if e1 = V.Constant(V.Int(V.REG_8, (Int64.of_int 1))) then e2
                          else oexp (* TODO: construct a new expression *)
                        | _ -> oexp
                    ) else if rtype = 2 then (
                      if (cal_int = (- const)) then 
                        (match new_exp with
                          | V.UnOp(V.NEG, n_exp) -> n_exp
                          | _ -> V.UnOp(V.NEG, new_exp))
                      else if (cal_int = (lnot const)) then
                        V.UnOp(V.NOT, new_exp)
                      else oexp
                    ) else oexp)
                  else oexp )
              | _ -> oexp)
          | _ as o -> o
        in
        let exp_n_typ = get_exp_typ exp_n in
        (* TODO: decide cast_type based on the difference between exp_typ and exp_n_typ *)
        if exp_typ <> exp_n_typ then
          if exp_typ = V.REG_64 && exp_n_typ = V.REG_32 then
            V.Cast(V.CAST_SIGNED, exp_typ, exp_n)
          else
            V.Cast(V.CAST_LOW, exp_typ, exp_n)
        else
          exp_n
      in
      let rec do_revise fl =
        match fl with
          | [] -> []
          | V.Move(lva, exp) as move :: lr ->
            let nmove = match lva with
              | V.Temp(var) ->
                let (_, name, _) = var in
                if String.exists name "R_ZF" then move (* Skip the constant 0 in calculation for R_ZF *)
                else V.Move(lva, do_revise_exp exp 2)
              | _ -> V.Move(lva, do_revise_exp exp 2)
            in
            nmove :: (do_revise lr)
          | V.Label(_) as c :: lr -> c :: lr
          | _ as t :: lr -> t :: (do_revise lr) in
      let rec do_find_revise st =
        match st with
          | [] -> []
          | V.Label(pc_str) as c :: l ->
            if pc_str = "pc_" ^ insn_pc then
              c :: (do_revise l)
            else
              c :: (do_find_revise l)
          | _ as t :: l -> t :: (do_find_revise l)
      in
      do_find_revise st
    in
    nst := revise_vine_ir !nst;
  ) !imm_para_mapping;
  (decl, !nst)

let init_mem fm arch dl prog =
  let (decl, stmt) = prog in
  let nst = ref [] in
  nst := stmt;
  let mem_out_mapping = ref [] in
  List.iter ( fun map ->
    match map with
      | Mem2MemMapping(arm_addr_str, arm_pc_list, arm_addr, x86_addr_str, x86_pc_list, x86_addr, ty) ->
        (* Mapping between arm and x86 memory *)
        let rec find_mem_val_name pc_s im =
          let pc_s_0 = List.nth pc_s 0 in
          match im with
            | MemMapping(pc, _, var, name, _) :: l ->
              if List.exists (fun s -> s == pc_s_0) pc then (var, name) else find_mem_val_name pc_s l
            | ARMImmMapping(_) :: l | X86ImmMapping(_) :: l -> find_mem_val_name pc_s l
            | _ -> raise Not_Parsed in
        let rec insert_revise_vine_ir pc_list addr_var addr_calc_stmt mem_init_stmt st =
          let do_revise_lvalue lval =
            match lval with
              | V.Mem(var, exp, typ) -> V.Mem(var, V.Lval(V.Temp(addr_var)), typ)
              | _ as t -> t in
          let rec do_revise_exp exp = 
            match exp with
              | V.BinOp(binop, e1, e2) -> V.BinOp(binop, (do_revise_exp e1), (do_revise_exp e2))
              | V.UnOp(unop, e) -> V.UnOp(unop, (do_revise_exp e))
              | V.Cast(ct, t, e) -> V.Cast(ct, t, (do_revise_exp e))
              | V.Lval(l) ->
                let nl = do_revise_lvalue l in
                V.Lval(nl)
              | _ as t -> t
          in
          let first = ref true in
          let rec do_insert_revise st =
            match st with
              | [] -> []
              | V.Label(pc_str) as c :: l ->
                let pc_s = String.sub pc_str 3 (String.length pc_str - 3) in
                if List.exists (fun s -> s = pc_s) pc_list then (
                  let rec do_revise fl =
                    match fl with
                      | [] -> []
                      | V.Move(lva, exp) :: lr ->
                        let nmove = V.Move((do_revise_lvalue lva), (do_revise_exp exp)) in
                        nmove :: (do_revise lr)
                      | V.Label(_) as c :: lr -> c :: lr
                      | _ as t :: lr -> t :: (do_revise lr) in
                  let nl = do_revise l in
                  if !first then ( (* We only need to add address calculation and initialization at the first occurence *)
                    first := false;
                    c :: addr_calc_stmt :: mem_init_stmt :: (do_insert_revise nl)
                  ) else
                    c :: (do_insert_revise nl)
                ) else
                    c :: (do_insert_revise l)
              | _ as t :: l -> t :: (do_insert_revise l)
          in
          do_insert_revise st
        in
        (* Prepare Vine expression for memory address calculation *)
        let addr_str = select_map arch (arm_addr_str, x86_addr_str) true in
        let pc_list = select_map arch (arm_pc_list, x86_pc_list) true in
        let r_pc_list = select_map arch (arm_pc_list, x86_pc_list) false in
        let addr = select_map arch (arm_addr, x86_addr) true in
        let (base, idx_str, scale_str, off_str) = addr in
          let addr_exp = fm#get_reg_exp base in
          let addr_exp = match idx_str with
            | "" -> addr_exp
            | _ ->
              let (idx, _) = parse_reg idx_str arch in
              let idx_exp = fm#get_reg_exp idx in
              let idx_exp = match scale_str with
                | "" -> idx_exp
                | _ ->
                  let scale_exp = find_imm_exp scale_str !internal_mapping in
                  let is_exp = match arch with
                    | ARM -> V.BinOp(V.LSHIFT, idx_exp, scale_exp)
                    | X86 -> (match scale_exp with
                      | V.BinOp(V.LSHIFT, e1, e2) ->
                        assert (e1 = V.Constant(V.Int(V.REG_8, Int64.of_int 1)));
                        V.BinOp(V.LSHIFT, idx_exp, e2)
                      | _ -> V.BinOp(V.TIMES, idx_exp, scale_exp))
                    | X64 -> failwith ("Unsupported arch, more time needed")
                  in
                  is_exp
              in
              V.BinOp(V.PLUS, addr_exp, idx_exp) 
          in
          let addr_exp = match off_str with
            | "" -> addr_exp
            | _ ->
              let off_exp = find_imm_exp off_str !internal_mapping in
              V.BinOp(V.PLUS, addr_exp, off_exp) in
          let a_name = generate_var_name "mem_addr_" in
          let addr_var = fm#generate_fresh_var a_name V.REG_32 in
          let addr_calc_stmt = V.Move(V.Temp(addr_var), addr_exp) in
          let (mem_init_var, mem_init_var_name) = 
            try
              let var, name = find_mem_val_name r_pc_list !internal_mapping in
              fm#declare_initialized_var var name;
              (var, name)
            with Not_Parsed ->
              let v_name = generate_var_name "mem_init_" in
              let var = fm#generate_initialized_var v_name V.REG_32 in
              (var, v_name)
          in
          internal_mapping := MemMapping(pc_list, addr_var, mem_init_var, mem_init_var_name, V.REG_32) ::
                              !internal_mapping;
          let mem_var = List.nth dl 0 in
          let mem_init_stmt = V.Move(V.Mem(mem_var, V.Lval(V.Temp(addr_var)), V.REG_32), V.Lval(V.Temp(mem_init_var))) in
          (* We need to insert addr_calc_stmt and mem_init_stmt to Vine IR and revise orginal memory access *)
          nst := insert_revise_vine_ir pc_list addr_var addr_calc_stmt mem_init_stmt !nst;
          mem_out_mapping := (addr_str, addr_var, V.REG_32) :: !mem_out_mapping
          (*List.iter (fun s -> Printf.printf "==== new st: %s\n" (V.stmt_to_string s)) nst;
          Printf.printf "======== Handle this memory: base: %s, index: %s, scale: %s, offset: %s\n"
              (reg_to_regstr base) idx_str scale_str off_str;
          Printf.printf "======== address calculation statement: %s" (V.stmt_to_string addr_calc_stmt);
          Printf.printf "======== memory initialization statement: %s" (V.stmt_to_string mem_init_stmt)*)
      | _ -> ()
  ) !init_mapping;
  ((decl, !nst), !mem_out_mapping)

(* Condition code mapping between ARM and X86
    ARM     X86
    ZF  ==  ZF
    CF  !=  CF ?? For sub/cmp: ARM_CF != X86_CF, buf for add: ARM_CF = X86_CF
    NF  ==  SF
    VF  ==  OF *)
let add_condition_code_mapping fm =
  match List.length !cc_mapping with
    | 0 ->
      (* ARM_ZF == x86_ZF *)
      let arm_cc = fm#get_reg_exp R_ZF in
      let x86_cc = fm#get_reg_exp R_ZF in
      cc_mapping := ("ARM_ZF", arm_cc, "x86_ZF", x86_cc) :: !cc_mapping;

      (* ARM_CF != x86_CF *)
      let arm_cc = fm#get_reg_exp R_CF in
      let x86_cc = fm#get_reg_exp R_CF in
      (*let x86_cc = fm#get_reg_exp R_CF in*)
      cc_mapping := ("ARM_CF", arm_cc, "x86_CF", x86_cc) :: !cc_mapping;

      (* ARM_NF == x86_SF *)
      let arm_cc = fm#get_reg_exp R_NF in
      let x86_cc = fm#get_reg_exp R_SF in
      cc_mapping := ("ARM_NF", arm_cc, "x86_SF", x86_cc) :: !cc_mapping;

      (* ARM_VF == x86_OF *)
      let arm_cc = fm#get_reg_exp R_VF in
      let x86_cc = fm#get_reg_exp R_OF in
      cc_mapping := ("ARM_VF", arm_cc, "x86_OF", x86_cc) :: !cc_mapping
    | _ -> ()

let do_symb_exec fm arch addr dl input_names gamma prog =
      Exec_options.opt_arch := arch;
      Exec_options.opt_trace_loads := true;
      Exec_options.opt_trace_stores := true;
      fm#init_prog (dl, []);
      Exec_set_options.apply_cmdline_opts_early fm dl;
      Exec_set_options.apply_cmdline_opts_nonlinux fm;
      Options_solver.apply_solver_cmdline_opts fm;
      Exec_set_options.apply_cmdline_opts_late fm;
      fm#make_snap ();
      fm#make_regs_symbolic;

      (* We verify every conditon code to see if all of them are equivalent *)
      add_condition_code_mapping fm;

      (* Initialize regisger, immediate and memory with symbolic values.
         Two passes are used because memory init requires the results of immediate init
         For memory initialization, VINE IR is revised *)
      init_reg_imm fm arch input_names;
      let prog = parameterize_imm prog in
      let (prog, mem_out_mapping) = init_mem fm arch dl prog in

      (* For debugging *)
      (*let (decl, nst) = prog in
      Printf.printf "\n======================\n";
      List.iter (fun s -> Printf.printf "== %s" (V.stmt_to_string s)) nst;*)

      fm#set_eip addr;
      fm#set_frag prog;
      fm#run_eip_hooks;
      let next_lab = fm#run () in
	(*fm#print_regs;*)
	ignore(next_lab);

  (* Get symbolic execution results for comparision *)
  let mem_out_mapping = List.rev mem_out_mapping in
	let mem_result =
  	List.map (
      fun map ->
        let (addr_str, addr_var, ty) = map in
        let mem_addr = fm#symbolic_word_var addr_var in
        let mem_val = fm#get_symbolic_mem (V.Lval(V.Temp(addr_var))) ty in
        (addr_str, mem_addr, mem_val)
    ) mem_out_mapping in
  let reg_result =
    List.map (
      fun (reg, typ) ->
        match typ with
          | V.REG_32 -> fm#symbolic_word_reg reg
          | V.REG_64 -> fm#symbolic_long_reg reg
          | _ -> failwith "Unsupported type"
    ) (select_map arch !output_reg true) in
  let cond_result = 
    List.map (
      fun map ->
        let exp = select_map arch map true in
        fm#eval_expr_to_symbolic_expr exp
    ) !condition_mapping in
  let select_cc_map arch map = 
    match (arch, map) with
      | (ARM, (arm_str, arm_cc, _, _)) -> (arm_str, arm_cc)
      | (X86, (_, _, x86_str, x86_cc)) -> (x86_str, x86_cc)
      | _ -> failwith "Bad architecture"
  in
  let cc_result = 
    List.map (
      fun map ->
        let (cc, exp) = select_cc_map arch map in
        (cc, fm#eval_expr_to_symbolic_expr exp)
    ) !cc_mapping in

	let paths_left = fm#finish_path in
  assert(not paths_left);
  fm#reset ();
  (mem_result, reg_result, cond_result, cc_result)

let iter3 f l1 l2 l3 =
  let rec aux f i l1 l2 l3 =
    match (l1, l2, l3) with
      | ([], [], []) -> ()
      | (a1::l1, a2::l2, a3::l3) -> f i a1 a2 a3; aux f (i+1) l1 l2 l3
      | (_, _, _) -> invalid_arg "iter3"
  in
  aux f 1 l1 l2 l3

let check_exp srfm e1 e2 =
  let s1 = V.exp_to_string e1 and
      s2 = V.exp_to_string e2
  in
  if s1 = s2 then
    Printf.printf "Exactly equal\n    %s = %s\n" s1 s2
  else
    let ne_cond = V.BinOp(V.NEQ, e1, e2) in
    let (is_sat, ce) = srfm#query_with_path_cond ne_cond false in
	  if is_sat then
	    (Printf.printf "Different\n    %s != %s.\nCounterexample: " s1 s2;
	    Query_engine.ce_iter ce
	      (fun vname value -> Printf.printf "%s = %Lx\n" vname value))
	  else
	    Printf.printf "Logically equal\n    %s = %s\n" s1 s2
 
let check_mem_eq srfm arm_mem x86_mem =
  let (arm_addr, arm_addr_exp, arm_val) = arm_mem in
  let (x86_addr, x86_addr_exp, x86_val) = x86_mem in
  Printf.printf "== Compare memory (%s vs. %s):\n" arm_addr x86_addr;

  (* 1. Check address *)
  Printf.printf "  1. Address: ";
  check_exp srfm arm_addr_exp x86_addr_exp;

  (* 2. Check content *)
  Printf.printf "  2. Content: ";
  check_exp srfm arm_val x86_val

let check_cond_eq srfm arm_cond x86_cond =
  (*Printf.printf "==== arm condition: %s\n" (V.exp_to_string arm_cond);
  Printf.printf "==== x86 condition: %s\n" (V.exp_to_string x86_cond);*)
  Printf.printf "== Compare condition for conditional branch: ";
  check_exp srfm arm_cond x86_cond

let check_cc_mapping srfm arm_cc x86_cc =
  Printf.printf "== Condition Code: ";
  let (arm_cc_str, arm_exp) = arm_cc in
  let (x86_cc_str, x86_exp) = x86_cc in
  let cond = V.BinOp(V.NEQ, arm_exp, x86_exp) in
  let (is_sat, _) = srfm#query_with_path_cond cond false in
  if (not is_sat) then
    Printf.printf "%s = %s\n" arm_cc_str x86_cc_str
  else (
    let cond = V.BinOp(V.NEQ, arm_exp, V.UnOp(V.NOT, x86_exp)) in
    let (is_sat, _) = srfm#query_with_path_cond cond false in
    if (not is_sat) then
      Printf.printf "%s = !%s\n" arm_cc_str x86_cc_str
    else
      Printf.printf "%s is not defined\n" arm_cc_str
  )

let setup_reg_mapping srfm arm_reg_result x86_reg_result =
  let (arm_out_regs, x86_out_regs) = !output_reg in
  let x86_reg_comb = List.combine x86_out_regs x86_reg_result in
  let check_reg arm_reg_s arm_exp =
    let arm_exp_s = V.exp_to_string arm_exp in
    try
      let x86_result = List.find (
        fun s ->
          let ((r, _), x86_exp) = s in
          (*Printf.printf "==== x86 register: %s = %s\n" (reg_to_regstr r) (V.exp_to_string x86_exp);*)
          let ne_cond = V.BinOp(V.NEQ, arm_exp, x86_exp) in
          let (is_sat, ce) = srfm#query_with_path_cond ne_cond false in
          (arm_exp_s = (V.exp_to_string x86_exp)) || (not is_sat)) x86_reg_comb in
      let (x86_reg, x86_exp) = x86_result in
      let (x86_r, _) = x86_reg in
      Printf.printf "== Found a register mapping %s = %s:\n" arm_reg_s (reg_to_regstr x86_r);
      Printf.printf "    %s = %s\n" arm_exp_s (V.exp_to_string x86_exp)
    with
      Not_found ->
        Printf.printf "== Cannot find equivalent x86 register for this ARM register: %s\n" arm_reg_s;
  in
  List.iter2 (
    fun arm_reg arm_exp ->
      let (arm_r, _) = arm_reg in
      check_reg (reg_to_regstr arm_r) arm_exp
  ) arm_out_regs arm_reg_result

let main argv =
  let x86_dl = Asmir.decls_for_arch Asmir.arch_i386 and
      arm_dl = Asmir.decls_for_arch Asmir.arch_arm in
  let mem_var = List.find (fun (i, s, t) -> s = "mem") x86_dl in
  let x86_regs = List.filter (fun (i, s, t) -> s <> "mem") x86_dl and
      arm_regs = List.filter (fun (i, s, t) -> s <> "mem") arm_dl in
  let merged_dl = mem_var :: x86_regs @ arm_regs in
  let gamma = Asmir.gamma_create mem_var merged_dl in
  let x86_str = ref "" and
      arm_str = ref "" in
  let dt = ((new Linear_decision_tree.linear_decision_tree)
            :> Decision_tree.decision_tree) in
  let srfm = new SRFM.sym_region_frag_machine dt in
  let fm = (srfm :> Fragment_machine.fragment_machine) in
  let arm_out_regs = ref [] and
      x86_out_regs = ref [] in
  let parse_out_reg s arch =
    let sl = split_str_to_list s ',' in
    let reg_l = List.map (fun reg_s ->
                 parse_reg reg_s arch) sl in
    reg_l
  in
    Arg.parse
      (Arg.align (Exec_set_options.cmdline_opts
                  @ Exec_set_options.concrete_state_cmdline_opts
                  @ Exec_set_options.symbolic_state_cmdline_opts
		  @ Exec_set_options.explore_cmdline_opts
                  @ Options_solver.solver_cmdline_opts
		  @
		  [("-arm-def-reg",
        Arg.String (
          (fun s ->
            arm_out_regs := parse_out_reg s ARM
        )),
        " ARMReg, ARMReg, ... Defined ARM registers");
       ("-x86-def-reg",
        Arg.String (
          (fun s ->
            x86_out_regs := parse_out_reg s X86
            )),
        " X86Reg, X86Reg, ... Defined X86 registers");
       ("-init-map",
        Arg.String (
          (fun s ->
            let (arm_s, x86_s) = split_string '=' s in
            let map_t = parse_init_mapping fm arm_s x86_s in
            init_mapping := merge_guest_reg_mapping map_t !init_mapping)),
        " ARMReg/ARMImm=X86Reg/X86Imm Initialization mapping");
       ("-mem-map",
        Arg.String (
          (fun s ->
            let (arm_s, x86_s) = split_string '=' s in
            let (arm_addr, arm_pc, arm_m) = parse_mem arm_s ARM and
                (x86_addr, x86_pc, x86_m) = parse_mem x86_s X86 in
            (*let (base, index, scale, off) = arm_m in
            Printf.printf "==== [arm] base: %s, index: %s, scale: %s, offset: %s\n"
                          (reg_to_regstr base) index scale off;
            let (base, index, scale, off) = x86_m in
            Printf.printf "==== [x86] base: %s, index: %s, scale: %s, offset: %s\n"
                          (reg_to_regstr base) index scale off;*)
            init_mapping := Mem2MemMapping(arm_addr, arm_pc, arm_m, x86_addr, x86_pc, x86_m, V.REG_32) 
                             :: !init_mapping
            (*output_mapping := MemMapping(arm_m, x86_m, V.REG_32)
                              :: !output_mapping*))),
          " ARMmem=X86mem Memory mapping");
       ("-imm-para",
        Arg.String (
          (fun s ->
            let first_equal = String.index s '=' in
            let second_equal = String.rindex s '=' in
            let insn_str = String.sub s 0 first_equal in
            let imm_val = int_of_string (
                                String.sub s (first_equal + 1) (second_equal - first_equal - 1)) in
            let imm_sym = String.sub s (second_equal + 1) ((String.length s) - second_equal - 1) in
            imm_para_mapping := (insn_str, imm_val, imm_sym) :: !imm_para_mapping
          )), " insn=imm-val=imm-sym");
       ("-input-map",
		    Arg.String(
		      (fun s ->
			 let (arm_s, x86_s) = split_string '=' s in
			 let (arm_r, arm_ty) = parse_reg arm_s ARM and
			     (x86_r, x86_ty) = parse_reg x86_s X86 in
			   assert(arm_ty = x86_ty);
			   (*input_mapping := RegMapping(arm_r, x86_r, x86_ty)
			   :: !input_mapping*)
		      )),
		    " ARMreg=X86reg Input register mapping");
		   ("-output-map",
		    Arg.String(
		      (fun s ->
			 let (arm_s, x86_s) = split_string '=' s in
			 let (arm_r, arm_ty) = parse_reg arm_s ARM and
			     (x86_r, x86_ty) = parse_reg x86_s X86 in
			   assert(arm_ty = x86_ty);
			   (*output_mapping := RegMapping(arm_r, x86_r, x86_ty)
			   :: !output_mapping*)
		      )),
		    " ARMreg=X86reg Output register mapping");
		   ("-x86-insns",
		    Arg.String
		      (fun s ->
			 x86_str := parse_hex_bytes s
		      ),
		    " hex-bytes x86 instruction bytes in hex");
		   ("-arm-insns",
		    Arg.String
		      (fun s ->
			 arm_str := parse_hex_words s
		      ),
		    " hex-words ARM instruction words in hex");
		  ]
		 ))
      (fun s -> failwith "No non-options args allowed")
      "insn_compare ...\n";
    init_mapping := List.rev !init_mapping;
    (*input_mapping := List.rev !input_mapping;
    output_mapping := List.rev !output_mapping;*)
    output_reg := (!arm_out_regs, !x86_out_regs);
    assert(!x86_str <> "");
    assert(!arm_str <> "");
    (*Printf.printf "%d bytes of x86 instructions\n" (String.length !x86_str);*)
    let input_names = List.mapi
      (fun i m -> ("input" ^ (string_of_int i)))
      !init_mapping
    in
      Exec_options.opt_omit_pf_af := true;
      let x86_sl = translate_insns 0x08048000L Libasmir.Asmir_arch_x86
	merged_dl mem_var gamma !x86_str and
	  arm_sl = translate_insns 0x00010000L Libasmir.Asmir_arch_arm
	merged_dl mem_var gamma !arm_str
      in
      let x86_prog = merge_blocks x86_sl and
	  arm_prog = merge_blocks arm_sl
      in
    (* Handle conditional branches in arm and x86. Currently, only one
       conditional branch is allowed in arm and x86 code respectively. *)
    let arm_condition = ref (V.Constant(V.Int(V.REG_32, (Int64.of_int 1)))) in
    let arm_target = ref "" in
    let x86_condition = ref (V.Constant(V.Int(V.REG_32, (Int64.of_int 1)))) in
    let x86_target = ref "" in
    let rec check_last_ir_jmp st condition target =
      match st with
        | [] -> (false, false)
        | [V.Jmp(bt)] -> 
          (match bt with
            | V.Name(addr) ->
              let addr_int = int_of_string (String.sub addr 3 ((String.length addr) - 3)) in
              if addr_int <> ((Int64.to_int 0x00010000L) + (String.length !arm_str)) &&
                 addr_int <> ((Int64.to_int 0x08048000L) + (String.length !x86_str)) then
                (true, false)
              else (false, false)
            | _ -> raise Not_found)
        | [V.CJmp(c, bt, _)] ->
          (match bt with
            | V.Name(addr) -> condition := c; target := addr; (true, true)
            | _ -> raise Not_found)
        | _ :: l -> check_last_ir_jmp l condition target in
    let rec find_last_comment_str st =
      let rst = List.rev st in
      match rst with
        | [] -> raise Not_found
        | V.Comment(s) :: l -> s
        | _ :: l -> find_last_comment_str l
    in
    let (arm_dl, arm_st) = arm_prog in
    (*Printf.printf "******** ARM instructions (Before) length: %d ********\n" (String.length !arm_str);
    List.iter (fun s -> print_endline (V.stmt_to_string s)) arm_st;*)
    let (arm_has_jmp, arm_has_condition) = check_last_ir_jmp arm_st arm_condition arm_target in
    let (x86_dl, x86_st) = x86_prog in
    (*Printf.printf "******** X86 instructions (Before) length: %d ********\n" (String.length !x86_str);
    List.iter (fun s -> Printf.printf "==== [x86] %s" (V.stmt_to_string s)) x86_st;*)
    let (x86_has_jmp, x86_has_condition) = check_last_ir_jmp x86_st x86_condition x86_target in
    (*Printf.printf "==========arm_has_jmp: %s, arm_has_condition: %s\n" (string_of_bool arm_has_jmp) (string_of_bool arm_has_condition);
    Printf.printf "==========x86_has_jmp: %s, x86_has_condition: %s\n" (string_of_bool x86_has_jmp) (string_of_bool x86_has_condition);*)
    let (arm_prog, x86_prog) = 
      if arm_has_jmp && x86_has_jmp then (
        if arm_has_condition <> x86_has_condition then (
          Printf.printf "\n\n==== Verification Result ====\n";
          Printf.printf "== Compare condition for conditional branch: Different.\n";
          exit 0);
        if arm_has_condition && x86_has_condition then (
          (* check the condition to see if we need to reverse the condition *)
          let arm_ins_target = find_last_comment_str arm_st and
              x86_ins_target = find_last_comment_str x86_st in
          arm_target := String.sub !arm_target 5 (String.length !arm_target - 5); (* skip pc_0x *)
          x86_target := String.sub !x86_target 5 (String.length !x86_target - 5); (* skip pc_0x *)
          if not (String.exists arm_ins_target !arm_target) then
            arm_condition := V.UnOp(V.NOT, !arm_condition);
          if not (String.exists x86_ins_target !x86_target) then
            x86_condition := V.UnOp(V.NOT, !x86_condition);
          (*Printf.printf "===================arm condition: %s\n" (V.exp_to_string !arm_condition);
          Printf.printf "===================x86 condition: %s\n" (V.exp_to_string !x86_condition);*)
          condition_mapping := (!arm_condition, !x86_condition) :: !condition_mapping
        );
        (* Erase the last jmp Vine IR because we don't want to execute it *)
        let arm_new_st = List.rev (List.tl (List.rev arm_st)) in
        let x86_new_st = List.rev (List.tl (List.rev x86_st)) in
        let arm_new_prog = (arm_dl, arm_new_st) in
        let x86_new_prog = (x86_dl, x86_new_st) in
        (arm_new_prog, x86_new_prog)
      ) else if (arm_has_jmp <> x86_has_jmp) ||
                (arm_has_condition <> x86_has_condition) then
        (Printf.printf "\n\n==== Verification Result ====\n";
         Printf.printf "== Compare condition for conditional branch: Different.\n";
         exit 0)
      else
        (arm_prog, x86_prog)
    in
    (*Printf.printf "******** ARM instructions (Before) ********\n";
    let (_, st) = arm_prog in
    List.iter (fun s -> Printf.printf "==== [arm] %s" (V.stmt_to_string s)) st;
	  V.pp_program print_string arm_prog;*)
    (*Printf.printf "******** ARM instructions (After) ********\n";*)
	  let (arm_mem_out, arm_reg_out, arm_cond_out, arm_cc_out) =
	    do_symb_exec fm ARM 0x00010000L merged_dl
                   input_names gamma arm_prog
	  in
    (*Printf.printf "******** X86 instructions (Before) ********\n";
    let (_, st) = x86_prog in
    List.iter (fun s -> Printf.printf "==== [x86] %s" (V.stmt_to_string s)) st;*)
    (*Printf.printf "******** X86 instructions (After) ********\n";*)
	    let (x86_mem_out, x86_reg_out, x86_cond_out, x86_cc_out) =
	      do_symb_exec fm X86 0x08048000L merged_dl
                     input_names gamma x86_prog
	    in
	        Printf.printf "\n\n==== Verification Result ====\n";
	    (*iter3 (check_eq srfm) !output_mapping x86_out arm_out;*)
      List.iter2 (check_mem_eq srfm) arm_mem_out x86_mem_out;
      setup_reg_mapping srfm arm_reg_out x86_reg_out;
      List.iter2 (check_cond_eq srfm) arm_cond_out x86_cond_out;
	    List.iter2 (check_cc_mapping srfm) arm_cc_out x86_cc_out;
;;

main Sys.argv;;
