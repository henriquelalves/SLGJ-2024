;; ============================================================
;; define defstruct macro
(define-macro (defstruct struct-name . fields)
  (let* ((name (if (list? struct-name) (car struct-name) struct-name))
	 (sname (if (string? name) name (symbol->string name)))

	 (fsname (if (list? struct-name)
		     (let ((cname (assoc :conc-name (cdr struct-name))))
		       (if cname
			   (symbol->string (cadr cname))
			   sname))
		     sname))

	 (make-name (if (list? struct-name)
			(let ((cname (assoc :constructor (cdr struct-name))))
			  (if cname
			      (cadr cname)
			      (symbol "make-" sname)))
			(symbol "make-" sname)))

	 (copy-name (if (list? struct-name)
			(let ((cname (assoc :copier (cdr struct-name))))
			  (if cname
			      (cadr cname)
			      (symbol "copy-" sname)))
			(symbol "copy-" sname)))

	 (field-names (map (lambda (n)
			     (symbol->string (if (list? n) (car n) n)))
			   fields))

	 (field-types (map (lambda (field)
			     (if (list? field)
				 (apply (lambda* (val type read-only) type) (cdr field))
				 #f))
			   fields))

	 (field-read-onlys (map (lambda (field)
				  (if (list? field)
				      (apply (lambda* (val type read-only) read-only) (cdr field))
				      #f))
				fields)))
    
    `(begin
       (define ,(symbol sname "?")
	 (lambda (obj)
	   (and (vector? obj)
		(eq? (obj 0) ',(string->symbol sname)))))

       (define* (,make-name
		 ,@(map (lambda (n)
			  (if (and (list? n)
				   (>= (length n) 2))
			      (list (car n) (cadr n))
			      (list n #f)))
			fields))
	 (vector ',(string->symbol sname) ,@(map string->symbol field-names)))

       (define ,copy-name copy)

       ,@(map (let ((ctr 1))
		(lambda (n type read-only)
		  (let ((val (if read-only
				 `(define ,(symbol fsname "-" n)
				    (lambda (arg) (arg ,ctr)))
				 `(define ,(symbol fsname "-" n)
				    (dilambda
				     (lambda (arg) (arg ,ctr))
				     (lambda (arg val) (set! (arg ,ctr) val)))))))
		    (set! ctr (+ 1 ctr))
		    val)))
	      field-names field-types field-read-onlys))))


;; ============================================================
;; Structures

(defstruct rect (x 0.0) (y 0.0) (width 0.0) (height 0.0))
(defstruct point (x 0.0) (y 0.0))
(defstruct stage (width 0) (height 0) (generations 0) (final-state #f))
