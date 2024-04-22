(define a 0)
(define b 0)

(define (update)
  (set! a (+ a 1))
  (set! b (rl-load-texture "./assets/test.png"))
  ;; Not displaying the next lines makes the crash take longer to happen
  (display a)
  (newline)
  (display b)
  (newline)
  )

(define (draw)
  (newline)
  )
