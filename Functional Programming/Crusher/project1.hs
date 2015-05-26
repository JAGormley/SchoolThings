{- Susannah Kirby
   Andrew Gormley -}

import Data.List


-- = * MAIN * = --


crusher_e5r8 history side minimax_height n = minimax_e5r8 history side minimax_height n


-- = * BOARD EVALUATION * = --


{- Static board evaluation function -}
evaluation_e5r8 board side n
   | win_e5r8 board side n   = (100::Int)
   | loss_e5r8 board side n  = (-100::Int)
   | otherwise               = advantage_e5r8 board side

{- Checks to see if someone has won -}
game_over_e5r8 board side n = win_e5r8 board side n || loss_e5r8 board side n
win_e5r8 board side n = n_pieces_captured_e5r8 board side n
loss_e5r8 board side n = win_e5r8 board (opponent_e5r8 side) n
n_pieces_captured_e5r8 board side n = (number_on_board_e5r8 board (opponent_e5r8 side) < n)
number_on_board_e5r8 board side = length (filter (==side) board)

{- Checks to see what a player's advantage is, in terms number of pieces -}
advantage_e5r8 board side = (number_on_board_e5r8 board side) -
                            (number_on_board_e5r8 board (opponent_e5r8 side))

{- Defines the opponent of each player -}
opponent_e5r8 'W' = 'B'
opponent_e5r8 'B' = 'W'


-- = * MINIMAX SEARCH * = --


{- Constant to initialize best (board, rating) tuple -}
curr_max_e5r8 = ("fakeboard", -100000)
curr_min_e5r8 = ("fakeboard", 100000)

{- Getters for (board, rating) tuples -}
board_e5r8 (x, y) = x
rating_e5r8 (x, y) = y

{- Returns MAX-rated child node, cons'ed to game history -}
minimax_e5r8 history side mm_ht n
   | length rated_children == 0 = ((head history):history)
   | otherwise                  = ((board_e5r8 (max_board_with_rating_e5r8
                                               rated_children curr_max_e5r8)):history)
     where
     rated_children = generate_evaluate_children_e5r8 history side mm_ht n (mm_ht-1) (1::Int)

{- Returns a list of (board, rating) tuples representing child nodes with ratings -}
generate_evaluate_children_e5r8 history side mm_ht n height depth =
   evaluate_boards_e5r8 child_nodes history side mm_ht n height depth []
   where
   child_nodes = generate_moves_e5r8 history [(get_side_e5r8 side depth)] mm_ht n

{- Determines whose turn it would be at this depth in the minimax look-ahead -}
get_side_e5r8 side depth
   | (odd depth)  = side
   | (even depth) = (opponent_e5r8 side)

{- Takes a list of boards, returns a list of (board, rating) tuples -}
evaluate_boards_e5r8 [] history side mm_ht n height depth board_tuples = board_tuples
evaluate_boards_e5r8 (b:bs) history side mm_ht n height depth board_tuples =
   evaluate_boards_e5r8 bs history side mm_ht n height depth
   ((evaluate_board_e5r8 (b:history) side mm_ht n height depth):board_tuples)

{- Evaluates a board given height in minimax look-ahead tree; returns a (board, rating) tuple -}
evaluate_board_e5r8 history side mm_ht n 0 depth =
   ((head history), (evaluation_e5r8 (head history) side n))
evaluate_board_e5r8 history side mm_ht n height depth
   | game_over_e5r8 bd side n  = (bd, evaluation_e5r8 bd side n)
   | (even depth)              = (bd, rating_e5r8
                                      (max_board_with_rating_e5r8 rated_children curr_max_e5r8))
   | (odd depth)               = (bd, rating_e5r8
                                      (min_board_with_rating_e5r8 rated_children curr_min_e5r8))
     where
     bd = head history
     rated_children = generate_evaluate_children_e5r8 history
                      (opponent_e5r8 side) mm_ht n (height-1) (depth+1)

{- Takes a list of (board, rating) tuples, returns MAX-rated tuple -}
max_board_with_rating_e5r8 [] current_max = current_max
max_board_with_rating_e5r8 (t:ts) current_max
   | (rating_e5r8 t) > (rating_e5r8 current_max)  = max_board_with_rating_e5r8 ts t
   | otherwise                                    = max_board_with_rating_e5r8 ts current_max

{- Takes a list of (board, rating) tuples, returns MIN-rated tuple -}
min_board_with_rating_e5r8 [] current_min = current_min
min_board_with_rating_e5r8 (t:ts) current_min
   | (rating_e5r8 t) < (rating_e5r8 current_min)  = min_board_with_rating_e5r8 ts t
   | otherwise                                    = min_board_with_rating_e5r8 ts current_min


-- = * MOVE GENERATION * = --


{- Takes a string board, returns a list of boards representing all possible moves -}
generate_moves_e5r8 history side minimax_height n =
   map board_stitcher_e5r8 (gen_moves_h_e5r8 (board_splitter_e5r8 (head history) n)
      side n (history_splitter_e5r8 history n) (6::Int))
gen_moves_h_e5r8 board p_colour n history rotate_6
  | (rotate_6 == 0) = []
  | otherwise       = (process_lines_e5r8 board board 0 p_colour history n rotate_6) ++
                      (gen_moves_h_e5r8 (board_splitter_e5r8 (rotate_e5r8 board n) n)
                      p_colour n history (rotate_6-1))

{- Takes a board line, gets every possible move, returns a new board with each move -}
process_lines_e5r8 [] orig_b height p_colour history n rotations = []
process_lines_e5r8 (x:xs) orig_b height p_colour history n rotations
   = (( (step_left_e5r8 x 0 height orig_b p_colour history n rotations)
    ++ (jump_left_e5r8 x 0 height orig_b p_colour history n rotations) ))
    ++ (process_lines_e5r8 xs orig_b (height+1) p_colour history n rotations)

{- Generates left slide move -}
step_left_e5r8 line index height orig_b p_colour history n rotations
  | (index == (length line)) = (step_left_h_e5r8 line index height orig_b p_colour history n rotations)
  | (index == 0)             = step_left_e5r8 line (index+1) height orig_b p_colour history n rotations
  | (index >= 1)             = (step_left_h_e5r8 line index height orig_b p_colour history n rotations
                               ++ (step_left_e5r8 line (index+1) height orig_b p_colour
                                  history n rotations))

step_left_h_e5r8 line index height orig_b p_colour history n rotations
  | ([take 1 (drop (index) line)] == [p_colour])
    && ([take 1 (drop (index-1) line)]) == ["-"]  = construct_board_e5r8
                                                    [(take (index-1) line)++(p_colour++"-") ++
                                                    (drop (index+1) line)]
                                                    height orig_b history n rotations
  | otherwise                                     = []

{- Generates left jump move -}
jump_left_e5r8 line index height orig_b p_colour history n rotations
  | (index == (length line)) = []
  | (index <= 1)             = jump_left_e5r8 line (index+1) height orig_b p_colour history n rotations
  | (index >= 2)             = (jump_left_h_e5r8 line index height orig_b p_colour history n rotations
                               ++ (jump_left_e5r8 line (index+1) height orig_b p_colour
                                  history n rotations))

jump_left_h_e5r8 line index height orig_b p_colour history n rotations
  | ([take 1 (drop (index) line)] == [p_colour])
    && (([take 1 (drop (index-1) line)]) == [p_colour])
    && (([take 1 (drop (index-2) line)]) /= [p_colour]) = construct_board_e5r8
                                                          [(take (index-2) line)
                                                          ++ (p_colour
                                                          ++ (take 1 (drop (index-1) line))
                                                          ++ "-") ++ (drop (index+1) line)]
                                                          height orig_b history n rotations
  | otherwise                                           = []

{- Reconstructs the board from pieces representing former board and new move -}
construct_board_e5r8 new_line height orig_b history n rotations =
   check_history_e5r8 [(take height orig_b) ++ new_line ++ (drop (height+1) orig_b)]
   history n rotations
check_history_e5r8 board history n rotations
  | (board_splitter_e5r8 (rotate_cw_e5r8 (board_stitcher_e5r8 board)
                         n (rotations)) n) `elem` history            = []
  | otherwise   = [(board_splitter_e5r8 (rotate_cw_e5r8 (board_stitcher_e5r8 board) n (rotations)) n)]

{- Rotation (ClockWise; CounterClockWise) -}
rotate_cw_e5r8 board n i
  | (i == 0)      = board_stitcher_e5r8 board
  | otherwise     = rotate_cw_e5r8 (board_splitter_e5r8 (rotate_e5r8 board n) n) n (i-1)
rotate_ccw_e5r8 board n i = rotate_ccw_h_e5r8 (board_stitcher_e5r8 board) n i
rotate_ccw_h_e5r8 board n i
  | (i == 0)      = board
  | otherwise     = rotate_ccw_h_e5r8 (board_stitcher_e5r8 (map reverse (board_splitter_e5r8
                    (rotate_e5r8 (map reverse (board_splitter_e5r8 board n)) n) n))) n (i-1)
rotate_e5r8 board n = rotate_h_e5r8 (prep_board_e5r8 board n) n
rotate_h_e5r8 (x:xs) n
  | null x            = []
  | (head x) == '&'   = rotate_h_e5r8 (xs++[(tail x)]) n
  | otherwise         = ((head x) : (rotate_h_e5r8 (xs++[(tail x)]) n))

{- Rotation helper -}
prep_board_e5r8 board n = prep_board_h_e5r8 board n 0
prep_board_h_e5r8 board n count = pad_e5r8 (reverse board) n count

{- Pads the board in preparation for rotation -}
pad_e5r8 (x:xs) n count
  | null xs             = [pad_right_e5r8 x n count]
  | (count < n)         = (pad_left_e5r8 x n count) : (pad_e5r8 xs n (count+1))
  | (count >= n)        = (pad_right_e5r8 x n count) : (pad_e5r8 xs n (count+1))
  | otherwise           = []
pad_left_e5r8 x n count =  ((pad_gen_e5r8 (n-count-1)) ++ x)
pad_right_e5r8 x n count =  (x ++ (pad_gen_e5r8 (count-n+1)))
pad_gen_e5r8 count
  | count == 0    = []
  | otherwise     = '&':(pad_gen_e5r8 (count-1))

{- Splits board into a list of strings -}
board_splitter_e5r8 board n = board_splitter_h_e5r8 board n 0 0
board_splitter_h_e5r8 board n acc taker
  | null board = []
  | acc < n    = (take (n+acc) board):(board_splitter_h_e5r8 (drop (n+acc) board) n (acc+1) (taker+1))
  | otherwise  = (take (n+taker-2) board):
                 (board_splitter_h_e5r8 (drop (n+taker-2) board) n (acc+1) (taker-1))

{- Stitches list of strings back into a single string board -}
board_stitcher_e5r8 board_parts
  | null board_parts  = []
  | otherwise         = (head board_parts) ++ (board_stitcher_e5r8 (tail board_parts))

{- Splits all boards in the game history -}
history_splitter_e5r8 history n
  | null history = []
  | otherwise    = (board_splitter_e5r8 (head history) n) : (history_splitter_e5r8 (tail history) n)


