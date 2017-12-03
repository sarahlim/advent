#lang racket

; (listof number?) -> number
; returns the difference between the max and min list items
(define (part-one vals)
  (if (empty? vals) 0
    (- (apply max vals)
       (apply min vals))))

; (listof number?) -> number
(define (part-two vals)
  (let ([pair (find-divisible-pair vals)])
    (if (empty? pair) 0
      (apply / pair))))

; (listof number?) -> '(number number)
(define (find-divisible-pair vals)
  (let ([pair (filter (lambda (pair)
                        (and (not (apply = pair))
                             (divides? pair)))
                      (cartesian-product vals vals))])
    (if (empty? pair) '()
      (first pair))))

; (number number) -> bool
(define (divides? pair)
  (zero? (modulo (first pair) (second pair))))

; ((listof number?) -> number) -> number
(define (compute-checksum checksum)
  (call-with-input-file "input"
    (lambda (in)
      (let loop ([line (read-line in)])
        (if (or (eof-object? line)
                (zero? (string-length line))) 0
          (+ (checksum
               (map string->number
                    (string-split line "\t")))
             (loop (read-line in))))))))

(printf "Part one: ~a\n" (compute-checksum part-one))
(printf "Part two: ~a\n" (compute-checksum part-two))
