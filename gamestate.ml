(*Gamestate.ml*)

type location = int * int
and piece = {pce:string; id:int}

and player = {name: bytes; pieces: (piece*location) list; graveyard: piece list;
  won: bool}


and game_board = (location*((piece*player) option)) list

and gamestate = {gb: game_board ; human: player; comp: player; turn: player}

(*get the rank of the piece during attack *)
let get_rank (piece:piece) : int =
  match piece.pce with
  | "Spy" -> 1
  | "Scout" -> 2
  | "Marshal" -> 11
  | "General" -> 10
  | "Miner" -> 3
  | "Colonel" -> 9
  | "Major" -> 8
  | "Captain" -> 7
  | "Lieutenant" -> 6
  | "Sergeant" -> 5
  | "Corporal" -> 4
  | _ -> failwith "not a piece. no rank"

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

let making_game h c =
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
  let new1 = newboard board c.pieces c in
  let new2 = newboard new1 h.pieces h in
  new2

let add_human (board: game_board) (h: player) (loc: location) (p: piece): player =
  let pieces = h.pieces in
  let newp = pieces@[(p,loc)] in
  {name= h.name; pieces = newp; graveyard = h.graveyard; won=false}

(* let add board h loc p c =
   *)


(* Initializes game state from user input and computer generated setup *)
(* Testing:
let human = {name="human"; pieces = [(Spy 3, (7,3)); (Flag, (10,4))]; graveyard=[]}
in let comp = {name="comp"; pieces = [(Spy 3, (1,6)); (Flag, (1,10))]; graveyard=[]}
in print_gamestate (new_game human comp);;
 *)
let new_game (human:player) (comp:player) (board: game_board): gamestate =
  if List.length human.pieces = List.length comp.pieces then (
    {gb = board; human = human; comp = comp; turn = human}
  ) else failwith "It seems that you have not placed all of your pieces"

(* Uses player assocation pieces record to get the location of a piece
get location. try with, and check if that piece is in the player's piece to chekc
if my piece is actually on the board.*)

