;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname traffic-light-and-next-color) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; TrafficLight is one of:                ; types comment
;;  - "red"                               ;
;;  - "yellow"                            ;
;;  - "green"                             ;
;; interp. the color of a traffic light   ; interpretation
(define TL1 "red")                        ; examples
(define TL2 "yellow")                     ;

(define (fn-for-traffic-light tl)         ; template
  (cond [(string=? tl "red") (...)]
        [(string=? tl "yellow") (...)]
        [(string=? tl "green") (...)]))

;; TrafficLight -> TrafficLight
;; produce the next color of a traffic light after tl
(check-expect (next-color "red")    "green")
(check-expect (next-color "yellow") "red")
(check-expect (next-color "green")  "yellow")

#;
(define (next-color tl) ; stub
  "red")

; use template from TrafficLight

(define (next-color tl)
  (cond
    [(string=? "red"    tl) "green"]
    [(string=? "yellow" tl) "red"]
    [(string=? "green"  tl) "yellow"]))
