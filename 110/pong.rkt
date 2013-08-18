;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname pong) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

(define BOARDW 1280)
(define BOARDH 720)

(define SPEED 25)
(define BLANK (square 0 "outline" "black"))
(define PSPEED 30)
(define PADL 100)

(define BOARD (empty-scene BOARDW BOARDH "black"))
(define PBLOCK (square (/ PADL 7) "solid" "white"))
(define PADDLE (rectangle (/ PADL 7) (* 6 (/ PADL 7)) "solid" "white"))
(define BALL PBLOCK)



(define-struct ball (x y dir ydir ang))
;; ball is (make-ball number number boolean boolean number)
;; interp. a ball with pos x y, moving right or left, up or down, and at an angle

(define-struct pad (y dir))
;; pad is (make-pad number boolean)
;; interp. a paddle with a y pos that moves up or down

(define-struct pads (pad1 pad2))
;; pads is (make-pads pad pad)
;; interp. the state the pads of player1 and player2

(define-struct score (s1 s2))
;; score is (make-score natural natural)
;; interp. the score of each of the 2 players

(define-struct game (ball pad score))
;; game is (make-game ball pads score)
;; interp. the current state of the elements of the game


;; <FUNCTIONS> ;;

(define (main gs)
  (big-bang gs
            (on-tick tick .035)
            (to-draw render)
            (on-key move)))



;; GAME -> GAME
;; interp. advances game state per tick

(define (tick gs)
  (make-game (move-ball (game-ball gs)
                        (game-pad gs))
             (move-pads (game-pad gs))
             (check-score (game-score gs)
                          (game-ball gs))))


(define (check-score s b)
  (cond [(< (ball-x b) 0)
         (make-score (score-s1 s)
                     (add1 (score-s2 s)))]
        [(> (ball-x b) BOARDW)
         (make-score (add1 (score-s1 s))
                     (score-s2 s))]
        [else s]))



;; BALL -> BALL
;; interp. moves the ball depending on conds

