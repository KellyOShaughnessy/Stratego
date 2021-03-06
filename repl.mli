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
  | QuickStart

(* [print_game gamestate] prints the gameboard.*)
val print_game  : gamestate -> unit

(* [prompt gamestate] prompts user for next move
 * - returns a tuple of the next direction and the amount of spaces to move
 * parses the input text and gives the command. *)
val parse       : string -> cmd

(* [new_game ()] returns a new, fresh gamestate/gameboard*)
val new_game    : unit -> gamestate

(* [quit gamestate] returns the final gamestate and quits the game *)
val quit_game       : gamestate option -> ((piece*location) option) -> unit

(* [print_help ()] prints the full help menu with all options.
 * contains all of the instructions and commands. a block of text*)
val print_help  : unit -> unit

(* [print_board gamestate] prints the gameboard as seen from the human's
 * perspective. *)
val print_board : gamestate -> unit

val print_pieces : gamestate -> unit

(* [print_instructions ()] prints the game instructions. A block of text*)
val print_instructions : unit -> unit

(* [process gamestate] processes the comand [cmd] and initiates the change.
* Returns the updated gamestate. calls all of the gamestate functions. *)
val process     : gamestate option -> ((piece*location) option) -> unit

