;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname graded03yeaaahhheahahahaeyaha2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Problem Set 3:

;; NOTE: PLEASE FILL IN ALL THE FIELDS BELOW. FAILURE TO DO SO MAY RESULT IN POINTS OFF
;;       OF YOUR PROBLEM SET.

;; First Name(s):  ____________________________________________________________________

;; Last Name(s):  _____________________________________________________________________

;; UBC Student ID number(s): __________________________________________________________

;; CS Department account ID(s): _______________________________________________________

;; Lab section (of first person named above): _________________________________________

;; Lecture section (circle):  101 (Gregor), 102/BCS (Joanna), 103 (Ron)



(require 2htdp/image)
(require 2htdp/universe)

;; An image of the word "hello" that decends the screen while rotating


;; Constants:

(define WIDTH  200)
(define HEIGHT 400)

(define CTR-X (/ WIDTH 2))

(define SPEED 2)

(define ROTATE-SPEED 20)

(define HELLO-IMG (text "hello" 30 "black"))

(define MTS (empty-scene WIDTH HEIGHT))



;; Data definitions:


(define-struct hellodown (y rotate))
;; HelloDown is (make-hellodown (Number Number[0, 360))
;; interp. y coordinate and rotation of hello
;;
(define H1 (make-hellodown 20 200))
(define H2 (make-hellodown 30 150))

#;
(define (fn-for-hellodown hd)
  (... (hellodown-y hd)
       (hellodown-rotate hd)))
  

;; Template rules used:
;;  - atomic non-distinct: Number
;;  - atomic non-distinct: Number[0, 360)



;; Functions:

;; HelloDown -> HelloDown
  
;; starts decent of hello, starts at (main (make-hellodown 0 0))
;; no tests for main function

 (define (main hd)
  (big-bang hd
            (on-tick next-hellodown)     ; HelloDown -> HelloDown
            (to-draw render-hellodown)))   ; HelloDown -> Image
            (on-key handle-key)))

 
;; HelloDown -> HelloDown  
;; increase hellodown y position by SPEED and rotation by ROTATE-SPEED
(check-expect (next-hellodown (make-hellodown 0 0)) (make-hellodown (+ 0 SPEED) (+ 0 ROTATE-SPEED)))
(check-expect (next-hellodown (make-hellodown 10 10)) (make-hellodown (+ 10 SPEED) (+ 10 ROTATE-SPEED)))

#;
(define (next hd)      ; stub
  1)

;; template comes from HelloDown

(define (next-hellodown hd)
  (make-hellodown (+ (hellodown-y hd) SPEED)
       (+ (hellodown-rotate hd) ROTATE-SPEED)))
  


;; HelloDown -> Image
;; add HELLO-IMG to MTS at proper y coordinate and CTR-X
(check-expect (render-hellodown (make-hellodown 0 0))
              (place-image (rotate (remainder 0 360)(text "hello" 30 "black")) CTR-X 0 MTS))

#;
(define (render-hellodown hd)
  MTS)

;; use template from HelloDown

(define (render-hellodown hd)
  (place-image (rotate (remainder (hellodown-rotate hd) 360)(text "hello" 30 "black")) CTR-X (hellodown-y hd) MTS))


;; HelloDown KeyEvent -> HelloDown
;; on space key restart at top of screen with reset rotation. ignore other key events
(check-expect (handle-key 10 " ") )
(check-expect (handle-key 10 "a") 10)
#;
(define (handle-key c ke) c)       ;stub

#;
(define (handle-key c ke)          ;templated according to KeyEvent
  (cond [(key=? ke " ") 0]
        [else c]))

(define (handle-key hd ke)
  (cond [(key=? ke " ") (make-hellodown 0 0)]))


(main (make-hellodown 0 0))