(define (move-ball b ps)
  (cond 
    
    ;;;;;;;WALLS;;;;;;;;
    
    [(> (ball-x b) BOARDW)
     (make-ball (* BOARDW (/ 2 3))
                (/ BOARDH 2)                  
                false
                (ball-ydir b)
                0)]
    
    [(< (ball-x b) 0)
     (make-ball (/ BOARDW 3)
                (/ BOARDH 2) 
                true
                (ball-ydir b)
                0)]
    
    [(> (ball-y b) BOARDH)
     (make-ball (ball-x b)
                (- (ball-y b) SPEED)
                (ball-dir b)
                false
                (ball-ang b))]
    
    [(< (ball-y b) 0)
     (make-ball (ball-x b)
                (+ SPEED (ball-y b))
                (ball-dir b)
                true
                (ball-ang b))]
    
    
    
    
    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;PAD1;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;;;;;DOWN;;;;;;;;;;;
    
    [(and (and (< (ball-x b) (+ 30 (/ BOARDW 6)))
               (> (ball-x b) (- (/ BOARDW 6) 5)))  
          (and (< (+ (/ PADL 2.8) (pad-y (pads-pad1 ps))) (ball-y b))
               (>= (+ (/ PADL 2) (pad-y (pads-pad1 ps))) (ball-y b))))           
     (make-ball (+ SPEED (ball-x b))
                (ball-y b)
                true
                true
                35)]
    
    [(and (and (< (ball-x b) (+ 30 (/ BOARDW 6)))
               (> (ball-x b) (- (/ BOARDW 6) 5)))                
          (and (< (+ (/ PADL (/ 14 3)) (pad-y (pads-pad1 ps))) (ball-y b))
               (>= (+ (/ PADL 2.8) (pad-y (pads-pad1 ps))) (ball-y b))))                          
     (make-ball (+ SPEED (ball-x b))
                (ball-y b)
                true
                true
                15)]
    
    [(and (and (< (ball-x b) (+ 30 (/ BOARDW 6)))
               (> (ball-x b) (- (/ BOARDW 6) 5)))  
          (and (< (+ (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))
               (>= (+ (pad-y (pads-pad1 ps)) (/ PADL (/ 14 3))) (ball-y b))))                           
     (make-ball (+ SPEED (ball-x b))
                (ball-y b)
                true
                true
                5)]
    
    
    ;;;;;;;;STRAIGHT;;;;;;;;        
    
    
    [(and (and (< (ball-x b) (+ 30 (/ BOARDW 6)))
               (> (ball-x b) (- (/ BOARDW 6) 5)))  
          (and (<= (- (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))
               (>= (+ (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))))                           
     (make-ball (+ SPEED (ball-x b))
                (ball-y b)
                true
                true
                0)]
    
    
    ;;;;;;;;;UP;;;;;;;;;;;
    
    [(and (and (< (ball-x b) (+ 30 (/ BOARDW 6)))
               (> (ball-x b) (- (/ BOARDW 6) 5)))                
          (and (<= (- (pad-y (pads-pad1 ps)) (/ PADL (/ 14 3))) (ball-y b))
               (> (- (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))))         
     (make-ball (+ SPEED (ball-x b))
                (ball-y b)
                true
                false
                5)]
    
    [(and (and (< (ball-x b) (+ 30 (/ BOARDW 6)))
               (> (ball-x b) (- (/ BOARDW 6) 5)))              
          (and (<= (- (pad-y (pads-pad1 ps)) (/ PADL 2.8)) (ball-y b))
               (> (- (pad-y (pads-pad1 ps)) (/ PADL (/ 14 3))) (ball-y b))))        
     (make-ball (+ SPEED (ball-x b))
                (ball-y b)
                true
                false
                15)]
    
    [(and (and (< (ball-x b) (+ 30 (/ BOARDW 6)))
               (> (ball-x b) (- (/ BOARDW 6) 5)))
          (and (<= (- (pad-y (pads-pad1 ps)) (/ PADL 2)) (ball-y b))
               (> (- (pad-y (pads-pad1 ps)) (/ PADL 2.8)) (ball-y b))))         
     (make-ball (+ SPEED (ball-x b))
                (ball-y b)
                true
                false
                35)]       
    
    
    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;PAD2;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    ;;;;;;;;;DOWN;;;;;;;;;;;
    
    [(and (and (< (ball-x b) (+ 5 (* BOARDW (/ 5 6))))
               (> (ball-x b) (- (* BOARDW (/ 5 6)) 30)))  
          (and (< (+ (/ PADL 2.8) (pad-y (pads-pad2 ps))) (ball-y b))
               (>= (+ (/ PADL 2) (pad-y (pads-pad2 ps))) (ball-y b))))           
     (make-ball 
      (- (ball-x b) SPEED)
      (ball-y b)
      false
      true
      35)]
    
    [(and (and (< (ball-x b) (+ 5 (* BOARDW (/ 5 6))))
               (> (ball-x b) (- (* BOARDW (/ 5 6)) 30)))               
          (and (< (+ (/ PADL (/ 14 3)) (pad-y (pads-pad2 ps))) (ball-y b))
               (>= (+ (/ PADL 2.8) (pad-y (pads-pad2 ps))) (ball-y b))))                          
     (make-ball (- (ball-x b) SPEED)
                (ball-y b)
                false
                true
                15)]
    
    [(and (and (< (ball-x b) (+ 5 (* BOARDW (/ 5 6))))
               (> (ball-x b) (- (* BOARDW (/ 5 6)) 30))) 
          (and (< (+ (pad-y (pads-pad2 ps)) (/ PADL 22)) (ball-y b))
               (>= (+ (pad-y (pads-pad2 ps)) (/ PADL (/ 14 3))) (ball-y b))))                           
     (make-ball (- (ball-x b) SPEED)
                (ball-y b)
                false
                true
                5)]
    
    
    ;;;;;;;;STRAIGHT;;;;;;;;        
    
    
    [(and (and (< (ball-x b) (+ 5 (* BOARDW (/ 5 6))))
               (> (ball-x b) (- (* BOARDW (/ 5 6)) 30))) 
          (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL 22)) (ball-y b))
               (>= (+ (pad-y (pads-pad2 ps)) (/ PADL 22)) (ball-y b))))                           
     (make-ball (- (ball-x b) SPEED)
                (ball-y b)
                false
                true
                0)]
    
    
    ;;;;;;;;;UP;;;;;;;;;;;
    
    [(and (and (< (ball-x b) (+ 5 (* BOARDW (/ 5 6))))
               (> (ball-x b) (- (* BOARDW (/ 5 6)) 30)))               
          (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL (/ 14 3))) (ball-y b))
               (> (- (pad-y (pads-pad2 ps)) (/ PADL 22)) (ball-y b))))         
     (make-ball (- (ball-x b) SPEED)
                (ball-y b)
                false
                false
                5)]
    
    [(and (and (< (ball-x b) (+ 5 (* BOARDW (/ 5 6))))
               (> (ball-x b) (- (* BOARDW (/ 5 6)) 30)))             
          (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL 2.8)) (ball-y b))
               (> (- (pad-y (pads-pad2 ps)) (/ PADL (/ 14 3))) (ball-y b))))        
     (make-ball (- (ball-x b) SPEED)
                (ball-y b)
                false
                false
                15)]
    
    [(and (and (< (ball-x b) (+ 30 (* BOARDW (/ 5 6))))
               (> (ball-x b) (- (* BOARDW (/ 5 6)) 5)))
          (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL 2)) (ball-y b))
               (> (- (pad-y (pads-pad2 ps)) (/ PADL 2.8)) (ball-y b))))         
     (make-ball (- (ball-x b) SPEED)
                (ball-y b)
                false
                false
                35)]
    
    
      
    ;;;;;;;;;;NO CONTACT;;;;;;;;;
    
    [(ball-dir b)
     (make-ball (+ (ball-x b) SPEED)
                (if (ball-ydir b)
                    (+ (ball-y b) (ball-ang b))
                    (- (ball-y b) (ball-ang b)))
                (ball-dir b)
                (ball-ydir b)
                (ball-ang b))]
    [(not (ball-dir b))      
     (make-ball (- (ball-x b) SPEED)
                (if (ball-ydir b)
                    (+ (ball-y b) (ball-ang b))
                    (- (ball-y b) (ball-ang b)))
                (ball-dir b)
                (ball-ydir b)
                (ball-ang b))])) 



