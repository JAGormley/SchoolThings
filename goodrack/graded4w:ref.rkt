;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname graded4w:ref) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; When the mouse is clicked anywhere on the screen, a coundown from 10-0 begins at that position; the countdown also scrolls down the screen, stopping count and scroll at 0.


;; Constants:

(define HEIGHT 600)
(define WIDTH 600)

(define Y-SPACING -20)
(define MTS (empty-scene WIDTH HEIGHT))

(define TEXT-SIZE 20) 
(define TEXT-COLOR "black")




;; Data Definitions:

(define-struct countdown (x y i))
;; Countdown is (make-countdown Natural[0, WIDTH] Natural[0, HEIGHT] Natural[0, 10])
;; interp. (make-countdown x y i) is a countdown at x and y positions, and at a Natural[0, 10]

(define C1 (make-countdown 200 200 10))
(define C2 (make-countdown WIDTH 200 1))
(define C3 (make-countdown 200 HEIGHT 0))

#;
(define (fn-for-countdown c)
  (... (countdown-x c)          ;Natural[0, WIDTH]
       (countdown-y c)          ;Natural[0, HEIGHT]
       (countdown-i c)))        ;Natural[0, 10]

;; Template rules used:
;; - compound: countdown structure has 3 fields
;; - atomic non-distinct: Natural(0, WIDTH)
;; - atomic non-distinct: Natural(0, HEIGHT)
;; - atomic non-distinct: Natural[0, 10]




;; ListOfCountdown

;; ListOfCountdown is one of:
;;  - empty
;;  - (cons Countdown ListOfCountdown)
;; interp. a list of Countdowns
(define LOC1 empty)
(define LOC2 (cons (make-countdown 10 20 10) (cons (make-countdown 200 600 5) empty)))
#;
(define (fn-for-loc loc)
  (cond [(empty? loc) (...)]
        [else
         (... (fn-for-countdown (first loc))
              (fn-for-loc (rest loc)))]))
;; Rules used:
;; - one-of: 2 cases
;; - atomic distinct: empty
;; - compound: cons
;; - reference: (first loc) is Countdown
;; - self reference: (rest loc) is ListOfCountdown



;------------------------------------------------------------


;; Functions:



;; ListOfCountdown -> ListOfCountdown
;; run the program starting with a make-countdown I've defined
(define (start x)
  (big-bang x
            (on-mouse mouse-button)    ; ListOfCountdown Integer Integer MouseEvent -> ListOfCountdown
            (on-tick countlist 1)      ; ListOfCountdown -> ListOfCountdown
            (to-draw render-list)))    ; ListOfCountdown -> Image


;; ListOfCountdown -> ListOfCountdown
;; make ListOfCountdown containing new LOC and all previous LOC

(check-expect (countlist empty) empty)
(check-expect (countlist (cons (make-countdown 40 400 6) (cons (make-countdown 200 0 4) empty)))
              (cons (make-countdown 40 (- 400 Y-SPACING) (sub1 6)) (cons (make-countdown 200 (- 0 Y-SPACING) (sub1 4)) empty)))

#; 
(define (countlist loc)   ;stub
  empty)

;; Template from ListOfCountdown
#;
(define (countlist loc)
  (cond [(empty? loc) (...)]
        [else
         (... (fn-for-countdown (first loc))
              (render-list (rest loc)))]))


(define (countlist loc)
  (cond [(empty? loc) empty]
        [else
         (cons (next-count (first loc))
               (countlist (rest loc)))]))



;; Countdown -> Countdown
;; decrement the countdown-i by 1 and countdown-y by Y-SPACING

#;
(define (next-count c)       ;stub
  (make-countdown 0 0 0))

(check-expect (next-count (make-countdown 500 400 10)) (make-countdown 500 420 9))

; Template from Countdown
#;
(define (next-count c)
  (... (countdown-x c)         
       (countdown-y c)          
       (countdown-i c)))


(define (next-count c)
  (if (> (countdown-i c) 0)
      (make-countdown 
       (countdown-x c)
       (- (countdown-y c) Y-SPACING)  
       (sub1 (countdown-i c)))
      c))


;; ListOfCountdown -> Image
;; display the countdown

(check-expect(render-list empty) MTS)

(check-expect (render-list (cons (make-countdown 500 400 10) (cons (make-countdown 200 100 4) empty)))
              (place-countdown (make-countdown 500 400 10) (place-image (text "4" TEXT-SIZE TEXT-COLOR)
                                                                        200
                                                                        100
                                                                        MTS)))

#;
(define (render-list c)     ;stub
  MTS)

;; Template from ListOfCount
#;
(define (render-list loc)
  (cond [(empty? loc) (...)]
        [else
         (... (fn-for-countdown (first loc))
              (render-list (rest loc)))]))


(define (render-list loc)
  (cond [(empty? loc) MTS]
        [else
         (place-countdown  (first loc)
                           (render-list (rest loc)))]))


;; Countdown Image -> Image
;; places image of new Countdown onto image of previous countdowns
(check-expect (place-countdown (make-countdown 500 400 10) MTS) (place-image (text "10" TEXT-SIZE TEXT-COLOR)
                                                                             500
                                                                             400
                                                                             MTS))



(define (place-countdown c img)
  (place-image (text (number->string (countdown-i c)) TEXT-SIZE TEXT-COLOR)
               (countdown-x c)
               (countdown-y c)
               img))



;; ListOfCountdown Integer Integer MouseEvent -> ListOfCountdown
;; clicking the mouse on the screen adds a new Countdown to ListOfCountdown

(define (mouse-button loc x y me)                      ;; Template from HtDW page
  (cond [(mouse=? me "button-down") (cons (make-countdown x y 10) loc)]
        [else loc]))



(start empty)
