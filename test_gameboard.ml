open Gamestate

let human_list =
  [((Spy 1),(1,1));
  ((Scout 2),(2,1));
  ((Captain 3),(3,1));
  ((Major 4),(4,1));
  ((Flag),(5,1));
  ((Sergeant 5),(6,1));
  ((Colonel 6),(7,1));
  ((Miner 2),(8,1));
  ((General 7),(9,1));
  ((Captain 8),(10,1));
  ((Miner 2),(1,2));
  ((Marshal 9),(2,2));
  ((Lieutenant 6),(3,2));
  ((Bomb),(4,2));
  ((Bomb),(5,2));
  ((Bomb),(6,2));
  ((Scout 2),(7,2));
  ((Lieutenant 6),(8,2));
  ((Sergeant 5),(9,2));
  ((Scout 2),(10,2))]

let computer_list =
  [((Spy 1),(1,9));
  ((Scout 2),(2,9));
  ((Captain 3),(3,9));
  ((Major 4),(4,9));
  ((Flag),(5,9));
  ((Sergeant 5),(6,9));
  ((Colonel 6),(7,9));
  ((Miner 2),(7,9));
  ((General 7),(9,9));
  ((Captain 8),(10,9));
  ((Miner 2),(1,10));
  ((Marshal 9),(2,10));
  ((Lieutenant 6),(3,10));
  ((Bomb),(4,10));
  ((Bomb),(5,10));
  ((Bomb),(6,10));
  ((Scout 2),(7,10));
  ((Lieutenant 6),(8,10));
  ((Sergeant 5),(9,10));
  ((Scout 2),(10,10))]


let hum = {name= "human"; pieces = human_list; graveyard=[]}
let computer = {name= "comp"; pieces = computer_list; graveyard=[]}

let game_board =
[
((1,10),Some (Miner 2, computer));
((2,10),Some (Marshal 9, computer));
((3,10),Some (Lieutenant 6, computer));
((4,10),Some (Bomb, computer));
((5,10),Some (Bomb, computer));
((6,10),Some (Bomb, computer));
((7,10),Some (Scout 2, computer));
((8,10),Some (Lieutenant 6, computer));
((9,10),Some (Sergeant 5, computer));
((10,10),Some (Scout 2, computer));

((1,9),Some (Spy 1,computer));
((2,9),Some (Scout 2,computer));
((3,9),Some (Captain 3,computer));
((4,9),Some (Major 4,computer));
((5,9),Some (Flag,computer));
((6,9),Some (Sergeant 5,computer));
((7,9),Some (Colonel 6,computer));
((8,9),Some (Miner 2,computer));
((9,9),Some (General 7,computer));
((10,9),Some (Captain 8,computer));

((1,8),None);
((2,8),None);
((3,8),None);
((4,8),None);
((5,8),None);
((6,8),None);
((7,8),None);
((8,8),None);
((9,8),None);
((10,8),None);

((1,7),None);
((2,7),None);
((3,7),None);
((4,7),None);
((5,7),None);
((6,7),None);
((7,7),None);
((8,7),None);
((9,7),None);
((10,7),None);

((1,6),None);
((2,6),None);
((3,6),None);
((4,6),None);
((5,6),None);
((6,6),None);
((7,6),None);
((8,6),None);
((9,6),None);
((10,6),None);

((1,5),None);
((2,5),None);
((3,5),None);
((4,5),None);
((5,5),None);
((6,5),None);
((7,5),None);
((8,5),None);
((9,5),None);
((10,5),None);

((1,4),None);
((2,4),None);
((3,4),None);
((4,4),None);
((5,4),None);
((6,4),None);
((7,4),None);
((8,4),None);
((9,4),None);
((10,4),None);

((1,3),None);
((2,3),None);
((3,3),None);
((4,3),None);
((5,3),None);
((6,3),None);
((7,3),None);
((8,3),None);
((9,3),None);
((10,3),None);

((1,2),Some (Miner 2, hum));
((2,2),Some (Marshal 9, hum));
((3,2),Some (Lieutenant 6, hum));
((4,2),Some (Bomb, hum));
((5,2),Some (Bomb, hum));
((6,2),Some (Bomb, hum));
((7,2),Some (Scout 2, hum));
((8,2),Some (Lieutenant 6, hum));
((9,2),Some (Sergeant 5, hum));
((10,2),Some (Scout 2, hum));

((1,1),Some (Spy 1,hum));
((2,1),Some (Scout 2,hum));
((3,1),Some (Captain 3,hum));
((4,1),Some (Major 4,hum));
((5,1),Some (Flag,hum));
((6,1),Some (Sergeant 5,hum));
((7,1),Some (Colonel 6,hum));
((8,1),Some (Miner 2,hum));
((9,1),Some (General 7,hum));
((10,1),Some (Captain 8,hum));
]

let gamestate = {gb=game_board; human=hum; comp=computer; turn="human"}

(* Tests that we got rid of the right piece from human pieces list *)
let (new_gb,hum1) = (remove_from_board game_board hum (Miner 2) (8,1))
TEST = (List.assoc (Miner 2) hum1.pieces) = (1,2)
let (new_gb1, hum2) = (remove_from_board new_gb hum1 (Miner 2) (1,2))
TEST = (try List.assoc (Miner 2) hum2.pieces with Not_found -> (-1,-1)) = (-1,-1)

(* Test add_to_board *)
let gamestate = {gamestate with gb = new_gb}
let (new_gb2, hum3) = (add_to_board game_board hum (Miner 2) (8,1))
TEST = (List.assoc (Miner 2) hum3.pieces) = (8,1)
TEST = (List.mem (Miner 2) hum3.graveyard) = false

(* tests that the game board references the piece and the new player *)
TEST = (List.assoc (8,1) new_gb2) = Some (Miner 2, hum3)
TEST = (List.assoc (2,2) new_gb2) = Some (Marshal 9, hum3)

let () = Pa_ounit_lib.Runtime.summarize()