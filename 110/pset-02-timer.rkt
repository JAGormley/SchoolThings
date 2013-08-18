;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname pset-02-timer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; =================
;; Data definitions:

;; TimeLeft is one of:  
;;  - Natural[10, 30] 
;;  - Natural[1, 9]   
;;  - 0               
;; interp. the time left in the game  
(define T1 30)                        
(define T2 15)
(define T3 0)
#;
(define (fn-for-time-left t) 
  (cond [(<= 10 t 30) (... t)]
        [(<=  1 t  9) (... t)]        
        [else (...)]))

;; Template rules used:
;;  one of: 3 cases
;;  atomic non-distinct: interval Natural[10, 30]
;;  atomic non-distinct: interval Natural[1, 9]
;;  atomic distinct: 0


;; Light is one of: 
;;  - "green"
;;  - "yellow"
;;  - "red"
;; interp. the warning light displayed in the game
;; <examples are redundant for enumerations>
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

;; TimeLeft -> Light
;; produce appropriate light for time left
(check-expect (time-left->light 30) "green")  ; there are 2 intervals
(check-expect (time-left->light 20) "green")  ; 1 distinct (0) and 
(check-expect (time-left->light 10) "green")  ; 4 boundary cases
(check-expect (time-left->light  9) "yellow")
(check-expect (time-left->light  6) "yellow")
(check-expect (time-left->light  1) "yellow")
(check-expect (time-left->light  0) "red")


#;
(define (time-left->light t) 
  "green")                 

(define (time-left->light t)
  (cond [(<= 10 t 30) "green"]
        [(<=  1 t  9) "yellow"]
        [else "red"]))
