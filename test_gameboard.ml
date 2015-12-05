open Gamestate

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


let hum = {name= "human"; pieces = human_list; graveyard=[]; won=false}
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
((9,2),Some (sc1,computer));
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

let empty_game_board =
[
((10,1),None);
((10,2),None);
((10,3),None);
((10,4),None);
((10,5),None);
((10,6),None);
((10,7),None);
((10,8),None);
((10,9),None);
((10,10),None);

((9,1), None);
((9,2),None);
((9,3),None);
((9,4),None);
((9,5),None);
((9,6),None);
((9,7),None);
((9,8),None);
((9,9),None);
((9,10),None);

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

((2,1),None);
((2,2),None);
((2,3),None);
((2,4),None);
((2,5),None);
((2,6),None);
((2,7),None);
((2,8),None);
((2,9),None);
((2,10),None);

((1,1),None);
((1,2),None);
((1,3),None);
((1,4),None);
((1,5),None);
((1,6),None);
((1,7),None);
((1,8), None);
((1,9),None);
((1,10),None);
]
(* -------------------------TESTING VALIDATE_MOVE---------------------------- *)
(*TODO CANNOT COMPLETE TESTING UNTIL GET LOCATION IS DONE*)

(* Test completely empty game *)
TEST "empty_game" = empty_game () = empty_game_board

(* Test newplayer from (piece*option) list *)
TEST "newhumanplayer" = (newplayer "human" human_list) = hum
TEST "newcomplayer" = (newplayer "comp" computer_list) = computer

(* Tests generating game board from two players *)
TEST "building game_board" = (making_game hum computer) = game_board

(* Testing adding a piece to the human list *)
TEST "add_human" = (
  let piece = {pce= "Spy"; id = 2} in
  let newboard = add_human hum computer (3,1) piece in
  List.assoc (3,1) newboard
  ) = Some({pce= "Spy"; id = 2}, {hum with
    pieces=hum.pieces@[({pce= "Spy"; id = 2},(3,1))]})

(* Testing new game state *)
TEST "new_gamestate" = new_gamestate hum computer =
  {gb= game_board; human = hum; comp = computer; turn=hum}

(* Tests that Bomb and Flag cannot move *)
TEST = (validate_move game_board hum b1 (2,5)) = (false,None)
TEST = (validate_move game_board hum b2 (2,7)) = (false,None)
TEST = (validate_move game_board hum f1 (3,1)) = (false,None)

(* Tests that piece can "move" to its current location [if not bomb/flag] *)
TEST "no-move" = (validate_move game_board hum sp1 (1,1)) = (true,Some(sp1))
TEST "no-move" = (validate_move game_board hum sc1 (1,2)) = (true,Some(sc1))
TEST "no-move" = (validate_move game_board hum sc2 (2,7)) = (true,Some(sc2))
TEST "no-move" = (validate_move game_board hum cap1 (1,3)) = (true,Some(cap1))
TEST "no-move" = (validate_move game_board hum cap2 (1,10)) = (true,Some(cap2))

(* Tests that Spy, Marshal, General, Miner, Colonel, Major, Lieutenant, Sergeant
 * cannot move more than one square *)
TEST "big move" = (validate_move game_board hum sp1 (2,2)) = (false,None)
TEST "big move" = (validate_move game_board hum ma1 (3,4)) = (false,None)
TEST "big move" = (validate_move game_board hum g1 (3,9)) = (false,None)
TEST "big move" = (validate_move game_board hum mi2 (1,9)) = (false,None)
TEST "big move" = (validate_move game_board hum mi1 (4,1)) = (false,None)
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
(*Scount cannot jump other pieces*)
TEST "Scout" = (validate_move game_board hum sc1 (2,8)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (2,9)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (3,7)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (4,7)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (2,8)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (10,7)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (9,7)) = (false,None)
TEST "Scout" = (validate_move game_board hum sc1 (8,7)) = (false,None)
(*Testing legitimate Scount moves*)
TEST "Scout" = (validate_move game_board hum sc3 (3,10)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc3 (4,10)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc3 (5,10)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc3 (6,10)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc3 (7,10)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc3 (8,10)) = (true,None)
TEST "Scout" = (validate_move game_board hum sc3 (9,10)) = (true,Some(cap2))

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


(* Tests that we got rid of the right piece from human pieces list *)

