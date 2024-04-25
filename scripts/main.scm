(define a 0)
(define b (rl-load-texture))

(define (update)
  (cond ((rl-is-key-down 262) (set! b (rl-load-texture))) ;; right
	((rl-is-key-down 263) (set! a (+ a 1))) ;; left
	((rl-is-key-down 264) (gc)) ;; down
	)
  )

(define (draw)
  (rl-draw-text (number->string a))
;    (rl-draw-texture b)
  )
