(* $Id$
 * ----------------------------------------------------------------------
 *
 *)

let config_file = "/usr/local/etc/findlib.conf";;

let ocaml_stdlib = "/usr/local/lib/ocaml";;

let ocaml_ldconf = Filename.concat ocaml_stdlib "ld.conf";;

let ocaml_has_autolinking = true;;

let libexec_name = "stublibs";;

let system = "linux_elf";;
(* - "mingw", "mingw64", "win32", "cygwin", "linux_elf", ... *)

let dll_suffix =
  match Sys.os_type with
      "Unix" -> ".so"
    | "Win32" -> ".dll"
    | "Cygwin" -> ".dll"
    | "MacOS" -> ""        (* don't know *)
    | _ -> failwith "Unknown Sys.os_type"
;;
