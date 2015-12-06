open Gamestate
open Random
open Int64

(* [setup game_board] takes the the pieces for the computer player
during initialization *)
val setup : unit -> player


(* [choose_destination gamestate piece] takes a gamestate and a piece
* and returns an end location for that piece *)
val choose_destination  : gamestate -> piece -> location
  -> location list -> location option

val choose_piece : player -> (piece*location) list -> (piece*location) option

(* [next_move gamestate flag_locations recent_move tried_moves]
* returns a (piece*location) option for a piece to move and its desired
* location postcondition: piece to location must be a valid move
* - [gamestate] is the current gamestate
* - [flag_locations] is the list of locations that the computer thinks may
*   contain a flag
* - [recent_move] is piece that is most recently moved with its location
    AI will try to move this piece as far as possible
* - [tried_moves] is the list of pieces that we have tried to move. If this
*   equals the number of pieces that are movable by the computer on the board,
*   then there are no possible moves and we return None to signify that
*   the computer lost.  *)
val next_move : gamestate -> location list -> ((piece*location) option)
  -> piece list -> ((piece*location) option)

