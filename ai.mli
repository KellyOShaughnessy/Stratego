open Gamestate
open Repl

(* [setup game_board] takes the the pieces for the computer player
during initialization *)
val setup         : game_board -> (game_board * player)

(* [next_move gamestate] takes a gamestate and returns a command
for the next move *)
val next_move     : gamestate -> (dir * int)

(* Computer chooses its next move *)
val computer_move : game_board -> player -> (piece*location)

(*

1. Place 20 pieces within first two rows (rows 10 & 9)
2. Surround it's flag with 3 bombs or higher ranked pieces.
3. to initially move, select piece in row 9 at random and depending
on what that piece is, move up (row 8) that many respective tiles...
    -if Scout or captain (2 tiles max) can check if there is a piece in the way, then can proceed to attack that piece
        - smart AI will check of surounding pieces near destination, to avoid being attacks
4. if it doesnt hit anything, save that piece (id and all) in a next move list
so that it can move that piece next to advance towards the opponents side.
5. before every piece is moved, it checks its surroundings locations, 1 tile up down east west
too see which direction it should move in.
6. if it gets "bombed" then save that tile on a potential_flag list and save that location.
7. computer will try to get its higher ranked pieces to that location in the potential_flag list.
8. If any pieces (of the computers) does get attacked then start moving a random piece of a
higer rank.
9.
*)