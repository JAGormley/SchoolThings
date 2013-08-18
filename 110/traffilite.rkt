;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname traffilite) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; A working traffic light that changes from green to yellow to red to green



;; CONSTANTS ;;

(define MTS (empty-scene 600 400))

(define REDLIGHT (above (circle 50 "outline" "black")
                        (circle 50 "outline" "black")
                        (overlay (circle 50 "outline" "black")
                                 (circle 50 "solid" "red"))))

(define YELLOWLIGHT (above 
                        (circle 50 "outline" "black")
                        (overlay (circle 50 "outline" "black")
                                 (circle 50 "solid" "yellow"))
                        (circle 50 "outline" "black")))

(define GREENLIGHT (above (overlay (circle 50 "outline" "black")
                                 (circle 50 "solid" "green"))
                        (circle 50 "outline" "black")
                        (circle 50 "outline" "black")))



;; DATA DEFS                 



;; TrafficLight is one of:
;; - "red"
;; - "green"
;; - "yellow"
;; interp. the current color of the light

(define TL1 "red")

#;
(define (fn-for-tlight tl)
  (cond [(string=? "red") (...)]
        [(string=? "yellow") (...)]
        [(string=? "green") (...)]))

;; Template rules used:
;; one of 3 cases:
;; atomic-distinct: "red"
;; atomic-distinct: "green"
;; atomic-distinct: "yellow"



;; FUNCTIONS


;; TrafficLight -> TrafficLight
;; start the world with ...
(define (main tl)
  (big-bang tl
            (on-tick   next-light 1)     ; TrafficLight -> TrafficLight
            (to-draw   render-light)))      ; TrafficLight -> Image


;; TrafficLight -> TrafficLight
;; produce the next TrafficLight
#;
(define (next-light tl) 
  "red")

(define (next-light tl)    ;; template from Trafficlight
  (cond [(string=? "red" tl) "green"]
        [(string=? "yellow" tl) "red"]
        [(string=? "green" tl) "yellow"]))


;; TrafficLight -> Image
;; draw the light

#;
(define (render-light tl)
  REDLIGHT)

(check-expect (render-light "red") (overlay REDLIGHT
               MTS))

(define (render-light tl)        ;; template from Trafficlight
  (overlay (cond [(string=? "red" tl) REDLIGHT]
        [(string=? "yellow" tl) YELLOWLIGHT]
        [(string=? "green" tl) GREENLIGHT])
               MTS))
        

(main "green")

