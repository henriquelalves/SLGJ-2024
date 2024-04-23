(define a 0)
(define b 0)

(define update
  (lambda ()
    (set! a (+ a 1))
    (set! b (rl-load-texture))
    (display b)
    (newline)
    (gc-run)
    ))

(define draw
  (lambda ()
    (rl-draw-text (number->string a))
    ))
