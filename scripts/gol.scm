(define current-cells (make-hash-table))

(define neighbors
  '((-1 . -1) (0 . -1) (1 . -1) (-1 . 0) (1 . 0) (-1 . 1) (0 . 1) (1 . 1)))

(set! (current-cells '(1 . 1)) #t)
(set! (current-cells '(1 . 2)) #t)
(set! (current-cells '(1 . 3)) #t)

(define sum-cells
  (lambda (c1 c2)
    (cons (+ (car c1) (car c2)) (+ (cdr c1) (cdr c2)))))

(define diff-cells
  (lambda (c1 c2)
    (cons (- (car c1) (car c2)) (- (cdr c1) (cdr c2)))))

(define sum-all-cells
  (lambda (lat)
    (cond ((null? (cdr lat)) (car lat))
          (else (let ((c1 (car lat)) (c2 (sum-all-cells (cdr lat))))
                  (sum-cells c1 c2)
                  )))))

(define is-hash-neighbor?
  (lambda (c1 c2)
    (let ((d (diff-cells c1 c2)))
      (and (<= (car d) 1) (>= (car d) -1) (<= (cdr d) 1) (>= (cdr d) -1)))))

(define count-elements
  (lambda (lat s)
    (cond ((null? lat) s)
          (else (count-elements (cdr lat) (+ s 1))))))

(define list-neighbors
  (lambda (c)
    (map (lambda (n)
           (sum-cells c n))
         neighbors)))

(define sum-live-cells
  (lambda (lat n)
    (cond ((null? lat) n)
          (else (cond ((current-cells (car lat)) (sum-live-cells (cdr lat) (+ n 1)))
                      (else (sum-live-cells (cdr lat) n)))))))

(define list-all-neighbors
  (lambda (lat cells)
    (cond ((null? lat) cells)
          (else
           (map (lambda (new-neighbor)
                  (set! (cells new-neighbor) #t))
                (cons (car lat) (list-neighbors (car lat))))
           (list-all-neighbors (cdr lat) cells)))))

(define (hash-table-keys ht)
  (map (lambda (kv)
	 (kv 0)
	 )
       ht)
  )

(define run-step
  (lambda ()
    (let ((temp-hash (make-hash-table)) (next-cells (make-hash-table)))
      (map (lambda (temp-cell)
             (let ((n (sum-live-cells (list-neighbors temp-cell) 0)))
               (cond ((current-cells temp-cell)
                      (cond ((and (>= n 2) (<= n 3)) (set! (next-cells temp-cell) #t))))
                     (else (cond ((eq? n 3) (set! (next-cells temp-cell) #t))))))
             )
           (hash-table-keys (list-all-neighbors (hash-table-keys current-cells) temp-hash)))
      (set! current-cells  next-cells)
      )
    )
  )
