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


(* Using ocaml-matrix, make_matrix
* piece is the piece in that location with the string of the player,
* None if location is empty *)
and game_board = ((piece*string) option) array array

and gamestate = {gb: game_board ; human: player; comp: player; turn: string}

(* Initializes game state from user input and computer generated setup *)
let new_game location piece gamestate  = failwith "unimplemented"

(* Computer chooses its next move *)
let computer_move  game_board player  = failwith "unimplemented"

(* Uses player assocation pieces record to get the location of a piece *)
let get_location  player  piece  = failwith "unimplemented"

let validate_move game_board player piece location = failwith "unimplemented"

let attack piece1 piece2 = failwith "unimplemented"

let move gamestate player piece location = failwith "unimplemented"

