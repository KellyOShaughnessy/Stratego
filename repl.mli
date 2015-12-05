open Gamestate

(* repl.mli:
    Facilitates interaction between the game and the user.
      - Parsing
      - Printing
 *)

(* Defining possible commands *)
type cmd =
  | Quit
  | NewGame
  | Help
  | Move of (piece*location)
  | Place of (piece*location)
  | Invalid
  | Pieces
  | Graveyard
  | Board
  | Instructions

(* [parse ()] prompts user for next command and parses the input and
 * returns the appropriate command. *)
val parse       : string -> cmd

(* [quit gamestate] returns the final gamestate and quits the game *)
val quit        : gamestate -> unit

(* [print_game gamestate] prints the gameboard.*)
val print_game  : gamestate -> unit

(* [print_help gamestate] prints the full help menu with all options.
 * contains all of the instructions and commands. a block of text*)
val print_help  : unit -> unit

(* [process gamestate] processes the comand [cmd] and initiates the change.
* Returns the updated gamestate. calls all of the gamestate functions. *)
val process     : gamestate -> bool*gamestate

(* [new_game gamestate] returns a new, fresh gamestate/gameboard*)
val new_game    : unit -> gamestate
