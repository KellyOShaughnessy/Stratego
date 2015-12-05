open Gamestate

(* [setup game_board] takes the the pieces for the computer player
during initialization *)
val setup         : unit -> player

(* [next_move gamestate] takes a gamestate and returns a command
for the next move *)
val next_move     : gamestate -> location

(* Computer chooses its next move *)
val computer_move : game_board -> player -> (piece*location)
