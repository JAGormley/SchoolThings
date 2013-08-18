;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname pset-02-light-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; light-image function

(require 2htdp/image)

;; =================
;; Constants:

(define RADIUS 20)

(define RON  (circle RADIUS "solid"   "red"))    ;these constants are not
(define YON  (circle RADIUS "solid"   "yellow")) ;required; but at least 
(define GON  (circle RADIUS "solid"   "green"))  ;something like RADIUS
(define ROFF (circle RADIUS "outline" "red"))    ;should be defined
(define YOFF (circle RADIUS "outline" "yellow"))
(define GOFF (circle RADIUS "outline" "green"))


;; =================
;; Data definitions:

;; Light is one of: 
;;  - "green"
;;  - "yellow"
;;  - "red"
;; interp. the warning light displayed in the game  
;; examples are redundant for enumerations
#;
(define (fn-for-light l)  
  (cond [(string=? l "red")    (...)] 
        [(string=? l "yellow") (...)]
        [(string=? l "green")  (...)]))

;; Template rules used:                
;;  one of: 3 cases
;;  atomic distinct: "red"
;;  atomic distinct: "yellow"
;;  atomic distinct: "green"




;; =================
;; Functions:

;; Light -> Image 
;; produce proper image of lights given current state of lights 
(check-expect (light-image "red")    (beside RON  YOFF GOFF))   
(check-expect (light-image "yellow") (beside ROFF YON  GOFF))   
(check-expect (light-image "green")  (beside ROFF YOFF GON))

#;
(define (light-image l)
  RON)

(define (light-image l)
  (cond [(string=? l "red")    (beside RON  YOFF GOFF)]
        [(string=? l "yellow") (beside ROFF YON  GOFF)] 
        [(string=? l "green")  (beside ROFF YOFF GON)]))
