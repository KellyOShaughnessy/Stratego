open Gamestate
open Random
open Int64

(* [setup game_board] takes the the pieces for the computer player
during initialization *)
val setup         : unit -> player


(* [choose_destination gamestate piece] takes a gamestate and a piece
* and returns an end location for that piece *)
val choose_destination     : gamestate -> piece -> location -> location list -> location option

val choose_piece : player -> (piece*location) list -> (piece*location) option

(* [next_move gmae_board] *)
val next_move : gamestate -> location list -> ((piece*location) option) -> piece list -> ((piece*location) option)

