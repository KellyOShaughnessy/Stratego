(*Gamestate.ml*)

type location = int * int
and piece = {pce:string; id:int; rank:int}

and player = {name: bytes; pieces: (piece*location) list; graveyard: piece list}

(*get the rank of the piece during attack *)
let get_rank (piece:piece) : int =
  match piece.pce with
  | "Flag" -> 1
  | "Bomb" -> 0
  | "Spy" -> 2
  | "Scout" -> 3
  | "Marshal" -> 12
  | "General" -> 11
  | "Miner" -> 4
  | "Colonel" -> 10
  | "Major" -> 9
  | "Captain" -> 8
  | "Lieutenant" -> 7
  | "Sergeant" -> 6
  | "Corporal" -> 5
  | _ -> failwith "not a piece"


and game_board = (location*((piece*player) option)) list

and gamestate = {gb: game_board ; human: player; comp: player; turn: player}

(* Initializes game state from user input and computer generated setup *)
let new_game location piece gamestate  = failwith "unimplemented"

(* Uses player assocation pieces record to get the location of a piece
get location. try with, and check if that piece is in the player's piece to chekc
if my piece is actually on the board.*)
let get_location  (pl: player)  (pc: piece) : location  =
  (*Find piece in graveyard piece list. If the piece
  is there then raise error because you can't get the location of it.
  If it is not there, then return snd of piece.pieces in the player's list  *)
  let exists k l =
    List.fold_left(
      fun a x -> if x ==k then true else a)
      false l;;
  let pc_ex = exists pc (pl.graveyard) in
    match pc_ex with
    |true -> failwith "piece is in graveyard"
    |false -> let loc_tup = List.assoc pc pl.pieces in
                  match loc_tup with
                  |(x,y) -> y
                  | _ -> failwith "error in get_location"


# let lookup_weight ~compute_weight alist key =
    match List.Assoc.find alist key with
    | None -> 0.
    | Some data -> compute_weight data ;;


let validate_move game_board player piece location = failwith "unimplemented"

(*check if its a flag or bomb before i call get_rank.
if bomb && miner, then miner moves to that piece and bomb leaves
otherwise piece leaves and bomb leaves too.
and then the three cases of rankings. if flag, then win the game.

piece1 is my piece
piece2 is the piece that was on the tile.

piece -> piece -> ((piece*player) option)*)
let attack piece1 piece2 =
  match piece2.pce with
  | "Bomb" -> match piece1.pce with
             | "Miner" -> piece1
             | "Bomb" -> failwith "bomb and bomb attack"
             | _ -> failwith "remove piece1 from board. put into player Graveyard"
  | "Flag" -> failwith "game is won.. new_game?"
  | _ -> (if get_rank piece1 <= get_rank piece2 then Some piece2 else Some piece1)


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

let rec remove_first_from_list piece lst =
  match lst with
  | [] -> []
  | h::t -> if h=piece then t else h::remove_first_from_list piece t

let add_to_board game_board player piece location =
  let new_graveyard = remove_first_from_list piece player.graveyard in
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

(* returns a new gamestate with updated piece locations
* - [gamestate] is the current gamestate to be updated
* - [player] is the current player
* - [piece] is the piece to try to move
* - [location] is the desired end location
* Calls get_location to get the current location of the pice
* Calls validate_move to verify that that piece can move to the end location
* If validate_move returns true with no piece,
*   update game state with the current piece
* If validate_move returns true with some piece,
*   calls attack function and updates board
* If validate_move returns false,
*   asks player to try a different move *)
let move gamestate player piece end_location =
  let start_location = get_location player piece in
  let game_board = gamestate.gb in
  match validate_move game_board player piece end_location with
  | (true, Some opp_piece) ->
      (match attack piece opp_piece with
      | None ->
          let (removed_start_gb, new_player) = remove_from_board game_board
                                                player piece start_location in
          let (removed_end_gb, new_opp_player) = remove_from_board
                                                removed_start_gb new_player
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
              (true,{gamestate with human = newer_player; gb=add_end_gb})
            else
              let (add_end_gb, opp_player) = add_to_board removed_start_gb
                                                  gamestate.comp pce
                                                  end_location in
              (true,{gamestate with human = new_player; comp=opp_player; gb=add_end_gb})
          else
            if plyr.name="comp" then
              let (add_end_gb, newer_player) = add_to_board removed_start_gb
                                                  new_player pce
                                                  end_location in
              (true,{gamestate with comp = newer_player; gb=add_end_gb})
            else
              let (add_end_gb, opp_player) = add_to_board removed_start_gb
                                                  gamestate.comp pce
                                                  end_location in
              (true,{gamestate with comp = new_player; human=opp_player; gb=add_end_gb})
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
