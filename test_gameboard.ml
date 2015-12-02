open Gamestate

let human_list =
  [({pce="Spy";id=1;rank=1},(1,1));
  ({pce="Scout";id=1;rank=2},(1,2));
  ({pce="Captain";id=1;rank=3},(1,3));
  (({pce="Major";id=1;rank=4}),(1,4));
  (({pce="Flag";id=1;rank=0}),(1,5));
  (({pce="Sergeant";id=1;rank=5}),(1,6));
  ({pce="Colonel";id=1;rank=6},(1,7));
  (({pce="Miner";id=1;rank=2}),(1,8));
  (({pce="General";id=1;rank=7}),(1,9));
  (({pce="Captain";id=2;rank=8}),(1,10));
  (({pce="Miner";id=2;rank=2}),(2,1));
  (({pce="Marshal";id=1;rank=9}),(2,2));
  (({pce="Lieutenant";id=1;rank=6}),(2,3));
  (({pce="Bomb";id=1;rank=0}),(2,4));
  (({pce="Bomb";id=2;rank=0}),(2,5));
  (({pce="Bomb";id=3;rank=0}),(2,6));
  ({pce="Scout";id=2;rank=2},(2,7));
  (({pce="Lieutenant";id=2;rank=6}),(2,8));
  (({pce="Sergeant";id=2;rank=5}),(2,9));
  ({pce="Scout";id=3;rank=2},(2,10))]

let computer_list =
  [({pce="Spy";id=1;rank=1},(9,1));
  ({pce="Scout";id=1;rank=2},(9,2));
  ({pce="Captain";id=1;rank=3},(9,3));
  (({pce="Major";id=1;rank=4}),(9,3));
  (({pce="Flag";id=1;rank=0}),(9,5));
  (({pce="Sergeant";id=1;rank=5}),(9,6));
  ({pce="Colonel";id=1;rank=6},(9,7));
  (({pce="Miner";id=1;rank=2}),(9,8));
  (({pce="General";id=1;rank=7}),(9,9));
  (({pce="Captain";id=2;rank=8}),(9,10));
  (({pce="Miner";id=2;rank=2}),(10,1));
  (({pce="Marshal";id=1;rank=9}),(10,2));
  (({pce="Lieutenant";id=1;rank=6}),(10,3));
  (({pce="Bomb";id=1;rank=0}),(10,4));
  (({pce="Bomb";id=2;rank=0}),(10,5));
  (({pce="Bomb";id=3;rank=0}),(10,6));
  ({pce="Scout";id=2;rank=2},(10,7));
  (({pce="Lieutenant";id=2;rank=6}),(10,8));
  (({pce="Sergeant";id=2;rank=5}),(10,9));
  ({pce="Scout";id=3;rank=2},(10,10))]

let hum = {name= "human"; pieces = human_list; graveyard=[]}
let computer = {name= "comp"; pieces = computer_list; graveyard=[]}

