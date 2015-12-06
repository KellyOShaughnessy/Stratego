open Gamestate
open Random
open Int64

(* [setup] selects one of four initial piece placements for the computer
* and returns the piece list *)
let setup () =
  let sp1 = {pce="Spy";id=1} in
  let sc1 = {pce="Scout";id=1} in
  let cap1 = {pce="Captain";id=1} in
  let maj1 = {pce="Major";id=1} in
  let f1 = {pce="Flag";id=1} in
  let ser1 = {pce="Sergeant";id=1} in
  let co1 = {pce="Colonel";id=1} in
  let mi1 = {pce="Miner";id=1} in
  let g1 = {pce="General";id=1} in
  let cap2 = {pce="Captain";id=2} in
  let mi2 = {pce="Miner";id=2} in
  let ma1 = {pce="Marshal";id=1} in
  let l1 = {pce="Lieutenant";id=1} in
  let b1 = {pce="Bomb";id=1} in
  let b2 = {pce="Bomb";id=2} in
  let b3 = {pce="Bomb";id=3} in
  let sc2 = {pce="Scout";id=2} in
  let l2 = {pce="Lieutenant";id=2} in
  let ser2 = {pce="Sergeant";id=2} in
  let cor1 = {pce="Corporal";id=1} in
  let piece_list_1 =
    [(sp1,(9,1));
    (sc1,(9,2));
    (cap1,(9,3));
    (maj1,(9,4));
    (f1,(9,5));
    (ser1,(9,6));
    (co1,(9,7));
    (mi1,(9,8));
    (g1,(9,9));
    (cap2,(9,10));
    (mi2,(10,1));
    (ma1,(10,2));
    (l1,(10,3));
    (b1,(10,4));
    (b2,(10,5));
    (b3,(10,6));
    (sc2,(10,7));
    (l2,(10,8));
    (ser2,(10,9));
    (cor1,(10,10))]
  in
  let piece_list_2 =
    [(cap1,(9,1));
    (b1, (9,2));
    (g1, (9,3));
    (b2, (9,4));
    (sp1,(9,5));
    (ser1,(9,6));
    (sc1,(9,7));
    (ma1,(9,8));
    (maj1,(9,9));
    (ser2,(9,10));
    (cap2,(10,1));
    (f1,(10,2));
    (l1,(10,3));
    (mi2,(10,4));
    (mi1,(10,5));
    (co1,(10,6));
    (sc2,(10,7));
    (b3,(10,8));
    (cor1,(10,9));
    (l2,(10,10))]
  in
  let piece_list_3 =
    [(g1, (9,1));
    (b3,(9,2));
    (sc1,(9,3));
    (maj1,(9,4));
    (sc2,(9,5));
    (ser2,(9,6));
    (cor1,(9,7));
    (b1, (9,8));
    (b2, (9,9));
    (ma1,(9,10));
    (cap2,(10,1));
    (f1,(10,2));
    (sp1,(10,3));
    (mi2,(10,4));
    (co1,(10,5));
    (l2,(10,6));
    (ser1,(10,7));
    (cap1,(10,8));
    (mi1,(10,9));
    (l1,(10,10));]
  in
  let piece_list_4 =
    [(cap1,(9,1));
    (b1, (9,2));
    (sp1,(9,3));
    (g1, (9,4));
    (b2, (9,5));
    (sc1,(9,6));
    (l1,(10,7));
    (maj1,(9,8));
    (ser2,(9,9));
    (cor1,(9,10));
    (ma1,(10,1));
    (cap2,(10,2));
    (f1,(10,3));
    (mi1,(10,4));
    (ser1,(9,5));
    (sc2,(10,6));
    (co1,(10,7));
    (b3,(10,8));
    (mi2,(10,9));
    (l2,(10,10))]
  in
  let rand = to_int(Random.int64 (of_int 4)) in
  let start_list =
    (if rand = 0 then
      piece_list_1
    else if rand = 1 then
      piece_list_2
    else if rand = 2 then
      piece_list_3
    else
      piece_list_4
    )
  in
  newplayer "comp" start_list

