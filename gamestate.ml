(* Gamestate mli *)
type location = int * int
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

and player = {name: bytes; pieces: (piece*location) list; graveyard: piece list}

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
let get_location player piece  = failwith "unimplemented"

(*validates that the piece can move to the specified destination*)
let simple_validate pl pc dest gb =
  let loc = get_location pl pc in
    match loc,dest with
    | (x1,y1),(x2,y2) -> (
    (*TODO need to take absolute value*)
      let xdist = x2-x1 in
      let ydist = y2-y1 in
      (*Check that only trying to move one space*)
      if (xdist>1 || ydist>1) || (xdist=1 && ydist=1) then false
      else
        let dest_piece = List.assoc dest gb in
          match dest_piece with
          | None -> true
          | Some(x,y)->
            if (y = pl) then false
            else true
          )
    | _ -> false

let captain_validate pl pc dest gb =
  failwith "unimplemented"

let scout_validate pl pc dest gb =
  failwith "unimplemented"

let get_piece dest gb =
  let dest_tup = List.assoc dest gb in
      match dest_tup with
      |None -> None
      |Some(x,y) -> Some(x)

let loc_is_empty loc =
  if loc = None then true
  else false

let gb_is_empty gb =
  if gb = [] then true
  else false

let player_is_empty player =
  if player.name = "" || player.pieces = [] then true
  else false

(*Returns bool*(piece option) where the piece is the current piece at the
  destination location*)
let validate_move gb pl pc dest =
  (*check that no player, piece, game_board or location is empty *)
  if (gb_is_empty gb || player_is_empty pl || loc_is_empty dest) then
    (Printf.printf "Invalid move due to empty gameboard, player, or destination";
    (false, None))
  else(
    match pc with
    (*All pieces can move one space in any direction unless otherwise specified.*)
    | Flag -> (false,None)
    | Bomb -> (false,None)
    | Spy r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    (*Can move any number of empty spaces in a straight line. Not diagonally or
     *through occupied spaces.*)
    | Scout r ->
      if scout_validate player piece dest gb then (true,get_piece dest gb)
      else (false,None)
    | Marshal r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | General r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | Miner r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | Colonel r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | Major r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    (*Can move up to 2 spaces; and can choose to attack on the first or second
     * move. If attacking on the first move, the turn is over and piece does
     * not move another square.*)
    | Captain r ->
      if captain_validate player piece dest gb then (true,get_piece dest gb)
      else (false,None)
    | Lieutenant r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | Sergeant r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | Corporal r ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | _ ->
      Printf.printf "Invalid move due to invalid piece type." ;
      (false,None)
    )

(*check if its a flag or bomb before i call get_rank.
if bomb && miner, then miner moves to that piece and bomb leaves
otherwise piece leaves and bomb leaves too.
and then the three cases of rankings. if flag, then win the game.

piece1 is my piece
piece2 is the piece that was on the tile. *)
let attack piece1 piece2 = failwith "unimplemented"

let move gamestate player piece location = failwith "unimplemented"

let piece_to_string (piece:piece) =
  match piece with
  | Flag -> "Fla"
  | Bomb -> "Bom"
  | Spy x -> "Spy"
  | Scout x -> "Sco"
  | Marshal x -> "Mar"
  | General x -> "Gen"
  | Miner x -> "Min"
  | Colonel x -> "Col"
  | Major x -> "Maj"
  | Captain x -> "Cap"
  | Lieutenant x -> "Lie"
  | Sergeant x -> "Ser"
  | Corporal x -> "Cor"

let rec print_game_board (game_board:game_board)=
  match game_board with
  | [] -> ()
  | ((col,row),some_piece)::t ->
    let s1 =
      (match some_piece with
      | None -> "   "
      | Some (piece,player) ->
          if player.name="human" then
            (piece_to_string piece)
          else
            "XXX")
    in
    let s2 =
      (if col=1 && row!=10 then
        "     "^
        "-------------------------------------------------------------\n  "^
        (string_of_int row)^"  | "^s1^" |"
      else if col=1 && row=10 then
        "     "^
        "-------------------------------------------------------------\n "^
        (string_of_int row)^"  | "^s1^" |"
      else if col=10 then
        " "^s1^" |\n"
      else
        " "^s1^" |")
    in
    let s3 =
      (if row=1 && col=10 then
        s2^
        "     -------------------------------------------------------------\n"
      else
        s2
      )
    in
    Printf.printf "%s" s3;
    print_game_board t

let print_gamestate (gamestate:gamestate) =
  print_game_board gamestate.gb;
  Printf.printf
    "        1     2     3     4     5     6     7     8     9    10\n\n";



