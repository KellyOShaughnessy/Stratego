open Gamestate


(* Defining possible movement direction *)
type dir = Up | Down | Left | Right
(* Defining possible commands *)
and cmd =
  | Quit
  | NewGame
  | Help of bytes
  | Move of (dir*int)

let prompt gamestate = failwith "unimplemented"

let print_game gamestate = failwith "unimplemented"

let print_help gamestate = failwith "unimplemented"

let process gamestate cmd = failwith "unimplemented"

let new_game gamestate = failwith "unimplemented"

let quit gamestate = failwith "unimplemented"

