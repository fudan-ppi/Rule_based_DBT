module Misc = struct
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

(* Errors *)

exception Fatal_error

let fatal_error msg =
  prerr_string ">> Fatal error: "; prerr_endline msg; raise Fatal_error

(* Exceptions *)

let try_finally work cleanup =
  let result = (try work () with e -> cleanup (); raise e) in
  cleanup ();
  result
;;

(* List functions *)

let rec map_end f l1 l2 =
  match l1 with
    [] -> l2
  | hd::tl -> f hd :: map_end f tl l2

let rec map_left_right f = function
    [] -> []
  | hd::tl -> let res = f hd in res :: map_left_right f tl

let rec for_all2 pred l1 l2 =
  match (l1, l2) with
    ([], []) -> true
  | (hd1::tl1, hd2::tl2) -> pred hd1 hd2 && for_all2 pred tl1 tl2
  | (_, _) -> false

let rec replicate_list elem n =
  if n <= 0 then [] else elem :: replicate_list elem (n-1)

let rec list_remove x = function
    [] -> []
  | hd :: tl ->
      if hd = x then tl else hd :: list_remove x tl

let rec split_last = function
    [] -> assert false
  | [x] -> ([], x)
  | hd :: tl ->
      let (lst, last) = split_last tl in
      (hd :: lst, last)

let rec samelist pred l1 l2 =
  match (l1, l2) with
  | ([], []) -> true
  | (hd1 :: tl1, hd2 :: tl2) -> pred hd1 hd2 && samelist pred tl1 tl2
  | (_, _) -> false

(* Options *)

let may f = function
    Some x -> f x
  | None -> ()

let may_map f = function
    Some x -> Some (f x)
  | None -> None

(* File functions *)

let find_in_path path name =
  if not (Filename.is_implicit name) then
    if Sys.file_exists name then name else raise Not_found
  else begin
    let rec try_dir = function
      [] -> raise Not_found
    | dir::rem ->
        let fullname = Filename.concat dir name in
        if Sys.file_exists fullname then fullname else try_dir rem
    in try_dir path
  end

let find_in_path_uncap path name =
  let uname = String.uncapitalize name in
  let rec try_dir = function
    [] -> raise Not_found
  | dir::rem ->
      let fullname = Filename.concat dir name
      and ufullname = Filename.concat dir uname in
      if Sys.file_exists ufullname then ufullname
      else if Sys.file_exists fullname then fullname
      else try_dir rem
  in try_dir path

let remove_file filename =
  try
    Sys.remove filename
  with Sys_error msg ->
    ()

(* Expand a -I option: if it starts with +, make it relative to the standard
   library directory *)

let expand_directory alt s =
  if String.length s > 0 && s.[0] = '+'
  then Filename.concat alt
                       (String.sub s 1 (String.length s - 1))
  else s

(* Hashtable functions *)

let create_hashtable size init =
  let tbl = Hashtbl.create size in
  List.iter (fun (key, data) -> Hashtbl.add tbl key data) init;
  tbl

(* File copy *)

let copy_file ic oc =
  let buff = String.create 0x1000 in
  let rec copy () =
    let n = input ic buff 0 0x1000 in
    if n = 0 then () else (output oc buff 0 n; copy())
  in copy()

let copy_file_chunk ic oc len =
  let buff = String.create 0x1000 in
  let rec copy n =
    if n <= 0 then () else begin
      let r = input ic buff 0 (min n 0x1000) in
      if r = 0 then raise End_of_file else (output oc buff 0 r; copy(n-r))
    end
  in copy len

let string_of_file ic =
  let b = Buffer.create 0x10000 in
  let buff = String.create 0x1000 in
  let rec copy () =
    let n = input ic buff 0 0x1000 in
    if n = 0 then Buffer.contents b else
      (Buffer.add_substring b buff 0 n; copy())
  in copy()



(* Reading from a channel *)

let input_bytes ic n =
  let result = String.create n in
  really_input ic result 0 n;
  result
;;

(* Integer operations *)

let rec log2 n =
  if n <= 1 then 0 else 1 + log2(n asr 1)

let align n a =
  if n >= 0 then (n + a - 1) land (-a) else n land (-a)

let no_overflow_add a b = (a lxor b) lor (a lxor (lnot (a+b))) < 0

let no_overflow_sub a b = (a lxor (lnot b)) lor (b lxor (a-b)) < 0

let no_overflow_lsl a = min_int asr 1 <= a && a <= max_int asr 1

(* String operations *)

let chop_extension_if_any fname =
  try Filename.chop_extension fname with Invalid_argument _ -> fname

let chop_extensions file =
  let dirname = Filename.dirname file and basename = Filename.basename file in
  try
    let pos = String.index basename '.' in
    let basename = String.sub basename 0 pos in
    if Filename.is_implicit file && dirname = Filename.current_dir_name then
      basename
    else
      Filename.concat dirname basename
  with Not_found -> file

let search_substring pat str start =
  let rec search i j =
    if j >= String.length pat then i
    else if i + j >= String.length str then raise Not_found
    else if str.[i + j] = pat.[j] then search i (j+1)
    else search (i+1) 0
  in search start 0

let rev_split_words s =
  let rec split1 res i =
    if i >= String.length s then res else begin
      match s.[i] with
        ' ' | '\t' | '\r' | '\n' -> split1 res (i+1)
      | _ -> split2 res i (i+1)
    end
  and split2 res i j =
    if j >= String.length s then String.sub s i (j-i) :: res else begin
      match s.[j] with
        ' ' | '\t' | '\r' | '\n' -> split1 (String.sub s i (j-i) :: res) (j+1)
      | _ -> split2 res i (j+1)
    end
  in split1 [] 0

let get_ref r =
  let v = !r in
  r := []; v

let fst3 (x, _, _) = x
let snd3 (_,x,_) = x
let thd3 (_,_,x) = x

let fst4 (x, _, _, _) = x
let snd4 (_,x,_, _) = x
let thd4 (_,_,x,_) = x
let for4 (_,_,_,x) = x


module LongString = struct
  type t = string array

  let create str_size =
    let tbl_size = str_size / Sys.max_string_length + 1 in
    let tbl = Array.make tbl_size "" in
    for i = 0 to tbl_size - 2 do
      tbl.(i) <- String.create Sys.max_string_length;
    done;
    tbl.(tbl_size - 1) <- String.create (str_size mod Sys.max_string_length);
    tbl

  let length tbl =
    let tbl_size = Array.length tbl in
    Sys.max_string_length * (tbl_size - 1) + String.length tbl.(tbl_size - 1)

  let get tbl ind =
    tbl.(ind / Sys.max_string_length).[ind mod Sys.max_string_length]

  let set tbl ind c =
    tbl.(ind / Sys.max_string_length).[ind mod Sys.max_string_length] <- c

  let blit src srcoff dst dstoff len =
    for i = 0 to len - 1 do
      set dst (dstoff + i) (get src (srcoff + i))
    done

  let output oc tbl pos len =
    for i = pos to pos + len - 1 do
      output_char oc (get tbl i)
    done

  let unsafe_blit_to_string src srcoff dst dstoff len =
    for i = 0 to len - 1 do
      String.unsafe_set dst (dstoff + i) (get src (srcoff + i))
    done

  let input_bytes ic len =
    let tbl = create len in
    Array.iter (fun str -> really_input ic str 0 (String.length str)) tbl;
    tbl
end


let edit_distance a b cutoff =
  let la, lb = String.length a, String.length b in
  let cutoff =
    (* using max_int for cutoff would cause overflows in (i + cutoff + 1);
       we bring it back to the (max la lb) worstcase *)
    min (max la lb) cutoff in
  if abs (la - lb) > cutoff then None
  else begin
    (* initialize with 'cutoff + 1' so that not-yet-written-to cases have
       the worst possible cost; this is useful when computing the cost of
       a case just at the boundary of the cutoff diagonal. *)
    let m = Array.make_matrix (la + 1) (lb + 1) (cutoff + 1) in
    m.(0).(0) <- 0;
    for i = 1 to la do
      m.(i).(0) <- i;
    done;
    for j = 1 to lb do
      m.(0).(j) <- j;
    done;
    for i = 1 to la do
      for j = max 1 (i - cutoff - 1) to min lb (i + cutoff + 1) do
        let cost = if a.[i-1] = b.[j-1] then 0 else 1 in
        let best =
          (* insert, delete or substitute *)
          min (1 + min m.(i-1).(j) m.(i).(j-1)) (m.(i-1).(j-1) + cost)
        in
        let best =
          (* swap two adjacent letters; we use "cost" again in case of
             a swap between two identical letters; this is slightly
             redundant as this is a double-substitution case, but it
             was done this way in most online implementations and
             imitation has its virtues *)
          if not (i > 1 && j > 1 && a.[i-1] = b.[j-2] && a.[i-2] = b.[j-1])
          then best
          else min best (m.(i-2).(j-2) + cost)
        in
        m.(i).(j) <- best
      done;
    done;
    let result = m.(la).(lb) in
    if result > cutoff
    then None
    else Some result
  end


(* split a string [s] at every char [c], and return the list of sub-strings *)
let split s c =
  let len = String.length s in
  let rec iter pos to_rev =
    if pos = len then List.rev ("" :: to_rev) else
      match try
              Some ( String.index_from s pos c )
        with Not_found -> None
      with
          Some pos2 ->
            if pos2 = pos then iter (pos+1) ("" :: to_rev) else
              iter (pos2+1) ((String.sub s pos (pos2-pos)) :: to_rev)
        | None -> List.rev ( String.sub s pos (len-pos) :: to_rev )
  in
  iter 0 []

let cut_at s c =
  let pos = String.index s c in
  String.sub s 0 pos, String.sub s (pos+1) (String.length s - pos - 1)

end;;
module Terminfo = struct
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

(* Basic interface to the terminfo database *)

type status =
  | Uninitialised
  | Bad_term
  | Good_term of int
