;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname paaangpadsnotworking) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

(define BOARDW 1280)
(define BOARDH 720)

(define BOARD (empty-scene BOARDW BOARDH "black"))
(define PBLOCK (square 20 "solid" "white"))
(define PADDLE (above/align "middle"
                            PBLOCK 
                            PBLOCK
                            PBLOCK
                            PBLOCK
                            PBLOCK
                            PBLOCK))

(define BALL PBLOCK)
(define SPEED 20)
(define BLANK (square 0 "outline" "black"))
(define PSPEED 15)
(define PADL 140)



(define-struct ball (x y dir ydir ang))
(define-struct pad (y dir))
(define-struct pads (pad1 pad2))
(define-struct game (ball pads))




(define (main gs)
  (big-bang gs
            (on-tick tick .035)
            (to-draw render)
            (on-key move)))



;; GAME -> GAME

(define (tick gs)
  (make-game (move-ball (game-ball gs)
                        (game-pads gs))
             (move-pads (game-pads gs))))




;; BALL -> BALL


(define (move-ball b ps)
  
  ;;;;;;;BOUNCE;;;;;;;;;;
  
  (cond [(> (ball-x b) BOARDW)
         (make-ball (- (ball-x b) SPEED)
                    (ball-y b)                   
                    false
                    (ball-ydir b)
                    (ball-ang b))]
        [(< (ball-x b) 0)
         (make-ball (+ (ball-x b) SPEED)
                    (ball-y b)
                    true
                    (ball-ydir b)
                    (ball-ang b))]
        
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
        
        
        
        ;;;;;;;;;PAD1;;;;;;;;;;;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;
        
        
        ;;;;;;;;;DOWN;;;;;;;;;;;
        
        [(and (and (< (ball-x b) (+ 17 (/ BOARDW 6)))
                   (> (ball-x b) (- (/ BOARDW 6) 5)))  
              (and (< (+ (/ PADL 2.8) (pad-y (pads-pad1 ps))) (ball-y b))
                   (>= (+ (/ PADL 2) (pad-y (pads-pad1 ps))) (ball-y b))))           
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    35)]
        
        [(and (and (< (ball-x b) (+ 17 (/ BOARDW 6)))
                   (> (ball-x b) (- (/ BOARDW 6) 5)))                
              (and (< (+ (/ PADL (/ 14 3)) (pad-y (pads-pad1 ps))) (ball-y b))
                   (>= (+ (/ PADL 2.8) (pad-y (pads-pad1 ps))) (ball-y b))))                          
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    15)]
        
        [(and (and (< (ball-x b) (+ 17 (/ BOARDW 6)))
                   (> (ball-x b) (- (/ BOARDW 6) 5)))  
              (and (< (+ (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))
                   (>= (+ (pad-y (pads-pad1 ps)) (/ PADL (/ 14 3))) (ball-y b))))                           
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    5)]       
        
        ;;;;;;;;STRAIGHT;;;;;;;;        
        
        [(and (and (< (ball-x b) (+ 17 (/ BOARDW 6)))
                   (> (ball-x b) (- (/ BOARDW 6) 5)))  
              (and (<= (- (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))
                   (>= (+ (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))))                         
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    0)]       
        
        ;;;;;;;;;UP;;;;;;;;;;;
        
        [(and (and (< (ball-x b) (+ 17 (/ BOARDW 6)))
                   (> (ball-x b) (- (/ BOARDW 6) 5)))                
              (and (<= (- (pad-y (pads-pad1 ps))) (/ PADL (/ 14 3)) (ball-y b))
                   (> (- (pad-y (pads-pad1 ps)) (/ PADL 14)) (ball-y b))))     
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    false
                    5)]
        
        [(and (and (< (ball-x b) (+ 17 (/ BOARDW 6)))
                   (> (ball-x b) (- (/ BOARDW 6) 5)))              
              (and (<= (- (pad-y (pads-pad1 ps)) (/ PADL 2.8)) (ball-y b))
                   (> (- (pad-y (pads-pad1 ps))) (/ PADL (/ 14 3)) (ball-y b))))       
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    false
                    15)]
        
        [(and (and (< (ball-x b) (+ 17 (/ BOARDW 6)))
                   (> (ball-x b) (- (/ BOARDW 6) 5)))
              (and (<= (- (pad-y (pads-pad1 ps)) (/ PADL 2)) (ball-y b))
                   (> (- (pad-y (pads-pad1 ps)) (/ PADL 2.8)) (ball-y b))))         
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    false
                    35)]
        
        ;;;;;;;;;PAD2;;;;;;;;;;;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;
        
        ;;;;;;;;;DOWN;;;;;;;;;;;
        
        [(and (and (< (ball-x b) (- (* BOARDW (/ 5 6)) 17))
                   (> (ball-x b) (+ (* BOARDW (/ 5 6)) 5))) 
              (and (< (+ (/ PADL 2.8) (pad-y (pads-pad2 ps))) (ball-y b))
                   (>= (+ (/ PADL 2) (pad-y (pads-pad2 ps))) (ball-y b))))           
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    35)]
        
        [(and (and (< (ball-x b) (- (* BOARDW (/ 5 6)) 17))
                   (> (ball-x b) (+ (* BOARDW (/ 5 6)) 5)))                
              (and (< (+ (/ PADL (/ 14 3)) (pad-y (pads-pad2 ps))) (ball-y b))
                   (>= (+ (/ PADL 2.8) (pad-y (pads-pad2 ps))) (ball-y b))))                          
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    15)]
        
        [(and (and (< (ball-x b) (- (* BOARDW (/ 5 6)) 17))
                   (> (ball-x b) (+ (* BOARDW (/ 5 6)) 5)))  
              (and (< (+ (pad-y (pads-pad2 ps)) (/ PADL 14)) (ball-y b))
                   (>= (+ (pad-y (pads-pad2 ps)) (/ PADL (/ 14 3))) (ball-y b))))                           
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    5)]
        
        
        ;;;;;;;;STRAIGHT;;;;;;;;        
        
        
        [(and (and (< (ball-x b) (- (* BOARDW (/ 5 6)) 17))
                   (> (ball-x b) (+ (* BOARDW (/ 5 6)) 5)))  
              (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL 14)) (ball-y b))
                   (>= (+ (pad-y (pads-pad2 ps)) (/ PADL 14)) (ball-y b))))                           
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    true
                    0)]
        
        
        ;;;;;;;;;UP;;;;;;;;;;;
        
        [(and (and (< (ball-x b) (- (* BOARDW (/ 5 6)) 17))
                   (> (ball-x b) (+ (* BOARDW (/ 5 6)) 5)))                
              (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL (/ 14 3))) (ball-y b))
                   (> (- (pad-y (pads-pad2 ps)) (/ PADL 14)) (ball-y b))))         
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    false
                    5)]
        
        [(and (and (< (ball-x b) (- (* BOARDW (/ 5 6)) 17))
                   (> (ball-x b) (+ (* BOARDW (/ 5 6)) 5)))              
              (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL 2.8)) (ball-y b))
                   (> (- (pad-y (pads-pad2 ps)) (/ PADL (/ 14 3))) (ball-y b))))        
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    false
                    15)]
        
        [(and (and (< (ball-x b) (- (* BOARDW (/ 5 6)) 17))
                   (> (ball-x b) (+ (* BOARDW (/ 5 6)) 5)))
              (and (<= (- (pad-y (pads-pad2 ps)) (/ PADL 2)) (ball-y b))
                   (> (- (pad-y (pads-pad2 ps)) (/ PADL 2.8)) (ball-y b))))         
         (make-ball (if (ball-dir b)
                        (+ SPEED (ball-x b))
                        (- (ball-x b) SPEED))
                    (ball-y b)
                    (not (ball-dir b))
                    false
                    35)]
        
        ;;;;;;;;NO CONTACT;;;;;;;;
        
        
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

