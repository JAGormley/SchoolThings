;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname rotrectry) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)



(define ROTATION 2)

(define rec(rectangle 20 30 "solid" "red"))



(define (main r)
  (big-bang r
            ;(state true)           ; uncommenting this line displays changing state
            (on-tick next-rec)     ; HelloDown -> HelloDown
            (to-draw render-rec)))


(define (next-rec r)
  (rotate ROTATION r))



(define (render-rec r))



(define-struct rr (rotate ticks))

(define (fn-for-rr r)
  (... (fn-for-tl-color (tl-color r))
       (tl-ticks r)))