;;
external setup : out_channel -> status = "caml_terminfo_setup";;
external backup : int -> unit = "caml_terminfo_backup";;
external standout : bool -> unit = "caml_terminfo_standout";;
external resume : int -> unit = "caml_terminfo_resume";;

end;;
module Warnings = struct
(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Pierre Weis && Damien Doligez, INRIA Rocquencourt        *)
(*                                                                     *)
(*  Copyright 1998 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* When you change this, you need to update the documentation:
   - man/ocamlc.m   in ocaml
   - man/ocamlopt.m in ocaml
   - manual/cmds/comp.etex   in the doc sources
   - manual/cmds/native.etex in the doc sources
*)

type t =
  | Comment_start                           (*  1 *)
  | Comment_not_end                         (*  2 *)
  | Deprecated of string                    (*  3 *)
  | Fragile_match of string                 (*  4 *)
  | Partial_application                     (*  5 *)
  | Labels_omitted                          (*  6 *)
  | Method_override of string list          (*  7 *)
  | Partial_match of string                 (*  8 *)
  | Non_closed_record_pattern of string     (*  9 *)
  | Statement_type                          (* 10 *)
  | Unused_match                            (* 11 *)
  | Unused_pat                              (* 12 *)
  | Instance_variable_override of string list (* 13 *)
  | Illegal_backslash                       (* 14 *)
  | Implicit_public_methods of string list  (* 15 *)
  | Unerasable_optional_argument            (* 16 *)
  | Undeclared_virtual_method of string     (* 17 *)
  | Not_principal of string                 (* 18 *)
  | Without_principality of string          (* 19 *)
  | Unused_argument                         (* 20 *)
  | Nonreturning_statement                  (* 21 *)
  | Camlp4 of string                        (* 22 *)
  | Useless_record_with                     (* 23 *)
  | Bad_module_name of string               (* 24 *)
  | All_clauses_guarded                     (* 25 *)
  | Unused_var of string                    (* 26 *)
  | Unused_var_strict of string             (* 27 *)
  | Wildcard_arg_to_constant_constr         (* 28 *)
  | Eol_in_string                           (* 29 *)
  | Duplicate_definitions of string * string * string * string (*30 *)
  | Multiple_definition of string * string * string (* 31 *)
  | Unused_value_declaration of string      (* 32 *)
  | Unused_open of string                   (* 33 *)
  | Unused_type_declaration of string       (* 34 *)
  | Unused_for_index of string              (* 35 *)
  | Unused_ancestor of string               (* 36 *)
  | Unused_constructor of string * bool * bool  (* 37 *)
  | Unused_exception of string * bool       (* 38 *)
  | Unused_rec_flag                         (* 39 *)
  | Name_out_of_scope of string * string list * bool (* 40 *)
  | Ambiguous_name of string list * string list *  bool    (* 41 *)
  | Disambiguated_name of string            (* 42 *)
  | Nonoptional_label of string             (* 43 *)
  | Open_shadow_identifier of string * string (* 44 *)
  | Open_shadow_label_constructor of string * string (* 45 *)
  | Bad_env_variable of string * string     (* 46 *)
;;

(* If you remove a warning, leave a hole in the numbering.  NEVER change
   the numbers of existing warnings.
   If you add a new warning, add it at the end with a new number;
   do NOT reuse one of the holes.
*)

let number = function
  | Comment_start -> 1
  | Comment_not_end -> 2
  | Deprecated _ -> 3
  | Fragile_match _ -> 4
  | Partial_application -> 5
  | Labels_omitted -> 6
  | Method_override _ -> 7
  | Partial_match _ -> 8
  | Non_closed_record_pattern _ -> 9
  | Statement_type -> 10
  | Unused_match -> 11
  | Unused_pat -> 12
  | Instance_variable_override _ -> 13
  | Illegal_backslash -> 14
  | Implicit_public_methods _ -> 15
  | Unerasable_optional_argument -> 16
  | Undeclared_virtual_method _ -> 17
  | Not_principal _ -> 18
  | Without_principality _ -> 19
  | Unused_argument -> 20
  | Nonreturning_statement -> 21
  | Camlp4 _ -> 22
  | Useless_record_with -> 23
  | Bad_module_name _ -> 24
  | All_clauses_guarded -> 25
  | Unused_var _ -> 26
  | Unused_var_strict _ -> 27
  | Wildcard_arg_to_constant_constr -> 28
  | Eol_in_string -> 29
  | Duplicate_definitions _ -> 30
  | Multiple_definition _ -> 31
  | Unused_value_declaration _ -> 32
  | Unused_open _ -> 33
  | Unused_type_declaration _ -> 34
  | Unused_for_index _ -> 35
  | Unused_ancestor _ -> 36
  | Unused_constructor _ -> 37
  | Unused_exception _ -> 38
  | Unused_rec_flag -> 39
  | Name_out_of_scope _ -> 40
  | Ambiguous_name _ -> 41
  | Disambiguated_name _ -> 42
  | Nonoptional_label _ -> 43
  | Open_shadow_identifier _ -> 44
  | Open_shadow_label_constructor _ -> 45
  | Bad_env_variable _ -> 46
;;

let last_warning_number = 46
(* Must be the max number returned by the [number] function. *)

let letter = function
  | 'a' ->
     let rec loop i = if i = 0 then [] else i :: loop (i - 1) in
     loop last_warning_number
  | 'b' -> []
  | 'c' -> [1; 2]
  | 'd' -> [3]
  | 'e' -> [4]
  | 'f' -> [5]
  | 'g' -> []
  | 'h' -> []
  | 'i' -> []
  | 'j' -> []
  | 'k' -> [32; 33; 34; 35; 36; 37; 38; 39]
  | 'l' -> [6]
  | 'm' -> [7]
  | 'n' -> []
  | 'o' -> []
  | 'p' -> [8]
  | 'q' -> []
  | 'r' -> [9]
  | 's' -> [10]
  | 't' -> []
  | 'u' -> [11; 12]
  | 'v' -> [13]
  | 'w' -> []
  | 'x' -> [14; 15; 16; 17; 18; 19; 20; 21; 22; 23; 24; 25; 30]
  | 'y' -> [26]
  | 'z' -> [27]
  | _ -> assert false
;;

let active = Array.create (last_warning_number + 1) true;;
let error = Array.create (last_warning_number + 1) false;;

let is_active x = active.(number x);;
let is_error x = error.(number x);;

let parse_opt flags s =
  let set i = flags.(i) <- true in
  let clear i = flags.(i) <- false in
  let set_all i = active.(i) <- true; error.(i) <- true in
  let error () = raise (Arg.Bad "Ill-formed list of warnings") in
  let rec get_num n i =
    if i >= String.length s then i, n
    else match s.[i] with
    | '0'..'9' -> get_num (10 * n + Char.code s.[i] - Char.code '0') (i + 1)
    | _ -> i, n
  in
  let get_range i =
    let i, n1 = get_num 0 i in
    if i + 2 < String.length s && s.[i] = '.' && s.[i + 1] = '.' then
      let i, n2 = get_num 0 (i + 2) in
      if n2 < n1 then error ();
      i, n1, n2
    else
      i, n1, n1
  in
  let rec loop i =
    if i >= String.length s then () else
    match s.[i] with
    | 'A' .. 'Z' ->
       List.iter set (letter (Char.lowercase s.[i]));
       loop (i+1)
    | 'a' .. 'z' ->
       List.iter clear (letter s.[i]);
       loop (i+1)
    | '+' -> loop_letter_num set (i+1)
    | '-' -> loop_letter_num clear (i+1)
    | '@' -> loop_letter_num set_all (i+1)
    | c -> error ()
  and loop_letter_num myset i =
    if i >= String.length s then error () else
    match s.[i] with
    | '0' .. '9' ->
        let i, n1, n2 = get_range i in
        for n = n1 to min n2 last_warning_number do myset n done;
        loop i
    | 'A' .. 'Z' ->
       List.iter myset (letter (Char.lowercase s.[i]));
       loop (i+1)
    | 'a' .. 'z' ->
       List.iter myset (letter s.[i]);
       loop (i+1)
    | _ -> error ()
  in
  loop 0
;;

let parse_options errflag s = parse_opt (if errflag then error else active) s;;

