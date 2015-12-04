open Gamestate
(* repl.mli:
    Facilitates interaction between the game and the user.
      - Parsing
      - Printing
 *)

(* Defining possible movement direction *)
(* type dir = Up | Down | Left | Right *)

(* Defining possible commands *)
type cmd =
  | Quit
  | NewGame
  | Help of bytes
  | Move of (piece*location)

(* [prompt gamestate] prompts user for next move
 * - returns a tuple of the next direction and the amount of spaces to move
 * parses the input text and gives the command. *)
val prompt      : gamestate -> cmd

(* [print_game gamestate] prints the gameboard.*)
val print_game  : gamestate -> unit

(* [print_help gamestate] prints the full help menu with all options.
 * contains all of the instructions and commands. a block of text*)
val print_help  : bytes -> gamestate -> unit

(* [process gamestate] processes the comand [cmd] and initiates the change.
* Returns the updated gamestate. calls all of the gamestate functions. *)
val process     : gamestate -> cmd -> bool*gamestate

(* [new_game gamestate] returns a new, fresh gamestate/gameboard*)
val new_game    : unit -> bool*gamestate

(* [quit gamestate] returns the final gamestate and quits the game *)
val quit        : gamestate -> unit

