(define prompt-active #f)
(define prompt-box (make-rect 0 0 800 20))
(define prompt-text "")

(define (prompt-update)
  (if (eq? current-pressed-key KEY_F1)
      (set! prompt-active (not prompt-active))
      )
  
  (if prompt-active
      (begin
	(let ((key (rl-get-char-pressed)))
	  (cond ((and (>= key 32) (<= key 125))
		 (set! prompt-text
		       (string-append prompt-text (string (integer->char key)))))
		))
	
	(if (rl-is-key-down KEY_ENTER)
	    (begin
	      (eval-string prompt-text)
	      (set! prompt-text "")
	      ))
	
	(if (eq? current-pressed-key KEY_BACKSPACE)
	    (let ((n (string-length prompt-text)))
	      (cond ((>= n 1)
		     (set! prompt-text (substring prompt-text 0 (- n 1))))
		    )))
	
	))
  
  )

(define (prompt-draw)
  (if prompt-active
      (begin
	(rl-draw-rectangle
	 (rect-x prompt-box)
	 (rect-y prompt-box)
	 (rect-width prompt-box)
	 (rect-height prompt-box)
	 (make-color 190 100 255 255))
	(rl-draw-text prompt-text 0 0 20 (make-color 0 0 0 255))
	))
  )