(* If you change these, don't forget to change them in man/ocamlc.m *)
let defaults_w = "+a-4-6-7-9-27-29-32..39-41..42-44-45";;
let defaults_warn_error = "-a";;

let () = parse_options false defaults_w;;
let () = parse_options true defaults_warn_error;;

let message = function
  | Comment_start -> "this is the start of a comment."
  | Comment_not_end -> "this is not the end of a comment."
  | Deprecated s -> "deprecated feature: " ^ s
  | Fragile_match "" ->
      "this pattern-matching is fragile."
  | Fragile_match s ->
      "this pattern-matching is fragile.\n\
       It will remain exhaustive when constructors are added to type " ^ s ^ "."
  | Partial_application ->
      "this function application is partial,\n\
       maybe some arguments are missing."
  | Labels_omitted ->
      "labels were omitted in the application of this function."
  | Method_override [lab] ->
      "the method " ^ lab ^ " is overridden."
  | Method_override (cname :: slist) ->
      String.concat " "
        ("the following methods are overridden by the class"
         :: cname  :: ":\n " :: slist)
  | Method_override [] -> assert false
  | Partial_match "" -> "this pattern-matching is not exhaustive."
  | Partial_match s ->
      "this pattern-matching is not exhaustive.\n\
       Here is an example of a value that is not matched:\n" ^ s
  | Non_closed_record_pattern s ->
      "the following labels are not bound in this record pattern:\n" ^ s ^
      "\nEither bind these labels explicitly or add '; _' to the pattern."
  | Statement_type ->
      "this expression should have type unit."
  | Unused_match -> "this match case is unused."
  | Unused_pat   -> "this sub-pattern is unused."
  | Instance_variable_override [lab] ->
      "the instance variable " ^ lab ^ " is overridden.\n" ^
      "The behaviour changed in ocaml 3.10 (previous behaviour was hiding.)"
  | Instance_variable_override (cname :: slist) ->
      String.concat " "
        ("the following instance variables are overridden by the class"
         :: cname  :: ":\n " :: slist) ^
      "\nThe behaviour changed in ocaml 3.10 (previous behaviour was hiding.)"
  | Instance_variable_override [] -> assert false
  | Illegal_backslash -> "illegal backslash escape in string."
  | Implicit_public_methods l ->
      "the following private methods were made public implicitly:\n "
      ^ String.concat " " l ^ "."
  | Unerasable_optional_argument -> "this optional argument cannot be erased."
  | Undeclared_virtual_method m -> "the virtual method "^m^" is not declared."
  | Not_principal s -> s^" is not principal."
  | Without_principality s -> s^" without principality."
  | Unused_argument -> "this argument will not be used by the function."
  | Nonreturning_statement ->
      "this statement never returns (or has an unsound type.)"
  | Camlp4 s -> s
  | Useless_record_with ->
      "all the fields are explicitly listed in this record:\n\
       the 'with' clause is useless."
  | Bad_module_name (modname) ->
      "bad source file name: \"" ^ modname ^ "\" is not a valid module name."
  | All_clauses_guarded ->
      "bad style, all clauses in this pattern-matching are guarded."
  | Unused_var v | Unused_var_strict v -> "unused variable " ^ v ^ "."
  | Wildcard_arg_to_constant_constr ->
     "wildcard pattern given as argument to a constant constructor"
  | Eol_in_string ->
     "unescaped end-of-line in a string constant (non-portable code)"
  | Duplicate_definitions (kind, cname, tc1, tc2) ->
      Printf.sprintf "the %s %s is defined in both types %s and %s."
        kind cname tc1 tc2
  | Multiple_definition(modname, file1, file2) ->
      Printf.sprintf
        "files %s and %s both define a module named %s"
        file1 file2 modname
  | Unused_value_declaration v -> "unused value " ^ v ^ "."
  | Unused_open s -> "unused open " ^ s ^ "."
  | Unused_type_declaration s -> "unused type " ^ s ^ "."
  | Unused_for_index s -> "unused for-loop index " ^ s ^ "."
  | Unused_ancestor s -> "unused ancestor variable " ^ s ^ "."
  | Unused_constructor (s, false, false) -> "unused constructor " ^ s ^ "."
  | Unused_constructor (s, true, _) ->
      "constructor " ^ s ^
      " is never used to build values.\n\
        (However, this constructor appears in patterns.)"
  | Unused_constructor (s, false, true) ->
      "constructor " ^ s ^
      " is never used to build values.\n\
        Its type is exported as a private type."
  | Unused_exception (s, false) ->
      "unused exception constructor " ^ s ^ "."
  | Unused_exception (s, true) ->
      "exception constructor " ^ s ^
      " is never raised or used to build values.\n\
        (However, this constructor appears in patterns.)"
  | Unused_rec_flag ->
      "unused rec flag."
  | Name_out_of_scope (ty, [nm], false) ->
      nm ^ " was selected from type " ^ ty ^
      ".\nIt is not visible in the current scope, and will not \n\
       be selected if the type becomes unknown."
  | Name_out_of_scope (_, _, false) -> assert false
  | Name_out_of_scope (ty, slist, true) ->
      "this record of type "^ ty ^" contains fields that are \n\
       not visible in the current scope: "
      ^ String.concat " " slist ^ ".\n\
       They will not be selected if the type becomes unknown."
  | Ambiguous_name ([s], tl, false) ->
      s ^ " belongs to several types: " ^ String.concat " " tl ^
      "\nThe first one was selected. Please disambiguate if this is wrong."
  | Ambiguous_name (_, _, false) -> assert false
  | Ambiguous_name (slist, tl, true) ->
      "these field labels belong to several types: " ^
      String.concat " " tl ^
      "\nThe first one was selected. Please disambiguate if this is wrong."
  | Disambiguated_name s ->
      "this use of " ^ s ^ " required disambiguation."
  | Nonoptional_label s ->
      "the label " ^ s ^ " is not optional."
  | Open_shadow_identifier (kind, s) ->
      Printf.sprintf
        "this open statement shadows the %s identifier %s (which is later used)"
        kind s
  | Open_shadow_label_constructor (kind, s) ->
      Printf.sprintf
        "this open statement shadows the %s %s (which is later used)"
        kind s
  | Bad_env_variable (var, s) ->
    Printf.sprintf "illegal environment variable %s : %s" var s
;;

let nerrors = ref 0;;

let print ppf w =
  let msg = message w in
  let num = number w in
  let newlines = ref 0 in
  for i = 0 to String.length msg - 1 do
    if msg.[i] = '\n' then incr newlines;
  done;
  let (out, flush, newline, space) =
    Format.pp_get_all_formatter_output_functions ppf ()
  in
  let countnewline x = incr newlines; newline x in
  Format.pp_set_all_formatter_output_functions ppf out flush countnewline space;
  Format.fprintf ppf "%d: %s" num msg;
  Format.pp_print_flush ppf ();
  Format.pp_set_all_formatter_output_functions ppf out flush newline space;
  if error.(num) then incr nerrors;
  !newlines
;;

exception Errors of int;;

let check_fatal () =
  if !nerrors > 0 then begin
    let e = Errors !nerrors in
    nerrors := 0;
    raise e;
  end;
;;

let descriptions =
  [
    1, "Suspicious-looking start-of-comment mark.";
    2, "Suspicious-looking end-of-comment mark.";
    3, "Deprecated feature.";
    4, "Fragile pattern matching: matching that will remain complete even\n\
   \    if additional constructors are added to one of the variant types\n\
   \    matched.";
    5, "Partially applied function: expression whose result has function\n\
   \    type and is ignored.";
    6, "Label omitted in function application.";
    7, "Method overridden.";
    8, "Partial match: missing cases in pattern-matching.";
    9, "Missing fields in a record pattern.";
   10, "Expression on the left-hand side of a sequence that doesn't have type\n\
   \    \"unit\" (and that is not a function, see warning number 5).";
   11, "Redundant case in a pattern matching (unused match case).";
   12, "Redundant sub-pattern in a pattern-matching.";
   13, "Instance variable overridden.";
   14, "Illegal backslash escape in a string constant.";
   15, "Private method made public implicitly.";
   16, "Unerasable optional argument.";
   17, "Undeclared virtual method.";
   18, "Non-principal type.";
   19, "Type without principality.";
   20, "Unused function argument.";
   21, "Non-returning statement.";
   22, "Camlp4 warning.";
   23, "Useless record \"with\" clause.";
   24, "Bad module name: the source file name is not a valid OCaml module \
        name.";
   25, "Pattern-matching with all clauses guarded.  Exhaustiveness cannot be\n\
   \    checked.";
   26, "Suspicious unused variable: unused variable that is bound\n\
   \    with \"let\" or \"as\", and doesn't start with an underscore (\"_\")\n\
   \    character.";
   27, "Innocuous unused variable: unused variable that is not bound with\n\
   \    \"let\" nor \"as\", and doesn't start with an underscore (\"_\")\n\
   \    character.";
   28, "Wildcard pattern given as argument to a constant constructor.";
   29, "Unescaped end-of-line in a string constant (non-portable code).";
   30, "Two labels or constructors of the same name are defined in two\n\
   \    mutually recursive types.";
   31, "A module is linked twice in the same executable.";
   32, "Unused value declaration.";
   33, "Unused open statement.";
   34, "Unused type declaration.";
   35, "Unused for-loop index.";
   36, "Unused ancestor variable.";
   37, "Unused constructor.";
   38, "Unused exception constructor.";
   39, "Unused rec flag.";
   40, "Constructor or label name used out of scope.";
   41, "Ambiguous constructor or label name.";
   42, "Disambiguated constructor or label name.";
   43, "Nonoptional label applied as optional.";
   44, "Open statement shadows an already defined identifier.";
   45, "Open statement shadows an already defined label or constructor.";
  ]
;;

let help_warnings () =
  List.iter (fun (i, s) -> Printf.printf "%3i %s\n" i s) descriptions;
  print_endline "  A All warnings.";
  for i = Char.code 'b' to Char.code 'z' do
    let c = Char.chr i in
    match letter c with
    | [] -> ()
    | [n] ->
        Printf.printf "  %c Synonym for warning %i.\n" (Char.uppercase c) n
    | l ->
        Printf.printf "  %c Set of warnings %s.\n"
          (Char.uppercase c)
          (String.concat ", " (List.map string_of_int l))
  done;
  exit 0
;;

end;;
module Location = struct
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

open Lexing

let absname = ref false
    (* This reference should be in Clflags, but it would create an additional
       dependency and make bootstrapping Camlp4 more difficult. *)

type t = { loc_start: position; loc_end: position; loc_ghost: bool };;

let in_file name =
  let loc = {
    pos_fname = name;
    pos_lnum = 1;
    pos_bol = 0;
    pos_cnum = -1;
  } in
  { loc_start = loc; loc_end = loc; loc_ghost = true }
;;

let none = in_file "_none_";;

let curr lexbuf = {
  loc_start = lexbuf.lex_start_p;
  loc_end = lexbuf.lex_curr_p;
  loc_ghost = false
};;

let init lexbuf fname =
  lexbuf.lex_curr_p <- {
    pos_fname = fname;
    pos_lnum = 1;
    pos_bol = 0;
    pos_cnum = 0;
  }
;;

let symbol_rloc () = {
  loc_start = Parsing.symbol_start_pos ();
  loc_end = Parsing.symbol_end_pos ();
  loc_ghost = false;
};;

let symbol_gloc () = {
  loc_start = Parsing.symbol_start_pos ();
  loc_end = Parsing.symbol_end_pos ();
  loc_ghost = true;
};;

let rhs_loc n = {
  loc_start = Parsing.rhs_start_pos n;
  loc_end = Parsing.rhs_end_pos n;
  loc_ghost = false;
};;

let input_name = ref "_none_"
let input_lexbuf = ref (None : lexbuf option)

(* Terminal info *)

let status = ref Terminfo.Uninitialised

let num_loc_lines = ref 0 (* number of lines already printed after input *)

(* Highlight the locations using standout mode. *)

let highlight_terminfo ppf num_lines lb loc1 loc2 =
  Format.pp_print_flush ppf ();  (* avoid mixing Format and normal output *)
  (* Char 0 is at offset -lb.lex_abs_pos in lb.lex_buffer. *)
  let pos0 = -lb.lex_abs_pos in
  (* Do nothing if the buffer does not contain the whole phrase. *)
  if pos0 < 0 then raise Exit;
  (* Count number of lines in phrase *)
  let lines = ref !num_loc_lines in
  for i = pos0 to lb.lex_buffer_len - 1 do
    if lb.lex_buffer.[i] = '\n' then incr lines
  done;
  (* If too many lines, give up *)
  if !lines >= num_lines - 2 then raise Exit;
  (* Move cursor up that number of lines *)
  flush stdout; Terminfo.backup !lines;
  (* Print the input, switching to standout for the location *)
  let bol = ref false in
  print_string "# ";
  for pos = 0 to lb.lex_buffer_len - pos0 - 1 do
    if !bol then (print_string "  "; bol := false);
    if pos = loc1.loc_start.pos_cnum || pos = loc2.loc_start.pos_cnum then
      Terminfo.standout true;
    if pos = loc1.loc_end.pos_cnum || pos = loc2.loc_end.pos_cnum then
      Terminfo.standout false;
    let c = lb.lex_buffer.[pos + pos0] in
    print_char c;
    bol := (c = '\n')
  done;
  (* Make sure standout mode is over *)
  Terminfo.standout false;
  (* Position cursor back to original location *)
  Terminfo.resume !num_loc_lines;
  flush stdout

(* Highlight the location by printing it again. *)

let highlight_dumb ppf lb loc =
  (* Char 0 is at offset -lb.lex_abs_pos in lb.lex_buffer. *)
  let pos0 = -lb.lex_abs_pos in
  (* Do nothing if the buffer does not contain the whole phrase. *)
  if pos0 < 0 then raise Exit;
  let end_pos = lb.lex_buffer_len - pos0 - 1 in
  (* Determine line numbers for the start and end points *)
  let line_start = ref 0 and line_end = ref 0 in
  for pos = 0 to end_pos do
    if lb.lex_buffer.[pos + pos0] = '\n' then begin
      if loc.loc_start.pos_cnum > pos then incr line_start;
      if loc.loc_end.pos_cnum   > pos then incr line_end;
    end
  done;
  (* Print character location (useful for Emacs) *)
  Format.fprintf ppf "Characters %i-%i:@."
                 loc.loc_start.pos_cnum loc.loc_end.pos_cnum;
  (* Print the input, underlining the location *)
  Format.pp_print_string ppf "  ";
  let line = ref 0 in
  let pos_at_bol = ref 0 in
  for pos = 0 to end_pos do
    match lb.lex_buffer.[pos + pos0] with
    | '\n' ->
      if !line = !line_start && !line = !line_end then begin
        (* loc is on one line: underline location *)
        Format.fprintf ppf "@.  ";
        for _i = !pos_at_bol to loc.loc_start.pos_cnum - 1 do
          Format.pp_print_char ppf ' '
        done;
        for _i = loc.loc_start.pos_cnum to loc.loc_end.pos_cnum - 1 do
          Format.pp_print_char ppf '^'
        done
      end;
      if !line >= !line_start && !line <= !line_end then begin
        Format.fprintf ppf "@.";
        if pos < loc.loc_end.pos_cnum then Format.pp_print_string ppf "  "
      end;
      incr line;
      pos_at_bol := pos + 1
    | '\r' -> () (* discard *)
    | c ->
      if !line = !line_start && !line = !line_end then
        (* loc is on one line: print whole line *)
        Format.pp_print_char ppf c
      else if !line = !line_start then
        (* first line of multiline loc:
           print a dot for each char before loc_start *)
        if pos < loc.loc_start.pos_cnum then
          Format.pp_print_char ppf '.'
        else
          Format.pp_print_char ppf c
      else if !line = !line_end then
        (* last line of multiline loc: print a dot for each char
           after loc_end, even whitespaces *)
        if pos < loc.loc_end.pos_cnum then
          Format.pp_print_char ppf c
        else
          Format.pp_print_char ppf '.'
      else if !line > !line_start && !line < !line_end then
        (* intermediate line of multiline loc: print whole line *)
        Format.pp_print_char ppf c
  done

(* Highlight the location using one of the supported modes. *)

let rec highlight_locations ppf loc1 loc2 =
  match !status with
    Terminfo.Uninitialised ->
      status := Terminfo.setup stdout; highlight_locations ppf loc1 loc2
  | Terminfo.Bad_term ->
      begin match !input_lexbuf with
        None -> false
      | Some lb ->
          let norepeat =
            try Sys.getenv "TERM" = "norepeat" with Not_found -> false in
          if norepeat then false else
            try highlight_dumb ppf lb loc1; true
            with Exit -> false
      end
  | Terminfo.Good_term num_lines ->
      begin match !input_lexbuf with
        None -> false
      | Some lb ->
          try highlight_terminfo ppf num_lines lb loc1 loc2; true
          with Exit -> false
      end

(* Print the location in some way or another *)

open Format

let absolute_path s = (* This function could go into Filename *)
  let open Filename in
  let s = if is_relative s then concat (Sys.getcwd ()) s else s in
  (* Now simplify . and .. components *)
  let rec aux s =
    let base = basename s in
    let dir = dirname s in
    if dir = s then dir
    else if base = current_dir_name then aux dir
    else if base = parent_dir_name then dirname (aux dir)
    else concat (aux dir) base
  in
  aux s

let show_filename file =
  if !absname then absolute_path file else file

let print_filename ppf file =
  Format.fprintf ppf "%s" (show_filename file)

let reset () =
  num_loc_lines := 0

let (msg_file, msg_line, msg_chars, msg_to, msg_colon) =
  ("File \"", "\", line ", ", characters ", "-", ":")

(* return file, line, char from the given position *)
let get_pos_info pos =
  (pos.pos_fname, pos.pos_lnum, pos.pos_cnum - pos.pos_bol)
;;

let print_loc ppf loc =
  let (file, line, startchar) = get_pos_info loc.loc_start in
  let endchar = loc.loc_end.pos_cnum - loc.loc_start.pos_cnum + startchar in
  if file = "//toplevel//" then begin
    if highlight_locations ppf loc none then () else
      fprintf ppf "Characters %i-%i"
              loc.loc_start.pos_cnum loc.loc_end.pos_cnum
  end else begin
    fprintf ppf "%s%a%s%i" msg_file print_filename file msg_line line;
    if startchar >= 0 then
      fprintf ppf "%s%i%s%i" msg_chars startchar msg_to endchar
  end
;;

let print ppf loc =
  if loc.loc_start.pos_fname = "//toplevel//"
  && highlight_locations ppf loc none then ()
  else fprintf ppf "%a%s@." print_loc loc msg_colon
;;

let print_error ppf loc =
  print ppf loc;
  fprintf ppf "Error: ";
;;

let print_error_cur_file ppf = print_error ppf (in_file !input_name);;

let print_warning loc ppf w =
  if Warnings.is_active w then begin
    let printw ppf w =
      let n = Warnings.print ppf w in
      num_loc_lines := !num_loc_lines + n
    in
    print ppf loc;
    fprintf ppf "Warning %a@." printw w;
    pp_print_flush ppf ();
    incr num_loc_lines;
  end
;;

let prerr_warning loc w = print_warning loc err_formatter w;;

let echo_eof () =
  print_newline ();
  incr num_loc_lines

type 'a loc = {
  txt : 'a;
  loc : t;
}

