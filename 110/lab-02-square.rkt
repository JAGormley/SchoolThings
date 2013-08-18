;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lab-02-square) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; CPSC 110 Lab 2, Problem 1

(require 2htdp/image)


; Image -> Bool
; determines truth or falsity of an image's squareness

;(define (square? img) ;stub
;  true)

;(define (square? img) ;template
;  (... img))

(check-expect (square? (rectangle 20 25 "solid" "blue")) false)
(check-expect (square? (triangle 20 "solid" "blue")) false)
(check-expect (square? (rectangle 20 20 "solid" "blue")) true)


(define (square? img)
  (= (image-width img) (image-height img)) )

(square? (rectangle 20 20 "solid" "blue"))
