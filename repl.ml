open Gamestate
open Ai
open Pervasives
(* NOTE: WHEN COMPILING, USE 'cs3110 compile -p str repl.ml' *)

(*TODO: add function to print opponent's graveyard list*)
(*TODO: add restart function*)
(*TODO: check the 'won' flag in gamestate*)

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

let fix_input (inp:string) : string list =
  (*lowercase & get rid of extraneous characters*)
  let input_lower = String.lowercase inp in
  let input_trim = String.trim input_lower in
  (*splits into list*)
  let regex = Str.regexp " +" in
  let ret_list = Str.split regex input_trim in
  ret_list

let print_retry () =
  print_string "This is an invalid move command, please try again.\n
                      To see a list of commands, type \"help\".\n\n
                      Please type a command --> "

let extract_piece (pc:string) : piece =
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
  let ret_pce = (List.assoc pc pce_lst) in
  ret_pce

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
      let last =  (String.length loc_str) - 1 in
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
           (try int_of_string (String.sub loc_str comma (last - comma +1))
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
    | "ng" -> NewGame
    | "move" -> (
      (*Extracting piece & location from user input*)
      (*Command can be 'move <piece> to <location>'' or 'move <piece> <location>'*)
      if (List.length input) > 2 then (
        let pce = extract_piece (List.nth input 1) in
        let loc = extract_location input in
        match loc with
        | (-1,-1) -> Invalid
        | _ -> Move((pce,loc))
      )
      else
        Invalid
      )
    (*Command of type 'place <piece> <location>*)
    | "place" -> (
      if (List.length input) = 3 then (
        let pce = extract_piece (List.nth input 1) in
        let loc = extract_location input in
        match loc with
        | (-1,-1) -> Invalid
        | _ -> Place((pce,loc)) )
    else
      Invalid
    )
    | _ -> Invalid
  in cmd


(* TODO: Need testing!! *)
(* TODO: didn't fix failwith thing for checking if pieces are placed appropriately *)
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
  let rec build_human hum c pieces = (
    let new_board = making_game hum c in
    print_game_board new_board;
    if (List.length hum.pieces = List.length comp.pieces && pieces = [])
      then (let newer = new_gamestate hum c in newer)
    else (
      print_string ("\n\nPlease place these pieces on the board: "^
        (piecelst_to_string pieces));
      print_string "\n\nWhere would you like to place your next piece -> ";
      let input = read_line() in
      (* TODO: not yet fixed *)
      let place = parse input in
      match place with
      | Place (pi, loc) -> (
        if (List.mem pi pieces) then (
          let new_human = add_human hum c loc pi in
          build_human new_human c (List.filter (fun x -> x <> pi) pieces)
        )
        else (
          print_string "\n\nThis is not a valid piece";
          build_human hum c pieces
        )
      )
      | _ -> print_string "\n\nThis is not valid syntax for placing your pieces.
                            \nPlease try placing a piece.\n";
        build_human hum c pieces
    )
  ) in
  let empty_hum = newplayer "human" [] in
  build_human empty_hum comp piece_list

(*TODO: implement*)
let quit gamestate =
  print_string "Now quitting the game :'( -- Play again soon!!\n\n"
(*   let rec quitted (game: gamestate):unit = (
    let prompt2 = print_string "\nAre you sure you would like to quit this game?\n\n-> " in
    let response2 =  String.lowercase(read_line prompt2) in
    if response2 = "no"
      then (print_string "\nOK.\n\n"; prompt game)
      else if response2 = "yes" then Printf.printf "\nOK.\n\n";
      else (print_string "\nPlease answer the question."; quitted game)
    )
  in quitted gamestate
 *)

(******************************PRINT FUNCTIONS*********************************)

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

      [help] displays this menu again
      [quit] quits the game
      [new] will begin a new game
      [instructions] will print out the instructions on how to play the game
      [move piece location] will move the [piece] to the desired [location].
        - Pieces are named with the first 3 letters and its id
        (ex: Miner with id 1 is 'Min 1').
        - Location is (row,column) as defined on the board
      [pieces] prints the list of your pieces on the board and their location
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

        Spy:  rank = 1
        Scout (Sco): rank = 2  Can move any number of spaces on
          the board as long as there are no obstacles between
          start and end locations.
        Miner (Min) = 3. Can defuse bombs
          (miner attacks bomb and remains on board).
        Corporal (Cor) = 4.
        Sergeant (Ser) = 5
        Lieutenant (Lie) = 6
        Captain (Cap) = 7. Can move up to two spaces on the
          board as long as there are no obstacles between
          start and end locations
        Major (Maj) = 8
        Colonel (Col) = 9n
        General (Gen) = 10
        Marshal (Mar) = 11
        Flag (Fla) = No rank and immovable, but when attacked,
          game ends and attacking player wins the game
        Bomb (Bom) = No rank and immovable, but when attacked,
          attacking player loses piece and bomb is
          removed from board.
        \n"

let print_intro () : unit =
  print_string "  Type 'help' to revisit the list of commands, type 'new' to
  get started, 'instructions' to understand how to play, or 'quit'
  if you just aren't up for the challenge right now.\n"

(*TODO: Print function for when a player wins. Add in restart capabilities*)
(* let check_for_win gamestate : bool =
  match gamestate with
  | None -> false
  | Some x -> (
      if x.turn.won = true
      then true (print_game x; win ())
  print_string "
    \n\n~~~~~~~~~~~~~~~~~~~~~~~~~WINNER!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n" *)

(****************************GAME PLAY REPL*************************************)

(*NOTE: gamestate now takes in a gamestate option; need to make appropriate changes*)
(*TODO: I took out bool in the (bool*gamestate) tuple so need to actually change
 the "turn" field in gamestate at each stage for whose turn it is *)
(*TODO: process needs to return a unit because this is the main repl function.
This might conflict with how the 'move' function returns a gamestate option.*)
let rec process gamestate =
  (*TODO: check if 'won' is true*)
  print_string "Type a command --> ";
  let cmd = parse (read_line()) in
  match cmd with
  | Quit -> (quit gamestate)
  | NewGame -> (
      let g = new_game () in
      print_game g;
      process (Some(g))
    )
  | Help -> (
      print_help ();
      process gamestate
    )
  | Move (pce,loc) -> (
      match gamestate with
      | None -> (
          print_string "You must start the game before you can print your pieces!\n";
          print_intro ();
          process None)
      | Some g -> (
        process (move g g.turn pce loc) )
    )
  | Place (p,l) -> (
      match gamestate with
      | None -> print_string "Initialization failed. Please quit and try again."
      | Some g -> (
        print_string "You have already placed all of your pieces!\n";
        process gamestate )
    )
  | Pieces -> (
      match gamestate with
      | None -> (
          print_string "You must start the game before you can print your pieces!\n";
          print_intro ();
          process None )
      | Some g ->
          print_pieces g;
          process gamestate
    )
  | Graveyard -> (
      match gamestate with
      | None -> (
          print_string "You must start the game before you can print your graveyard!\n";
          print_intro ();
          process None )
      | Some g ->
          print_graveyard g.human;
          process gamestate
    )
  | Board ->(
      match gamestate with
      | None -> (
          print_string "You must start the game before you can print the board!\n";
          print_intro ();
          process None )
      | Some g ->
          print_graveyard g.human;
          process gamestate
    )
  | Instructions -> (
      print_instructions ();
      process gamestate
    )
  | Invalid -> (
      print_retry ();
      process gamestate
    )

(*Main function that begins gameplay prompting*)
(*NOTE: I think main function needs to be all units; can't return gamestate*)
let () =
  Printf.printf "\nWelcome to Stratego!\n\n";
  print_string "Check out the commands below.\n";
  print_intro ();
  print_help ();
  process None