let mkloc txt loc = { txt ; loc }
let mknoloc txt = mkloc txt none

end;;
module Longident = struct
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

type t =
    Lident of string
  | Ldot of t * string
  | Lapply of t * t

let rec flat accu = function
    Lident s -> s :: accu
  | Ldot(lid, s) -> flat (s :: accu) lid
  | Lapply(_, _) -> Misc.fatal_error "Longident.flat"

let flatten lid = flat [] lid

let last = function
    Lident s -> s
  | Ldot(_, s) -> s
  | Lapply(_, _) -> Misc.fatal_error "Longident.last"

let rec split_at_dots s pos =
  try
    let dot = String.index_from s pos '.' in
    String.sub s pos (dot - pos) :: split_at_dots s (dot + 1)
  with Not_found ->
    [String.sub s pos (String.length s - pos)]

let parse s =
  match split_at_dots s 0 with
    [] -> Lident ""  (* should not happen, but don't put assert false
                        so as not to crash the toplevel (see Genprintval) *)
  | hd :: tl -> List.fold_left (fun p s -> Ldot(p, s)) (Lident hd) tl

end;;
module Asttypes = struct
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

(* Auxiliary a.s.t. types used by parsetree and typedtree. *)

type constant =
    Const_int of int
  | Const_char of char
  | Const_string of string
  | Const_float of string
  | Const_int32 of int32
  | Const_int64 of int64
  | Const_nativeint of nativeint

type rec_flag = Nonrecursive | Recursive | Default

type direction_flag = Upto | Downto

type private_flag = Private | Public

type mutable_flag = Immutable | Mutable

type virtual_flag = Virtual | Concrete

type override_flag = Override | Fresh

type closed_flag = Closed | Open

type label = string

type 'a loc = 'a Location.loc = {
  txt : 'a;
  loc : Location.t;
}

end;;
module Parsetree = struct
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

(* Abstract syntax tree produced by parsing *)

open Asttypes

(* Type expressions for the core language *)

type core_type =
  { ptyp_desc: core_type_desc;
    ptyp_loc: Location.t }

and core_type_desc =
    Ptyp_any
  | Ptyp_var of string
  | Ptyp_arrow of label * core_type * core_type
  | Ptyp_tuple of core_type list
  | Ptyp_constr of Longident.t loc * core_type list
  | Ptyp_object of core_field_type list
  | Ptyp_class of Longident.t loc * core_type list * label list
  | Ptyp_alias of core_type * string
  | Ptyp_variant of row_field list * bool * label list option
  | Ptyp_poly of string list * core_type
  | Ptyp_package of package_type


