(load "./scripts/keys.scm")
(load "./scripts/structs.scm")
(load "./scripts/utils.scm")

;; (define a 0)
;; (define b (rl-load-texture))

(define text-box (make-rect 30 180 250 80))
(define mouse-on-text #f)


(define (update)
;;  (cond ((rl-is-key-down KEY_RIGHT) (set! b (rl-load-texture))) ;; right
;;	((rl-is-key-down KEY_LEFT) (set! a (+ a 1))) ;; left
;;	((rl-is-key-down KEY_DOWN) (gc)) ;; down
;;	)
;; (display (rl-get-mouse-position))
;; (newline)
  
  (define mouse-pos (rl-get-mouse-position))
  (define mouse-pos-point (make-point (mouse-pos 0) (mouse-pos 1)))
  (set! mouse-on-text (is-point-inside-rect? mouse-pos-point text-box))


  #f
  )

(define (draw)
  (rl-draw-rectangle (rect-x text-box) (rect-y text-box) (rect-width text-box) (rect-height text-box) (make-color 190 100 255))

  (rl-draw-text (format #f "~A" mouse-on-text) 100 100 30 (make-color 100 100 100))
  #f
  )
