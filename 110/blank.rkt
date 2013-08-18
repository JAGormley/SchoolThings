;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname blank) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)


(define MTS (empty-scene 200 200))

(define HEIGHT 200)
(define WIDTH 200)

(define SPEED 5)

(define GRASSWIDTH 5)


(define (main x)
  (big-bang x
            (on-tick next-grass 1)
            (to-draw render-grass)))

;; Grass is Natural
;; interp. the length of a blade of grass in pixels

(define G1 0)
(define G2 5)

#;
(define (fn-for-grass g)
  (... g))

; Template rules used:
; atomic non-distinct: Natural




;;; FUNCTIONS ;;;


;; Grass -> Grass
;; grows the grass by SPEED

#;
(define (next-grass g)
  g)

(check-expect (next-grass 0) (+ 0 SPEED))
(check-expect (next-grass 5) (+ 5 SPEED))