and package_type = Longident.t loc * (Longident.t loc * core_type) list

and core_field_type =
  { pfield_desc: core_field_desc;
    pfield_loc: Location.t }

and core_field_desc =
    Pfield of string * core_type
  | Pfield_var

and row_field =
    Rtag of label * bool * core_type list
  | Rinherit of core_type

(* Type expressions for the class language *)

type 'a class_infos =
  { pci_virt: virtual_flag;
    pci_params: string loc list * Location.t;
    pci_name: string loc;
    pci_expr: 'a;
    pci_variance: (bool * bool) list;
    pci_loc: Location.t }

(* Value expressions for the core language *)

type pattern =
  { ppat_desc: pattern_desc;
    ppat_loc: Location.t }

and pattern_desc =
    Ppat_any
  | Ppat_var of string loc
  | Ppat_alias of pattern * string loc
  | Ppat_constant of constant
  | Ppat_tuple of pattern list
  | Ppat_construct of Longident.t loc * pattern option * bool
  | Ppat_variant of label * pattern option
  | Ppat_record of (Longident.t loc * pattern) list * closed_flag
  | Ppat_array of pattern list
  | Ppat_or of pattern * pattern
  | Ppat_constraint of pattern * core_type
  | Ppat_type of Longident.t loc
  | Ppat_lazy of pattern
  | Ppat_unpack of string loc

type expression =
  { pexp_desc: expression_desc;
    pexp_loc: Location.t }

and expression_desc =
    Pexp_ident of Longident.t loc
  | Pexp_constant of constant
  | Pexp_let of rec_flag * (pattern * expression) list * expression
  | Pexp_function of label * expression option * (pattern * expression) list
  | Pexp_apply of expression * (label * expression) list
  | Pexp_match of expression * (pattern * expression) list
  | Pexp_try of expression * (pattern * expression) list
  | Pexp_tuple of expression list
  | Pexp_construct of Longident.t loc * expression option * bool
  | Pexp_variant of label * expression option
  | Pexp_record of (Longident.t loc * expression) list * expression option
  | Pexp_field of expression * Longident.t loc
  | Pexp_setfield of expression * Longident.t loc * expression
  | Pexp_array of expression list
  | Pexp_ifthenelse of expression * expression * expression option
  | Pexp_sequence of expression * expression
  | Pexp_while of expression * expression
  | Pexp_for of
      string loc *  expression * expression * direction_flag * expression
  | Pexp_constraint of expression * core_type option * core_type option
  | Pexp_when of expression * expression
  | Pexp_send of expression * string
  | Pexp_new of Longident.t loc
  | Pexp_setinstvar of string loc * expression
  | Pexp_override of (string loc * expression) list
  | Pexp_letmodule of string loc * module_expr * expression
  | Pexp_assert of expression
  | Pexp_assertfalse
  | Pexp_lazy of expression
  | Pexp_poly of expression * core_type option
  | Pexp_object of class_structure
  | Pexp_newtype of string * expression
  | Pexp_pack of module_expr
  | Pexp_open of override_flag * Longident.t loc * expression

(* Value descriptions *)

and value_description =
  { pval_type: core_type;
    pval_prim: string list;
    pval_loc: Location.t
    }

(* Type declarations *)

and type_declaration =
  { ptype_params: string loc option list;
    ptype_cstrs: (core_type * core_type * Location.t) list;
    ptype_kind: type_kind;
    ptype_private: private_flag;
    ptype_manifest: core_type option;
    ptype_variance: (bool * bool) list;
    ptype_loc: Location.t }

and type_kind =
    Ptype_abstract
  | Ptype_variant of
      (string loc * core_type list * core_type option * Location.t) list
  | Ptype_record of
      (string loc * mutable_flag * core_type * Location.t) list

and exception_declaration = core_type list

(* Type expressions for the class language *)

and class_type =
  { pcty_desc: class_type_desc;
    pcty_loc: Location.t }

and class_type_desc =
    Pcty_constr of Longident.t loc * core_type list
  | Pcty_signature of class_signature
  | Pcty_fun of label * core_type * class_type

and class_signature = {
    pcsig_self: core_type;
    pcsig_fields: class_type_field list;
    pcsig_loc: Location.t;
  }

and class_type_field = {
    pctf_desc: class_type_field_desc;
    pctf_loc: Location.t;
  }

and class_type_field_desc =
    Pctf_inher of class_type
  | Pctf_val of (string * mutable_flag * virtual_flag * core_type)
  | Pctf_virt  of (string * private_flag * core_type)
  | Pctf_meth  of (string * private_flag * core_type)
  | Pctf_cstr  of (core_type * core_type)

and class_description = class_type class_infos

and class_type_declaration = class_type class_infos

(* Value expressions for the class language *)

and class_expr =
  { pcl_desc: class_expr_desc;
    pcl_loc: Location.t }

and class_expr_desc =
    Pcl_constr of Longident.t loc * core_type list
  | Pcl_structure of class_structure
  | Pcl_fun of label * expression option * pattern * class_expr
  | Pcl_apply of class_expr * (label * expression) list
  | Pcl_let of rec_flag * (pattern * expression) list * class_expr
  | Pcl_constraint of class_expr * class_type

and class_structure = {
    pcstr_pat: pattern;
    pcstr_fields: class_field list;
  }

and class_field = {
    pcf_desc: class_field_desc;
    pcf_loc: Location.t;
  }

and class_field_desc =
    Pcf_inher of override_flag * class_expr * string option
  | Pcf_valvirt of (string loc * mutable_flag * core_type)
  | Pcf_val of (string loc * mutable_flag * override_flag * expression)
  | Pcf_virt of (string loc * private_flag * core_type)
  | Pcf_meth of (string loc * private_flag * override_flag * expression)
  | Pcf_constr of (core_type * core_type)
  | Pcf_init of expression

and class_declaration = class_expr class_infos

(* Type expressions for the module language *)

and module_type =
  { pmty_desc: module_type_desc;
    pmty_loc: Location.t }

and module_type_desc =
    Pmty_ident of Longident.t loc
  | Pmty_signature of signature
  | Pmty_functor of string loc * module_type * module_type
  | Pmty_with of module_type * (Longident.t loc * with_constraint) list
  | Pmty_typeof of module_expr

and signature = signature_item list

and signature_item =
  { psig_desc: signature_item_desc;
    psig_loc: Location.t }

and signature_item_desc =
    Psig_value of string loc * value_description
  | Psig_type of (string loc * type_declaration) list
  | Psig_exception of string loc * exception_declaration
  | Psig_module of string loc * module_type
  | Psig_recmodule of (string loc * module_type) list
  | Psig_modtype of string loc * modtype_declaration
  | Psig_open of override_flag * Longident.t loc
  | Psig_include of module_type
  | Psig_class of class_description list
  | Psig_class_type of class_type_declaration list

and modtype_declaration =
    Pmodtype_abstract
  | Pmodtype_manifest of module_type

and with_constraint =
    Pwith_type of type_declaration
  | Pwith_module of Longident.t loc
  | Pwith_typesubst of type_declaration
  | Pwith_modsubst of Longident.t loc

(* Value expressions for the module language *)

and module_expr =
  { pmod_desc: module_expr_desc;
    pmod_loc: Location.t }

and module_expr_desc =
    Pmod_ident of Longident.t loc
  | Pmod_structure of structure
  | Pmod_functor of string loc * module_type * module_expr
  | Pmod_apply of module_expr * module_expr
  | Pmod_constraint of module_expr * module_type
  | Pmod_unpack of expression

and structure = structure_item list

and structure_item =
  { pstr_desc: structure_item_desc;
    pstr_loc: Location.t }

and structure_item_desc =
    Pstr_eval of expression
  | Pstr_value of rec_flag * (pattern * expression) list
  | Pstr_primitive of string loc * value_description
  | Pstr_type of (string loc * type_declaration) list
  | Pstr_exception of string loc * exception_declaration
  | Pstr_exn_rebind of string loc * Longident.t loc
  | Pstr_module of string loc * module_expr
  | Pstr_recmodule of (string loc * module_type * module_expr) list
  | Pstr_modtype of string loc * module_type
  | Pstr_open of override_flag * Longident.t loc
  | Pstr_class of class_declaration list
  | Pstr_class_type of class_type_declaration list
  | Pstr_include of module_expr

(* Toplevel phrases *)

type toplevel_phrase =
    Ptop_def of structure
  | Ptop_dir of string * directive_argument

and directive_argument =
    Pdir_none
  | Pdir_string of string
  | Pdir_int of int
  | Pdir_ident of Longident.t
  | Pdir_bool of bool

end;;
module Outcometree = struct
(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*     Daniel de Rauglaudre, projet Cristal, INRIA Rocquencourt        *)
(*                                                                     *)
(*  Copyright 2001 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* Module [Outcometree]: results displayed by the toplevel *)

(* These types represent messages that the toplevel displays as normal
   results or errors. The real displaying is customisable using the hooks:
      [Toploop.print_out_value]
      [Toploop.print_out_type]
      [Toploop.print_out_sig_item]
      [Toploop.print_out_phrase] *)

type out_ident =
  | Oide_apply of out_ident * out_ident
  | Oide_dot of out_ident * string
  | Oide_ident of string

type out_value =
  | Oval_array of out_value list
  | Oval_char of char
  | Oval_constr of out_ident * out_value list
  | Oval_ellipsis
  | Oval_float of float
  | Oval_int of int
  | Oval_int32 of int32
  | Oval_int64 of int64
  | Oval_nativeint of nativeint
  | Oval_list of out_value list
  | Oval_printer of (Format.formatter -> unit)
  | Oval_record of (out_ident * out_value) list
  | Oval_string of string
  | Oval_stuff of string
  | Oval_tuple of out_value list
  | Oval_variant of string * out_value option

