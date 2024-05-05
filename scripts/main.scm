(load "./scripts/structs.scm")
(load "./scripts/utils.scm")
(load "./scripts/prompt.scm")
(load "./scripts/gol.scm")

(define camera-offset (make-point))

(define (update)
  ;;  (prompt-update) ;; it's eating the input!
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

  (if (eq? (rl-get-key-pressed) KEY_SPACE)
      (run-step)
      )
  
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


