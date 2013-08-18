;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lect27thprogtry) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; ListOfNumber is one of:
;; - empty
;; - (cons Number ListOfNumber)
;; inter. a list of numbers

(define LON1 empty)
(define LON2 (cons 1 LON1))
(define LON3 (cons 2 LON2))

#;
(define (fn-for-lon lon)
(cond [(empty? lon) (...)]
       [else
        (... (first lon)
             (fn-for-lon (rest lon)))]))
;; Template rules used:
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: cons
;; - atomic non-distinct: (first lon) is of type Number
;; - self-reference: (rest los) is of type ListOfNumber


;; ListOfNumber -> Number
;; number of numbers in lon

(check-expect (count-lon LON1) 0)
(check-expect (count-lon LON1) 1)
(check-expect (count-lon LON1) 2)


; stub


(define (count-lon lon)
(cond [(empty? lon) 0]
       [else
        (+ 1
           (count-lon (rest lon)))]))