(* [opp_piece_exists gamestate end_dest] checks if there
* exists an opposing player's piece at the end destination *)
let opp_piece_exists gamestate end_dest =
  try
    (match List.assoc end_dest gamestate.gb with
    | None -> false
    | Some (piece,player) -> player.name = "human")
  with
  | Not_found -> false

(* [choose_destination gamestate piece cur_location tried_locations]
* returns: a location type option that is a valid move for the selected piece
* to move to. If that piece has no valid moves, returns None *)
let rec choose_destination gamestate piece cur_location tried_locations =
  if List.length tried_locations < 4 then
    let up = (fst cur_location - 1, snd cur_location) in
    let down = (fst cur_location + 1, snd cur_location) in
    let right = (fst cur_location, snd cur_location - 1) in
    let left = (fst cur_location, snd cur_location + 1) in

    let end_dest =
      (if opp_piece_exists gamestate up then
        up
      else if opp_piece_exists gamestate right then
        right
      else if opp_piece_exists gamestate left then
        left
      else if opp_piece_exists gamestate down then
        down
      else
        (if List.mem up tried_locations then
          let direction64 = Random.int64 (of_int 5) in
          let direction = to_int direction64 in
          (if direction <= 1 then
            left
          else if direction <= 3 then
            right
          else
            down
          )
        else
          up
        )
      )
      in
    Printf.printf "%d %d \n" (fst end_dest) (snd end_dest);
    (if List.mem end_dest tried_locations then
      choose_destination gamestate piece cur_location tried_locations
    else
      match  validate_move gamestate.gb gamestate.comp piece end_dest with
      | (false, _) ->
          choose_destination gamestate piece
            cur_location (end_dest::tried_locations)
      | (true, _) -> Some end_dest)
  else
    None

(* [choose_piece player movable_pieces] selects a movable piece from the
* list of pieces on the board for the computer and returns an option
* containing the piece to move and the location of that piece. If there
* is no possible piece to move, returns None *)
let choose_piece player movable_pieces  =
  if List.length movable_pieces > 0 then
    let index64 = Random.int64 (of_int (List.length movable_pieces)) in
    let index = to_int index64 in
    (*TODO: remove this print statement*)
    Printf.printf "piece index %d \n" index;
    let (pce_to_move, cur_location) = List.nth movable_pieces index in
    Some (pce_to_move, cur_location)
  else
    None

(* Returns true if this piece is on the board, false if not *)
let is_on_board gamestate piece loc =
  match List.assoc loc gamestate.gb with
  | None -> false
  | Some(pce,player) -> pce=piece && player.name="comp"

let get_opt opt =
  match opt with
  | None -> failwith "This should never happen, no gameboard exists"
  | Some g -> g

let rec next_move gs flag_locations recent_move tried_moves =
  let gamestate = get_opt gs in
  let movable_pieces =
    List.filter
      (fun (piece,_) -> piece.pce!="Bomb" && piece.pce!="Flag")
      gamestate.comp.pieces
  in
  if List.length tried_moves != List.length movable_pieces then
    match recent_move with
    | None ->
      (* random piece selection *)
      (match choose_piece gamestate.comp movable_pieces with
      | None -> None
        (* Can't move, computer loses! *)
      | Some(pce_to_move, cur_location) ->
        (match choose_destination gamestate pce_to_move cur_location [] with
          | None ->
            (* Piece is immovable, try again with new piece *)
            next_move (Some gamestate) flag_locations
              recent_move (pce_to_move::tried_moves)
          | Some loc -> Some (pce_to_move, loc)))
    | Some (pce_to_move,cur_location) ->
      if is_on_board gamestate pce_to_move cur_location then
        (* Move this piece until something happens with it *)
        (match choose_destination gamestate pce_to_move cur_location [] with
          | None ->
              next_move (Some gamestate) flag_locations None (pce_to_move::tried_moves)
          | Some loc -> Some (pce_to_move, loc))
      else
        next_move (Some gamestate) flag_locations None tried_moves
  else
    (* No possible moves for any pieces, computer loses! *)
    None