let game_board =
[
((10,1),Some ({pce="Miner";id=1;rank=2}, computer));
((10,2),Some ({pce="Marshal";id=1;rank=9}, computer));
((10,3),Some ({pce="Lieutenant";id=1;rank=6}, computer));
((10,4),Some ({pce="Bomb";id=1;rank=0}, computer));
((10,5),Some ({pce="Bomb";id=2;rank=0}, computer));
((10,6),Some ({pce="Bomb";id=3;rank=0}, computer));
((10,7),Some ({pce="Scout";id=1;rank=2}, computer));
((10,8),Some ({pce="Lieutenant";id=2;rank=6}, computer));
((10,9),Some ({pce="Sergeant";id=1;rank=5}, computer));
((10,10),Some ({pce="Scout";id=2;rank=2}, computer));

((9,1),Some ({pce="Spy";id=1;rank=1},computer));
((9,2),Some ({pce="Scout";id=3;rank=2},computer));
((9,3),Some ({pce="Captain";id=1;rank=8},computer));
((9,4),Some ({pce="Major";id=1;rank=4},computer));
((9,5),Some ({pce="Flag";id=1;rank=0},computer));
((9,6),Some ({pce="Sergeant";id=2;rank=5},computer));
((9,7),Some ({pce="Colonel";id=1;rank=6},computer));
((9,8),Some ({pce="Miner";id=2;rank=2},computer));
((9,9),Some ({pce="General";id=1;rank=7},computer));
((9,10),Some ({pce="Captain";id=2;rank=8},computer));

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

((2,1),Some ({pce="Miner";id=1;rank=2}, hum));
((2,2),Some ({pce="Marshal";id=1;rank=9}, hum));
((2,3),Some ({pce="Lieutenant";id=1;rank=6}, hum));
((2,4),Some ({pce="Bomb";id=1;rank=0}, hum));
((2,5),Some ({pce="Bomb";id=2;rank=0}, hum));
((2,6),Some ({pce="Bomb";id=3;rank=0}, hum));
((2,7),Some ({pce="Scout";id=1;rank=2}, hum));
((2,8),Some ({pce="Lieutenant";id=2;rank=6}, hum));
((2,9),Some ({pce="Sergeant";id=1;rank=5}, hum));
((2,10),Some ({pce="Scout";id=2;rank=2}, hum));

((1,1),Some ({pce="Spy";id=1;rank=1},hum));
((1,2),Some ({pce="Scout";id=3;rank=2},hum));
((1,3),Some ({pce="Captain";id=1;rank=8},hum));
((1,4),Some ({pce="Major";id=1;rank=4},hum));
((1,5),Some ({pce="Flag";id=1;rank=0},hum));
((1,6),Some ({pce="Sergeant";id=2;rank=5},hum));
((1,7),Some ({pce="Colonel";id=1;rank=6},hum));
((1,8),Some ({pce="Miner";id=2;rank=2},hum));
((1,9),Some ({pce="General";id=1;rank=7},hum));
((1,10),Some ({pce="Captain";id=2;rank=8},hum));
]

(* -------------------------TESTING VALIDATE_MOVE---------------------------- *)
(*TODO CANNOT COMPLETE TESTING UNTIL GET LOCATION IS DONE*)
let sp1 = {pce="Spy";id=1;rank=1}
let sc1 = {pce="Scout";id=1;rank=2}
let cap1 = {pce="Captain";id=1;rank=3}
let maj1 = {pce="Major";id=1;rank=4}
let f1 = {pce="Flag";id=1;rank=0}
let ser1 = {pce="Sergeant";id=1;rank=5}
let co1 = {pce="Colonel";id=1;rank=6}
let mi1 = {pce="Miner";id=1;rank=2}
let g1 = {pce="General";id=1;rank=7}
let cap2 = {pce="Captain";id=2;rank=8}
let mi2 = {pce="Miner";id=2;rank=2}
let ma1 = {pce="Marshal";id=1;rank=9}
let l1 = {pce="Lieutenant";id=1;rank=6}
let b1 = {pce="Bomb";id=1;rank=0}
let b2 = {pce="Bomb";id=2;rank=0}
let b3 = {pce="Bomb";id=3;rank=0}
let sc2 = {pce="Scout";id=2;rank=2}
let l2 = {pce="Lieutenant";id=2;rank=6}
let ser2 = {pce="Sergeant";id=2;rank=5}
let sc3 = {pce="Scout";id=3;rank=2}

(* Tests that Bomb and Flag cannot move *)
TEST = (validate_move game_board hum b1 (2,5)) = (false,None)
TEST = (validate_move game_board hum b2 (2,7)) = (false,None)
TEST = (validate_move game_board hum f1 (3,1)) = (false,None)

(* Tests that piece can "move" to its current location [if not bomb/flag] *)
TEST "no-move" = (validate_move game_board hum sp1 (1,1)) = (true,Some(sp1))
TEST "no-move" = (validate_move game_board hum sc1 (2,7)) = (true,Some(sc1))
TEST "no-move" = (validate_move game_board hum sc2 (2,10)) = (true,Some(sc2))
TEST "no-move" = (validate_move game_board hum cap1 (1,3)) = (true,Some(cap1))
TEST "no-move" = (validate_move game_board hum cap2 (1,10)) = (true,Some(cap2))

(* Tests that Spy, Marshal, General, Miner, Colonel, Major, Lieutenant, Sergeant
 * cannot move more than one square *)
