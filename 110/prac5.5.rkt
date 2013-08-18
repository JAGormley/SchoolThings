;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname prac5.5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; ListOfString -> ListOfString
;; sort a list of strings into lexicographical order

;(check-expect (sort (list "sells" "tape" "chicken")) 
;(list "chicken" "sells" "tape"))

(check-expect (sort (cons "sells" (cons "tape" (cons "chicken" empty)))) (cons "chicken" (cons "sells" (cons "tape" empty))))

;; NEED TO BREAK LOS INTO 2 PARAMETERS SO FIRST OF REST CAN BE REPEATEDLY GOTTEN AT


(define (sort los)
  (cond [(empty? los) empty]
        [else 
         (place-string (first los)
                       (sort (rest los)))]))=

(define (place-string s los)
  (cond [(empty? los) (cons s empty)]
        [else
         (if
          (string<=? s (first los))
          (cons s los)
          (cons (first los)
                (place-string s (rest los))))]))






#;
(define (sort-balls lob)
  (cond [(empty? lob) empty]
        [else
         (insert-ball (first lob)
                      (sort-balls (rest lob)))]))
#;
(define (insert-ball b lob)
  (cond [(empty? lob) (cons b empty)]
        [else
         (if (ball<=? b (first lob))
             (cons b lob)
             (cons (first lob)
                   (insert-ball b (rest lob))))]))

