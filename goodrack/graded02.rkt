;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname graded02) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

(require 2htdp/image)


;; Problem Set 2:

;; NOTE: PLEASE FILL IN ALL THE FIELDS BELOW. FAILURE TO DO SO MAY RESULT IN POINTS OFF
;;       OF YOUR PROBLEM SET.

;; First Name(s):  ____________________________________________________________________

;; Last Name(s):  _____________________________________________________________________

;; UBC Student ID number(s): __________________________________________________________

;; CS Department account ID(s): _______________________________________________________

;; Lab section (of first person named above): _________________________________________

;; Lecture section (circle):  101 (Gregor), 102/BCS (Joanna), 103 (Ron)



;; PROBLEM 1


;; Dinner is one of:
;; - "chicken"
;; - "beef"
;; - "pasta"
;; interp. the chosen dinner type

;; <examples are redundant for enumerations>

#;
(define (fn-for-dinner d)
  (cond [(string=? "chicken" d) (...)]
        [(string=? "beef" d) (...)]
        [(string=? "pasta" d) (...)]))

;; Template rules used:
;;  - one of: 3 cases
;;  - atomic distinct: "chicken"
;;  - atomic distinct: "beef"
;;  - atomic distinct: "pasta" 



;; PROBLEM 2

;; LoadBalance is one of:
;;  - Number(-inf.0, -500)  
;;  - Number[-500, 500] 
;;  - Number(500, +inf.0)
;; interp. result of load balance test
;;         (-inf.0, -500) is tail heavy
;;         [-500, 500] is fairly balanced
;;         (500, +inf.0) is nose heavy

(define L1 -inf.0)
(define L2 -700)
(define L3 -500)
(define L4 0)
(define L5 500)
(define L6 700)
(define L7 +inf.0)

#;
(define (fn-for-load-balance l)
  (cond [(< l -500) (... l)]
        [(<= -500 l 500) (... l)]
        [(> l 500) (... l)]))


;; Template rules used:
;;  - one of: 3 cases
;;  - atomic non-distinct: Number(-inf.0, -500)
;;  - atomic non-distinct: Number[-500, 500]
;;  - atomic non-distinct: Number(500, +inf.0)


;; PROBLEM 3

;; LoadBalance -> String
;; consumes a LoadBalance and indicates whether it is safe or not.

#;
(define (safe? lb)
  "s")

#;
(define (safe? lb)
  (... lb))

(check-expect (safe? L1) "unsafe")
(check-expect (safe? L2) "unsafe")
(check-expect (safe? L3) "safe")
(check-expect (safe? L4) "safe")
(check-expect (safe? L5) "safe")
(check-expect (safe? L6) "unsafe")
(check-expect (safe? L7) "unsafe")

(define (safe? lb)
  (cond [(< lb -500) "unsafe"]
        [(<= -500 lb 500) "safe"]
        [(> lb 500) "unsafe"]))


:: PROBLEM 4


;; LoadBalance -> Image
;; converts a loadbalance into an image display

#;
(define (display lb)
  (circle 20 "solid" "red"))

#;                      
(define (display lb)
  (... lb))

(check-expect (display L1) (overlay (text (number->string L1) 30 "yellow")(rectangle 100 50 "outline" "black")(rectangle 100 50 "solid" "red")))
(check-expect (display L4) (overlay (text (number->string L4) 30 "white")(rectangle 100 50 "outline" "black")(rectangle 100 50 "solid" "blue")))
(check-expect (display L7) (overlay (text (number->string L7) 30 "yellow")(rectangle 100 50 "outline" "black")(rectangle 100 50 "solid" "red")))

(define (display lb)
  (cond [(< lb -500) (overlay (text (number->string lb) 30 "yellow")(rectangle 100 50 "outline" "black")(rectangle 100 50 "solid" "red"))]
        [(<= -500 lb 500) (overlay (text (number->string lb) 30 "white")(rectangle 100 50 "outline" "black")(rectangle 100 50 "solid" "blue"))]
        [(> lb 500) (overlay (text (number->string lb) 30 "yellow")(rectangle 100 50 "outline" "black")(rectangle 100 50 "solid" "red"))]))

