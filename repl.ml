open Gamestate
open Ai
open Pervasives
(* NOTE: WHEN COMPILING, USE 'cs3110 compile -p str repl.ml' *)

(* TODO: make sure it doesn't print two gameboards when you do quickstart*)
(* Defining possible commands *)
type cmd =
  | Quit
  | NewGame
  | Help
  | Move of (piece*location)
  | Place of (piece*location)
  | Invalid
  | Pieces
  | Graveyard
  | Board
  | Instructions
  | QuickStart

let hum_quickstart_pces =
    [({pce="Spy";id=1},(1,1));
    ({pce="Scout";id=1},(1,2));
    ({pce="Captain";id=1},(1,3));
    ({pce="Major";id=1},(1,4));
    ({pce="Flag";id=1},(1,5));
    ({pce="Sergeant";id=1},(1,6));
    ({pce="Colonel";id=1},(1,7));
    ({pce="Miner";id=1},(1,8));
    ({pce="General";id=1},(1,9));
    ({pce="Captain";id=2},(1,10));
    ({pce="Miner";id=2},(2,1));
    ({pce="Marshal";id=1},(2,2));
    ({pce="Lieutenant";id=1},(2,3));
    ({pce="Bomb";id=1},(2,4));
    ({pce="Bomb";id=2},(2,5));
    ({pce="Bomb";id=3},(2,6));
    ({pce="Scout";id=2},(2,7));
    ({pce="Lieutenant";id=2},(2,8));
    ({pce="Sergeant";id=2},(2,9));
    ({pce="Corporal";id=1},(2,10))]

let fix_input (inp:string) : string list =
  (*lowercase & get rid of extraneous characters*)
  let input_lower = String.lowercase inp in
  let input_trim = String.trim input_lower in
  (*splits into list*)
  let regex = Str.regexp " +" in
  let ret_list = Str.split regex input_trim in
  ret_list

let print_retry () =
  print_string "------------------------------------------------------------------------";
  print_string "\nThis is an invalid command, please try again.\n"
(*   To see a list of commands, type \"help\".
  Please type a command --> " *)

let extract_piece (pc:string) : piece option=
  let pce_lst = [
    ("spy1",{pce="Spy";id=1});
    ("sco1", {pce="Scout";id=1});
    ("cap1",{pce="Captain";id=1});
    ("maj1",{pce="Major";id=1});
    ("fla1",{pce="Flag";id=1});
    ("ser1",{pce="Sergeant";id=1});
    ("col1",{pce="Colonel";id=1});
    ("min1",{pce="Miner";id=1});
    ("gen1",{pce="General";id=1});
    ("cap2",{pce="Captain";id=2});
    ("min2",{pce="Miner";id=2});
    ("mar1",{pce="Marshal";id=1});
    ("lie1",{pce="Lieutenant";id=1});
    ("bom1",{pce="Bomb";id=1});
    ("bom2",{pce="Bomb";id=2});
    ("bom3",{pce="Bomb";id=3});
    ("sco2",{pce="Scout";id=2});
    ("lie2",{pce="Lieutenant";id=2});
    ("ser2",{pce="Sergeant";id=2});
    ("cor1",{pce="Corporal";id=1}) ] in
  if (List.mem_assoc pc pce_lst) then Some(List.assoc pc pce_lst)
  else None

(*Returns (-1,-1) if incorrect move format*)
let extract_location_str (inp:string list) : string =
  if (List.length inp)-1 = 2 then (List.nth inp 2)
  else if ((List.length inp)-1 = 3 && List.nth inp 2 = "to") then (List.nth inp 3)
  else "(-1,-1)"

let extract_location (inp:string list) : int*int =
  let loc_str = extract_location_str inp in
  (*Check that location is in correct format i.e. (0,0), (10,10)*)
  let loc = (match loc_str with
    | "(-1,-1)" -> (-1,-1)
    | _ -> (
      (*Checks if location has parentheses*)
      let last = (String.length loc_str) - 1 in
      let paren1 = (
        if ((String.contains loc_str '(') && (String.get loc_str 0) = '(') then true
        else false ) in
      let paren2 = (
        if (String.contains loc_str ')' && String.get loc_str last = ')') then true
        else false ) in
      (*Checks that contents of tuple is 2 ints*)
      let comma  = (
        if String.contains loc_str ',' then String.index loc_str ','
        else -1 ) in
      match comma with
      | -1 -> (-1,-1)
      | _    -> (
        if (paren1 && paren2) then
          let before_com =
           (try int_of_string (String.sub loc_str 1 (comma-1))
            with | Failure x -> -1 | Not_found -> -1) in
          let after_com  =
           (try int_of_string (String.sub loc_str (comma+1) (last - comma -1))
            with | Failure x -> -1 | Not_found -> -1) in
          (before_com,after_com)
        else
          (-1,-1)
        )))
    in loc

let rec parse inp =
  let input = fix_input (inp) in
  let fst_cmd = List.nth input 0 in
  (* Extracting cmd type from input *)
  let cmd = match fst_cmd with
    | "quit" -> Quit
    | "q" -> Quit
    | "exit" -> Quit
    | "help" -> Help
    | "h" -> Help
    | "pieces" -> Pieces
    | "graveyard" -> Graveyard
    | "gy" -> Graveyard
    | "board" -> Board
    | "gameboard" -> Board
    | "instructions" -> Instructions
    | "new" -> NewGame
    | "newgame" -> NewGame
    | "quickstart" -> QuickStart
    | "ng" -> NewGame
    | "move" -> (
      (*Extracting piece & location from user input*)
      (*Command can be 'move <piece> to <location>'' or 'move <piece> <location>'*)
      if (List.length input) > 2 then (
        let pce = extract_piece (List.nth input 1) in
        let loc = extract_location input in
        match pce,loc with
        | _,(-1,-1) -> Invalid
        | None,_    -> Invalid
        | Some p,_  -> Move((p,loc))
      )
      else
        Invalid
      )
    (*Command of type 'place <piece> <location>*)
    | "place" -> (
      if (List.length input) = 3 then (
        let pce = extract_piece (List.nth input 1) in
        let loc = extract_location input in
        match pce,loc with
        | _,(-1,-1) -> Invalid
        | None,_    -> Invalid
        | Some p,(-1,_)  -> Invalid
        | Some p,(_,-1)  -> Invalid
        | Some p,_       -> Place((p,loc)) )
    else
      Invalid
    )
    | _ -> Invalid
  in cmd

let new_game () =
  let comp = setup () in
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
  let cor1 = {pce="Corporal";id=1} in
  let piece_list =
    [sp1; sc1; cap1; maj1; f1; ser1; co1; mi1; g1; cap2; mi2; ma1; l1; b1; b2;
    b3; sc2; l2; ser2; cor1]
  in
  let rec build_human hum pieces = (
    if (List.length hum.pieces = List.length comp.pieces && pieces = [])
      then (new_gamestate hum comp)
    else (
      print_string ("\nPlease place these pieces on the board: "^
        (piecelst_to_string pieces));
      Printf.printf "\n\nWhere would you like to place your next piece?
      Format: 'place <piece> <location>'
        - <piece> is the name of the piece as listed in the piece list above
        - <location> is the location formatted as (row,column).
            ex: place Spy1 (2,3)\nType here --> ";
      let input = read_line() in
      (* TODO: not yet fixed *)
      let place = parse (input) in
      match place with
      | Place (pi, loc) -> (
        if (List.mem pi pieces)
        then (
          if ((fst loc) < 3 && (fst loc) > 0 && (snd loc) < 11 && (snd loc) > 0)
          then (
              let board = making_game hum comp in
              if (List.assoc loc board = None)
              then (
                  let new_human = add_human hum comp loc pi in
                  let nboard = making_game new_human comp in
                  print_game_board nboard;
                  build_human new_human (List.filter (fun x -> x <> pi) pieces)
                )
                else (print_string "There is a piece in this location";
                build_human hum pieces)
              )
          else (print_string "\n\nThis location is not in your allocated space of
           the board! Please place your piece within rows 1 and 2 and columns 1-10.
           \n";
           build_human hum pieces)
          )
        else (
          print_string "\n\nThis is not a valid piece\n";
          build_human hum pieces
        )
      )
      | Quit -> print_string "\nOk. Goodbuy!\n\n"; exit 0
      | _ ->
        print_string "--------------------------------------------------------------------";
        print_string "\nThis is not valid syntax for placing your pieces.
        Please try placing a piece.\n";
        build_human hum pieces
    )
  ) in
  let empty_hum = newplayer "human" [] in
  let new_board = making_game empty_hum comp in
  print_game_board new_board;
  let gamestate = build_human empty_hum piece_list
  in print_gamestate gamestate;
  gamestate

let quickstart () =
  let comp = setup () in
  let human = {comp with name = "human"; pieces=hum_quickstart_pces} in
  new_gamestate human comp

(******************************PRINT FUNCTIONS*********************************)

(*call prompt to get the comamand. if command ois quit *)

let print_game gamestate =
  print_gamestate gamestate

let print_piece_list player =
  Printf.printf "     Your list of pieces \n";
  (List.iter
      (fun (piece,(x,y)) ->
        Printf.printf "     piece: %s %d. location: %d %d \n"
          piece.pce piece.id x y)
      player.pieces);
  print_newline ()

let print_graveyard player =
  Printf.printf "     Your graveyard: \n";
  (List.iter
      (fun piece -> Printf.printf "     %s %d \n" piece.pce piece.id)
      player.graveyard);
  print_newline ()

let print_help () =
  print_string "
      This is the help menu for Stratego. The following
      are commands to help you understand the game and remind you of the
      current state of the game:

      [quickstart] will randomly fill the board with your pieces. Convenient to
      begin the game as soon as possible.
      [help] displays this menu again
      [quit] quits the game
      [new] will begin a new game
      [place <piece> <location>] will place the piece (such as Spy1) at
        location (formatted as '(row,column)') in the board. You may only
        place ONE piece at a time.
      [instructions] will print out the instructions on how to play the game
      [move piece location] will move the [piece] to the desired [location].
        - Pieces are named with the first 3 letters and its id
        (ex: Miner with id 1 is 'Min 1').
        - Location is (row,column) as defined on the board
      [pieces] prints the list of your pieces on the board and their location. \n
      [graveyard] prints the list of your pieces in your graveyard
      [board] prints the current game board, displaying your pieces and
        the computer's pieces as X's \n \n"

let print_pieces gamestate = print_piece_list gamestate.human

let print_grave_list gamestate = print_graveyard gamestate.human

let print_board gamestate = print_game gamestate

let print_instructions () =
    print_endline "
      - Stratego's end goal is to capture the opponent's flag while defending
        your own.
      - Each player controls 20 pieces representing individual soldier
        ranks in an army.
      - To start, you must arrange your pieces strategically in the first
        two rows of the board (1 and 2).
      - You cannot see the ranks of the opponent's pieces, they are displayed
        with an X on the gameboard.
      - Each player moves one piece per turn.
      - Movements are only allowed North, South, East, and West.
      - When you want to attack your opponent's piece, move your piece onto
        a square occupied by the oppenent's piece ('X'). When this occurs,
        the weaker piece is removed from the board and placed in its
        respective player's graveyard. If the pieces are of equal rank,
        both are removed.
      - The following are the piece rankings and special cases, assume that
        any piece, unless noted otherwise, can only move 1 space at a time:

        Spy:  rank = 1, Quantity: 1
        Scout (Sco): rank = 2, Quantity: 2,  Can move any number of spaces on
          the board as long as there are no obstacles between
          start and end locations.
        Miner (Min) = rank =3, Quantity: 2, Can defuse bombs
          (miner attacks bomb and remains on board).
        Corporal (Cor) = rank = 4, Quantity: 1
        Sergeant (Ser) = rank = 5, Quantity: 2
        Lieutenant (Lie) = rank = 6, Quantity: 2
        Captain (Cap) = rank = 7, Quantity: 2, Can move up to two spaces on the
          board as long as there are no obstacles between
          start and end locations
        Major (Maj) = rank = 8, Quantity: 1
        Colonel (Col) = rank = 9, Quantity: 1
        General (Gen) = rank = 10, Quantity: 1
        Marshal (Mar) = rank = 11, Quantity: 1
        Flag (Fla) = Quantity: 1, No rank and immovable, but when attacked,
          game ends and attacking player wins the game
        Bomb (Bom) = Quantity: 3, No rank and immovable, but when attacked,
          attacking player loses piece and bomb is
          removed from board.
        \n"

let print_intro () : unit =
  print_string "  Type 'help' to revisit the list of commands, type 'new' to
  get started, 'instructions' to understand how to play, or 'quit'
  if you just aren't up for the challenge right now.\n"

(*Print function for when a player wins.*)
let rec check_for_win new_gs ai_move =
  match new_gs with
  | None -> process new_gs ai_move
  | Some gs ->
    (if gs.human.won then
      (print_string "\nALLSTAR!! YOU HAVE CAPTURED THE FLAG! YOU WIN!\n ";
      print_string "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n";
      print_string "Play again? ";
      process None ai_move)
    else if gs.comp.won then
      (print_string "\nThe computer beat you! AI's are taking over \n";
      print_string "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n ";
      print_string "You can do better than that, try again? ";
      process None ai_move)
    else
      process new_gs ai_move)

(****************************GAME PLAY REPL*************************************)

and quit_game game ai_move =
(*   print_string "Now quitting the game :'( - Play again soon!\n \n"; *)
    print_string "\nAre you sure you would like to quit this game? Type yes or no. \n\n-> ";
    let prompt2 = read_line () in
    let response2 =  String.lowercase(prompt2) in
    if response2 = "no"
    then (print_string "\nOK.\n\n"; process game ai_move)
    else if response2 = "yes" then Printf.printf "\nGoodbuy.\n\n"
    else (print_string "\nPlease answer yes or no."; quit_game game ai_move)

and process gamestate ai_move =
  let name = (
    match gamestate with
    | Some g -> g.turn.name
    | None -> "" ) in
  let cmd = (
    if name = "comp"
      then
        (match next_move gamestate [] ai_move [] with
        | None ->
          print_string "YOU WON!!! The computer has no more moves! \n";
          NewGame
        | Some(piece,loc) -> Move(piece,loc))
    else (
      let _ = (match gamestate with | None -> () | Some g -> print_gamestate g) in
      print_string "To see list of commands, type 'help'\nType a command --> ";
      parse (read_line()))
  )
 in
  match cmd with
  | Quit ->
    let _ = (match gamestate with | None -> () | Some g -> print_gamestate g) in
    (quit_game gamestate ai_move)
  | NewGame -> (
      let g = new_game () in
      process (Some(g)) ai_move
    )
  | Help -> (
      print_help ();
      process gamestate ai_move
    )
  | Move (pce,loc) -> (
      match gamestate with
      | None ->
          (print_string "You must start the game before you can move your pieces!\n";
          print_intro ();
          process gamestate ai_move)
      | Some g ->
          (let new_gs = move g g.turn pce loc in
          match new_gs with
          | None -> process gamestate ai_move
          | Some g -> check_for_win new_gs ai_move)
    )
  | Place (p,l) -> (
      match gamestate with
      | None -> (
        print_string "You must type 'newgame' before placing pieces.";
        process None ai_move )
      | Some g -> (
        print_string "You have already placed all of your pieces! Try another command.\n";
        process gamestate ai_move)
    )
  | Pieces -> (
      match gamestate with
      | None -> (
          print_string "You must start the game before you can print your pieces!\n";
          print_intro ();
          process None ai_move)
      | Some g ->
          print_pieces g;
          process gamestate ai_move
    )
  | Graveyard -> (
      match gamestate with
      | None -> (
          print_string "You must start the game before you can print your graveyard!\n";
          print_intro ();
          process None ai_move)
      | Some g ->
          print_graveyard g.human;
          process gamestate ai_move
    )
  | Board ->(
      match gamestate with
      | None -> (
          print_string "You must start the game before you can print the board!\n";
          print_intro ();
          process None ai_move)
      | Some g ->
          print_board g;
          process gamestate ai_move
    )
  | Instructions -> (
      print_instructions ();
      process gamestate ai_move
    )
  | QuickStart ->  (
      let g = quickstart () in
      process (Some g) ai_move
  )
  | Invalid -> (
      print_retry ();
      process gamestate ai_move
    )

(*Main function that begins gameplay prompting*)
let () =
  Printf.printf "\nWelcome to Stratego!\n\n";
  print_string "Check out the commands below.\n";
  print_intro ();
  print_help ();
  process None None

