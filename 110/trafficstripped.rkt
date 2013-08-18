;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname trafficstripped) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; Constants:

(define WIDTH  300)
(define HEIGHT 400)


(define CTR-X (/ WIDTH 2))
(define CTR-Y (/ HEIGHT 2))

(define FONT-SIZE 80)

(define START-TICKS  3) ; The start value of the counter in each color.

(define MTS (rectangle WIDTH HEIGHT "solid" "black"))



;;;;;;;;;;

(define-struct tl (color ticks))


;;;;;;;;;;;;;;;



(define (main tl)
  (big-bang tl
            (on-tick next-tlight 1)   ; TLight -> TLight
            (to-draw render)))        ; TLight -> Image



;;;;;;;;;;;;;;



(define (next-tlight tl)
  (if (> (tl-ticks tl) 0)
      (make-tl (tl-color tl)                 ;not operating on internal
               ;                             ;structure of TLColor type here, so
               ;                             ;we don't need to call helper
               (sub1 (tl-ticks tl)))
      (make-tl (next-tl-color (tl-color tl)) ;must call helper here
               START-TICKS)))



;;;;;;;;;;;;


(define (next-tl-color c)
  (cond [(string=? c "red")    "green"]
        [(string=? c "yellow") "red"]
        [(string=? c "green")  "yellow"]))





;;;;;;;;;;;;;;



(define (render tl)
  (place-image (text (number->string (tl-ticks tl)) FONT-SIZE (tl-color tl))
               CTR-X
               CTR-Y
               MTS))

;;;;;;;;;;;;



(main (make-tl "green" START-TICKS))


