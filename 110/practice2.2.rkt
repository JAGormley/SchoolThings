;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname practice2.2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)

;; TimeLeft is one of
;; - Number[30, 10]
;; - Number(10, 0)
;; - Number[0]
;; interp. the time remaining on the timer

(define T1 30)
(define T2 25)
(define T3 10)
(define T4 5)
(define T5 0)

#;
(define (fn-for-timeleft t)
  (cond [(and (>= 30 t) (<= 10 t)) (... t)]
        [(and (> 10 t) (< 0 t)) (... t)]
        [(= t 0) (... t)]))
;; one-of: 3 cases
;; - atomic non-distinct: interval[10, 30]
;; - atomic non-distinct: interval(0, 10)
;; - atomic distinct: Number 0

;; Light is one of:
;; - "green"
;; - "yellow"
;; - "red"
;; interp. which of the lights is lit

(define L1 "green")
(define L2 "yellow")

#;
(define (fn-for-light l)
  (cond [(string=? l "red") (...)]
        [(string=? l "yellow") (...)]
        [(string=? l "green") (...)]))
        
;; one-of:3 cases
;; atomic distinct - "red"
;; atomic distinct - "yellow"
;; atomic distinct - "green"


;; Functions

;; TimeLeft -> Light
;; takes time left and outputs appropriate light color

#;
(define (time->light t)
  "green")

(check-expect (time->light 30) "green")
(check-expect (time->light 20) "green")
(check-expect (time->light 10) "green")
(check-expect (time->light 9) "yellow")
(check-expect (time->light 6) "yellow")
(check-expect (time->light 1) "yellow")
(check-expect (time->light 0) "red")

(define (time->light t)
  (cond [(and (>= 30 t) (<= 10 t)) "green"]
        [(and (> 10 t) (< 0 t)) "yellow"]
        [(= t 0) "red"]))


;; Light -> image
;; consumes Light state and outputs image of the light that's on

#;
(define (light->image l)
  (circle 20 "solid" "green"))

(check-expect (light->image "green") (beside (circle 30 "solid" "green")
        (circle 30 "outline" "yellow")
        (circle 30 "outline" "red")))
(check-expect (light->image "yellow") (beside (circle 30 "outline" "green")
        (circle 30 "solid" "yellow")
        (circle 30 "outline" "red")))
(check-expect (light->image "red") (beside (circle 30 "outline" "green")
        (circle 30 "outline" "yellow")
        (circle 30 "solid" "red")))


(define (light->image l)
  (cond [(string=? l "red") (beside (circle 30 "outline" "green")
        (circle 30 "outline" "yellow")
        (circle 30 "solid" "red"))]
        [(string=? l "yellow") (beside (circle 30 "outline" "green")
        (circle 30 "solid" "yellow")
        (circle 30 "outline" "red"))]
        [(string=? l "green") (beside (circle 30 "solid" "green")
        (circle 30 "outline" "yellow")
        (circle 30 "outline" "red"))]))
              
              

(light->image (time->light 0))
              
              