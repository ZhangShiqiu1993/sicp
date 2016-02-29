#lang planet neil/sicp
(define (double f)(lambda (x) (f (f x))))
(define (compose f g)(lambda (x) (f (g x))))
(define (repeated f n)
  (define (big-enough? x) (>= (/ x 2) n))
  (define (iter k result)
    (cond ((= k 0) result)
          ((big-enough? k) (iter (/ k 2) (f (f result))))
          (else (iter (- k 1) (f result)))))
  (lambda (x) (iter n x)))
(define (average x y) (/ (+ x y) 2.0))

(define (average-damp f) (lambda (x) (average x (f x))))

(define (fixed-point f first-guess)
  (define tolerance 0.000000001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess))) ;(display guess) (newline)
      (if (close-enough? guess next) next (try next))))
  (try first-guess))

(define (expt base n)
  (if (= n 0) 1 ((repeated (lambda (x) (* base x)) n) 1)))

(define (log a b)
  (define (a-iter n result)
    (if (< b result)
        (- n 1)
        (a-iter (+ n 1) (* result a))))
  (a-iter 0 1))
(define lg (lambda (x) (log 2 x)))

(define (average-damp-n-times f n)
  ((repeated average-damp n) f))

(define (search-root n damp-times)
  (lambda (x)
    (fixed-point (average-damp-n-times
                (lambda (y) (/ x (expt y (- n 1))))
                damp-times)
               1.0)))

;((search-root 3 1) 8)
;((search-root 4 2) 16)
;((search-root 5 2) 32)
;((search-root 6 2) 64)
;((search-root 7 2) 128)
;((search-root 8 3) 256)
(define msg "将进行的阻尼次数： ")
(define (nth-root n)
  (let ((damp-time (lg n)))
    (lambda (x)
      (display msg) (display damp-time) (newline)
      ((search-root n damp-time) x))))
((nth-root 10) 1024)