;; PADS -> PADS
;; interp. moves the pads

(define (move-pads ps)
  (make-pads (move1 (pads-pad1 ps))
             (move2 (pads-pad2 ps))))



(define (move1 p)
  (cond [(string=? (pad-dir p) "w")
         (if (<= (- (pad-y p) (* 3 (image-width PBLOCK))) 0)
             p
             (make-pad (- (pad-y p) PSPEED)
                       (pad-dir p))
             )]
        [(string=? (pad-dir p) "s")
         (if (>= (+ (* 3.5 (image-width PBLOCK)) (pad-y p)) BOARDH)
             p
             (make-pad (+ (pad-y p) PSPEED)
                       (pad-dir p))
             )]))



(define (move2 p)    
  (cond  [(string=? (pad-dir p) "up")
          (if (<= (- (pad-y p) (* 3 (image-width PBLOCK))) 0)
              p             
              (make-pad (- (pad-y p) PSPEED)
                        (pad-dir p)))]
         
         [(string=? (pad-dir p) "down")
          (if (>= (+ (* 3 (image-width PBLOCK)) (pad-y p)) BOARDH)
              p
              
              (make-pad (+ (pad-y p) PSPEED)
                        (pad-dir p)))]))



;; GAME -> IMAGE
;; interp. draws the game elements onto the screen

(define (render gs)
  (draw-game (game-ball gs)
             (game-pad gs)
             (game-score gs)))


(define (draw-game b ps s)
  (place-image BALL
               (ball-x b)
               (ball-y b)
               (place-image (text/font (number->string (score-s1 s))
                                       100
                                       "white"
                                       #f
                                       'default
                                       'normal
                                       'normal
                                       #f)
                            (/ BOARDW 3.5)
                            (/ BOARDH 8)
                            
                            (place-image (text/font (number->string (score-s2 s))
                                       100
                                       "white"
                                       #f
                                       'default
                                       'normal
                                       'normal
                                       #f)
                            (- BOARDW (/ BOARDW 3.5))
                            (/ BOARDH 8)
                            
                            (place-image PADDLE
                                         (* BOARDW (/ 5 6))
                                         (pad-y (pads-pad2 ps))
                                         (draw-pads ps))))))      


(define (draw-pads ps)
  (place-image PADDLE
               (/ BOARDW 6)
               (pad-y (pads-pad1 ps))                            
               (scene+line                
                BOARD
                (/ BOARDW 2)
                0
                (/ BOARDW 2)
                BOARDH
                "white")))


;; GAME KeyEvent -> GAME
;; interp. consumes player-input keys that control the paddles

(define (move gs a-key)
  (cond  
    [(key=? a-key "w")(make-game (game-ball gs)
                                  (make-pads (move-up (pads-pad1 (game-pad gs)))
                                             (pads-pad2 (game-pad gs)))
                                  (game-score gs))]
    [(key=? a-key "s") (make-game (game-ball gs)
                                     (make-pads (move-down (pads-pad1 (game-pad gs)))
                                                (pads-pad2 (game-pad gs)))
                                     (game-score gs))]
    [(key=? a-key "up") (make-game (game-ball gs)
                                  (make-pads (pads-pad1 (game-pad gs))
                                             (move-up2 (pads-pad2 (game-pad gs))))
                                  (game-score gs))]  
    [(key=? a-key "down") (make-game (game-ball gs)
                                  (make-pads (pads-pad1 (game-pad gs))
                                             (move-down2 (pads-pad2 (game-pad gs))))
                                  (game-score gs))] 
    [else gs]))


(define (move-up p)
  (make-pad (pad-y p)
            "w"))
(define (move-down p)
  (make-pad (pad-y p)
            "s"))
(define (move-up2 p)
  (make-pad (pad-y p)
            "up"))
(define (move-down2 p)
  (make-pad (pad-y p)
            "down"))


;;;START CONDITIONS;;;

(main (make-game (make-ball 100 (/ BOARDH 2) true true 0)
                 (make-pads (make-pad 65 "w")
                            (make-pad 65 "down"))
                 (make-score 0 0)))







