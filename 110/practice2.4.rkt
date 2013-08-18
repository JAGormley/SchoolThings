;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname practice2.4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; NumberGrade is one of:
;; - [90, 100]
;; - [80, 89]
;; - [50, 79]
;; - [0, 50]
;; interp. which category the number grade is in

(define NG1 90)
(define NG2 40)

(define (fn-for-numbergrade n)
  (cond [(<= 90 n 100) (... n)]
        [(<= 80 n 89) (... n)]
        [(<= 50 n 79) (... n)]
        [(<= 0 n 49) (... n)]))

;; one-of: 4 cases
;; atomic non-distinct: interval[90, 100]
;; atomic non-distinct: interval[80. 89]
;; atomic non-distinct: interval[50, 79]
;; atomic non-distinct: interval[0, 49]


;; LetterGrades is one of:
;; "A"
;; "B"
;; "Pass"
;; "Fail"

;; examples redundant

#;
(define (fn-for-lettergrades l)
  (cond [(string=? "A") (...)]
        [(string=? "B") (...)]
        [(string=? "Pass") (...)]
        [(string=? "Fail") (...)]))

;; one-of: 4 conditions
;; all atomic distinct


;; FUNCTIONs

;; NumericGrade -> LetterGrade
;; convert numeric grade to letter grade

#;
(define (numeric-letter n)
  "A")

#;
(define (numeric-letter n) ;template
  (... n))

(check-expect (numeric-letter 0) "Fail")
(check-expect (numeric-letter 50) "Pass")
(check-expect (numeric-letter 79) "Pass")
(check-expect (numeric-letter 80) "B")
(check-expect (numeric-letter 89) "B")
(check-expect (numeric-letter 90) "A")
(check-expect (numeric-letter 100) "A")

(define (numeric-letter n)
  (cond [(<= 90 n 100) "A"]
        [(<= 80 n 89) "B"]
        [(<= 50 n 79) "Pass"]
        [(<= 0 n 49) "Fail"]))


;; NumericGrade -> Bool
;; consumes number grade and outputs true if an A grade, false if not

#;
(define (excellent? n)
  true)

#;
(define (excellent? n)
  (... n))

(check-expect (excellent? 89) false)
(check-expect (excellent? 90) true)

(define (excellent? n)
  (string=? (numeric-letter n) "A"))



