open Pervasives
(* Gamestate mli *)
type location = int * int
type piece = {pce:string ; id:int ; rank:int}
  (*| Flag
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
  | Corporal of int *)

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
let get_location player piece  = (2,7)

let on_gameboard (dest:location) : bool =
  if ((fst dest) <= 10 && (fst dest) >0 && (snd dest) <=10 && (snd dest) >0) then true
  else false

(*validates that the piece can move to the specified destination*)
let simple_validate (pl:player) (pc:piece) (dest:location) (gb:game_board) : bool =
  let loc = get_location pl pc in
  (*TODO need to take absolute value*)
  let xdist = fst dest - fst loc in
  let ydist = snd dest - snd loc in
  (*Check that only trying to move one space*)
  if ((abs xdist) >1 || (abs ydist) >1) || ((abs xdist) =1 && (abs ydist) =1) ||
    ((on_gameboard dest) =false) then false
  else
    let dest_piece = List.assoc dest gb in
      match dest_piece with
      | None -> true
      | Some(x,y)->
        if (y = pl) then false
        else true

let get_piece (dest:location) (gb:game_board) : piece option =
  let dest_tup = List.assoc dest gb in
      match dest_tup with
      |None -> None
      |Some(x,y) -> Some(x)

(*Check intermediate spaces if moving 2 spaces*)
let rec check_intermediate (gb:game_board) (pl:player) (dir:string) (loc:location)
                            (dest:location) : bool =
  if loc=dest then true
  else
    let new_loc = if dir = "up" then (fst loc, snd loc + 1) else
                  if dir = "down" then (fst loc, snd loc - 1) else
                  if dir = "right" then (fst dest +1, snd dest)
                  else (fst dest -1, snd dest) in
    let pc_tup = List.assoc new_loc gb in match pc_tup with
    |None -> check_intermediate gb pl dir new_loc dest
    |Some (x,y) ->
      if y=pl then false
      else check_intermediate gb pl dir new_loc dest

let captain_validate (pl:player) (pc:piece) (dest:location) (gb:game_board) : bool =
  let loc = get_location pl pc in
  (*TODO need to take absolute value?*)
  let xdist = fst dest - fst loc in
  let axd = abs xdist in
  let ydist = snd dest - snd loc in
  let ayd = abs ydist in
  (*Check that only trying to move two spaces*)
  if ((axd>2 || ayd>2) || (axd=1 && ayd<>0) || (axd=2 && ayd<>0)
    || (ayd=1 && axd<>0) || (axd=2 && ayd<>0) || on_gameboard dest =false)
     then false
  else
    (*get direction of movement*)
    let dir =
      if xdist=0 then (if min ydist 0 = ydist then "down" else "up")
      else (if min xdist 0 = xdist then "left" else "right") in
    let dest_piece = List.assoc dest gb in
      match dest_piece with
      | None -> check_intermediate gb pl dir loc dest
      | Some(x,y)->
        if (y = pl) then false
        else check_intermediate gb pl dir loc dest

let scout_validate (pl:player) (pc:piece) (dest:location) (gb:game_board) : bool =
  let loc = get_location pl pc in
  (*TODO need to take absolute value*)
  let xdist = fst dest - fst loc in
  let ydist = snd dest - snd loc in
  (*Check that only trying to move in one direction that is contained on board*)
  if ((xdist<>0 && ydist<>0) || on_gameboard dest =false)
    then false
  else
    (*get direction of movement as (dir,destination starting point)*)
    let dir =
      if xdist=0 then (if min ydist 0 = ydist then "down" else "up")
      else (if min xdist 0 = xdist then "left" else "right") in
    let dest_piece = List.assoc dest gb in
      match dest_piece with
      | None -> check_intermediate gb pl dir loc dest
      | Some(x,y)->
        if (y = pl) then false
        else check_intermediate gb pl dir loc dest

(* let loc_is_empty loc =
  if loc = None then true
  else false *)

let gb_is_empty (gb:game_board) : bool =
  if gb = [] then true
  else false

let player_is_empty (player:player) : bool =
  if player.name = "" || player.pieces = [] then true
  else false

(*Returns bool*(piece option) where the piece is the current piece at the
  destination location*)
let validate_move gb pl pc dest =
  (*check that no player, piece, game_board or location is empty *)
  if (gb_is_empty gb || player_is_empty pl) then
    (Printf.printf "Invalid move due to empty gameboard or player.";
    (false, None))
  else(
    let loc = get_location pl pc in
    if  loc = dest then (true, Some(pc)) else
    match pc.pce with
    (*All pieces can move one space in any direction unless otherwise specified.*)
    | "Flag" -> (false,None)
    | "Bomb" -> (false,None)
    | "Spy" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    (*Can move any number of empty spaces in a straight line. Not diagonally or
     *through occupied spaces.*)
    | "Scout" ->
      if scout_validate pl pc dest gb then (true,get_piece dest gb)
      else (false,None)
    | "Marshal" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | "General" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | "Miner" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | "Colonel" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | "Major" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    (*Can move up to 2 spaces; and can choose to attack on the first or second
     * move. If attacking on the first move, the turn is over and piece does
     * not move another square.*)
    | "Captain" ->
      if captain_validate pl pc dest gb then (true,get_piece dest gb)
      else (false,None)
    | "Lieutenant" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | "Sergeant" ->
      if (simple_validate pl pc dest gb) then (true,get_piece dest gb)
      else (false,None)
    | _ -> Printf.printf "Unrecognized piece name." ; (false,None)
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
  failwith "unimplemented"

let rec print_game_board (game_board:game_board)=
 failwith "unimplemented"

let print_gamestate (gamestate:gamestate) =
  failwith "unimplemented"