let get_location  (pl: player)  (pc: piece) : location  =
  (*Find piece in graveyard piece list. If the piece
  is there then raise error because you can't get the location of it.
  If it is not there, then return snd of piece.pieces in the player's list  *)
  try
    List.assoc pc pl.pieces
  with
  | Not_found -> failwith "error in get_location"


(*Checks that piece isn't trying to move off of gameboard*)
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
  if loc = dest then
    true
  else
    let new_loc = if dir = "up" then (fst loc + 1, snd loc) else
                if dir = "down" then (fst loc - 1, snd loc) else
                if dir = "right" then (fst loc, snd loc + 1)
                else (fst loc, snd loc - 1) in
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
      if xdist=0 then (if min ydist 0 = ydist then "left" else "right")
      else (if min xdist 0 = xdist then "down" else "up") in
    let dest_piece = List.assoc dest gb in
      match dest_piece with
      | None -> check_intermediate gb pl dir loc dest
      | Some(x,y)->
        if (y = pl) then false
        else check_intermediate gb pl dir loc dest

let scout_validate (pl:player) (pc:piece) (dest:location) (gb:game_board) : bool =
  let loc = get_location pl pc in
(*   Printf.printf "loc: (%d,%d) dest: (%d,%d)\n" (fst loc) (snd loc) (fst dest) (snd dest);
 *)  (*TODO need to take absolute value*)
  let xdist = fst dest - fst loc in
  let ydist = snd dest - snd loc in
  (*Check that only trying to move in one direction that is contained on board*)
  if ((xdist<>0 && ydist<>0) || on_gameboard dest =false)
    then false
  else
    (*get direction of movement as (dir,destination starting point)*)
    let dir =
      if xdist=0 then (if min ydist 0 = ydist then "left" else "right")
      else (if min xdist 0 = xdist then "down" else "up") in
    let dest_piece = List.assoc dest gb in
      match dest_piece with
      | None -> check_intermediate gb pl dir loc dest
      | Some(x,y)->
        if (y = pl) then false
        else check_intermediate gb pl dir loc dest

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
      if scout_validate pl pc dest gb then
      (true,get_piece dest gb)
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
piece2 is the piece that was on the tile.

piece -> piece -> ((piece*player) option)

 Some(piece1,player)
*)
let attack piece1 piece2 p1 p2 =
  match piece2.pce with
  | "Bomb" -> (match piece1.pce with
             | "Miner" -> Some (piece1, p1)
             | _ -> None)
  | "Flag" -> Some(piece1,{p1 with won=true})
  | _ -> (if get_rank piece1 < get_rank piece2 then Some (piece2, p2)
          else if get_rank piece1 > get_rank piece2 then Some (piece1,p1)
          else None)


(*check if piece 2 is a bomb or miner. if piece piece 2 is bomb
and piece 1 in miner, then miner takes that tile. bomb leaves.
otherwise both piece 1 and piece 2 = bomb leave. piece 1 goes into graveyard
remove_from_board game_board, piece1 location

1. if piece2 = flag then game is won
2. if piece1 rank < piece 2 rank, piece 1 goes to graveyard
2. piece1 rank > piece2 rank then piece2 graveyard, piece 1 on that location*)


let remove_from_board game_board player piece location =
  let new_player_pieces =
    (List.filter
      (fun (pce,(row,col)) ->
        pce<>piece || (row,col)<>location
      )
      player.pieces
    )
  in
  let new_player_1 = {player with pieces=new_player_pieces} in
  let new_player_2 = {new_player_1 with graveyard=piece::player.graveyard} in
  let new_game_board =
    (List.map
      (fun ((row,col),some_piece) ->
        if (row,col)=location then
          ((row,col),None)
        else
          (match some_piece with
            | None -> ((row,col),some_piece)
            | Some (pce,plyr) ->
              if plyr.name = player.name then
                ((row,col),Some (pce,new_player_2))
              else
                ((row,col), some_piece)
          )
      )
      game_board)
  in
  (new_game_board,new_player_2)

let rec remove_from_graveyard piece lst =
  match lst with
  | [] -> []
  | h::t -> if h=piece then t else h::remove_from_graveyard piece t

let rec remove_from_pieces piece lst =
  match lst with
  | [] -> []
  | (pce,loc)::t -> if pce=piece then t else (pce,loc)::remove_from_pieces piece t

let add_to_board game_board player piece location =
  let new_graveyard = remove_from_graveyard piece player.graveyard in
  let new_player_pieces = (piece,location)::player.pieces in
  let new_player_1 = {player with pieces=new_player_pieces; graveyard=new_graveyard} in
  let new_gameboard =
    (List.map
      (fun ((row,col),some_piece) ->
        if (row,col)=location then
          ((row,col),Some (piece,new_player_1))
        else
          (match some_piece with
          | None -> ((row,col),some_piece)
          | Some (pce,plyr) ->
            if plyr.name=player.name then
              (row,col),Some (pce, new_player_1)
            else
              (row,col), some_piece
          )
      )
      game_board)
  in
  (new_gameboard, new_player_1)

let move gamestate player piece end_location =
  let start_location = get_location player piece in
  let game_board = gamestate.gb in
  match validate_move game_board player piece end_location with
  | (true, Some opp_piece) ->
    let opp_player = (if player.name ="human" then gamestate.comp else gamestate.human) in
      (match attack piece opp_piece player opp_player with
      | None ->
          let (removed_start_gb, new_player) = remove_from_board game_board
                                                player piece start_location in
          let (removed_end_gb, new_opp_player) = remove_from_board
                                                removed_start_gb opp_player
                                                opp_piece end_location in
          let changed_gs = {gamestate with gb = removed_end_gb} in
          let new_gs =
            (if player.name = "human" then
              {changed_gs with human = new_player; comp = new_opp_player}
            else
              {changed_gs with human = new_opp_player; comp = new_player})
          in
          (true, new_gs)
      | Some (pce,plyr) ->
          let (removed_start_gb, new_player) = remove_from_board game_board
                                                player piece start_location in
          if new_player.name="human" then
            if plyr.name="human" then
              let (add_end_gb, newer_player) = add_to_board removed_start_gb
                                                  new_player pce
                                                  end_location in
              let new_opp_graveyard = opp_piece::gamestate.comp.graveyard in
              let new_opp_pieces = remove_from_pieces opp_piece gamestate.comp.pieces in
              let new_opp = {gamestate.comp with pieces=new_opp_pieces; graveyard = new_opp_graveyard} in
              (true,{gamestate with human = newer_player; comp = new_opp; gb=add_end_gb})
            else
              let (add_end_gb, opp_player) = add_to_board removed_start_gb
                                                  gamestate.comp pce
                                                  end_location in
              let new_pl_graveyard = piece::new_player.graveyard in
              let new_pl_pieces = remove_from_pieces piece new_player.pieces in
              let new_pl = {new_player with pieces=new_pl_pieces; graveyard = new_pl_graveyard} in
              (true,{gamestate with human = new_pl; comp=opp_player; gb=add_end_gb})
          else
            if plyr.name="comp" then
              let (add_end_gb, newer_player) = add_to_board removed_start_gb
                                                  new_player pce
                                                  end_location in
              let new_opp_graveyard = opp_piece::gamestate.human.graveyard in
              let new_opp_pieces = remove_from_pieces opp_piece gamestate.human.pieces in
              let new_opp = {gamestate.human with pieces=new_opp_pieces; graveyard = new_opp_graveyard} in
              (true,{gamestate with comp = newer_player; human = new_opp; gb=add_end_gb})
            else
              let (add_end_gb, opp_player) = add_to_board removed_start_gb
                                                  gamestate.comp pce
                                                  end_location in
              let new_comp_graveyard = piece::new_player.graveyard in
              let new_comp_pieces = remove_from_pieces piece new_player.pieces in
              let new_comp = {new_player with pieces=new_comp_pieces; graveyard = new_comp_graveyard} in
              (true,{gamestate with comp = new_comp; human=opp_player; gb=add_end_gb})
      )
  | (true, None) ->
      let (removed_gb,new_player) = remove_from_board game_board player
                                      piece start_location
      in
      let (added_gb,newer_player) = add_to_board removed_gb new_player
                                      piece end_location
      in
      if player.name="human" then
        (true,{gamestate with gb = added_gb; human = newer_player})
      else
        (true,{gamestate with gb = added_gb; comp = newer_player})
  | (false, _) -> (false, gamestate)


let piece_to_string (piece:piece) =
  match piece.pce with
  | "Flag" -> "Fla "^(string_of_int piece.id)
  | "Bomb" -> "Bom "^(string_of_int piece.id)
  | "Spy" -> "Spy "^(string_of_int piece.id)
  | "Scout" -> "Sco "^(string_of_int piece.id)
  | "Marshal" -> "Mar "^(string_of_int piece.id)
  | "General" -> "Gen "^(string_of_int piece.id)
  | "Miner" -> "Min "^(string_of_int piece.id)
  | "Colonel" -> "Col "^(string_of_int piece.id)
  | "Major" -> "Maj "^(string_of_int piece.id)
  | "Captain" -> "Cap "^(string_of_int piece.id)
  | "Lieutenant" -> "Lie "^(string_of_int piece.id)
  | "Sergeant" -> "Ser "^(string_of_int piece.id)
  | "Corporal" -> "Cor "^(string_of_int piece.id)
  | _ -> failwith "not a piece"

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
      | None -> "     "
      | Some (piece,player) ->
          if player.name="human" then
            (piece_to_string piece)
          else
            "  X  ")
    in
    let s2 =
      (if col=1 && row!=10 then
        "     "^
        "---------------------------------------------------------------------------------\n  "^
        (string_of_int row)^"  | "^s1^" |"
      else if col=1 && row=10 then
        "     "^
        "---------------------------------------------------------------------------------\n "^
        (string_of_int row)^"  | "^s1^" |"
      else if col=10 then
        " "^s1^" |\n"
      else
        " "^s1^" |")
    in
    let s3 = (
      if row = 1 && col = 10 then
       s2^"     ---------------------------------------------------------------------------------"
       ^"\n         1       2       3       4       5       6       7       8       9      10\n"

     else s2
    ) in
    Printf.printf "%s" s3;
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