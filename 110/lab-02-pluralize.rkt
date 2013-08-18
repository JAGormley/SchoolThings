;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lab-02-pluralize) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; CPSC 110 Lab 2, Problem 3

;; String -> String
;; takes a word, adds and 's' at the end unless there's one already there

(check-expect (plz "cat") "cats")
(check-expect (plz "far") "fars")
(check-expect (plz "houses") "houses")

;(define (plz str) ;stub
;  "yes")

;(define (plz str) ;template
;  (... str))

; (define (plz str)
; (if (string=? (first (reverse(explode str))) "s") str (string-append str "s"))) ;; my version

(define (plz str)
(if (string=? (string-ith str (- (string-length str) 1)) "s") str (string-append str "s")))


(plz "cats")
(plz "water")


