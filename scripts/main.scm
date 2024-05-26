(load "./scripts/structs.scm")
(load "./scripts/utils.scm")
(load "./scripts/prompt.scm")
(load "./scripts/gol.scm")

(define current-stage-number 0)
(define current-generation 0)
(define current-pressed-key #f)
(define starting-cells (list))
(define trigger-level-reload #t)
(define overlay-fade-time 0.0)
(define is-advancing #f)


(define stages (list (list '(1 . 0)
			   '(1 . 1)
			   '(0 . 0)
			   '(0 . 1))
		     (list '(0 . -1)
			   '(1 . 0)
			   '(0 . 1)
			   '(-1 . 0))
		     (list '(0 . 0)
			   '(0 . 1)
			   '(0 . 2))
		     (list '(0 . 0)
			   '(-1 . 0)
			   '(0 . -1))
		     (list '(1 . 0)
			   '(0 . 1))
		     (list '(2 . 0)
			   '(1 . 0)
			   '(1 . 1)
			   '(0 . 1)
			   '(0 . 2))
		     (list '(-1 . -1)
			   '(0 . -1)
			   '(1 . 0)
			   '(0 . 1)
			   '(-1 . 1)
			   '(-2 . 0))
		     (list '(-1 . -1)
			   '(0 . -1)
			   '(1 . -1)
			   '(-1 . 0)
			   '(1 . 0)
			   '(-1 . 1)
			   '(0 . 1)
			   '(1 . 1))
		     (list '(0 . -1)
			   '(0 . 0)
			   '(0 . 1)
			   '(1 . -1)
			   '(1 . 0)
			   '(1 . 1)
			   '(2 . 0))
		     ))

(define (update-generation)
  (clear-cells)
  (set-cells-array starting-cells)

  (let loop ((times 0))
    (if (< times current-generation)
	(begin (run-step)
	       (loop (+ times 1)))
	)
    )
  )

(define (is-solution? l1)
  (define trigger #t)
  (for-each (lambda (c)
	      (if (not (hash-table-ref current-cells c))
		  (begin (set! trigger #f)))
	      )
	    (stages current-stage-number))
  (and trigger (eq? (length (stages current-stage-number)) (length (hash-table-keys current-cells))))
  )

(define (update-game)
  
  (set! current-pressed-key (rl-get-key-pressed))
  
  (prompt-update)

  (if trigger-level-reload
      (begin (set! starting-cells (list))
	     (clear-cells)
	     (set-cells-array starting-cells)
	     (set! trigger-level-reload #f)))
  
  (cond ((and (not prompt-active) (not is-advancing))
	 (if (eq? current-pressed-key KEY_LEFT)
	     (cond ((> current-generation 0)
		    (set! current-generation (- current-generation 1))
		    (update-generation)))
	     )
	 
	 (if (eq? current-pressed-key KEY_RIGHT)
	     (cond ((< current-generation 1)
		    (set! current-generation (+ current-generation 1))
		    (update-generation)))
	     )
	 
	 ))

  (if (and (eq? current-generation 1) (not is-advancing))
      (if (is-solution? (stages current-stage-number))
	  (begin (set! is-advancing #t)
		 (set! overlay-fade-time 0.0))
	  )
      )

  (if (and (rl-is-mouse-button-pressed) (eq? current-generation 0))
      (let ((mouse-pos (rl-get-mouse-position)))
	(define tile-x (floor ( / (- (mouse-pos 0) 275) 50)))
	(define tile-y (floor ( / (- (mouse-pos 1) 200) 50)))
	(if (and (>= tile-x -1)
		 (<= tile-x 1)
		 (>= tile-y -1)
		 (<= tile-y 1))
	    (begin (toggle-cell `(,tile-x . ,tile-y))
		   (set! starting-cells (get-cells-list))))
	))

  (if is-advancing
      (set! overlay-fade-time (+ overlay-fade-time (rl-get-frame-time)))
      (set! overlay-fade-time (- overlay-fade-time (rl-get-frame-time)))
      )

  (if (> overlay-fade-time 1.0)
      (begin (set! is-advancing #f)
	     (clear-cells)
	     (set! starting-cells (list))
	     (set! current-generation 0)
	     (set! current-stage-number (+ current-stage-number 1))
	     )
      )
  )

(define (update-end)
  (if is-advancing
      (set! overlay-fade-time (+ overlay-fade-time (rl-get-frame-time)))
      (set! overlay-fade-time (- overlay-fade-time (rl-get-frame-time)))
      )
  )

(define (update)
  (if (>= current-stage-number (length stages))
      (update-end)
      (update-game)
      )
  )

(define (draw-game)
  (rl-draw-rectangle 0 0 600 450 (make-color 255 255 255 255))
  
  (prompt-draw)
  
  (rl-draw-text (string-append "Level " (number->string current-stage-number)) 75 15 20 (make-color 0 0 0 255))

  (draw-cells)

  (draw-grid)

  (draw-generation)
  
  (define lerped-alpha (* 255.0 overlay-fade-time) )
  (if (< lerped-alpha 0.0)
      (set! lerped-alpha 0.0))

  (rl-draw-rectangle 0 0 600 450 (make-color 255 255 255 (floor lerped-alpha)))
  )

(define (draw-end)
  (rl-draw-rectangle 0 0 600 450 (make-color 255 255 255 255))
  
  (rl-draw-text "The end! Thank you for playing :)"  38 200 30 (make-color 0 0 0 255))

  (rl-draw-text "Made with Raylib + S7 Scheme"  146 340 20 (make-color 0 0 0 255))
  
  (define lerped-alpha (* 255.0 overlay-fade-time) )
  (if (< lerped-alpha 0.0)
      (set! lerped-alpha 0.0))

  (rl-draw-rectangle 0 0 600 450 (make-color 255 255 255 (floor lerped-alpha)))
  )

(define (draw-generation)
  
  (let loop ((times 0))
    (if (< times 2)
	(begin
	  (rl-draw-rectangle (+ 75 (* times 40))
			     410
			     30
			     30
			     (make-color 190 190 190 255))
	  (if (eq? times current-generation)
	      (rl-draw-rectangle (+ 80 (* times 40))
				 415
				 20
				 20
				 (make-color 0 0 0 255)))
	  
	  (loop (+ times 1))
	  )))

  )

(define (draw)
  (if (>= current-stage-number (length stages))
      (draw-end)
      (draw-game)
      )
  )


(define (draw-grid)
  (define cell-width 50)
  (define cell-height 50)
  
  (let loop ((times 10))
    (if (> times 0)
	(begin (rl-draw-line (+ (* times cell-width) (* cell-width 0.5))
			     50
			     (+ (* times cell-width) (* cell-width 0.5))
			     400
			     (make-color 200 200 200 255))
	       (loop (- times 1)))
	)
    )

  (let loop ((times 8))
    (if (> times 0)
	(begin (rl-draw-line 75
			     (* times cell-height)
			     525
			     (* times cell-height)
			     (make-color 200 200 200 255))
	       (loop (- times 1)))
	)
    )

  (let loop ((times 4))
    (if (> times 0)
	(begin (rl-draw-line (+ (* times cell-width) 175)
			     150
			     (+ (* times cell-width) 175)
			     300
			     (make-color 0 0 0 255))
	       (loop (- times 1)))
	)
    )

  (let loop ((times 4))
    (if (> times 0)
	(begin (rl-draw-line 225
			     (+ (* times cell-height) 100)
			     375
			     (+ (* times cell-height) 100)
			     (make-color 0 0 0 255))
	       (loop (- times 1)))
	)
    )
  )

(define (draw-cells)
  (define cell-width 50)
  (define cell-height 50)
  (define cell-color (if (eq? current-generation 0)
			 (make-color 190 100 255 255)
			 (make-color 255 190 100 255)))

  
  (for-each (lambda (cell)
	      (rl-draw-rectangle
	       (+ (* (car cell) cell-width) (- 300 (* cell-width 0.5)) )
	       (+ (* (cdr cell) cell-height) (- 225 (* cell-height 0.5)) )
	       cell-width
	       cell-height
	       cell-color)
	      
	      ) (hash-table-keys current-cells))


  (for-each (lambda (cell)
	      (rl-draw-rectangle
	       (+ (* (car cell) 50) 290 )
	       (+ (* (cdr cell) 50) 215 )
	       20
	       20
	       (make-color 255 190 100 255))
	      
	      ) (stages current-stage-number))

  
  )
