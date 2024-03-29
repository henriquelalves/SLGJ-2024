(define a 0)

(define update
  (lambda ()
    (set! a (+ a 1))
    ))

(define draw
  (lambda ()
    (rl-draw-text (string-append (number->string a) " oi "))
    ))
