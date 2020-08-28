(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* Emission of Intel 386 assembly code *)

module StringSet =
  Set.Make(struct type t = string let compare (x:t) y = compare x y end)

open Misc
open Cmm
open Arch
open Proc
open Reg
open Mach
open Linearize
open Emitaux

(* Tradeoff between code size and code speed *)

let fastcode_flag = ref true

let stack_offset = ref 0

(* Layout of the stack frame *)

let frame_size () =                     (* includes return address *)
  let sz =
    !stack_offset + 4 * num_stack_slots.(0) + 8 * num_stack_slots.(1) + 4
  in Misc.align sz stack_alignment

let slot_offset loc cl =
  match loc with
    Incoming n ->
      assert (n >= 0);
      frame_size() + n
  | Local n ->
      if cl = 0
      then !stack_offset + n * 4
      else !stack_offset + num_stack_slots.(0) * 4 + n * 8
  | Outgoing n ->
      assert (n >= 0);
      n

let trap_frame_size = Misc.align 8 stack_alignment

(* Prefixing of symbols with "_" *)

let symbol_prefix =
  match Config.system with
    "linux_elf" -> ""
  | "bsd_elf" -> ""
  | "solaris" -> ""
  | "beos" -> ""
  | "gnu" -> ""
  | _ -> "_"

let emit_symbol s =
  emit_string symbol_prefix; Emitaux.emit_symbol '$' s

(* Output a label *)

let label_prefix =
  match Config.system with
    "linux_elf" -> ".L"
  | "bsd_elf" -> ".L"
  | "solaris" -> ".L"
  | "beos" -> ".L"
  | "gnu" -> ".L"
  | _ -> "L"

let emit_label lbl =
  emit_string label_prefix; emit_int lbl

let emit_data_label lbl =
  emit_string label_prefix; emit_string "d"; emit_int lbl


(* Some data directives have different names under Solaris *)

let word_dir =
  match Config.system with
    "solaris" -> ".value"
  | _ -> ".word"
let skip_dir =
  match Config.system with
    "solaris" -> ".zero"
  | _ -> ".space"
let use_ascii_dir =
  match Config.system with
    "solaris" -> false
  | _ -> true

(* MacOSX has its own way to reference symbols potentially defined in
   shared objects *)

let macosx =
  match Config.system with
  | "macosx" -> true
  | _ -> false

(* Output a .align directive.
   The numerical argument to .align is log2 of alignment size, except
   under ELF, where it is the alignment size... *)

let emit_align =
  match Config.system with
    "linux_elf" | "bsd_elf" | "solaris" | "beos" | "cygwin" | "mingw" | "gnu" ->
      (fun n -> (emit_string "	.align	"; emit_int n; emit_char '\n'))
  | _ ->
      (fun n -> (emit_string "	.align	"; emit_int(Misc.log2 n); emit_char '\n'))

let emit_Llabel fallthrough lbl =
  if not fallthrough && !fastcode_flag then
    emit_align 16 ;
  emit_label lbl

(* Output a pseudo-register *)

let emit_reg = function
    { loc = Reg r } ->
      emit_string (register_name r)
  | { loc = Stack(Incoming n | Outgoing n) } when n < 0 ->
      (emit_symbol "caml_extra_params"; emit_string " + "; emit_int (n + 64))
  | { loc = Stack s } as r ->
      let ofs = slot_offset s (register_class r) in
      (emit_int ofs; emit_string "(%esp)")
  | { loc = Unknown } ->
      fatal_error "Emit_i386.emit_reg"

(* Output a reference to the lower 8 bits or lower 16 bits of a register *)

let reg_low_byte_name = [| "%al"; "%bl"; "%cl"; "%dl" |]
let reg_low_half_name = [| "%ax"; "%bx"; "%cx"; "%dx"; "%si"; "%di"; "%bp" |]

let emit_reg8 r =
  match r.loc with
    Reg r when r < 4 -> emit_string (reg_low_byte_name.(r))
  | _ -> fatal_error "Emit_i386.emit_reg8"

let emit_reg16 r =
  match r.loc with
    Reg r when r < 7 -> emit_string (reg_low_half_name.(r))
  | _ -> fatal_error "Emit_i386.emit_reg16"

(* Output an addressing mode *)

let emit_addressing addr r n =
  match addr with
    Ibased(s, d) ->
      (emit_symbol s);
      if d <> 0 then (emit_string " + "; emit_int d)
  | Iindexed d ->
      if d <> 0 then emit_int d;
      (emit_char '('; emit_reg r.(n); emit_char ')')
  | Iindexed2 d ->
      if d <> 0 then emit_int d;
      (emit_char '('; emit_reg r.(n); emit_string ", "; emit_reg r.(n+1); emit_char ')')
  | Iscaled(2, d) ->
      if d <> 0 then emit_int d;
      (emit_char '('; emit_reg r.(n); emit_string ", "; emit_reg r.(n); emit_char ')')
  | Iscaled(scale, d) ->
      if d <> 0 then emit_int d;
      (emit_string "(, "; emit_reg r.(n); emit_string ", "; emit_int scale; emit_char ')')
  | Iindexed2scaled(scale, d) ->
      if d <> 0 then emit_int d;
      (emit_char '('; emit_reg r.(n); emit_string ", "; emit_reg r.(n+1); emit_string ", "; emit_int scale; emit_char ')')

(* Record live pointers at call points *)

let record_frame_label live dbg =
  let lbl = new_label() in
  let live_offset = ref [] in
  Reg.Set.iter
    (function
        {typ = Addr; loc = Reg r} ->
          live_offset := ((r lsl 1) + 1) :: !live_offset
      | {typ = Addr; loc = Stack s} as reg ->
          live_offset := slot_offset s (register_class reg) :: !live_offset
      | _ -> ())
    live;
  frame_descriptors :=
    { fd_lbl = lbl;
      fd_frame_size = frame_size();
      fd_live_offset = !live_offset;
      fd_debuginfo = dbg } :: !frame_descriptors;
  lbl

let record_frame live dbg =
  let lbl = record_frame_label live dbg in (emit_label lbl; emit_string ":\n")

