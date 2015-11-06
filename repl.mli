(* repl.mli:
    Facilitates interaction between the game and the user.
      - Parsing
      - Printing
 *)

(* Defining possible movement direction *)
type dir = Up | Down | Left | Right
(* Defining possible commands *)
and cmd =
  | Quit
  | NewGame
  | Help of str
  | Move of (dir*int)

(* Prompts user for next move *)
val prompt      : gamestate -> (dir * int)

(* print game *)
val print_game  : gamestate -> unit

(* print help menu *)
val print_help  : gamestate -> unit

(* processes the comand and initiates the chnge. Returns the new gamestate *)
val process     : gamestate -> cmd -> gamestate

(* returns a new game state *)
val new_game    : gamestate -> gamestate

(* returns the final gamestate and quits the game *)
val quit        : gamestate -> unit

