open Gamestate
open Random
open Int64

(* TODO: implement this! This is just for setting up the game_state right now *)
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
  let piece_list =
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
  newplayer "comp" piece_list

(* 1 spy
2 scouts
1 Corporal
2 captains
1 major
1 flag
2 sergeants
3 bombs
1 marshall
1 colonel
2 miners
2 lieutenants
1 gen  *)

let rec choose_destination gamestate piece cur_location tried_locations =
  if List.length tried_locations < 4 then
    let up = (fst cur_location - 1, snd cur_location) in
    let end_dest =
      (if List.mem up tried_locations then
        let direction64 = Random.int64 (of_int 5) in
        let direction = to_int direction64 in
        (if direction <= 1 then
          (* Left *)
          (fst cur_location, snd cur_location + 1)
        else if direction <= 3 then
          (* Right *)
          (fst cur_location, snd cur_location - 1)
        else
          (* Down *)
          (fst cur_location + 1, snd cur_location)
        )
      else
        up
      )
      in
    (if List.mem end_dest tried_locations then
      choose_destination gamestate piece cur_location tried_locations
    else
      match  validate_move gamestate.gb gamestate.comp piece end_dest with
      | (false, _) -> choose_destination gamestate piece cur_location (end_dest::tried_locations)
      | (true, _) -> Some end_dest)
  else
    None


let choose_piece player movable_pieces  =
  if List.length movable_pieces > 0 then
    let index64 = Random.int64 (of_int (List.length movable_pieces)) in
    let index = to_int index64 in
    Printf.printf "piece index %d \n" index;
    let (pce_to_move, cur_location) = List.nth movable_pieces index in
    Some (pce_to_move, cur_location)
  else
    None

let rec next_move gamestate flag_locations recent_move tried_moves =
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
            next_move gamestate flag_locations recent_move (pce_to_move::tried_moves)
          | Some loc -> Some (pce_to_move, loc)))
    | Some (pce_to_move,cur_location) ->
      (* Move this piece until something happens with it *)
      (match choose_destination gamestate pce_to_move cur_location [] with
        | None -> next_move gamestate flag_locations None (pce_to_move::tried_moves)
        | Some loc -> Some (pce_to_move, loc))
  else
    (* No possible moves for any pieces, computer loses! *)
    None