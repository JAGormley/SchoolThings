;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |traffic-light-and-next-color (1)|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
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