let (new_gb1,hum1) = (remove_from_board game_board hum mi2 (1,8))
TEST = (try List.assoc mi2 hum1.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (List.assoc mi1 hum1.pieces) = (2,1)
TEST = (List.mem mi2 hum1.graveyard) = true
TEST = List.assoc (1,8) new_gb1 = None

let (new_gb2, hum2) = (remove_from_board new_gb1 hum1 mi2 (2,1))
TEST = (try List.assoc mi2 hum2.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (List.mem mi2 hum2.graveyard) = true
TEST = List.assoc (2,1) new_gb2 = None

(* Test add_to_board *)
let (new_gb3, hum3) = (add_to_board new_gb1 hum2 mi1 (1,8))
TEST = (List.assoc mi1 hum3.pieces) = (1,8)
TEST = (List.mem mi1 hum3.graveyard) = false
TEST = (List.mem mi2 hum3.graveyard) = true

(* tests that the game board references the piece and the new player *)
TEST = (List.assoc (1,8) new_gb3) = Some (mi1, hum3)
TEST = (List.assoc (2,2) new_gb3) = Some (ma1, hum3)

let (new_gb4, hum4) = (add_to_board new_gb2 hum3 mi1 (2,1))
TEST = (List.assoc mi1 hum4.pieces) = (2,1)
TEST = (List.mem mi1 hum4.graveyard) = false
TEST = (List.mem mi1 hum4.graveyard) = false
TEST = List.assoc (2,1) new_gb4 = Some(mi1,hum4)

(* test move *)

(* TEST =  (print_game_board game_board) = () *)

(* Tests that we can move and update properly up *)
let gamestate = {gb=game_board; human=hum; comp=computer; turn=hum}
let (_, new_gamestate1) = move gamestate gamestate.human mi1 (3,1)
TEST = (List.assoc (2,1) new_gamestate1.gb) = None
TEST = (List.assoc (3,1) new_gamestate1.gb) = (Some(mi1,new_gamestate1.human))
TEST = (List.assoc mi1 new_gamestate1.human.pieces) = (3,1)
TEST = (List.mem mi1 new_gamestate1.human.graveyard) = false

(* Tests that we can move and update properly right *)
let (_, new_gamestate2) = move new_gamestate1 new_gamestate1.human mi1 (3,2)
TEST = (List.assoc (3,1) new_gamestate2.gb) = None
TEST = (List.assoc (3,2) new_gamestate2.gb) = (Some(mi1,new_gamestate2.human))
TEST = (List.assoc mi1 new_gamestate2.human.pieces) = (3,2)
TEST = (List.mem mi1 new_gamestate2.human.graveyard) = false

(* Tests that we can move human up and win attack on computer piece *)
let (_, gs1) = move new_gamestate1 new_gamestate1.human mi1 (4,1)
let (_, gs2) = move gs1 gs1.human mi1 (5,1)
let (_, gs3) = move gs2 gs2.human mi1 (6,1)
let (_, gs4) = move gs3 gs3.human mi1 (7,1)
let (_, gs5) = move gs4 gs4.human mi1 (8,1)
let (_, gs6) = move gs5 gs5.human mi1 (9,1)
TEST = (List.assoc (9,1) gs6.gb) = Some(mi1,gs6.human)
TEST = (List.assoc mi1 gs6.human.pieces) = (9,1)
TEST = (List.mem sp1 gs6.comp.graveyard) = true

(* Tests that we can move human up and tie attack with removing both pieces *)
let (_,gs7) = move gs6 gs6.human mi1 (10,1)
TEST = (List.assoc (10,1) gs7.gb) = None
TEST = (try List.assoc mi1 gs7.human.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (try List.assoc mi2 gs7.comp.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (List.mem mi1 gs7.human.graveyard) = true
TEST = (List.mem mi2 gs7.comp.graveyard) = true

(* Tests move computer down and hit human bomb, both leave *)
let (_, gs_1) = move gamestate gamestate.comp ser1 (8,6)
let (_, gs_2) = move gs_1 gs_1.comp ser1 (7,6)
let (_, gs_3) = move gs_2 gs_2.comp ser1 (6,6)
let (_, gs_4) = move gs_3 gs_3.comp ser1 (5,6)
let (_, gs_5) = move gs_4 gs_4.comp ser1 (4,6)
let (_, gs_6) = move gs_5 gs_5.comp ser1 (3,6)
let (_, gs_7) = move gs_6 gs_6.comp ser1 (2,6)
TEST = (List.assoc (2,6) gs_7.gb) = None
TEST = (try List.assoc ser1 gs_7.comp.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (try List.assoc b3 gs_7.human.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (List.mem ser1 gs_7.comp.graveyard) = true
TEST = (List.mem b3 gs_7.human.graveyard) = true

(* Test that we can't move a piece if there's another piece for the same player in the way *)
let (boolean, same_gs) = move gamestate gamestate.comp mi2 (9,1)
TEST = (boolean) = false
TEST = same_gs = gamestate

(* Test that miner hits a bomb stays on board *)
let (_,gs_1) = move gamestate gamestate.comp mi1 (8,8)
let (_,gs_2) = move gs_1 gs_1.comp mi1 (7,8)
let (_,gs_3) = move gs_2 gs_2.comp mi1 (6,8)
let (_,gs_4) = move gs_3 gs_3.comp mi1 (5,8)
let (_,gs_5) = move gs_4 gs_4.comp mi1 (4,8)
let (_,gs_6) = move gs_5 gs_5.comp mi1 (3,8)
let (_,gs_7) = move gs_6 gs_6.comp mi1 (3,7)
let (_,gs_8) = move gs_7 gs_7.comp mi1 (3,6)
let (_,gs_9) = move gs_8 gs_8.comp mi1 (2,6)
TEST = (List.assoc (2,6) gs_9.gb) = Some(mi1,gs_9.comp)
TEST = (List.assoc mi1 gs_9.comp.pieces) = (2,6)
TEST = (List.mem b3 gs_9.human.graveyard) = true
TEST = (try List.assoc b3 gs_9.human.pieces with Not_found -> (-1,-1)) = (-1,-1)

(* Test the computer attacks human piece and wins *)
let (_,gs_7_down) = move gs_7 gs_7.comp mi1 (2,7)
TEST = (List.assoc (2,7) gs_7_down.gb) = Some(mi1,gs_7_down.comp)
TEST = (List.assoc mi1 gs_7_down.comp.pieces) = (2,7)
TEST = (List.mem sc2 gs_7_down.human.graveyard) = true
TEST = (try List.assoc sc2 gs_7_down.human.pieces with Not_found -> (-1,-1)) = (-1,-1)

(* Test that computer attacks human piece and loses *)
let (_,gs_6_down) = move gs_6 gs_6.comp mi1 (2,8)
TEST = (List.assoc (2,8) gs_6_down.gb) = Some(l2,gs_6_down.human)
TEST = (List.assoc l2 gs_6_down.human.pieces) = (2,8)
TEST = (List.mem mi1 gs_6_down.comp.graveyard) = true
TEST = (try List.assoc mi1 gs_6_down.comp.pieces with Not_found -> (-1,-1)) = (-1,-1)

(* Test that invalid move of 2 spaces for a piece that can't do that *)
let (boolean,gs_1_no) = move gamestate gamestate.comp mi1 (6,8)
TEST = boolean = false
TEST = gs_1_no = gamestate


(* TEST =  (print_game_board gamestate.gb) = () *)

(* Test that scout can move up properly *)
let (boolean, sc_gamestate) = move gamestate hum sc3 (6,10)
TEST = (List.assoc (6,10) sc_gamestate.gb) = Some(sc3,sc_gamestate.human)
TEST = (List.assoc (2,10) sc_gamestate.gb) = None
TEST = (List.assoc sc3 sc_gamestate.human.pieces) = (6,10)

(* Test that scout can move sideways properly *)
let (boolean, sc_gamestate_left) = move sc_gamestate sc_gamestate.human sc3 (6,2)
TEST = (List.assoc (6,2) sc_gamestate_left.gb) = Some(sc3,sc_gamestate_left.human)
TEST = (List.assoc (6,10) sc_gamestate_left.gb) = None
TEST = (List.assoc sc3 sc_gamestate_left.human.pieces) = (6,2)

(* Test that scout can attack *)
let (_, sc_gamestate2) = move sc_gamestate sc_gamestate.human sc3 (9,10)
TEST = (List.assoc (9,10) sc_gamestate2.gb) = Some(cap2,sc_gamestate2.comp)
TEST = (List.assoc (6,10) sc_gamestate2.gb) = None
TEST = (try List.assoc sc3 sc_gamestate2.human.pieces with Not_found -> (-1,-1)) = (-1,-1)
TEST = (List.mem sc3 sc_gamestate2.human.graveyard) = true
TEST = (List.assoc cap2 sc_gamestate2.comp.pieces) = (9,10)
TEST = (List.mem cap2 sc_gamestate2.comp.graveyard) = false

(* Test that scout can't move onto a piece for its player *)
let (boolean, sc_gamestate3) = move sc_gamestate_left sc_gamestate_left.human sc3 (2,2)
TEST = boolean = false
TEST = sc_gamestate3 = sc_gamestate_left

(* Test that captain can move up to 1 spaces *)
let (_, cap_gamestate) = move sc_gamestate sc_gamestate.human cap2 (2,10)
TEST = (List.assoc (2,10) cap_gamestate.gb) = Some(cap2,cap_gamestate.human)
TEST = (List.assoc (1,10) cap_gamestate.gb) = None
TEST = (List.assoc cap2 cap_gamestate.human.pieces) = (2,10)

let (_, cap_gamestate2) = move sc_gamestate sc_gamestate.human cap2 (3,10)
TEST = (List.assoc (3,10) cap_gamestate2.gb) = Some(cap2,cap_gamestate2.human)
TEST = (List.assoc (1,10) cap_gamestate2.gb) = None
TEST = (List.assoc cap2 cap_gamestate2.human.pieces) = (3,10)

let (_, cap_gamestate3) = move cap_gamestate2 cap_gamestate2.human cap2 (3,8)
TEST = (List.assoc (3,8) cap_gamestate3.gb) = Some(cap2,cap_gamestate3.human)
TEST = (List.assoc (3,10) cap_gamestate3.gb) = None
TEST = (List.assoc cap2 cap_gamestate3.human.pieces) = (3,8)


let () = Pa_ounit_lib.Runtime.summarize()