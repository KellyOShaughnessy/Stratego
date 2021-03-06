open Gamestate
open Repl

let sp1 = {pce="Spy";id=1}
let sc1 = {pce="Scout";id=1}
let cap1 = {pce="Captain";id=1}
let maj1 = {pce="Major";id=1}
let f1 = {pce="Flag";id=1}
let ser1 = {pce="Sergeant";id=1}
let co1 = {pce="Colonel";id=1}
let mi1 = {pce="Miner";id=1}
let g1 = {pce="General";id=1}
let cap2 = {pce="Captain";id=2}
let mi2 = {pce="Miner";id=2}
let ma1 = {pce="Marshal";id=1}
let l1 = {pce="Lieutenant";id=1}
let b1 = {pce="Bomb";id=1}
let b2 = {pce="Bomb";id=2}
let b3 = {pce="Bomb";id=3}
let sc2 = {pce="Scout";id=2}
let l2 = {pce="Lieutenant";id=2}
let ser2 = {pce="Sergeant";id=2}
let sc3 = {pce="Scout";id=3}

let human_list =
  [(sp1,(1,1));
  (sc1,(1,2));
  (cap1,(1,3));
  (maj1,(1,4));
  (f1,(1,5));
  (ser1,(1,6));
  (co1,(1,7));
  (mi2,(1,8));
  (g1,(1,9));
  (cap2,(1,10));
  (mi1,(2,1));
  (ma1,(2,2));
  (l1,(2,3));
  (b1,(2,4));
  (b2,(2,5));
  (b3,(2,6));
  (sc2,(2,7));
  (l2,(2,8));
  (ser2,(2,9));
  (sc3,(2,10))]

let computer_list =
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

let hum = {name= "human"; pieces = human_list; graveyard=[]; won = false}
let hum_gravyard = {name= "human"; pieces = human_list; graveyard=[ma1;mi2;l1]; won=false}
let computer = {name= "comp"; pieces = computer_list; graveyard=[]; won=false}

let game_board =
[
((10,1),Some (mi2, computer));
((10,2),Some (ma1, computer));
((10,3),Some (l1, computer));
((10,4),Some (b1, computer));
((10,5),Some (b2, computer));
((10,6),Some (b3, computer));
((10,7),Some (sc2, computer));
((10,8),Some (l2, computer));
((10,9),Some (ser2, computer));
((10,10),Some (sc3, computer));

((9,1),Some (sp1,computer));
((9,2),Some (sc3,computer));
((9,3),Some (cap1,computer));
((9,4),Some (maj1,computer));
((9,5),Some (f1,computer));
((9,6),Some (ser1,computer));
((9,7),Some (co1,computer));
((9,8),Some (mi1,computer));
((9,9),Some (g1,computer));
((9,10),Some (cap2,computer));

((8,1),None);
((8,2),None);
((8,3),None);
((8,4),None);
((8,5),None);
((8,6),None);
((8,7),None);
((8,8),None);
((8,9),None);
((8,10),None);

((7,1),None);
((7,2),None);
((7,3),None);
((7,4),None);
((7,5),None);
((7,6),None);
((7,7),None);
((7,8),None);
((7,9),None);
((7,10),None);

((6,1),None);
((6,2),None);
((6,3),None);
((6,4),None);
((6,5),None);
((6,6),None);
((6,7),None);
((6,8),None);
((6,9),None);
((6,10),None);

((5,1),None);
((5,2),None);
((5,3),None);
((5,4),None);
((5,5),None);
((5,6),None);
((5,7),None);
((5,8),None);
((5,9),None);
((5,10),None);

((4,1),None);
((4,2),None);
((4,3),None);
((4,4),None);
((4,5),None);
((4,6),None);
((4,7),None);
((4,8),None);
((4,9),None);
((4,10),None);

((3,1),None);
((3,2),None);
((3,3),None);
((3,4),None);
((3,5),None);
((3,6),None);
((3,7),None);
((3,8),None);
((3,9),None);
((3,10),None);

((2,1),Some (mi1, hum));
((2,2),Some (ma1, hum));
((2,3),Some (l1, hum));
((2,4),Some (b1, hum));
((2,5),Some (b2, hum));
((2,6),Some (b3, hum));
((2,7),Some (sc2, hum));
((2,8),Some (l2, hum));
((2,9),Some (ser2, hum));
((2,10),Some (sc3, hum));

((1,1),Some (sp1,hum));
((1,2),Some (sc1,hum));
((1,3),Some (cap1,hum));
((1,4),Some (maj1,hum));
((1,5),Some (f1,hum));
((1,6),Some (ser1,hum));
((1,7),Some (co1,hum));
((1,8),Some (mi2,hum));
((1,9),Some (g1,hum));
((1,10),Some (cap2,hum));
]

let gamestate_graveyard = {gb = game_board; human = hum_gravyard; comp = computer; turn = hum}
let gamestate = {gb = game_board; human = hum; comp = computer; turn = hum}

(* Test the print_help functions *)

(* TEST = print_help "help" gamestate = ()
TEST = print_help "instructions" gamestate = ()
TEST = print_help "pieces" gamestate = ()
TEST = print_help "graveyard" gamestate_graveyard = () *)

(* TODO: Test process functions *)

(* Test call of quit *)
(* TEST = process gamestate (Quit) = (false, ????) *)

(* Test call of new game *)
(* TEST = process gamestate (NewGame) = (true, ????) *)

(* Test call of help functions *)
(* TEST = process gamestate (Help "help") = (false, gamestate)
TEST = process gamestate (Help "instructions") = (false, gamestate)
TEST = process gamestate (Help "pieces") = (false, gamestate)
TEST = process gamestate (Help "graveyard") = (false, gamestate)
TEST = process gamestate (Help "board") = (false, gamestate) *)

(* Test call of move funciton *)
(* let (_, moved_gamestate) = move gamestate gamestate.human ser2 (3,9)
TEST = process gamestate (Move (ser2,(3,9))) = (true, moved_gamestate)

TEST = process gamestate (Move (ser2,(1,9))) = (false, gamestate) *)