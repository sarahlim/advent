#lang racket

(require test-engine/racket-tests)

; number -> number
; maps an index in the spiral to an equivalence "ring" of the spiral,
; given as the minimum possible Manhattan distance to the origin
; from some point in the ring.
(define (ring-distance n)
  (inexact->exact
    (floor (/ (ceiling (sqrt n))
              2))))

(check-expect (ring-distance 1) 0)
(check-expect (ring-distance 2) 1)
(check-expect (ring-distance 9) 1)
(check-expect (ring-distance 10) 2)
(check-expect (ring-distance 23) 2)
(check-expect (ring-distance 26) 3)
(check-expect (ring-distance 64) 4)

; number -> (listof number)
; given a ring-distance, return a list of positions within that ring
; whose distance to the origin is exactly ring-distance
(define (midpoints d)
  (let ([last-posn (sqr (+ 1 (* 2 d)))]
        [intervals (cons 0
                         (build-list 4
                                     (lambda (n) (+ 1 (* 2 n)))))])
    (map (lambda (i) (abs (- last-posn (* i d))))
         intervals)))

(check-expect (midpoints 0) '(1 1 1 1 1))
(check-expect (midpoints 1) '(9 8 6 4 2))
(check-expect (midpoints 2) '(25 23 19 15 11))
(check-expect (midpoints 3) '(49 46 40 34 28))

; number -> number
; given a position in the ring, return the distance from that
; position to the nearest midpoint in that ring
(define (distance-to-midpoint n)
  (apply min
         (map (lambda (midpoint)
                (abs (- n midpoint)))
              (midpoints (ring-distance n)))))

(check-expect (distance-to-midpoint 1) 0)
(check-expect (distance-to-midpoint 2) 0)
(check-expect (distance-to-midpoint 53) 0)
(check-expect (distance-to-midpoint 57) 4)
(check-expect (distance-to-midpoint 64) 3)

; number -> number
; given a position in the ring, return the Manhattan distance
; from that position to the origin
(define (part-one n)
  (+ (ring-distance n)
     (distance-to-midpoint n)))

(check-expect (part-one 12) 3)
(check-expect (part-one 23) 2)
(check-expect (part-one 1024) 31)

(define input 325489)
(printf "Part one: ~a\n" (part-one input))

(test)
