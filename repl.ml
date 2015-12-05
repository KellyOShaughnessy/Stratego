open Gamestate
(* NOTE: WHEN COMPILING, USE 'cs3110 compile -p str repl.ml' *)

(* Defining possible commands *)
type cmd =
  | Quit
  | NewGame
  | Help
  | Move of (piece*location)
  | Place of (piece*location)
  | Invalid

(*We should have a start function where it prints the directions and then
 *starts prompt.*)
(*Could also have functions that print*)
let fix_input (inp:string) : string list =
  (*lowercase & get rid of extraneous characters*)
  let input_lower = String.lowercase inp in
  let input_better = Str.global_replace (Str.regexp "[^0-9a-zA-Z ]+") "" input_lower in
  (*splits into list*)
  let regex = Str.regexp " +" in
  let ret_list = Str.split regex input_better in
  ret_list

let rec parse () =
  print_string "\n\nPlease type a command -->";
  let input = fix_input (read_line()) in
  let fst_cmd = List.nth input 0 in
  (* Extracting cmd type from input *)
  let cmd = (
    if (fst_cmd = "quit" || fst_cmd = "q" || fst_cmd = "exit") then Quit
    else if (fst_cmd = "new game" || fst_cmd = "ng") then NewGame
    else if (fst_cmd = "help" || fst_cmd = "h") then Help
    else if (fst_cmd = "move" || fst_cmd = "m") then
        failwith "unimplemented"
    else if (fst_cmd = "place" || fst_cmd =  "p" || fst_cmd = "put") then
        failwith "unimplemented"
    else let () = print_string "\n\nWhat was that again?" in Invalid
    ) in
  match cmd with
  | Invalid -> parse ()
  | _ -> cmd

let print_game gamestate = failwith "unimplemented"

let print_help gamestate = failwith "unimplemented"

let process gamestate cmd = failwith "unimplemented"

let new_game gamestate = failwith "unimplemented"

let quit gamestate = failwith "unimplemented"
