open Gamestate

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
  let sc3 = {pce="Scout";id=3} in
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
    (sc3,(10,10))]
  in
  newplayer "comp" piece_list

let next_move gamestate = failwith "unimplemented"

(* Computer chooses its next move *)
let computer_move  game_board player  = failwith "unimplemented"