type out_type =
  | Otyp_abstract
  | Otyp_alias of out_type * string
  | Otyp_arrow of string * out_type * out_type
  | Otyp_class of bool * out_ident * out_type list
  | Otyp_constr of out_ident * out_type list
  | Otyp_manifest of out_type * out_type
  | Otyp_object of (string * out_type) list * bool option
  | Otyp_record of (string * bool * out_type) list
  | Otyp_stuff of string
  | Otyp_sum of (string * out_type list * out_type option) list
  | Otyp_tuple of out_type list
  | Otyp_var of bool * string
  | Otyp_variant of
      bool * out_variant * bool * (string list) option
  | Otyp_poly of string list * out_type
  | Otyp_module of string * string list * out_type list

and out_variant =
  | Ovar_fields of (string * bool * out_type list) list
  | Ovar_name of out_ident * out_type list

type out_class_type =
  | Octy_constr of out_ident * out_type list
  | Octy_fun of string * out_type * out_class_type
  | Octy_signature of out_type option * out_class_sig_item list
and out_class_sig_item =
  | Ocsg_constraint of out_type * out_type
  | Ocsg_method of string * bool * bool * out_type
  | Ocsg_value of string * bool * bool * out_type

type out_module_type =
  | Omty_abstract
  | Omty_functor of string * out_module_type * out_module_type
  | Omty_ident of out_ident
  | Omty_signature of out_sig_item list
and out_sig_item =
  | Osig_class of
      bool * string * (string * (bool * bool)) list * out_class_type *
        out_rec_status
  | Osig_class_type of
      bool * string * (string * (bool * bool)) list * out_class_type *
        out_rec_status
  | Osig_exception of string * out_type list
  | Osig_modtype of string * out_module_type
  | Osig_module of string * out_module_type * out_rec_status
  | Osig_type of out_type_decl * out_rec_status
  | Osig_value of string * out_type * string list
and out_type_decl =
  string * (string * (bool * bool)) list * out_type * Asttypes.private_flag *
  (out_type * out_type) list
and out_rec_status =
  | Orec_not
  | Orec_first
  | Orec_next

type out_phrase =
  | Ophr_eval of out_value * out_type
  | Ophr_signature of (out_sig_item * out_value option) list
  | Ophr_exception of (exn * out_value)

