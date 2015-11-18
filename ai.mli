open Gamestate
open Repl

(* [setup game_board] takes the the pieces for the computer player
during initialization *)
val setup         : game_board -> (game_board * player)

(* [next_move gamestate] takes a gamestate and returns a command
for the next move *)
val next_move     : gamestate -> (dir * int)

(* Computer chooses its next move *)
val computer_move : game_board -> player -> (piece*location)
