;;;; Definitions


;;; MIT Scheme

(define lib:cons (%make-tag-aware cons))
(define lib:cons* (%make-tag-aware cons*))
(define lib:list (%make-tag-aware list))

(define lib:apply
  (%make-tag-aware
   (lambda (f . args)
     ;; The cons* allows the usage (apply f arg1 arg2 ... rest-of-args).
     (execute-application f (apply cons* args)))))

(define lib:procedure?
  (%make-tag-aware
   (lambda (f)
     (or (procedure? f)
         (tag-aware? f)
         (compound-procedure? f)
         (madlab-procedure? f)))))


;;; Dwimiykwim

(define lib:tag (%make-tag-aware tag))
(define lib:tags (%make-tag-aware tags))
(define lib:untag (%make-tag-aware untag))
;; It's not tag-aware, so it strips tags.
(define lib:clear-tags identity)


;;;; Bindings


(define library-exps '(


;;; MIT Scheme

(define cons lib:cons)
(define cons* lib:cons*)
(define list lib:list)
(define apply lib:apply)
(define procedure? lib:procedure?)

(define (map f xs)
  (if (null? xs)
      '()
      (cons (f (car xs)) (map f (cdr xs)))))

(define (filter keep? xs)
  (if (null? xs)
      '()
      (let ((x (car xs))
            (rest (filter keep? (cdr xs))))
        (if (keep? x)
            (cons x rest)
            rest))))


;;; Utils

(define (identity x) x)

(define (any? x) #t)

(define (compose f g)
  (lambda args
    (f (apply g args))))

(define (partial-apply f . args)
  (lambda more-args
     (apply f (append args more-args))))

(define (zip f xs ys)
  (cond
   ((null? xs) '())
   ((null? ys) '())
   (else (cons (f (car xs) (car ys)) (zip f (cdr xs) (cdr ys))))))


;;; Dwimiykwim

(define tag lib:tag)
(define tags lib:tags)
(define untag lib:untag)
(define clear-tags lib:clear-tags)

(define (has-tag? name)
  (lambda (x)
    (member name (tags x))))

(define (?? proc . args)
  (infer proc args))

(define (??:apply proc . args)
  (lambda more-args
    (infer proc (append args more-args))))

(define (~~ names x)
  (tag (if (list? names)
           names
           (list names))
       x))

(define (~~:delq names x)
  (untag (if (list? names)
             names
             (list names))
         x))

(define (fold-left (proc procedure?)
                   (init (has-tag? 'init))
                   (xs list?))
  (if (null? xs)
      (untag '(init) init)
      (fold-left proc
                 (~~ 'init (proc (untag '(init) init) (car xs)))
                 (cdr xs))))

))
