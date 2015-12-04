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

let hum = {name= "human"; pieces = human_list; graveyard=[ma1;mi2;l1]; won=false}
let computer = {name= "comp"; pieces = computer_list; graveyard=[]; won=false}

(* Test the print_help function *)

let gamestate = {gb = []; human = hum; comp = computer; turn = hum}

TEST = print_help "help" gamestate = ()
TEST = print_help "instructions" gamestate = ()
TEST = print_help "pieces" gamestate = ()
TEST = print_help "graveyard" gamestate = ()