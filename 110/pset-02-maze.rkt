;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname pset-02-maze) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; Data Definitions:

;; Direction is one of:
;;  - "N"
;;  - "S"
;;  - "E"
;;  - "W"
;; interp. a direction that a player can be facing
;; <examples are redundant for enumerations>
#;
(define (fn-for-direction d)
  (cond [(string=? d "N") (...)]
        [(string=? d "S") (...)]
        [(string=? d "E") (...)]
        [(string=? d "W") (...)]))

;; Template rules used:
;; one-of: 4 cases
;; atomic distinct: "N"
;; atomic distinct: "S"
;; atomic distinct: "E"
;; atomic distinct: "W"



;; Functions:

;; Direction -> Direction
;; direction resulting from facing d and turning 90 degrees left
(check-expect (left "N") "W")
(check-expect (left "S") "E")
(check-expect (left "E") "N")
(check-expect (left "W") "S")

#;
(define (left d) "N") ; stub
#;
(define (left d)      ; template
  (cond [(string=? d "N") (...)]
        [(string=? d "S") (...)]
        [(string=? d "E") (...)]
        [(string=? d "W") (...)]))

(define (left d)
  (cond [(string=? d "N") "W"]
        [(string=? d "S") "E"]
        [(string=? d "E") "N"]
        [(string=? d "W") "S"]))




;; Direction -> Direction
;; direction resulting from facing d and turning 180 degrees 
(check-expect (uturn "N") "S")
(check-expect (uturn "S") "N")
(check-expect (uturn "E") "W")
(check-expect (uturn "W") "E")

#;
(define (uturn d) "N") ; stub
#;
(define (uturn d)      ; template
  (cond [(string=? d "N") (...)]
        [(string=? d "S") (...)]
        [(string=? d "E") (...)]
        [(string=? d "W") (...)]))

(define (uturn d)
  (cond [(string=? d "N") "S"]
        [(string=? d "S") "N"]
        [(string=? d "E") "W"]
        [(string=? d "W") "E"]))