(define (move-pads ps)
  (cond 
    
    [(string=? (pad-dir (pads-pad1 ps)) "up")
     (if (<= (- (pad-y (pads-pad1 ps)) 60) 0)
         ps
         (make-pads (make-pad (- (pad-y (pads-pad1 ps)) PSPEED)
                              (pad-dir (pads-pad1 ps)))
                    (pads-pad2 ps)))]
    [(string=? (pad-dir (pads-pad1 ps)) "down")
     (if (>= (+ 55 (pad-y (pads-pad1 ps))) BOARDH)
         ps
         (make-pads (make-pad (+ (pad-y (pads-pad1 ps)) PSPEED)
                              (pad-dir (pads-pad1 ps)))
                    (pads-pad2 ps)))]
    
    
    [(string=? (pad-dir (pads-pad2 ps)) "w")
     (if (<= (- (pad-y (pads-pad2 ps)) 60) 0)
         ps
         (make-pads (pads-pad1 ps)
                    (make-pad (- (pad-y (pads-pad2 ps)) PSPEED)
                              (pad-dir (pads-pad2 ps)))))]
    
    [(string=? (pad-dir (pads-pad2 ps)) "s")
     (if (>= (+ 55 (pad-y (pads-pad2 ps))) BOARDH)
         ps
         (make-pads (pads-pad1 ps) 
                    (make-pad (+ (pad-y (pads-pad2 ps)) PSPEED)
                              (pad-dir (pads-pad2 ps)))))]
    
    
    ))



;; GAME -> IMAGE

(define (render gs)
  (draw-game (game-ball gs)
             (game-pads gs)))


(define (draw-game b ps)
  (place-image BALL
               (ball-x b)
               (ball-y b)
               (draw-pads ps)))

(define (draw-pads ps)
  (place-image PADDLE
               (/ BOARDW 6)
               (pad-y (pads-pad1 ps))              
               (draw-pads2 (pads-pad2 ps))))

(define (draw-pads2 p)
  (place-image PADDLE
               (* BOARDW (/ 5 6))
               (pad-y p)
               BOARD))


;; GAME -> GAME

(define (move gs a-key)
  (cond  
    [(key=? a-key "up")(make-game (game-ball gs)
                                  (make-pads (move-up (pads-pad1 (game-pads gs)))
                                             (pads-pad2 (game-pads gs))))]
    [(key=? a-key "down") (make-game (game-ball gs)
                                     (make-pads (move-down (pads-pad1 (game-pads gs)))
                                                (pads-pad2 (game-pads gs))))]
    [(key=? a-key "w")(make-game (game-ball gs)
                                 (make-pads (pads-pad1 (game-pads gs))
                                            (move-up2 (pads-pad2 (game-pads gs)))))]
    [(key=? a-key "s") (make-game (game-ball gs)
                                  (make-pads (pads-pad1 (game-pads gs))
                                             (move-down2 (pads-pad2 (game-pads gs)))))]
    [else gs]))




(define (move-up p)
  (make-pad (pad-y p)
            "up"))
(define (move-down p)
  (make-pad (pad-y p)
            "down"))

(define (move-up2 p)
  (make-pad (pad-y p)
            "w"))
(define (move-down2 p)
  (make-pad (pad-y p)
            "s"))

(main (make-game (make-ball 100 (/ BOARDH 2) true true 0)
                 (make-pads (make-pad 65 "up")
                            (make-pad 400 "s"))))