TEST "big move" = (validate_move game_board hum sp1 (2,2)) = (false,None)
TEST "big move" = (validate_move game_board hum ma1 (3,4)) = (false,None)
TEST "big move" = (validate_move game_board hum g1 (3,9)) = (false,None)
TEST "big move" = (validate_move game_board hum mi2 (1,9)) = (false,None)
TEST "big move" = (validate_move game_board hum mi1 (2,1)) = (false,None)
TEST "big move" = (validate_move game_board hum co1 (2,8)) = (false,None)
TEST "big move" = (validate_move game_board hum maj1 (0,0)) = (false,None)
TEST "big move" = (validate_move game_board hum l1 (3,8)) = (false,None)
TEST "big move" = (validate_move game_board hum ser2 (1,9)) = (false,None)

(* Tests that Scout can move up to as many squares that the size of the game board
 * allows. *)
(*Move off gameboard -> false*)
TEST "Scout" = (validate_move game_board hum sc1 (10,11)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc2 (11,10)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc3 (9,14)) = (false,None)
(*Move in multiple directions -> false*)
TEST "Scout" = (validate_move game_board hum sc1 (3,8)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (4,9)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (10,8)) = (false,None)

TEST "Scout" = (validate_move game_board hum sc1 (2,8)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (2,9)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (3,7)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc1 (4,7)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc1 (2,8)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (10,7)) = (false,Some(sc1))
TEST "Scout" = (validate_move game_board hum sc1 (9,7)) = (true,Some(co1))
TEST "Scout" = (validate_move game_board hum sc1 (8,7)) = (false,None)

(* Tests that Captain can move up to two squares in the same direction *)
(*TODO: cannot test successus until captain has moved*)
TEST "Captain" = (validate_move game_board hum cap1 (1,5)) = (false,None)
TEST "Captain" = (validate_move game_board hum cap2 (3,3)) = (false,None)
TEST "Captain" = (validate_move game_board hum cap1 (1,4)) = (false,None)
TEST "Captain" = (validate_move game_board hum cap2 (2,3)) = (false,None)

(* Tests that piece can move when destination piece is empty *)

(* Tests that piece can move when destination piece contains opponents piece *)

(* Tests that piece cannot move when destination piece contains own piece *)

(* Tests that piece cannot move when destination piece is empty but
 * intermediate pieces are non-empty [for scout and captain] *)

(* Tests that piece cannot move when destination piece contains opponent's piece
 * but intermediate pieces are non-empty [for scout and captain] *)


(*-----------------------------Robyn Testing----------------------------------*)
(* TEST =  (print_game_board game_board) = () *)
(* let gamestate = {gb=game_board; human=hum; comp=computer; turn=hum} *)

(* Tests that we got rid of the right piece from human pieces list *)
let miner1 = {pce="Miner";id=1;rank=2}
let miner2 = {pce="Miner";id=2;rank=2}

let (new_gb1,hum1) = (remove_from_board game_board hum miner1 (1,8))
TEST = (try List.assoc miner1 hum1.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (List.assoc miner2 hum1.pieces) = (2,1)
TEST = (List.mem miner1 hum1.graveyard) = true
TEST = List.assoc (1,8) new_gb1 = None

let (new_gb2, hum2) = (remove_from_board new_gb1 hum1 miner2 (2,1))
TEST = (try List.assoc miner2 hum2.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (List.mem miner2 hum2.graveyard) = true
TEST = List.assoc (2,1) new_gb2 = None

(* Test add_to_board *)
let (new_gb3, hum3) = (add_to_board new_gb1 hum2 miner1 (1,8))
TEST = (List.assoc miner1 hum3.pieces) = (1,8)
TEST = (List.mem miner1 hum3.graveyard) = false
TEST = (List.mem miner2 hum3.graveyard) = true

(* tests that the game board references the piece and the new player *)
TEST = (List.assoc (1,8) new_gb3) = Some (miner1, hum3)
TEST = (List.assoc (2,2) new_gb3) = Some ({pce="Marshal";id=1;rank=9}, hum3)

let (new_gb4, hum4) = (add_to_board new_gb2 hum3 miner2 (2,1))
TEST = (List.assoc miner2 hum4.pieces) = (2,1)
TEST = (List.mem miner1 hum4.graveyard) = false
TEST = (List.mem miner2 hum4.graveyard) = false
TEST = List.assoc (2,1) new_gb4 = Some(miner2,hum4)

let () = Pa_ounit_lib.Runtime.summarize()