(* Record calls to the GC -- we've moved them out of the way *)

type gc_call =
  { gc_lbl: label;                      (* Entry label *)
    gc_return_lbl: label;               (* Where to branch after GC *)
    gc_frame: label }                   (* Label of frame descriptor *)

let call_gc_sites = ref ([] : gc_call list)

let emit_call_gc gc =
  (emit_label gc.gc_lbl; emit_string ":	call	"; emit_symbol "caml_call_gc"; emit_char '\n');
  (emit_label gc.gc_frame; emit_string ":	jmp	"; emit_label gc.gc_return_lbl; emit_char '\n')

(* Record calls to caml_ml_array_bound_error.
   In -g mode, we maintain one call to caml_ml_array_bound_error
   per bound check site.  Without -g, we can share a single call. *)

type bound_error_call =
  { bd_lbl: label;                      (* Entry label *)
    bd_frame: label }                   (* Label of frame descriptor *)

let bound_error_sites = ref ([] : bound_error_call list)
let bound_error_call = ref 0

let bound_error_label dbg =
  if !Clflags.debug then begin
    let lbl_bound_error = new_label() in
    let lbl_frame = record_frame_label Reg.Set.empty dbg in
    bound_error_sites :=
     { bd_lbl = lbl_bound_error; bd_frame = lbl_frame } :: !bound_error_sites;
   lbl_bound_error
 end else begin
   if !bound_error_call = 0 then bound_error_call := new_label();
   !bound_error_call
 end

let emit_call_bound_error bd =
  (emit_label bd.bd_lbl; emit_string ":	call	"; emit_symbol "caml_ml_array_bound_error"; emit_char '\n');
  (emit_label bd.bd_frame; emit_string ":\n")

let emit_call_bound_errors () =
  List.iter emit_call_bound_error !bound_error_sites;
  if !bound_error_call > 0 then
    (emit_label !bound_error_call; emit_string ":	call	"; emit_symbol "caml_ml_array_bound_error"; emit_char '\n')

(* Names for instructions *)

let instr_for_intop = function
    Iadd -> "addl"
  | Isub -> "subl"
  | Imul -> "imull"
  | Iand -> "andl"
  | Ior -> "orl"
  | Ixor -> "xorl"
  | Ilsl -> "sall"
  | Ilsr -> "shrl"
  | Iasr -> "sarl"
  | _ -> fatal_error "Emit_i386: instr_for_intop"

let instr_for_floatop = function
    Inegf -> "fchs"
  | Iabsf -> "fabs"
  | Iaddf -> "faddl"
  | Isubf -> "fsubl"
  | Imulf -> "fmull"
  | Idivf -> "fdivl"
  | Ispecific Isubfrev -> "fsubrl"
  | Ispecific Idivfrev -> "fdivrl"
  | _ -> fatal_error "Emit_i386: instr_for_floatop"

let instr_for_floatop_reversed = function
    Iaddf -> "faddl"
  | Isubf -> "fsubrl"
  | Imulf -> "fmull"
  | Idivf -> "fdivrl"
  | Ispecific Isubfrev -> "fsubl"
  | Ispecific Idivfrev -> "fdivl"
  | _ -> fatal_error "Emit_i386: instr_for_floatop_reversed"

let instr_for_floatop_pop = function
    Iaddf -> "faddp"
  | Isubf -> "fsubp"
  | Imulf -> "fmulp"
  | Idivf -> "fdivp"
  | Ispecific Isubfrev -> "fsubrp"
  | Ispecific Idivfrev -> "fdivrp"
  | _ -> fatal_error "Emit_i386: instr_for_floatop_pop"

let instr_for_floatarithmem double = function
    Ifloatadd -> if double then "faddl" else "fadds"
  | Ifloatsub -> if double then "fsubl" else "fsubs"
  | Ifloatsubrev -> if double then "fsubrl" else "fsubrs"
  | Ifloatmul -> if double then "fmull" else "fmuls"
  | Ifloatdiv -> if double then "fdivl" else "fdivs"
  | Ifloatdivrev -> if double then "fdivrl" else "fdivrs"

let name_for_cond_branch = function
    Isigned Ceq -> "e"     | Isigned Cne -> "ne"
  | Isigned Cle -> "le"     | Isigned Cgt -> "g"
  | Isigned Clt -> "l"     | Isigned Cge -> "ge"
  | Iunsigned Ceq -> "e"   | Iunsigned Cne -> "ne"
  | Iunsigned Cle -> "be"  | Iunsigned Cgt -> "a"
  | Iunsigned Clt -> "b"  | Iunsigned Cge -> "ae"

(* Output an = 0 or <> 0 test. *)

let output_test_zero arg =
  match arg.loc with
    Reg r -> (emit_string "	testl	"; emit_reg arg; emit_string ", "; emit_reg arg; emit_char '\n')
  | _     -> (emit_string "	cmpl	$0, "; emit_reg arg; emit_char '\n')

(* Deallocate the stack frame before a return or tail call *)

let output_epilogue f =
  let n = frame_size() - 4 in
  if n > 0 then
  begin
    (emit_string "	addl	$"; emit_int n; emit_string ", %esp\n");
    cfi_adjust_cfa_offset (-n);
    f ();
    (* reset CFA back cause function body may continue *)
    cfi_adjust_cfa_offset n
  end
  else
    f ()

(* Determine if the given register is the top of the floating-point stack *)

let is_tos = function { loc = Reg _; typ = Float } -> true | _ -> false

(* Emit the code for a floating-point comparison *)

let emit_float_test cmp neg arg lbl =
  let actual_cmp =
    match (is_tos arg.(0), is_tos arg.(1)) with
      (true, true) ->
      (* both args on top of FP stack *)
      (emit_string "	fcompp\n");
      cmp
    | (true, false) ->
      (* first arg on top of FP stack *)
      (emit_string "	fcompl	"; emit_reg arg.(1); emit_char '\n');
      cmp
    | (false, true) ->
      (* second arg on top of FP stack *)
      (emit_string "	fcompl	"; emit_reg arg.(0); emit_char '\n');
      Cmm.swap_comparison cmp
    | (false, false) ->
      (emit_string "	fldl	"; emit_reg arg.(0); emit_char '\n');
      (emit_string "	fcompl	"; emit_reg arg.(1); emit_char '\n');
      cmp
    in
  (emit_string "	fnstsw	%ax\n");
  begin match actual_cmp with
    Ceq ->
      if neg then begin
      (emit_string "	andb	$68, %ah\n");
      (emit_string "	xorb	$64, %ah\n");
      (emit_string "	jne	")
      end else begin
      (emit_string "	andb	$69, %ah\n");
      (emit_string "	cmpb	$64, %ah\n");
      (emit_string "	je	")
      end
  | Cne ->
      if neg then begin
      (emit_string "	andb	$69, %ah\n");
      (emit_string "	cmpb	$64, %ah\n");
      (emit_string "	je	")
      end else begin
      (emit_string "	andb	$68, %ah\n");
      (emit_string "	xorb	$64, %ah\n");
      (emit_string "	jne	")
      end
  | Cle ->
      (emit_string "	andb	$69, %ah\n");
      (emit_string "	decb	%ah\n");
      (emit_string "	cmpb	$64, %ah\n");
      if neg
      then (emit_string "	jae	")
      else (emit_string "	jb	")
  | Cge ->
      (emit_string "	andb	$5, %ah\n");
      if neg
      then (emit_string "	jne	")
      else (emit_string "	je	")
  | Clt ->
      (emit_string "	andb	$69, %ah\n");
      (emit_string "	cmpb	$1, %ah\n");
      if neg
      then (emit_string "	jne	")
      else (emit_string "	je	")
  | Cgt ->
      (emit_string "	andb	$69, %ah\n");
      if neg
      then (emit_string "	jne	")
      else (emit_string "	je	")
  end;
  (emit_label lbl; emit_char '\n')

(* Emit a Ifloatspecial instruction *)

let emit_floatspecial = function
    "atan"  -> (emit_string "	fld1; fpatan\n")
  | "atan2" -> (emit_string "	fpatan\n")
  | "cos"   -> (emit_string "	fcos\n")
  | "log"   -> (emit_string "	fldln2; fxch; fyl2x\n")
  | "log10" -> (emit_string "	fldlg2; fxch; fyl2x\n")
  | "sin"   -> (emit_string "	fsin\n")
  | "sqrt"  -> (emit_string "	fsqrt\n")
  | "tan"   -> (emit_string "	fptan; fstp %st(0)\n")
  | _ -> assert false

(* Floating-point constants *)

let float_constants = ref ([] : (string * int) list)

let add_float_constant cst =
  try
    List.assoc cst !float_constants
  with
    Not_found ->
      let lbl = new_label() in
      float_constants := (cst, lbl) :: !float_constants;
      lbl

let emit_float_constant (cst, lbl) =
  (emit_label lbl; emit_char ':');
  emit_float64_split_directive ".long" cst

(* Output the assembly code for an instruction *)

(* Name of current function *)
let function_name = ref ""
(* Entry point for tail recursive calls *)
let tailrec_entry_point = ref 0
(* Label of trap for out-of-range accesses *)
let range_check_trap = ref 0
(* Record references to external C functions (for MacOSX) *)
let external_symbols_direct = ref StringSet.empty
let external_symbols_indirect = ref StringSet.empty

let emit_instr fallthrough i =
    emit_debug_info i.dbg;
    match i.desc with
      Lend -> ()
    | Lop(Imove | Ispill | Ireload) ->
        let src = i.arg.(0) and dst = i.res.(0) in
        if src.loc <> dst.loc then begin
          if src.typ = Float then
            if is_tos src then
              (emit_string "	fstpl	"; emit_reg dst; emit_char '\n')
            else if is_tos dst then
              (emit_string "	fldl	"; emit_reg src; emit_char '\n')
            else begin
              (emit_string "	fldl	"; emit_reg src; emit_char '\n');
              (emit_string "	fstpl	"; emit_reg dst; emit_char '\n')
            end
          else
              (emit_string "	movl	"; emit_reg src; emit_string ", "; emit_reg dst; emit_char '\n')
        end
    | Lop(Iconst_int n) ->
        if n = 0n then begin
          match i.res.(0).loc with
            Reg n -> (emit_string "	xorl	"; emit_reg i.res.(0); emit_string ", "; emit_reg i.res.(0); emit_char '\n')
          | _     -> (emit_string "	movl	$0, "; emit_reg i.res.(0); emit_char '\n')
        end else
          (emit_string "	movl	$"; emit_nativeint n; emit_string ", "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iconst_float s) ->
        begin match Int64.bits_of_float (float_of_string s) with
        | 0x0000_0000_0000_0000L ->       (* +0.0 *)
          (emit_string "	fldz\n")
        | 0x8000_0000_0000_0000L ->       (* -0.0 *)
          (emit_string "	fldz\n	fchs\n")
        | 0x3FF0_0000_0000_0000L ->       (*  1.0 *)
          (emit_string "	fld1\n")
        | 0xBFF0_0000_0000_0000L ->       (* -1.0 *)
          (emit_string "	fld1\n	fchs\n")
        | _ ->
          let lbl = add_float_constant s in
          (emit_string "	fldl	"; emit_label lbl; emit_char '\n')
        end
    | Lop(Iconst_symbol s) ->
        (emit_string "	movl	$"; emit_symbol s; emit_string ", "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Icall_ind) ->
        (emit_string "	call	*"; emit_reg i.arg.(0); emit_char '\n');
        record_frame i.live i.dbg
    | Lop(Icall_imm s) ->
        (emit_string "	call	"; emit_symbol s; emit_char '\n');
        record_frame i.live i.dbg
    | Lop(Itailcall_ind) ->
        output_epilogue begin fun () ->
        (emit_string "	jmp	*"; emit_reg i.arg.(0); emit_char '\n')
        end
    | Lop(Itailcall_imm s) ->
        if s = !function_name then
          (emit_string "	jmp	"; emit_label !tailrec_entry_point; emit_char '\n')
        else begin
          output_epilogue begin fun () ->
          (emit_string "	jmp	"; emit_symbol s; emit_char '\n')
          end
        end
    | Lop(Iextcall(s, alloc)) ->
        if alloc then begin
          if not macosx then
            (emit_string "	movl	$"; emit_symbol s; emit_string ", %eax\n")
          else begin
            external_symbols_indirect :=
              StringSet.add s !external_symbols_indirect;
            (emit_string "	movl	L"; emit_symbol s; emit_string "$non_lazy_ptr, %eax\n")
          end;
          (emit_string "	call	"; emit_symbol "caml_c_call"; emit_char '\n');
          record_frame i.live i.dbg
        end else begin
          if not macosx then
            (emit_string "	call	"; emit_symbol s; emit_char '\n')
          else begin
            external_symbols_direct :=
              StringSet.add s !external_symbols_direct;
            (emit_string "	call	L"; emit_symbol s; emit_string "$stub\n")
          end
        end
    | Lop(Istackoffset n) ->
        if n < 0
        then (emit_string "	addl	$"; emit_int(-n); emit_string ", %esp\n")
        else (emit_string "	subl	$"; emit_int(n); emit_string ", %esp\n");
        cfi_adjust_cfa_offset n;
        stack_offset := !stack_offset + n
    | Lop(Iload(chunk, addr)) ->
        let dest = i.res.(0) in
        begin match chunk with
          | Word | Thirtytwo_signed | Thirtytwo_unsigned ->
              (emit_string "	movl	"; emit_addressing addr i.arg 0; emit_string ", "; emit_reg dest; emit_char '\n')
          | Byte_unsigned ->
              (emit_string "	movzbl	"; emit_addressing addr i.arg 0; emit_string ", "; emit_reg dest; emit_char '\n')
          | Byte_signed ->
              (emit_string "	movsbl	"; emit_addressing addr i.arg 0; emit_string ", "; emit_reg dest; emit_char '\n')
          | Sixteen_unsigned ->
              (emit_string "	movzwl	"; emit_addressing addr i.arg 0; emit_string ", "; emit_reg dest; emit_char '\n')
          | Sixteen_signed ->
              (emit_string "	movswl	"; emit_addressing addr i.arg 0; emit_string ", "; emit_reg dest; emit_char '\n')
          | Single ->
            (emit_string "	flds	"; emit_addressing addr i.arg 0; emit_char '\n')
          | Double | Double_u ->
            (emit_string "	fldl	"; emit_addressing addr i.arg 0; emit_char '\n')
        end
    | Lop(Istore(chunk, addr)) ->
        begin match chunk with
          | Word | Thirtytwo_signed | Thirtytwo_unsigned ->
            (emit_string "	movl	"; emit_reg i.arg.(0); emit_string ", "; emit_addressing addr i.arg 1; emit_char '\n')
          | Byte_unsigned | Byte_signed ->
            (emit_string "	movb	"; emit_reg8 i.arg.(0); emit_string ", "; emit_addressing addr i.arg 1; emit_char '\n')
          | Sixteen_unsigned | Sixteen_signed ->
            (emit_string "	movw	"; emit_reg16 i.arg.(0); emit_string ", "; emit_addressing addr i.arg 1; emit_char '\n')
          | Single ->
              if is_tos i.arg.(0) then
                (emit_string "	fstps	"; emit_addressing addr i.arg 1; emit_char '\n')
              else begin
                (emit_string "	fldl	"; emit_reg i.arg.(0); emit_char '\n');
                (emit_string "	fstps	"; emit_addressing addr i.arg 1; emit_char '\n')
              end
          | Double | Double_u ->
              if is_tos i.arg.(0) then
                (emit_string "	fstpl	"; emit_addressing addr i.arg 1; emit_char '\n')
              else begin
                (emit_string "	fldl	"; emit_reg i.arg.(0); emit_char '\n');
                (emit_string "	fstpl	"; emit_addressing addr i.arg 1; emit_char '\n')
              end
        end
    | Lop(Ialloc n) ->
        if !fastcode_flag then begin
          let lbl_redo = new_label() in
          (emit_label lbl_redo; emit_string ":	movl	"; emit_symbol "caml_young_ptr"; emit_string ", %eax\n");
          (emit_string "	subl	$"; emit_int n; emit_string ", %eax\n");
          (emit_string "	movl	%eax, "; emit_symbol "caml_young_ptr"; emit_char '\n');
          (emit_string "	cmpl	"; emit_symbol "caml_young_limit"; emit_string ", %eax\n");
          let lbl_call_gc = new_label() in
          let lbl_frame = record_frame_label i.live Debuginfo.none in
          (emit_string "	jb	"; emit_label lbl_call_gc; emit_char '\n');
          (emit_string "	leal	4(%eax), "; emit_reg i.res.(0); emit_char '\n');
          call_gc_sites :=
            { gc_lbl = lbl_call_gc;
              gc_return_lbl = lbl_redo;
              gc_frame = lbl_frame } :: !call_gc_sites
        end else begin
          begin match n with
            8  -> (emit_string "	call	"; emit_symbol "caml_alloc1"; emit_char '\n')
          | 12 -> (emit_string "	call	"; emit_symbol "caml_alloc2"; emit_char '\n')
          | 16 -> (emit_string "	call	"; emit_symbol "caml_alloc3"; emit_char '\n')
          | _  -> (emit_string "	movl	$"; emit_int n; emit_string ", %eax\n");
                  (emit_string "	call	"; emit_symbol "caml_allocN"; emit_char '\n')
          end;
          (record_frame i.live Debuginfo.none; emit_string "	leal	4(%eax), "; emit_reg i.res.(0); emit_char '\n')
        end
    | Lop(Iintop(Icomp cmp)) ->
        (emit_string "	cmpl	"; emit_reg i.arg.(1); emit_string ", "; emit_reg i.arg.(0); emit_char '\n');
        let b = name_for_cond_branch cmp in
        (emit_string "	set"; emit_string b; emit_string "	%al\n");
        (emit_string "	movzbl	%al, "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iintop_imm(Icomp cmp, n)) ->
        (emit_string "	cmpl	$"; emit_int n; emit_string ", "; emit_reg i.arg.(0); emit_char '\n');
        let b = name_for_cond_branch cmp in
        (emit_string "	set"; emit_string b; emit_string "	%al\n");
        (emit_string "	movzbl	%al, "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iintop Icheckbound) ->
        let lbl = bound_error_label i.dbg in
        (emit_string "	cmpl	"; emit_reg i.arg.(1); emit_string ", "; emit_reg i.arg.(0); emit_char '\n');
        (emit_string "	jbe	"; emit_label lbl; emit_char '\n')
    | Lop(Iintop_imm(Icheckbound, n)) ->
        let lbl = bound_error_label i.dbg in
        (emit_string "	cmpl	$"; emit_int n; emit_string ", "; emit_reg i.arg.(0); emit_char '\n');
        (emit_string "	jbe	"; emit_label lbl; emit_char '\n')
    | Lop(Iintop(Idiv | Imod)) ->
        (emit_string "	cltd\n");
        (emit_string "	idivl	"; emit_reg i.arg.(1); emit_char '\n')
    | Lop(Iintop(Ilsl | Ilsr | Iasr as op)) ->
        (* We have i.arg.(0) = i.res.(0) and i.arg.(1) = %ecx *)
        (emit_char '	'; emit_string(instr_for_intop op); emit_string "	%cl, "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iintop op) ->
        (* We have i.arg.(0) = i.res.(0) *)
        (emit_char '	'; emit_string(instr_for_intop op); emit_char '	'; emit_reg i.arg.(1); emit_string ", "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iintop_imm(Iadd, n)) when i.arg.(0).loc <> i.res.(0).loc ->
        (emit_string "	leal	"; emit_int n; emit_char '('; emit_reg i.arg.(0); emit_string "), "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iintop_imm(Iadd, 1) | Iintop_imm(Isub, -1)) ->
        (emit_string "	incl	"; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iintop_imm(Iadd, -1) | Iintop_imm(Isub, 1)) ->
        (emit_string "	decl	"; emit_reg i.res.(0); emit_char '\n')
    | Lop(Iintop_imm(Idiv, n)) ->
        let l = Misc.log2 n in
        let lbl = new_label() in
        output_test_zero i.arg.(0);
        (emit_string "	jge	"; emit_label lbl; emit_char '\n');
        (emit_string "	addl	$"; emit_int(n-1); emit_string ", "; emit_reg i.arg.(0); emit_char '\n');
        (emit_label lbl; emit_string ":	sarl	$"; emit_int l; emit_string ", "; emit_reg i.arg.(0); emit_char '\n')
    | Lop(Iintop_imm(Imod, n)) ->
        let lbl = new_label() in
        (emit_string "	movl	"; emit_reg i.arg.(0); emit_string ", %eax\n");
        (emit_string "	testl	%eax, %eax\n");
        (emit_string "	jge	"; emit_label lbl; emit_char '\n');
        (emit_string "	addl	$"; emit_int(n-1); emit_string ", %eax\n");
        (emit_label lbl; emit_string ":	andl	$"; emit_int(-n); emit_string ", %eax\n");
        (emit_string "	subl	%eax, "; emit_reg i.arg.(0); emit_char '\n')
    | Lop(Iintop_imm(op, n)) ->
        (* We have i.arg.(0) = i.res.(0) *)
        (emit_char '	'; emit_string(instr_for_intop op); emit_string "	$"; emit_int n; emit_string ", "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Inegf | Iabsf as floatop) ->
        if not (is_tos i.arg.(0)) then
          (emit_string "	fldl	"; emit_reg i.arg.(0); emit_char '\n');
        (emit_char '	'; emit_string(instr_for_floatop floatop); emit_char '\n')
    | Lop(Iaddf | Isubf | Imulf | Idivf | Ispecific(Isubfrev | Idivfrev)
          as floatop) ->
        begin match (is_tos i.arg.(0), is_tos i.arg.(1)) with
          (true, true) ->
          (* both operands on top of FP stack *)
          (emit_char '	'; emit_string(instr_for_floatop_pop floatop); emit_string "	%st, %st(1)\n")
        | (true, false) ->
          (* first operand on stack *)
          (emit_char '	'; emit_string(instr_for_floatop floatop); emit_char '	'; emit_reg i.arg.(1); emit_char '\n')
        | (false, true) ->
          (* second operand on stack *)
          (emit_char '	'; emit_string(instr_for_floatop_reversed floatop); emit_char '	'; emit_reg i.arg.(0); emit_char '\n')
        | (false, false) ->
          (* both operands in memory *)
          (emit_string "	fldl	"; emit_reg i.arg.(0); emit_char '\n');
          (emit_char '	'; emit_string(instr_for_floatop floatop); emit_char '	'; emit_reg i.arg.(1); emit_char '\n')
        end
    | Lop(Ifloatofint) ->
        begin match i.arg.(0).loc with
          Stack s ->
            (emit_string "	fildl	"; emit_reg i.arg.(0); emit_char '\n')
        | _ ->
            (emit_string "	pushl	"; emit_reg i.arg.(0); emit_char '\n');
            (emit_string "	fildl	(%esp)\n");
            (emit_string "	addl	$4, %esp\n")
        end
    | Lop(Iintoffloat) ->
        if not (is_tos i.arg.(0)) then
          (emit_string "	fldl	"; emit_reg i.arg.(0); emit_char '\n');
        stack_offset := !stack_offset - 8;
        (emit_string "	subl	$8, %esp\n");
        cfi_adjust_cfa_offset 8;
        (emit_string "	fnstcw	4(%esp)\n");
        (emit_string "	movw	4(%esp), %ax\n");
        (emit_string "	movb    $12, %ah\n");
        (emit_string "	movw	%ax, 0(%esp)\n");
        (emit_string "	fldcw	0(%esp)\n");
        begin match i.res.(0).loc with
          Stack s ->
            (emit_string "	fistpl	"; emit_reg i.res.(0); emit_char '\n')
        | _ ->
            (emit_string "	fistpl	(%esp)\n");
            (emit_string "	movl	(%esp), "; emit_reg i.res.(0); emit_char '\n')
        end;
        (emit_string "	fldcw	4(%esp)\n");
        (emit_string "	addl	$8, %esp\n");
        cfi_adjust_cfa_offset (-8);
        stack_offset := !stack_offset + 8
    | Lop(Ispecific(Ilea addr)) ->
        (emit_string "	lea	"; emit_addressing addr i.arg 0; emit_string ", "; emit_reg i.res.(0); emit_char '\n')
    | Lop(Ispecific(Istore_int(n, addr))) ->
        (emit_string "	movl	$"; emit_nativeint n; emit_string ", "; emit_addressing addr i.arg 0; emit_char '\n')
    | Lop(Ispecific(Istore_symbol(s, addr))) ->
        (emit_string "	movl	$"; emit_symbol s; emit_string ", "; emit_addressing addr i.arg 0; emit_char '\n')
    | Lop(Ispecific(Ioffset_loc(n, addr))) ->
        (emit_string "	addl	$"; emit_int n; emit_string ", "; emit_addressing addr i.arg 0; emit_char '\n')
    | Lop(Ispecific(Ipush)) ->
        (* Push arguments in reverse order *)
        for n = Array.length i.arg - 1 downto 0 do
          let r = i.arg.(n) in
          match r with
            {loc = Reg _; typ = Float} ->
              (emit_string "	subl	$8, %esp\n");
              cfi_adjust_cfa_offset 8;
              (emit_string "	fstpl	0(%esp)\n");
              stack_offset := !stack_offset + 8
          | {loc = Stack sl; typ = Float} ->
              let ofs = slot_offset sl 1 in
              (emit_string "	pushl	"; emit_int(ofs + 4); emit_string "(%esp)\n");
              (emit_string "	pushl	"; emit_int(ofs + 4); emit_string "(%esp)\n");
              cfi_adjust_cfa_offset 8;
              stack_offset := !stack_offset + 8
          | _ ->
              (emit_string "	pushl	"; emit_reg r; emit_char '\n');
              cfi_adjust_cfa_offset 4;
              stack_offset := !stack_offset + 4
        done
    | Lop(Ispecific(Ipush_int n)) ->
        (emit_string "	pushl	$"; emit_nativeint n; emit_char '\n');
        cfi_adjust_cfa_offset 4;
        stack_offset := !stack_offset + 4
    | Lop(Ispecific(Ipush_symbol s)) ->
        (emit_string "	pushl	$"; emit_symbol s; emit_char '\n');
        cfi_adjust_cfa_offset 4;
        stack_offset := !stack_offset + 4
    | Lop(Ispecific(Ipush_load addr)) ->
        (emit_string "	pushl	"; emit_addressing addr i.arg 0; emit_char '\n');
        cfi_adjust_cfa_offset 4;
        stack_offset := !stack_offset + 4
    | Lop(Ispecific(Ipush_load_float addr)) ->
        (emit_string "	pushl	"; emit_addressing (offset_addressing addr 4) i.arg 0; emit_char '\n');
        (emit_string "	pushl	"; emit_addressing addr i.arg 0; emit_char '\n');
        cfi_adjust_cfa_offset 8;
        stack_offset := !stack_offset + 8
    | Lop(Ispecific(Ifloatarithmem(double, op, addr))) ->
        if not (is_tos i.arg.(0)) then
          (emit_string "	fldl	"; emit_reg i.arg.(0); emit_char '\n');
        (emit_char '	'; emit_string(instr_for_floatarithmem double op); emit_char '	'; emit_addressing addr i.arg 1; emit_char '\n')
    | Lop(Ispecific(Ifloatspecial s)) ->
        (* Push args on float stack if necessary *)
        for k = 0 to Array.length i.arg - 1 do
          if not (is_tos i.arg.(k)) then (emit_string "	fldl	"; emit_reg i.arg.(k); emit_char '\n')
        done;
        (* Fix-up for binary instrs whose args were swapped *)
        if Array.length i.arg = 2 && is_tos i.arg.(1) then
          (emit_string "	fxch	%st(1)\n");
        emit_floatspecial s
    | Lreloadretaddr ->
        ()
    | Lreturn ->
        output_epilogue begin fun () ->
        (emit_string "	ret\n")
        end
    | Llabel lbl ->
        (emit_Llabel fallthrough lbl; emit_string ":\n")
    | Lbranch lbl ->
        (emit_string "	jmp	"; emit_label lbl; emit_char '\n')
    | Lcondbranch(tst, lbl) ->
        begin match tst with
          Itruetest ->
            output_test_zero i.arg.(0);
            (emit_string "	jne	"; emit_label lbl; emit_char '\n')
        | Ifalsetest ->
            output_test_zero i.arg.(0);
            (emit_string "	je	"; emit_label lbl; emit_char '\n')
        | Iinttest cmp ->
            (emit_string "	cmpl	"; emit_reg i.arg.(1); emit_string ", "; emit_reg i.arg.(0); emit_char '\n');
            let b = name_for_cond_branch cmp in
            (emit_string "	j"; emit_string b; emit_char '	'; emit_label lbl; emit_char '\n')
        | Iinttest_imm((Isigned Ceq | Isigned Cne |
                        Iunsigned Ceq | Iunsigned Cne) as cmp, 0) ->
            output_test_zero i.arg.(0);
            let b = name_for_cond_branch cmp in
            (emit_string "	j"; emit_string b; emit_char '	'; emit_label lbl; emit_char '\n')
        | Iinttest_imm(cmp, n) ->
            (emit_string "	cmpl	$"; emit_int n; emit_string ", "; emit_reg i.arg.(0); emit_char '\n');
            let b = name_for_cond_branch cmp in
            (emit_string "	j"; emit_string b; emit_char '	'; emit_label lbl; emit_char '\n')
        | Ifloattest(cmp, neg) ->
            emit_float_test cmp neg i.arg lbl
        | Ioddtest ->
            (emit_string "	testl	$1, "; emit_reg i.arg.(0); emit_char '\n');
            (emit_string "	jne	"; emit_label lbl; emit_char '\n')
        | Ieventest ->
            (emit_string "	testl	$1, "; emit_reg i.arg.(0); emit_char '\n');
            (emit_string "	je	"; emit_label lbl; emit_char '\n')
        end
    | Lcondbranch3(lbl0, lbl1, lbl2) ->
            (emit_string "	cmpl	$1, "; emit_reg i.arg.(0); emit_char '\n');
            begin match lbl0 with
              None -> ()
            | Some lbl -> (emit_string "	jb	"; emit_label lbl; emit_char '\n')
            end;
            begin match lbl1 with
              None -> ()
            | Some lbl -> (emit_string "	je	"; emit_label lbl; emit_char '\n')
            end;
            begin match lbl2 with
              None -> ()
            | Some lbl -> (emit_string "	jg	"; emit_label lbl; emit_char '\n')
            end
    | Lswitch jumptbl ->
        let lbl = new_label() in
        (emit_string "	jmp	*"; emit_label lbl; emit_string "(, "; emit_reg i.arg.(0); emit_string ", 4)\n");
        (emit_string "	.data\n");
        (emit_label lbl; emit_char ':');
        for i = 0 to Array.length jumptbl - 1 do
          (emit_string "	.long	"; emit_label jumptbl.(i); emit_char '\n')
        done;
        (emit_string "	.text\n")
    | Lsetuptrap lbl ->
        (emit_string "	call	"; emit_label lbl; emit_char '\n')
    | Lpushtrap ->
        if trap_frame_size > 8 then
          (emit_string "	subl	$"; emit_int (trap_frame_size - 8); emit_string ", %esp\n");
        (emit_string "	pushl	"; emit_symbol "caml_exception_pointer"; emit_char '\n');
        cfi_adjust_cfa_offset trap_frame_size;
        (emit_string "	movl	%esp, "; emit_symbol "caml_exception_pointer"; emit_char '\n');
        stack_offset := !stack_offset + trap_frame_size
    | Lpoptrap ->
        (emit_string "	popl	"; emit_symbol "caml_exception_pointer"; emit_char '\n');
        (emit_string "	addl	$"; emit_int (trap_frame_size - 4); emit_string ", %esp\n");
        cfi_adjust_cfa_offset (-trap_frame_size);
        stack_offset := !stack_offset - trap_frame_size
    | Lraise ->
        if !Clflags.debug then begin
          (emit_string "	call    "; emit_symbol "caml_raise_exn"; emit_char '\n');
          record_frame Reg.Set.empty i.dbg
        end else begin
          (emit_string "	movl	"; emit_symbol "caml_exception_pointer"; emit_string ", %esp\n");
          (emit_string "	popl    "; emit_symbol "caml_exception_pointer"; emit_char '\n');
          if trap_frame_size > 8 then
            (emit_string "	addl	$"; emit_int (trap_frame_size - 8); emit_string ", %esp\n");
          (emit_string "	ret\n")
        end

let rec emit_all fallthrough i =
  match i.desc with
  |  Lend -> ()
  | _ ->
      emit_instr fallthrough i;
      emit_all
        (Linearize.has_fallthrough  i.desc)
        i.next

(* Emission of external symbol references (for MacOSX) *)

let emit_external_symbol_direct s =
  (emit_char 'L'; emit_symbol s; emit_string "$stub:\n");
  (emit_string "	.indirect_symbol "; emit_symbol s; emit_char '\n');
  (emit_string "	hlt ; hlt ; hlt ; hlt ; hlt\n")

let emit_external_symbol_indirect s =
  (emit_char 'L'; emit_symbol s; emit_string "$non_lazy_ptr:\n");
  (emit_string "	.indirect_symbol "; emit_symbol s; emit_char '\n');
  (emit_string "	.long	0\n")

let emit_external_symbols () =
  (emit_string "	.section __IMPORT,__pointers,non_lazy_symbol_pointers\n");
  StringSet.iter emit_external_symbol_indirect !external_symbols_indirect;
  external_symbols_indirect := StringSet.empty;
  (emit_string "	.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5\n");
  StringSet.iter emit_external_symbol_direct !external_symbols_direct;
  external_symbols_direct := StringSet.empty;
  if !Clflags.gprofile then begin
    (emit_string "Lmcount$stub:\n");
    (emit_string "	.indirect_symbol mcount\n");
    (emit_string "	hlt ; hlt ; hlt ; hlt ; hlt\n")
  end

(* Emission of the profiling prelude *)

let emit_profile () =
  match Config.system with
    "linux_elf" | "gnu" ->
      (emit_string "	pushl	%eax\n");
      (emit_string "	movl	%esp, %ebp\n");
      (emit_string "	pushl	%ecx\n");
      (emit_string "	pushl	%edx\n");
      (emit_string "	call	"; emit_symbol "mcount"; emit_char '\n');
      (emit_string "	popl	%edx\n");
      (emit_string "	popl	%ecx\n");
      (emit_string "	popl	%eax\n")
  | "bsd_elf" ->
      (emit_string "	pushl	%eax\n");
      (emit_string "	movl	%esp, %ebp\n");
      (emit_string "	pushl	%ecx\n");
      (emit_string "	pushl	%edx\n");
      (emit_string "	call	.mcount\n");
      (emit_string "	popl	%edx\n");
      (emit_string "	popl	%ecx\n");
      (emit_string "	popl	%eax\n")
  | "macosx" ->
      (emit_string "	pushl	%eax\n");
      (emit_string "	movl	%esp, %ebp\n");
      (emit_string "	pushl	%ecx\n");
      (emit_string "	pushl	%edx\n");
      (emit_string "	call	Lmcount$stub\n");
      (emit_string "	popl	%edx\n");
      (emit_string "	popl	%ecx\n");
      (emit_string "	popl	%eax\n")
  | _ -> () (*unsupported yet*)

(* Emission of a function declaration *)

let fundecl fundecl =
  function_name := fundecl.fun_name;
  fastcode_flag := fundecl.fun_fast;
  tailrec_entry_point := new_label();
  stack_offset := 0;
  call_gc_sites := [];
  bound_error_sites := [];
  bound_error_call := 0;
  (emit_string "	.text\n");
  emit_align 16;
  if macosx
  && not !Clflags.output_c_object
  && is_generic_function fundecl.fun_name
  then (* PR#4690 *)
    (emit_string "	.private_extern	"; emit_symbol fundecl.fun_name; emit_char '\n')
  else
    (emit_string "	.globl	"; emit_symbol fundecl.fun_name; emit_char '\n');
  (emit_symbol fundecl.fun_name; emit_string ":\n");
  emit_debug_info fundecl.fun_dbg;
  cfi_startproc ();
  if !Clflags.gprofile then emit_profile();
  let n = frame_size() - 4 in
  if n > 0 then
  begin
    (emit_string "	subl	$"; emit_int n; emit_string ", %esp\n");
    cfi_adjust_cfa_offset n;
  end;
  (emit_label !tailrec_entry_point; emit_string ":\n");
  emit_all true fundecl.fun_body;
  List.iter emit_call_gc !call_gc_sites;
  emit_call_bound_errors ();
  cfi_endproc ();
  begin match Config.system with
    "linux_elf" | "bsd_elf" | "gnu" ->
      (emit_string "	.type	"; emit_symbol fundecl.fun_name; emit_string ",@function\n");
      (emit_string "	.size	"; emit_symbol fundecl.fun_name; emit_string ",.-"; emit_symbol fundecl.fun_name; emit_char '\n')
  | _ -> () end


(* Emission of data *)

let emit_item = function
    Cglobal_symbol s ->
      (emit_string "	.globl	"; emit_symbol s; emit_char '\n');
  | Cdefine_symbol s ->
      (emit_symbol s; emit_string ":\n")
  | Cdefine_label lbl ->
      (emit_data_label lbl; emit_string ":\n")
  | Cint8 n ->
      (emit_string "	.byte	"; emit_int n; emit_char '\n')
  | Cint16 n ->
      (emit_char '	'; emit_string word_dir; emit_char '	'; emit_int n; emit_char '\n')
  | Cint32 n ->
      (emit_string "	.long	"; emit_nativeint n; emit_char '\n')
  | Cint n ->
      (emit_string "	.long	"; emit_nativeint n; emit_char '\n')
  | Csingle f ->
      emit_float32_directive ".long" f
  | Cdouble f ->
      emit_float64_split_directive ".long" f
  | Csymbol_address s ->
      (emit_string "	.long	"; emit_symbol s; emit_char '\n')
  | Clabel_address lbl ->
      (emit_string "	.long	"; emit_data_label lbl; emit_char '\n')
  | Cstring s ->
      if use_ascii_dir
      then emit_string_directive "	.ascii	" s
      else emit_bytes_directive  "	.byte	" s
  | Cskip n ->
      if n > 0 then (emit_char '	'; emit_string skip_dir; emit_char '	'; emit_int n; emit_char '\n')
  | Calign n ->
      emit_align n

let data l =
  (emit_string "	.data\n");
  List.iter emit_item l

(* Beginning / end of an assembly file *)

let begin_assembly() =
  reset_debug_info();                   (* PR#5603 *)
  float_constants := [];
  let lbl_begin = Compilenv.make_symbol (Some "data_begin") in
  (emit_string "	.data\n");
  (emit_string "	.globl	"; emit_symbol lbl_begin; emit_char '\n');
  (emit_symbol lbl_begin; emit_string ":\n");
  let lbl_begin = Compilenv.make_symbol (Some "code_begin") in
  (emit_string "	.text\n");
  (emit_string "	.globl	"; emit_symbol lbl_begin; emit_char '\n');
  (emit_symbol lbl_begin; emit_string ":\n");
  if macosx then (emit_string "	nop\n") (* PR#4690 *)

let end_assembly() =
  if !float_constants <> [] then begin
    (emit_string "	.data\n");
    List.iter emit_float_constant !float_constants
  end;
  let lbl_end = Compilenv.make_symbol (Some "code_end") in
  (emit_string "	.text\n");
  if macosx then (emit_string "	nop\n"); (* suppress "ld warning: atom sorting error" *)
  (emit_string "	.globl	"; emit_symbol lbl_end; emit_char '\n');
  (emit_symbol lbl_end; emit_string ":\n");
  (emit_string "	.data\n");
  let lbl_end = Compilenv.make_symbol (Some "data_end") in
  (emit_string "	.globl	"; emit_symbol lbl_end; emit_char '\n');
  (emit_symbol lbl_end; emit_string ":\n");
  (emit_string "	.long	0\n");
  let lbl = Compilenv.make_symbol (Some "frametable") in
  (emit_string "	.globl	"; emit_symbol lbl; emit_char '\n');
  (emit_symbol lbl; emit_string ":\n");
  emit_frames
    { efa_label = (fun l -> (emit_string "	.long	"; emit_label l; emit_char '\n'));
      efa_16 = (fun n -> (emit_char '	'; emit_string word_dir; emit_char '	'; emit_int n; emit_char '\n'));
      efa_32 = (fun n -> (emit_string "	.long	"; emit_int32 n; emit_char '\n'));
      efa_word = (fun n -> (emit_string "	.long	"; emit_int n; emit_char '\n'));
      efa_align = emit_align;
      efa_label_rel = (fun lbl ofs ->
                           (emit_string "	.long	"; emit_label lbl; emit_string " - . + "; emit_int32 ofs; emit_char '\n'));
      efa_def_label = (fun l -> (emit_label l; emit_string ":\n"));
      efa_string = (fun s ->
        let s = s ^ "\000" in
        if use_ascii_dir
        then emit_string_directive "	.ascii	" s
        else emit_bytes_directive  "	.byte	" s) };
  if macosx then emit_external_symbols ();
  if Config.system = "linux_elf" then
    (* Mark stack as non-executable, PR#4564 *)
    (emit_string "\n	.section .note.GNU-stack,\"\",%progbits\n")
