open Gamestate
(* NOTE: WHEN COMPILING, USE 'cs3110 compile -p str repl.ml' *)

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

(*We should have a start function where it prints the directions and then
 *starts prompt.*)
(*Could also have functions that print*)
let fix_input (inp:string) : string list =
  (*lowercase & get rid of extraneous characters*)
  let input_lower = String.lowercase inp in
  let input_better = Str.global_replace (Str.regexp "[^0-9a-zA-Z ]+") "" input_lower in
  (*splits into list*)
  let regex = Str.regexp " +" in
  let ret_list = Str.split regex input_better in
  ret_list

let rec parse () =
  print_string "\n\nPlease type a command -->";
  let input = fix_input (read_line()) in
  let fst_cmd = List.nth input 0 in
  (* Extracting cmd type from input *)
  let cmd = (
    if (fst_cmd = "quit" || fst_cmd = "q" || fst_cmd = "exit") then Quit
    else if (fst_cmd = "new game" || fst_cmd = "ng") then NewGame
    else if (fst_cmd = "help" || fst_cmd = "h") then Help
    else if (fst_cmd = "move" || fst_cmd = "m") then
        failwith "unimplemented"
    else if (fst_cmd = "place" || fst_cmd =  "p" || fst_cmd = "put") then
        failwith "unimplemented"
    else let () = print_string "\n\nWhat was that again?" in Invalid
    ) in
  match cmd with
  | Invalid -> parse ()
  | _ -> cmd

let new_game () = failwith "unimplemented"

let quit gamestate = failwith "unimplemented"
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
  Printf.printf "
      This is the help menu for Stratego. The following
      are commands to help you understand the game and remind you of the
      current state of the game:

      [help] displays this menu again
      [quit] quits the game
      [new game] will begin a new game
      [instructions] will print out the instructions on how to play the game
      [move piece location] will move the [piece] to the desired [location].
        - Pieces are named with the first 3 letters and its id
        (ex: Miner with id 1 is 'Min 1').
        - Location is (row,column) as defined on the board
      [pieces] prints the list of your pieces on the board and their location
      [graveyard] prints the list of your pieces in your graveyard
      [board] prints the current game board, displaying your pieces and
        the computer's pieces as X's \n \n"

  (* | "pieces" -> print_piece_list gamestate.human
  | "graveyard" -> print_graveyard gamestate.human
  | "board" -> print_game gamestate
  | "instructions" -> print_endline "
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
    | _ -> Printf.printf "Not a valid help command, please try again. \n" *)

let process gamestate cmd =
  match cmd with
  | Quit -> (false, quit gamestate)
  | NewGame -> (true, new_game ())
  | Help -> print_help (); (false, gamestate)
  | Move (pce,loc) ->
      move gamestate gamestate.turn pce loc
  | Place (p,l) -> failwith "unimplemented"
  | Pieces -> failwith "unimplemented"
  | Graveyard -> failwith "unimplemented"
  | Board -> failwith "unimplemented"
  | Instructions -> failwith "unimplemented"
  | _ -> failwith "unimplemented"
