(* Gamestate mli *)

type location : char * int
type player : {pieces : (piece*location) list; graveyard : piece list}
type piece :
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

(* Using ocaml-matrix, make_matrix
* piece is the piece in that location with the string of the player,
* None if location is empty *)
type game_board : ((piece*string) option) array array

type gamestate : {gb : game_board ; human : player; comp : player; turn: string}

(* Initializes game state from user input and computer generated setup *)
val new_game : location option -> piece option -> gamestate -> gamestate

(* Computer chooses its next move *)
val computer_move : game_board -> player -> (piece*location)

(* Uses player assocation pieces record to get the location of a piece *)
val get_location : player -> piece -> location

(* Returns true if the move is valid for that piece, with Some piece if there is an opponent's piece at the end location
* Returns false if the move is not valid
* - [game_board] the current game state
* - [player] the current player
* - [piece] the piece to move
* - [location] the end location *)
val validate_move : game_board -> player -> piece -> location -> (boolean*(piece option))

(* Returns the piece that "wins" the attack, or which piece will remain on the game board *)
val attack : piece -> piece -> (piece option)

(* returns a new gamestate with updated piece locations
* - [gamestate] is the current gamestate to be updated
* - [player] is the current player
* - [piece] is the piece to try to move
* - [location] is the desired end location
* Calls get_location to get the current location of the pice
* Calls validate_move to verify that that piece can move to the end location
* If validate_move returns true with no piece, update game state with the current piece
* If validate_move returns true with some piece, calls attack function and updates board
* If validate_move returns false, asks player to try a different move *)
val move : gamestate -> player -> piece -> location -> gamestate

