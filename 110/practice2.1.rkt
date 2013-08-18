;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname practice2.1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Direction is one of: ;data definitions
;; - "N"
;; - "E"
;; - "S"
;; - "W"
;; interp. which direction player is facing ;interpretation

(define D1 "W") ;examples
(define D2 "N")

#;
(define (fn-for-direction d) ;template
  (cond [(string=? d "N") (...)]
        [(string=? d "E") (...)]
        [(string=? d "S") (...)]
        [(string=? d "W") (...)]))

;; Template rules used:
;; - atomic distinct


;; Direction -> Direction
;; Produce the next direction after 90deg left turn from current direction

#;
(define (left d)
  ("W"))
#;
(define (left d) ;template
  (cond [(string=? d "N") (...)]
        [(string=? d "E") (...)]
        [(string=? d "S") (...)]
        [(string=? d "W") (...)]))

(check-expect (left "W") "S")
(check-expect (left "S") "E")
(check-expect (left "E") "N")
(check-expect (left "N") "W")

(define (left d) 
  (cond [(string=? d "N") "W"]
        [(string=? d "E") "N"]
        [(string=? d "S") "E"]
        [(string=? d "W") "S"]))

;; Direction -> Direction
;; Produce the next direction after 90deg right turn from current direction

#;
(define (right d)
  ("W"))
#;
(define (right d) ;template
  (cond [(string=? d "N") (...)]
        [(string=? d "E") (...)]
        [(string=? d "S") (...)]
        [(string=? d "W") (...)]))

(check-expect (right "W") "N")
(check-expect (right "S") "W")
(check-expect (right "E") "S")
(check-expect (right "N") "E")

(define (right d) 
  (cond [(string=? d "N") "E"]
        [(string=? d "E") "S"]
        [(string=? d "S") "W"]
        [(string=? d "W") "N"]))


;; Direction -> Direction
;; Produce the direction after 180 deg turn from current direction

#;
(define (uturn d)
  ("W"))
#;
(define (uturn d) ;template
  (cond [(string=? d "N") (...)]
        [(string=? d "E") (...)]
        [(string=? d "S") (...)]
        [(string=? d "W") (...)]))

(check-expect (uturn "W") "E")
(check-expect (uturn "S") "N")
(check-expect (uturn "E") "W")
(check-expect (uturn "N") "S")

(define (uturn d) 
  (cond [(string=? d "N") "S"]
        [(string=? d "E") "W"]
        [(string=? d "S") "N"]
        [(string=? d "W") "E"]))
