(load "./scripts/structs.scm")
(load "./scripts/utils.scm")
(load "./scripts/prompt.scm")
(load "./scripts/gol.scm")

(define camera-offset (make-point))
(define space-pressed #f)

(define (update)
  (prompt-update)

  (cond ((not prompt-active)
	 (if (rl-is-key-down KEY_DOWN)
	     (set! (point-y camera-offset) (+ (point-y camera-offset) 2))
	     )
	 
	 (if (rl-is-key-down KEY_UP)
	     (set! (point-y camera-offset) (+ (point-y camera-offset) -2))
	     )

	 (if (rl-is-key-down KEY_LEFT)
	     (set! (point-x camera-offset) (+ (point-x camera-offset) -2))
	     )
	 
	 (if (rl-is-key-down KEY_RIGHT)
	     (set! (point-x camera-offset) (+ (point-x camera-offset) 2))
	     )
	 
	 (cond ((and (rl-is-key-down KEY_SPACE) (not space-pressed))
		(set! space-pressed #t)
		(run-step))
	       )
	 
	 (if (not (rl-is-key-down KEY_SPACE))
	     (set! space-pressed #f)
	     )
	 ))
  )

(define (draw)
  (prompt-draw)

  (for-each (lambda (cell)
	      (rl-draw-rectangle
	       (+ (* (car cell) 30) (point-x camera-offset))
	       (+ (* (cdr cell) 30) (point-y camera-offset))
	       30
	       30
	       (make-color 190 100 255))
	      
	      ) (hash-table-keys current-cells))
  
  )


