(load "./scripts/keys.scm")
(load "./scripts/structs.scm")
(load "./scripts/utils.scm")
(load "./scripts/prompt.scm")
(load "./scripts/gol.scm")

(define camera-offset (make-point))

(define (update)  
  (prompt-update)

  (if (rl-is-key-down KEY_DOWN)
      (run-step)
      )
  )

(define (draw)
  (prompt-draw)

  (for-each (lambda (cell)
	      (rl-draw-rectangle
	       (* (car cell) 30)
	       (* (cdr cell) 30)
	       30
	       30
	       (make-color 190 100 255))
	      
	      ) (hash-table-keys current-cells))
  
  )


