(*Gamestate.ml*)

(*TODO: reveal opponents piece when you attack it; change it on gameboard*)

type location = int * int

and piece = {pce:string; id:int}

and player = {name: bytes; pieces: (piece*location) list;
  graveyard: piece list; won: bool}

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

let empty_game () : game_board =
  (* creating a ref to an empty list *)
  let newer = ref [] in
  for i=10 downto 1 do
    for j=1 to 10 do
    (* imperatively updating the list *)
      newer := (!newer)@[((i,j), None)];
    done
  done;
  (* return list with all possible locations initiatlize to none *)
  (!newer)

let playerwins player : player =
  {player with won=true}

let newplayer (name:bytes) (pieces: (piece*location) list) : player =
  (* making new player record from inputs *)
  {name= name; pieces = pieces; graveyard = []; won = false}

let making_game h c =
  (* creating a new empty board_game *)
  let board = empty_game () in
  (* helper function to loop through each player's pieces and add them to the
  game_board *)
  let rec newboard b pi pl = (
    (* iterates over the board *)
      match pi with
      | [] -> b
      | (p,l)::t -> (
        (* map function that checks if location in piece list is the same as l
           and adds the loc*player option to the pair if the current value is
           None. If not None, throws a warning.
         *)
        let n = List.map (fun (loc, op) -> (if (loc=l)
        then (if op = None then (loc, Some(p,pl))
        else failwith "You are trying to place two pieces in the same
          location...")
        else (loc,op))) b in
        newboard n t pl
      )
    ) in
  (* Adds the computer's pieces *)
  let new1 = newboard board c.pieces c in
  (* Adds the human's pieces *)
  let new2 = newboard new1 h.pieces h in
  (* returns the completed board *)
  new2

let add_human (h: player) (c: player) (loc: location)
  (p: piece): player =
  let pieces = h.pieces in
  if ((fst loc) <= 2 && (fst loc) > 0 && (snd loc) <= 10 && (fst loc) > 0)
    then (
      let newp = pieces@[(p,loc)] in
      let human = {name= h.name; pieces = newp;
        graveyard = h.graveyard; won=false}
      in
      human
    )
  else
    let _ = Printf.printf "You cannot place a piece here!! Try again. \n" in
    h

(* Initializes game state from user input and computer generated setup *)
(* Testing:
let human = {name="human"; pieces = [(Spy 3, (7,3)); (Flag, (10,4))]; graveyard=[]}
in let comp = {name="comp"; pieces = [(Spy 3, (1,6)); (Flag, (1,10))]; graveyard=[]}
in print_gamestate (new_game human comp);;
 *)
let new_gamestate (human:player) (comp:player): gamestate =
  if List.length human.pieces = List.length comp.pieces then (
    let board = making_game human comp in
    {gb = board; human = human; comp = comp; turn = human}
  ) else failwith "It seems that you have not placed all of your pieces"

(* Uses player assocation pieces record to get the location of a piece
* get location. try with, and check if that piece is in the player's piece
* to check if my piece is actually on the board.*)
let get_location  (pl: player)  (pc: piece) : location  =
  try
    List.assoc pc pl.pieces
  with
  | Not_found -> failwith "error in get_location"

(*Checks that piece isn't trying to move off of gameboard*)
let on_gameboard (dest:location) : bool =
  if ((fst dest) <= 10 && (fst dest) >0 && (snd dest) <=10 && (snd dest) >0)
  then true
  else false

(*validates that the piece can move to the specified destination*)
let simple_validate (pl:player) (pc:piece) (dest:location) (gb:game_board)  =
  let loc = get_location pl pc in
  let xdist = fst dest - fst loc in
  let ydist = snd dest - snd loc in
  (*Check that only trying to move one space*)
  if ((abs xdist) >1 || (abs ydist) >1) || ((abs xdist) =1
    && (abs ydist) =1) || ((on_gameboard dest) =false) then false
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
let rec check_intermediate (gb:game_board) (pl:player) (dir:string)
                          (loc:location) (dest:location) : bool =
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

(* [captain_validate pl pc dest gb] validates that the captain piece
* can move to that location *)
let captain_validate (pl:player) (pc:piece) (dest:location) (gb:game_board) =
  let loc = get_location pl pc in
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

(* [scout_validate plc pc dest gb] checks if the scout can move to that loc *)
let scout_validate (pl:player) (pc:piece) (dest:location) (gb:game_board) =
  let loc = get_location pl pc in
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

(* [validate_move gb pl pc dest] returns bool*(piece option) where the piece
* is the current piece at the destination location, if there is one *)
let validate_move gb pl pc dest =
  (*check that no player, piece, game_board or location is empty *)
  if (gb_is_empty gb || player_is_empty pl) then
    (Printf.printf "Invalid move due to empty gameboard or player.";
    (false, None))
  else(
    let loc = get_location pl pc in
    if  loc = dest then (true, Some(pc)) else
    match pc.pce with
    (*All pieces can move one space in any direction unless otherwise
    specified.*)
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

(* [attack piece1 piece2 p1 p2] returns an option containing the piece that
* should remain on the board with its respective player, if any pieces should
* remain. Also sets the won flag to true if the player captured the flag! *)
let attack piece1 piece2 p1 p2 =
  match piece2.pce with
  | "Bomb" -> (match piece1.pce with
             | "Miner" -> Some (piece1, p1)
             | _ -> None)
  | "Flag" -> Some(piece1,{p1 with won=true})
  | _ -> (if get_rank piece1 < get_rank piece2 then Some (piece2, p2)
          else if get_rank piece1 > get_rank piece2 then Some (piece1,p1)
          else None)

(* [remove_from_board game_board player piece location] removes that
* piece from the gameboard and transfers that piece from the player's list
* of pieces to their graveyard *)
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

(* [remove_from_graveyard piece lst] removes the first instance of that
* piece from the graveyard list *)
let rec remove_from_graveyard piece lst =
  match lst with
  | [] -> []
  | h::t -> if h=piece then t else h::remove_from_graveyard piece t

(* [remove_from_pieces piece lst] removes the piece from the piece list *)
let rec remove_from_pieces piece lst =
  match lst with
  | [] -> []
  | (pce,loc)::t -> if pce=piece then t else (pce,loc)::remove_from_pieces
    piece t

(* [add_to_board game_board player piece location] adds that piece to the
* location on the gameboard, and transfers it from the player's graveyard
* to their piece list *)
let add_to_board game_board player piece location =
  let new_graveyard = remove_from_graveyard piece player.graveyard in
  let new_player_pieces = (piece,location)::player.pieces in
  let new_player_1 = {player with pieces=new_player_pieces; graveyard=
  new_graveyard} in
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


(*
We will now need to update the 'turn' field in gamestate instead of having the
bool as part of the return value.
*)
let move gamestate player piece end_location =
  let start_location = get_location player piece in
  let game_board = gamestate.gb in
  match validate_move game_board player piece end_location with
  | (true, Some opp_piece) ->
    let opp_player = (if player.name ="human" then gamestate.comp else
    gamestate.human) in
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
              {changed_gs with human = new_player; comp = new_opp_player;
              turn = new_opp_player}
            else
              {changed_gs with human = new_opp_player; comp = new_player;
              turn = new_opp_player})
          in
          Some new_gs
      | Some (pce,plyr) ->
          let (removed_start_gb, new_player) = remove_from_board game_board
                                                player piece start_location in
          (* Attacking player 'wins' the attack *)
          if new_player.name = plyr.name then
            let (add_end_gb, newer_player) = add_to_board removed_start_gb
                                                new_player pce
                                                end_location in
            let new_opp_graveyard = opp_piece::gamestate.comp.graveyard in
            let new_opp_pieces = remove_from_pieces opp_piece
              gamestate.comp.pieces in
            let new_opp = {gamestate.comp with pieces=new_opp_pieces; graveyard
               = new_opp_graveyard} in
            if new_player.name = "human" then
              Some {human = newer_player; comp = new_opp;
                gb=add_end_gb; turn=new_opp}
            else
              Some {comp = newer_player; human = new_opp;
                gb=add_end_gb; turn=new_opp}
          else
              let (add_end_gb, opp_player) = add_to_board removed_start_gb
                                                  gamestate.comp pce
                                                  end_location in
              let new_pl_graveyard = piece::new_player.graveyard in
              let new_pl_pieces = remove_from_pieces piece new_player.pieces in
              let new_pl = {new_player with pieces=new_pl_pieces; graveyard =
                new_pl_graveyard} in
              if new_player.name = "human" then
                Some {human = new_pl; comp=opp_player;
                  gb=add_end_gb; turn=opp_player}
              else
                Some {comp = new_pl; human=opp_player;
                  gb=add_end_gb; turn=opp_player}
      )
  | (true, None) ->
      let (removed_gb,new_player) = remove_from_board game_board player
                                      piece start_location
      in
      let (added_gb,newer_player) = add_to_board removed_gb new_player
                                      piece end_location
      in
      if player.name="human" then
        Some {gamestate with gb = added_gb; human = newer_player;
              turn = gamestate.comp}
      else
        Some {gamestate with gb = added_gb; comp = newer_player;
            turn = gamestate.human}
  | (false, _) -> None


let piece_to_string (piece:piece) =
  match piece.pce with
  | "Flag" -> "Fla"^(string_of_int piece.id)
  | "Bomb" -> "Bom"^(string_of_int piece.id)
  | "Spy" -> "Spy"^(string_of_int piece.id)
  | "Scout" -> "Sco"^(string_of_int piece.id)
  | "Marshal" -> "Mar"^(string_of_int piece.id)
  | "General" -> "Gen"^(string_of_int piece.id)
  | "Miner" -> "Min"^(string_of_int piece.id)
  | "Colonel" -> "Col"^(string_of_int piece.id)
  | "Major" -> "Maj"^(string_of_int piece.id)
  | "Captain" -> "Cap"^(string_of_int piece.id)
  | "Lieutenant" -> "Lie"^(string_of_int piece.id)
  | "Sergeant" -> "Ser"^(string_of_int piece.id)
  | "Corporal" -> "Cor"^(string_of_int piece.id)
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
  Printf.printf "     Turn: %s\n\n" t

(* Displays the computer's pieces as well *)
let debug_print_gameboard gamestate =
  let new_gb =
    (List.map
      (fun (loc, opt) ->
        (match opt with
        | None -> (loc, None)
        | Some (piece,player) -> (loc, Some(piece,gamestate.human)))
    )
    gamestate.gb) in
  print_game_board new_gb