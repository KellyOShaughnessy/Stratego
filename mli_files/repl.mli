open Gamestate

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
  | Help of bytes
  | Move of (piece*dir*int)

(* [prompt gamestate] prompts user for next move
* - returns a tuple of the next direction and the amount of spaces to move *)
val prompt      : gamestate -> cmd

(* [print_game gamestate] prints the gameboard *)
val print_game  : gamestate -> unit

(* [print_help gamestate] prints the full help menu with all options *)
val print_help  : gamestate -> unit

(* [process gamestate] processes the comand [cmd] and initiates the change.
* Returns the updated gamestate *)
val process     : gamestate -> cmd -> gamestate

(* [new_game gamestate] returns a new, fresh gamestate *)
val new_game    : gamestate -> gamestate

(* [quit gamestate] returns the final gamestate and quits the game *)
val quit        : gamestate -> unit

