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

and gamestate = {gb: game_board ; human: player; comp: player; turn: player}

(*
Testing:
let board = empty_game ();;
print_game_board board;;
 *)
let empty_game () : game_board =
  let newer = ref [] in
  for i=1 to 10 do
    for j=1 to 10 do
      newer := (!newer)@[((i,j), None)];
    done
  done; (!newer)

(* Initializes game state from user input and computer generated setup *)
(* Testing:
let human = {name="human"; pieces = [(Spy 3, (7,3)); (Flag, (10,4))]; graveyard=[]}
in let comp = {name="comp"; pieces = [(Spy 3, (1,6)); (Flag, (1,10))]; graveyard=[]}
in print_gamestate (new_game human comp);;
 *)
let new_game (human:player) (comp:player): gamestate =
  let board = empty_game () in
  let rec newboard b pi pl = (
    match pi with
    | [] -> b
    | (p,l)::t -> ( let n = List.map (fun (loc, op) -> (if (loc=l)
      then (if op = None then (loc, Some(p,pl))
      else failwith "You are trying to place two pieces in the same location...")
      else (loc,op))) b in
      newboard n t pl
    )
  ) in
  let new1 = newboard board comp.pieces comp in
  let new2 = newboard new1 human.pieces human in
  {gb = new2; human = human; comp = comp; turn = human}

(* Uses player assocation pieces record to get the location of a piece
get location. try with, and check if that piece is in the player's piece to chekc
if my piece is actually on the board.*)
let get_location  player  piece  = failwith "unimplemented"

let validate_move game_board player piece location = failwith "unimplemented"

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

let piecelst_to_string (ls: piece list): string=
  let lststr = "[" in
  let rec addp l s =
  match l with
  | [] -> "Currently empty"
  | h::[] -> s^(piece_to_string h)^"]"
  | h::t -> (let news =  s^(piece_to_string h)^"; " in
  (addp t news)
  ) in addp ls lststr

let rec print_game_board (game_board:game_board)=
  match game_board with
  | [] -> ()
  | ((row,col),some_piece)::t ->
    let s1 =
      (match some_piece with
      | None -> "   "
      | Some (piece,player) ->
          if player.name="human" then
            (piece_to_string piece)
          else
            " X ")
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
      (if row=10 && col=10 then
        s2^
        "     -------------------------------------------------------------\n\n"
      else
        s2
      )
    in
    let s4 = (
      if row = 1 && col = 1 then
       "\n        1     2     3     4     5     6     7     8     9    10\n"^s3
     else s3
    ) in
    Printf.printf "%s" s4;
    print_game_board t

let print_gamestate (gamestate:gamestate) =
  print_game_board gamestate.gb;
  Printf.printf "     Your Graveyard: %s\n"
    (piecelst_to_string gamestate.human.graveyard);
  Printf.printf "     Opponent's Graveyard: %s\n\n"
    (piecelst_to_string gamestate.comp.graveyard);
  let turnt = (gamestate.turn).name in
  let t =
    if turnt = "human" then "Yours" else "Opponent"
  in
  Printf.printf "     Turn: %s\n\n" t;


(* Sarah TODO:
Qs and concerns:
 - changed the print function a bit for game board
 - changed it a lot for game state
 - Added an empty gameboard function --> good for testing printing

 - do we want the board to reappear after every time the player places a piece?
 - How do we make sure that the player and the computer have the same number of
 pieces?

 - If the gameboard now holds the piece*player then the player does not need to
 his pieces...
    - At the same time this is helpful in initialization
 - how will the pieces of same type and player appear different in the game?
 - how will the player identify the piece that he would like to move?
 - Should we switch the whole name thing in players to be a variant
 type player_type = Human | Comp

 - How can we stop people from putting things in the same place?
 - How can we tell them only to put stuff within specific rows and colums?
    -- Rows: probs only bottom 4...?
    -- colums: 1-10

 - Do we see the opponent's graveyard??

 - Right now new_game takes in the two players and forms the original game state
      --> Is this what we want OR we could have the input be just a list of
      (piece, location) as defined by the user in the I/O and comp list could be
      created by calling the AI directly.
      --> only input would then be the list... to be revisited
 *)
