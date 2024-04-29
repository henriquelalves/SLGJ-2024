(load "./scripts/keys.scm")
(load "./scripts/structs.scm")
(load "./scripts/utils.scm")
(load "./scripts/prompt.scm")

;; (define a 0)
;; (define b (rl-load-texture))


(define (update)  
  (prompt-update)
  )

(define (draw)
  (prompt-draw)
  )