end;;
module Oprint = struct
(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*                  Projet Cristal, INRIA Rocquencourt                 *)
(*                                                                     *)
(*  Copyright 2002 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

open Format
open Outcometree

exception Ellipsis

let cautious f ppf arg =
  try f ppf arg with
    Ellipsis -> fprintf ppf "..."

let rec print_ident ppf =
  function
    Oide_ident s -> pp_print_string ppf s
  | Oide_dot (id, s) ->
      print_ident ppf id; pp_print_char ppf '.'; pp_print_string ppf s
  | Oide_apply (id1, id2) ->
      fprintf ppf "%a(%a)" print_ident id1 print_ident id2

let parenthesized_ident name =
  (List.mem name ["or"; "mod"; "land"; "lor"; "lxor"; "lsl"; "lsr"; "asr"])
  ||
  (match name.[0] with
      'a'..'z' | 'A'..'Z' | '\223'..'\246' | '\248'..'\255' | '_' ->
        false
    | _ -> true)

let value_ident ppf name =
  if parenthesized_ident name then
    fprintf ppf "( %s )" name
  else
    pp_print_string ppf name

(* Values *)

let valid_float_lexeme s =
  let l = String.length s in
  let rec loop i =
    if i >= l then s ^ "." else
    match s.[i] with
    | '0' .. '9' | '-' -> loop (i+1)
    | _ -> s
  in loop 0

let float_repres f =
  match classify_float f with
    FP_nan -> "nan"
  | FP_infinite ->
      if f < 0.0 then "neg_infinity" else "infinity"
  | _ ->
      let float_val =
        let s1 = Printf.sprintf "%.12g" f in
        if f = float_of_string s1 then s1 else
        let s2 = Printf.sprintf "%.15g" f in
        if f = float_of_string s2 then s2 else
        Printf.sprintf "%.18g" f
      in valid_float_lexeme float_val

let parenthesize_if_neg ppf fmt v isneg =
  if isneg then pp_print_char ppf '(';
  fprintf ppf fmt v;
  if isneg then pp_print_char ppf ')'

let print_out_value ppf tree =
  let rec print_tree_1 ppf =
    function
    | Oval_constr (name, [param]) ->
        fprintf ppf "@[<1>%a@ %a@]" print_ident name print_constr_param param
    | Oval_constr (name, (_ :: _ as params)) ->
        fprintf ppf "@[<1>%a@ (%a)@]" print_ident name
          (print_tree_list print_tree_1 ",") params
    | Oval_variant (name, Some param) ->
        fprintf ppf "@[<2>`%s@ %a@]" name print_constr_param param
    | tree -> print_simple_tree ppf tree
  and print_constr_param ppf = function
    | Oval_int i -> parenthesize_if_neg ppf "%i" i (i < 0)
    | Oval_int32 i -> parenthesize_if_neg ppf "%lil" i (i < 0l)
    | Oval_int64 i -> parenthesize_if_neg ppf "%LiL" i (i < 0L)
    | Oval_nativeint i -> parenthesize_if_neg ppf "%nin" i (i < 0n)
    | Oval_float f -> parenthesize_if_neg ppf "%s" (float_repres f) (f < 0.0)
    | tree -> print_simple_tree ppf tree
  and print_simple_tree ppf =
    function
      Oval_int i -> fprintf ppf "%i" i
    | Oval_int32 i -> fprintf ppf "%lil" i
    | Oval_int64 i -> fprintf ppf "%LiL" i
    | Oval_nativeint i -> fprintf ppf "%nin" i
    | Oval_float f -> pp_print_string ppf (float_repres f)
    | Oval_char c -> fprintf ppf "%C" c
    | Oval_string s ->
        begin try fprintf ppf "%S" s with
          Invalid_argument "String.create" -> fprintf ppf "<huge string>"
        end
    | Oval_list tl ->
        fprintf ppf "@[<1>[%a]@]" (print_tree_list print_tree_1 ";") tl
    | Oval_array tl ->
        fprintf ppf "@[<2>[|%a|]@]" (print_tree_list print_tree_1 ";") tl
    | Oval_constr (name, []) -> print_ident ppf name
    | Oval_variant (name, None) -> fprintf ppf "`%s" name
    | Oval_stuff s -> pp_print_string ppf s
    | Oval_record fel ->
        fprintf ppf "@[<1>{%a}@]" (cautious (print_fields true)) fel
    | Oval_ellipsis -> raise Ellipsis
    | Oval_printer f -> f ppf
    | Oval_tuple tree_list ->
        fprintf ppf "@[<1>(%a)@]" (print_tree_list print_tree_1 ",") tree_list
    | tree -> fprintf ppf "@[<1>(%a)@]" (cautious print_tree_1) tree
  and print_fields first ppf =
    function
      [] -> ()
    | (name, tree) :: fields ->
        if not first then fprintf ppf ";@ ";
        fprintf ppf "@[<1>%a@ =@ %a@]" print_ident name (cautious print_tree_1)
          tree;
        print_fields false ppf fields
  and print_tree_list print_item sep ppf tree_list =
    let rec print_list first ppf =
      function
        [] -> ()
      | tree :: tree_list ->
          if not first then fprintf ppf "%s@ " sep;
          print_item ppf tree;
          print_list false ppf tree_list
    in
    cautious (print_list true) ppf tree_list
  in
  cautious print_tree_1 ppf tree

let out_value = ref print_out_value

(* Types *)

let rec print_list_init pr sep ppf =
  function
    [] -> ()
  | a :: l -> sep ppf; pr ppf a; print_list_init pr sep ppf l

let rec print_list pr sep ppf =
  function
    [] -> ()
  | [a] -> pr ppf a
  | a :: l -> pr ppf a; sep ppf; print_list pr sep ppf l

let pr_present =
  print_list (fun ppf s -> fprintf ppf "`%s" s) (fun ppf -> fprintf ppf "@ ")

let pr_vars =
  print_list (fun ppf s -> fprintf ppf "'%s" s) (fun ppf -> fprintf ppf "@ ")

let rec print_out_type ppf =
  function
  | Otyp_alias (ty, s) ->
      fprintf ppf "@[%a@ as '%s@]" print_out_type ty s
  | Otyp_poly (sl, ty) ->
      fprintf ppf "@[<hov 2>%a.@ %a@]"
        pr_vars sl
        print_out_type ty
  | ty ->
      print_out_type_1 ppf ty

and print_out_type_1 ppf =
  function
    Otyp_arrow (lab, ty1, ty2) ->
      pp_open_box ppf 0;
      if lab <> "" then (pp_print_string ppf lab; pp_print_char ppf ':');
      print_out_type_2 ppf ty1;
      pp_print_string ppf " ->";
      pp_print_space ppf ();
      print_out_type_1 ppf ty2;
      pp_close_box ppf ()
  | ty -> print_out_type_2 ppf ty
and print_out_type_2 ppf =
  function
    Otyp_tuple tyl ->
      fprintf ppf "@[<0>%a@]" (print_typlist print_simple_out_type " *") tyl
  | ty -> print_simple_out_type ppf ty
and print_simple_out_type ppf =
  function
    Otyp_class (ng, id, tyl) ->
      fprintf ppf "@[%a%s#%a@]" print_typargs tyl (if ng then "_" else "")
        print_ident id
  | Otyp_constr (id, tyl) ->
      pp_open_box ppf 0;
      print_typargs ppf tyl;
      print_ident ppf id;
      pp_close_box ppf ()
  | Otyp_object (fields, rest) ->
      fprintf ppf "@[<2>< %a >@]" (print_fields rest) fields
  | Otyp_stuff s -> pp_print_string ppf s
  | Otyp_var (ng, s) -> fprintf ppf "'%s%s" (if ng then "_" else "") s
  | Otyp_variant (non_gen, row_fields, closed, tags) ->
      let print_present ppf =
        function
          None | Some [] -> ()
        | Some l -> fprintf ppf "@;<1 -2>> @[<hov>%a@]" pr_present l
      in
      let print_fields ppf =
        function
          Ovar_fields fields ->
            print_list print_row_field (fun ppf -> fprintf ppf "@;<1 -2>| ")
              ppf fields
        | Ovar_name (id, tyl) ->
            fprintf ppf "@[%a%a@]" print_typargs tyl print_ident id
      in
      fprintf ppf "%s[%s@[<hv>@[<hv>%a@]%a ]@]" (if non_gen then "_" else "")
        (if closed then if tags = None then " " else "< "
         else if tags = None then "> " else "? ")
        print_fields row_fields
        print_present tags
  | Otyp_alias _ | Otyp_poly _ | Otyp_arrow _ | Otyp_tuple _ as ty ->
      pp_open_box ppf 1;
      pp_print_char ppf '(';
      print_out_type ppf ty;
      pp_print_char ppf ')';
      pp_close_box ppf ()
  | Otyp_abstract | Otyp_sum _ | Otyp_record _ | Otyp_manifest (_, _) -> ()
  | Otyp_module (p, n, tyl) ->
      fprintf ppf "@[<1>(module %s" p;
      let first = ref true in
      List.iter2
        (fun s t ->
          let sep = if !first then (first := false; "with") else "and" in
          fprintf ppf " %s type %s = %a" sep s print_out_type t
        )
        n tyl;
      fprintf ppf ")@]"
and print_fields rest ppf =
  function
    [] ->
      begin match rest with
        Some non_gen -> fprintf ppf "%s.." (if non_gen then "_" else "")
      | None -> ()
      end
  | [s, t] ->
      fprintf ppf "%s : %a" s print_out_type t;
      begin match rest with
        Some _ -> fprintf ppf ";@ "
      | None -> ()
      end;
      print_fields rest ppf []
  | (s, t) :: l ->
      fprintf ppf "%s : %a;@ %a" s print_out_type t (print_fields rest) l
and print_row_field ppf (l, opt_amp, tyl) =
  let pr_of ppf =
    if opt_amp then fprintf ppf " of@ &@ "
    else if tyl <> [] then fprintf ppf " of@ "
    else fprintf ppf ""
  in
  fprintf ppf "@[<hv 2>`%s%t%a@]" l pr_of (print_typlist print_out_type " &")
    tyl
and print_typlist print_elem sep ppf =
  function
    [] -> ()
  | [ty] -> print_elem ppf ty
  | ty :: tyl ->
      print_elem ppf ty;
      pp_print_string ppf sep;
      pp_print_space ppf ();
      print_typlist print_elem sep ppf tyl
and print_typargs ppf =
  function
    [] -> ()
  | [ty1] -> print_simple_out_type ppf ty1; pp_print_space ppf ()
  | tyl ->
      pp_open_box ppf 1;
      pp_print_char ppf '(';
      print_typlist print_out_type "," ppf tyl;
      pp_print_char ppf ')';
      pp_close_box ppf ();
      pp_print_space ppf ()

let out_type = ref print_out_type

(* Class types *)

let type_parameter ppf (ty, (co, cn)) =
  fprintf ppf "%s%s"
    (if not cn then "+" else if not co then "-" else "")
    (if ty = "_" then ty else "'"^ty)

let print_out_class_params ppf =
  function
    [] -> ()
  | tyl ->
      fprintf ppf "@[<1>[%a]@]@ "
        (print_list type_parameter (fun ppf -> fprintf ppf ", "))
        tyl

let rec print_out_class_type ppf =
  function
    Octy_constr (id, tyl) ->
      let pr_tyl ppf =
        function
          [] -> ()
        | tyl ->
            fprintf ppf "@[<1>[%a]@]@ " (print_typlist !out_type ",") tyl
      in
      fprintf ppf "@[%a%a@]" pr_tyl tyl print_ident id
  | Octy_fun (lab, ty, cty) ->
      fprintf ppf "@[%s%a ->@ %a@]" (if lab <> "" then lab ^ ":" else "")
        print_out_type_2 ty print_out_class_type cty
  | Octy_signature (self_ty, csil) ->
      let pr_param ppf =
        function
          Some ty -> fprintf ppf "@ @[(%a)@]" !out_type ty
        | None -> ()
      in
      fprintf ppf "@[<hv 2>@[<2>object%a@]@ %a@;<1 -2>end@]" pr_param self_ty
        (print_list print_out_class_sig_item (fun ppf -> fprintf ppf "@ "))
        csil
and print_out_class_sig_item ppf =
  function
    Ocsg_constraint (ty1, ty2) ->
      fprintf ppf "@[<2>constraint %a =@ %a@]" !out_type ty1
        !out_type ty2
  | Ocsg_method (name, priv, virt, ty) ->
      fprintf ppf "@[<2>method %s%s%s :@ %a@]"
        (if priv then "private " else "") (if virt then "virtual " else "")
        name !out_type ty
  | Ocsg_value (name, mut, vr, ty) ->
      fprintf ppf "@[<2>val %s%s%s :@ %a@]"
        (if mut then "mutable " else "")
        (if vr then "virtual " else "")
        name !out_type ty

let out_class_type = ref print_out_class_type

(* Signature *)

let out_module_type = ref (fun _ -> failwith "Oprint.out_module_type")
let out_sig_item = ref (fun _ -> failwith "Oprint.out_sig_item")
let out_signature = ref (fun _ -> failwith "Oprint.out_signature")

let rec print_out_module_type ppf =
  function
    Omty_abstract -> ()
  | Omty_functor (name, mty_arg, mty_res) ->
      fprintf ppf "@[<2>functor@ (%s : %a) ->@ %a@]" name
        print_out_module_type mty_arg print_out_module_type mty_res
  | Omty_ident id -> fprintf ppf "%a" print_ident id
  | Omty_signature sg ->
      fprintf ppf "@[<hv 2>sig@ %a@;<1 -2>end@]" !out_signature sg
and print_out_signature ppf =
  function
    [] -> ()
  | [item] -> !out_sig_item ppf item
  | item :: items ->
      fprintf ppf "%a@ %a" !out_sig_item item print_out_signature items
and print_out_sig_item ppf =
  function
    Osig_class (vir_flag, name, params, clt, rs) ->
      fprintf ppf "@[<2>%s%s@ %a%s@ :@ %a@]"
        (if rs = Orec_next then "and" else "class")
        (if vir_flag then " virtual" else "") print_out_class_params params
        name !out_class_type clt
  | Osig_class_type (vir_flag, name, params, clt, rs) ->
      fprintf ppf "@[<2>%s%s@ %a%s@ =@ %a@]"
        (if rs = Orec_next then "and" else "class type")
        (if vir_flag then " virtual" else "") print_out_class_params params
        name !out_class_type clt
  | Osig_exception (id, tyl) ->
      fprintf ppf "@[<2>exception %a@]" print_out_constr (id, tyl,None)
  | Osig_modtype (name, Omty_abstract) ->
      fprintf ppf "@[<2>module type %s@]" name
  | Osig_modtype (name, mty) ->
      fprintf ppf "@[<2>module type %s =@ %a@]" name !out_module_type mty
  | Osig_module (name, mty, rs) ->
      fprintf ppf "@[<2>%s %s :@ %a@]"
        (match rs with Orec_not -> "module"
                     | Orec_first -> "module rec"
                     | Orec_next -> "and")
        name !out_module_type mty
  | Osig_type(td, rs) ->
        print_out_type_decl
          (if rs = Orec_next then "and" else "type")
          ppf td
  | Osig_value (name, ty, prims) ->
      let kwd = if prims = [] then "val" else "external" in
      let pr_prims ppf =
        function
          [] -> ()
        | s :: sl ->
            fprintf ppf "@ = \"%s\"" s;
            List.iter (fun s -> fprintf ppf "@ \"%s\"" s) sl
      in
      fprintf ppf "@[<2>%s %a :@ %a%a@]" kwd value_ident name !out_type
        ty pr_prims prims

and print_out_type_decl kwd ppf (name, args, ty, priv, constraints) =
  let print_constraints ppf params =
    List.iter
      (fun (ty1, ty2) ->
         fprintf ppf "@ @[<2>constraint %a =@ %a@]" !out_type ty1
           !out_type ty2)
      params
  in
  let type_defined ppf =
    match args with
      [] -> pp_print_string ppf name
    | [arg] -> fprintf ppf "@[%a@ %s@]" type_parameter arg name
    | _ ->
        fprintf ppf "@[(@[%a)@]@ %s@]"
          (print_list type_parameter (fun ppf -> fprintf ppf ",@ ")) args name
  in
  let print_manifest ppf =
    function
      Otyp_manifest (ty, _) -> fprintf ppf " =@ %a" !out_type ty
    | _ -> ()
  in
  let print_name_args ppf =
    fprintf ppf "%s %t%a" kwd type_defined print_manifest ty
  in
  let ty =
    match ty with
      Otyp_manifest (_, ty) -> ty
    | _ -> ty
  in
  let print_private ppf = function
    Asttypes.Private -> fprintf ppf " private"
  | Asttypes.Public -> () in
  let print_out_tkind ppf = function
  | Otyp_abstract -> ()
  | Otyp_record lbls ->
      fprintf ppf " =%a {%a@;<1 -2>}"
        print_private priv
        (print_list_init print_out_label (fun ppf -> fprintf ppf "@ ")) lbls
  | Otyp_sum constrs ->
      fprintf ppf " =%a@;<1 2>%a"
        print_private priv
        (print_list print_out_constr (fun ppf -> fprintf ppf "@ | ")) constrs
  | ty ->
      fprintf ppf " =%a@;<1 2>%a"
        print_private priv
        !out_type ty
  in
  fprintf ppf "@[<2>@[<hv 2>%t%a@]%a@]"
    print_name_args
    print_out_tkind ty
    print_constraints constraints
and print_out_constr ppf (name, tyl,ret_type_opt) =
  match ret_type_opt with
  | None ->
      begin match tyl with
      | [] ->
          pp_print_string ppf name
      | _ ->
          fprintf ppf "@[<2>%s of@ %a@]" name
            (print_typlist print_simple_out_type " *") tyl
      end
  | Some ret_type ->
      begin match tyl with
      | [] ->
          fprintf ppf "@[<2>%s :@ %a@]" name print_simple_out_type  ret_type
      | _ ->
          fprintf ppf "@[<2>%s :@ %a -> %a@]" name
            (print_typlist print_simple_out_type " *")
            tyl print_simple_out_type ret_type
      end


and print_out_label ppf (name, mut, arg) =
  fprintf ppf "@[<2>%s%s :@ %a@];" (if mut then "mutable " else "") name
    !out_type arg

let _ = out_module_type := print_out_module_type
let _ = out_signature := print_out_signature
let _ = out_sig_item := print_out_sig_item

(* Phrases *)

let print_out_exception ppf exn outv =
  match exn with
    Sys.Break -> fprintf ppf "Interrupted.@."
  | Out_of_memory -> fprintf ppf "Out of memory during evaluation.@."
  | Stack_overflow ->
      fprintf ppf "Stack overflow during evaluation (looping recursion?).@."
  | _ -> fprintf ppf "@[Exception:@ %a.@]@." !out_value outv

let rec print_items ppf =
  function
    [] -> ()
  | (tree, valopt) :: items ->
      begin match valopt with
        Some v ->
          fprintf ppf "@[<2>%a =@ %a@]" !out_sig_item tree
            !out_value v
      | None -> fprintf ppf "@[%a@]" !out_sig_item tree
      end;
      if items <> [] then fprintf ppf "@ %a" print_items items

let print_out_phrase ppf =
  function
    Ophr_eval (outv, ty) ->
      fprintf ppf "@[- : %a@ =@ %a@]@." !out_type ty !out_value outv
  | Ophr_signature [] -> ()
  | Ophr_signature items -> fprintf ppf "@[<v>%a@]@." print_items items
  | Ophr_exception (exn, outv) -> print_out_exception ppf exn outv

let out_phrase = ref print_out_phrase

end;;
module Myocamlbuild_config = struct
(* # generated by ./configure  *)
let prefix = "/usr/local";;
let bindir = prefix^"/bin";;
let libdir = prefix^"/lib/ocaml";;
let stublibdir = libdir^"/stublibs";;
let mandir = prefix^"/man";;
let manext = "1";;
let ranlib = "ranlib";;
let ranlibcmd = "ranlib";;
let arcmd = "ar";;
let sharpbangscripts = true;;
let bng_arch = "ia32";;
let bng_asm_level = "2";;
let pthread_link = "-cclib -lpthread";;
let x11_includes = " ";;
let x11_link = "-lX11  ";;
let tk_defs = "-I/usr/include/tcl8.6 -I/usr/include/tk8.6 "^x11_includes;;
let tk_link = " -ltk8.6 -ltcl8.6  -ldl "^x11_link;;
let libbfd_link = "";;
let bytecc = "gcc";;
let bytecccompopts = "-fno-defer-pop -Wall -D_FILE_OFFSET_BITS=64 -D_REENTRANT";;
let bytecclinkopts = " -Wl,-E";;
let bytecclibs = " -lm  -ldl -lcurses -lpthread";;
let byteccrpath = "-Wl,-rpath,";;
let exe = "";;
let supports_shared_libraries = true;;
let sharedcccompopts = "-fPIC";;
let mksharedlibrpath = "-Wl,-rpath,";;
let natdynlinkopts = "-Wl,-E";;
(* SYSLIB=-l"^1^" *)
let syslib x = "-l"^x;;

(* ## *)
(* MKLIB=ar rc "^1^" "^2^"; ranlib "^1^" *)
let mklib out files opts = Printf.sprintf "ar rc %s %s %s; ranlib %s" out opts files out;;
let arch = "i386";;
let model = "default";;
let system = "linux_elf";;
let nativecc = "gcc";;
let nativecccompopts = "-Wall -D_FILE_OFFSET_BITS=64 -D_REENTRANT";;
let nativeccprofopts = "-Wall -D_FILE_OFFSET_BITS=64 -D_REENTRANT";;
let nativecclinkopts = "";;
let nativeccrpath = "-Wl,-rpath,";;
let nativecclibs = " -lm  -ldl";;
let asm = "as";;
let aspp = "gcc -c";;
let asppprofflags = "-DPROFILING";;
let profiling = "prof";;
let dynlinkopts = " -ldl";;
let otherlibraries = "unix str num dynlink bigarray systhreads threads graph labltk";;
let debugger = "ocamldebugger";;
let cc_profile = "-pg";;
let systhread_support = true;;
let partialld = "ld -r";;
let packld = partialld^" "^nativecclinkopts^" -o\ ";;
let dllcccompopts = "";;

let o = "o";;
let a = "a";;
let so = "so";;
let ext_obj = ".o";;
let ext_asm = ".s";;
let ext_lib = ".a";;
let ext_dll = ".so";;
let extralibs = "";;
let ccomptype = "cc";;
let toolchain = "cc";;
let natdynlink = true;;
let cmxs = "cmxs";;
let mkexe = bytecc;;
let mkexedebugflag = "-g";;
let mkdll = "gcc -shared";;
let mkmaindll = "gcc -shared";;
let runtimed = "noruntimed";;
let camlp4 = "camlp4";;
let asm_cfi_supported = true;;
let with_frame_pointers = false;;

end;;
module Config = struct
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

(***********************************************************************)
(**                                                                   **)
(**               WARNING WARNING WARNING                             **)
(**                                                                   **)
(** When you change this file, you must make the parallel change      **)
(** in config.mlp                                                     **)
(**                                                                   **)
(***********************************************************************)


(* The main OCaml version string has moved to ../VERSION *)
let version = Sys.ocaml_version

module C = Myocamlbuild_config

let standard_library_default = C.libdir

let standard_library =
  try
    Sys.getenv "OCAMLLIB"
  with Not_found ->
  try
    Sys.getenv "CAMLLIB"
  with Not_found ->
    standard_library_default

let windows =
  match Sys.os_type with
  | "Win32" -> true
  |    _    -> false

let sf = Printf.sprintf

let standard_runtime =
  if windows then "ocamlrun"
  else C.bindir^"/ocamlrun"
let ccomp_type = C.ccomptype
let bytecomp_c_compiler =
  sf "%s %s %s" C.bytecc C.bytecccompopts C.sharedcccompopts
let bytecomp_c_libraries = C.bytecclibs
let native_c_compiler = sf "%s %s" C.nativecc C.nativecccompopts
let native_c_libraries = C.nativecclibs
let native_pack_linker = C.packld
let ranlib = C.ranlibcmd
let ar = C.arcmd
let cc_profile = C.cc_profile
let mkdll = C.mkdll
let mkexe = C.mkexe
let mkmaindll = C.mkmaindll

let exec_magic_number = "Caml1999X008"
and cmi_magic_number = "Caml1999I015"
and cmo_magic_number = "Caml1999O007"
and cma_magic_number = "Caml1999A008"
and cmx_magic_number = "Caml1999Y011"
and cmxa_magic_number = "Caml1999Z010"
and ast_impl_magic_number = "Caml1999M016"
and ast_intf_magic_number = "Caml1999N015"
and cmxs_magic_number = "Caml2007D001"
and cmt_magic_number = "Caml2012T002"

let load_path = ref ([] : string list)

let interface_suffix = ref ".mli"

let max_tag = 245
(* This is normally the same as in obj.ml, but we have to define it
   separately because it can differ when we're in the middle of a
   bootstrapping phase. *)
let lazy_tag = 246

let max_young_wosize = 256
let stack_threshold = 256 (* see byterun/config.h *)

let architecture = C.arch
let model = C.model
let system = C.system

let asm = C.asm
let asm_cfi_supported = C.asm_cfi_supported

let ext_obj = C.ext_obj
let ext_asm = C.ext_asm
let ext_lib = C.ext_lib
let ext_dll = C.ext_dll

let default_executable_name =
  match Sys.os_type with
    "Unix" -> "a.out"
  | "Win32" | "Cygwin" -> "camlprog.exe"
  | _ -> "camlprog"

let systhread_supported = C.systhread_support;;

let print_config oc =
  let p name valu = Printf.fprintf oc "%s: %s\n" name valu in
  let p_bool name valu = Printf.fprintf oc "%s: %B\n" name valu in
  p "version" version;
  p "standard_library_default" standard_library_default;
  p "standard_library" standard_library;
  p "standard_runtime" standard_runtime;
  p "ccomp_type" ccomp_type;
  p "bytecomp_c_compiler" bytecomp_c_compiler;
  p "bytecomp_c_libraries" bytecomp_c_libraries;
  p "native_c_compiler" native_c_compiler;
  p "native_c_libraries" native_c_libraries;
  p "native_pack_linker" native_pack_linker;
  p "ranlib" ranlib;
  p "cc_profile" cc_profile;
  p "architecture" architecture;
  p "model" model;
  p "system" system;
  p "asm" asm;
  p_bool "asm_cfi_supported" asm_cfi_supported;
  p "ext_obj" ext_obj;
  p "ext_asm" ext_asm;
  p "ext_lib" ext_lib;
  p "ext_dll" ext_dll;
  p "os_type" Sys.os_type;
  p "default_executable_name" default_executable_name;
  p_bool "systhread_supported" systhread_supported;
  p "exec_magic_number" exec_magic_number;
  p "cmi_magic_number" cmi_magic_number;
  p "cmo_magic_number" cmo_magic_number;
  p "cma_magic_number" cma_magic_number;
  p "cmx_magic_number" cmx_magic_number;
  p "cmxa_magic_number" cmxa_magic_number;
  p "ast_impl_magic_number" ast_impl_magic_number;
  p "ast_intf_magic_number" ast_intf_magic_number;
  p "cmxs_magic_number" cmxs_magic_number;
  p "cmt_magic_number" cmt_magic_number;

  flush oc;
;;

end;;
