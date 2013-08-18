;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lecture18thnotes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; @241

;; design function that represents city names
;; could try to write them all out but its not realistic

;; CITYNAMES


;;Cityname is String
;; TEMPLATE RULES:
;; Start by looking at form

;; - then what I want to know is how to fill in template, right column tells us

(define (fn-for-city-name cn)
  (...cn))

;; -atomic non-distinct: String

;; SEATNUMBERS (the Natural means whole)

;; SeatNum is Natural[1, 32]
;; Interp. the number of a seat in a row
(define SN1 1)
(define SN2 32)
#;
(define (fn-for-seat-number sn)
  (... sn)) 

;; Template rules used:
;; - atomic non-distinct: Natural[1, 32]



;; LETTERGRADE

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



;; ITEMIZATION NEEDS TO HAVE 1 NON-DISTINCT (OTHERWISE ITS ENUMERATION)
;; READING FILE


;; SeatNum -> Reading ---which template to use??
;; this is how HtDD fits with HtDF

;; TEMPLATE IS FORMED ON DATA THAT IS CONSUMED