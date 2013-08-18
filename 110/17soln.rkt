;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 17soln) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; CPSC 110 Practice Problems Week 1

;; Practice Problem 1.7

;; String -> String
;; Generates a summoning charm for the given string
(check-expect (accio "Firebolt") "accio Firebolt")
(check-expect (accio "portkey") "accio portkey")
(check-expect (accio "broom") "accio broom")

;(define (accio s) "")
#;
(define (accio s)
  (... s))

(define (accio s)
  (string-append "accio" " " s))


(accio "THUNDER")