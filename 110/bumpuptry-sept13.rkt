;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname bumpuptry-sept13) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; LetterGrade is one of: ;types (DATA DEFINITION)
;; F
;; D
;; C
;; B
;; A
;; interp. the letter of the grade ;interpretation
(define G1 "F")
(define G2 "D")

#;
(define (fn-for-lettergrade lg)
  (cond [(string=? g1 "F") (...)]
        [(string=? g1 "D") (...)]
        [(string=? g1 "C") (...)]
        [(string=? g1 "B") (...)]
        [(string=? g1 "A") (...)]))

;; LetterGrade -> LetterGrade
;; produces next grade up, no grade higher than A

#;
(define (bump-up lg) ;stub
  ("B"))

#;
(define (bump-up lg)                ;template
  (cond [(string=? lg "F") (...)]
        [(string=? lg "D") (...)]
        [(string=? lg "C") (...)]
        [(string=? lg "B") (...)]
        [(string=? lg "A") (...)]))

(check-expect (bump-up "B") "A")
(check-expect (bump-up "C") "B")
(check-expect (bump-up "A") "A")


(define (bump-up lg)
  (cond [(string=? lg "F") "D"]
        [(string=? lg "D") "C"]
        [(string=? lg "C") "B"]
        [(string=? lg "B") "A"]
        [(string=? lg "A") "A"]))

(bump-up "A")