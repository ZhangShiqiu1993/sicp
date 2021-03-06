#lang planet neil/sicp
(define (average x y) (/ (+ x y) 2.0))
(define (square x) (* x x))
(define (average-damp f) (lambda (x) (average x (f x))))
(define tolerance 0.000000001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (display guess)
      (newline)
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))
(define dx 0.00000001)

(define (cube x) (* x x x))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

;(define (sqrt1 x)
 ; (newtons-method (lambda (y) (- (square y) x)) 1.0))
;(define (sqrt2 x)
 ; (fixed-point (average-damp (lambda (y)(/ x y))) 1.0))

(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g) guess))