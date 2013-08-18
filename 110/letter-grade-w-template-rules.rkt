;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname letter-grade-w-template-rules) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; Data definitions:

;; LetterGrade is one of: 
;;  - "A"
;;  - "B"
;;  - "C"
;; interp. a grade in a course
;; <examples are redundant for enumerations>
#;
(define (fn-for-letter-grade lg)
  (cond [(string=? "A" lg) (...)]
        [(string=? "B" lg) (...)]
        [(string=? "C" lg) (...)]))
;; Template rules used:
;;  one-of: 3 cases
;;  atomic distinct: "A"
;;  atomic distinct: "B"
;;  atomic distinct: "C"