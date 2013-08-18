;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lab-02-boxify) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; CPSC 110 Lab 2, Problem 2

(require 2htdp/image)

;; Image -> Image
;; take an image and overlay it onto the outline of a box of the same size


;(define (boxify img) ;stub
;  (circle 20 "solid" "blue"))

;(define (boxify img) ;template
;  ... img)

(define (boxify img)
  (overlay img (rectangle (image-width img) (image-height img) "outline" "red")))

(check-expect (boxify (circle 10 "outline" "green")) (overlay (circle 10 "outline" "green")
           (rectangle 20 20 "outline" "red")))

(check-expect (boxify (triangle 30 "outline" "green")) (overlay (triangle 30 "outline" "green")
           (rectangle 30 26 "outline" "red")))

(check-expect (boxify (rectangle 25 35 "solid" "blue")) (overlay (rectangle 25 35 "solid" "blue")
           (rectangle 25 35 "outline" "red")))


(boxify (ellipse 320 216 "solid" "purple"))