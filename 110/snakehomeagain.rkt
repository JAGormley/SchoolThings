;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname snakehomeagain) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)




(define BOARD-SIZE 10)   ; The board is 10 cells by 10 cells

(define CELL-PIXELS 14)                         ; cells are square
(define BOARD-WIDTH (* BOARD-SIZE CELL-PIXELS)) ;
(define BOARD-HEIGHT BOARD-WIDTH)               ;


(define HEAD (circle (/ CELL-PIXELS 2) "solid" "green"))
(define BODY (circle (/ CELL-PIXELS 2) "solid" "red"))
(define FOOD (circle (/ CELL-PIXELS 2) "solid" "blue"))


(define MTS (empty-scene BOARD-WIDTH BOARD-HEIGHT))







(define-struct cell (c r))   

(define C1 (make-cell 0 BOARD-SIZE))
(define C2 (make-cell BOARD-SIZE 0))


(define-struct snake (dir head)) 

(define S1 (make-snake "D" (make-cell 5 5)))


(define-struct game (snake))


(define G1 (make-game (make-snake "D" (make-cell 4 7))))








(define (main g)
  (big-bang g
            (on-tick   next-game 1)     ; Game -> Game
            (to-draw   render-game)      ; Game -> Image
            (on-key    controls)))    ; Game KeyEvent -> Game


                                        

(define (next-game g)  ; Template from Game
  (make-game (next-snake (game-snake g))))



(define (next-snake s)         ;; Tempate from Snake
  (make-snake (snake-dir s)
       (next-cell (snake-dir s)(snake-head s))))




(define (next-cell d cl) 
   (cond [(string=? d "U") (make-cell (cell-c cl) (sub1 (cell-r cl)))]
         [(string=? d "D") (make-cell (cell-c cl) (add1 (cell-r cl)))]
         [(string=? d "L") (make-cell (sub1 (cell-c cl)) (cell-r cl))]
         [(string=? d "R") (make-cell (add1 (cell-c cl)) (cell-r cl))]))




(check-expect (controls (make-snake (make-snake "U" (make-cell 5 5)))) (make-game (make-snake "L" (make-cell 5 5))))

(define (controls g)
  (control-snake (game-snake g)))



(check-expect (control-snake (make-snake "U" (make-cell 5 5)) "S" ) (make-snake "L" (make-cell 5 5)))

(define (control-snake s key)
  (cond [(key=? key "W") (make-game (make-snake "U" (snake-head s)))]
        [(key=? key "S") (make-game (make-snake "D" (snake-head s)))]
        [(key=? key "A") (make-game (make-snake "L" (snake-head s)))]
        [(key=? key "D") (make-game (make-snake "R" (snake-head s)))]
        [else s]))




(define (place-in-cell img cl scn)
  (place-image img 
               (+ (* (cell-c cl) CELL-PIXELS) (/ CELL-PIXELS 2))
               (+ (* (cell-r cl) CELL-PIXELS) (/ CELL-PIXELS 2))
               scn))




(define (render-game g)
  (draw-snake (game-snake g)))




(define (draw-snake s)
  (place-in-cell HEAD 
                 (snake-head s)
                 MTS))


               

(main (make-game (make-snake "L" (make-cell 5 (sub1 BOARD-SIZE)))))
