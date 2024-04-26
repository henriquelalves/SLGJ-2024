(load "./scripts/keys.scm")

(define a 0)
(define b (rl-load-texture))

(define (update)
  (cond ((rl-is-key-down KEY_RIGHT) (set! b (rl-load-texture))) ;; right
	((rl-is-key-down KEY_LEFT) (set! a (+ a 1))) ;; left
	((rl-is-key-down KEY_DOWN) (gc)) ;; down
	)
  )

(define (draw)
  (rl-draw-text (number->string a))
  (rl-draw-texture b)
  )
