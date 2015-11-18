(* Gamestate mli *)
type location = char * int
type piece =
  | Flag
  | Bomb
  | Spy of int
  | Scout of int
  | Marshal of int
  | General of int
  | Miner of int
  | Colonel of int
  | Major of int
  | Captain of int
  | Lieutenant of int
  | Sergeant of int
  | Corporal of int

and player = {pieces: (piece*location) list; graveyard: piece list}

(*function that gets rank of the piece so that in attack, it can match on the rankings.
get_rank keep in mind flag and bomb*)

(* piece is the piece in that location with the string of the player,
* None if location is empty *)
and game_board = (location*((piece*player) option)) list

and gamestate = {gb: game_board ; human: player; comp: player; turn: string}

(* Initializes game state from user input and computer generated setup *)
let new_game location piece gamestate  = failwith "unimplemented"

(* Uses player assocation pieces record to get the location of a piece 
get location. try with, and check if that piece is in the player's piece to chekc 
if my piece is actually on the board.*)
let get_location  player  piece  = failwith "unimplemented"

let validate_move game_board player piece location = failwith "unimplemented"

(*check if its a flag or bomb before i call get_rank. 
if bomb && miner, then miner moves to that piece and bomb leaves
otherwise piece leaves and bomb leaves too.
and then the three cases of rankings. if flag, then win the game.

piece1 is my piece
piece2 is the piece that was on the tile. *)
let attack piece1 piece2 = failwith "unimplemented"

let move gamestate player piece location = failwith "unimplemented"

