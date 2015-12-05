open Gamestate

(* [setup game_board] takes the the pieces for the computer player
during initialization *)
val setup         : unit -> player

(* [choose_destination] takes a gamestate and returns a command
for the next move. validate move will take this in*)
val choose_destination     : gamestate -> piece -> location

(* Computer chooses its next move *)
val computer_move : game_board -> (piece*location)

