type location = (int * int)

and piece = {pce:string; id:int;}

and player = {name: bytes; pieces : (piece*location) list;
  graveyard : piece list; won: bool}

(* Store each location on the game board and a (piece*player) option
  so that the value is None if the location is empty and
  Some(piece, player) if the position currently holds a piece *)
and game_board = (location*((piece*player) option)) list

and gamestate = {gb : game_board ; human : player; comp : player; turn: player}

(*get the rank of the piece during attack *)
val get_rank : piece -> int

(* creates a game_board with all locations initilized to None *)
val empty_game : unit -> game_board

(* Sets won of player to true *)
val playerwins : player -> player

(* creates a new player from a location list and the name type (comp or human) *)
val newplayer : bytes -> (piece*location) list -> player

(* Initializes game state from user input and computer generated setup *)
val making_game : player -> player -> game_board

val add_human: player -> player -> location -> piece -> game_board

(* Initializes game state from user input and computer generated setup *)
val new_gamestate : player -> player -> gamestate

(* Uses player assocation pieces record to get the location of a piece *)
val get_location : player -> piece -> location

(* Returns true if the move is valid for that piece,
* with Some piece if there is an opponent's piece at the end location
* Returns false if the move is not valid
* - [game_board] the current game state
* - [player] the current player
* - [piece] the piece to move
* - [location] the end location *)
val validate_move : game_board -> player -> piece -> location ->
    (bool*(piece option))

(* Returns the piece that "wins" the attack, or which piece will
* remain on the game board *)
val attack : piece -> piece -> player -> player -> ((piece*player) option)

val remove_from_board : game_board -> player -> piece -> location ->
  game_board*player

val add_to_board : game_board -> player -> piece -> location ->
  game_board*player

(* returns a new gamestate with updated piece locations
* - [gamestate] is the current gamestate to be updated
* - [player] is the current player
* - [piece] is the piece to try to move
* - [end_location] is the desired end location
* Calls get_location to get the current location of the pice
* Calls validate_move to verify that that piece can move to the end location
* If validate_move returns true with no piece,
*   update game state with the current piece
* If validate_move returns true with some piece,
*   calls attack function and updates board
* If validate_move returns false,
*   asks player to try a different move *)
val move : gamestate -> player -> piece -> location -> (bool*gamestate)

(* [print_game_board game_board] Prints the current game_board *)
val print_game_board : game_board -> unit

(* [piece_to_string piece] Converts the [piece] to the string representation *)
val piece_to_string : piece -> bytes

(* [piecelst_to_string piece] Converts a [piece list] to the string
   representation *)
val piecelst_to_string: piece list -> bytes

(* [print_gamestate gamestate]  *)
val print_gamestate : gamestate -> unit

