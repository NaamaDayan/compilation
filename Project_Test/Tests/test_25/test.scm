  
        (define andmap (lambda (p lst)
                (or (null? lst)
                    (and (p (car lst)) (andmap p (cdr lst)))) ))
        ; make-matrix creates a matrix (a vector of vectors).
        ; make-matrix creates a matrix (a vector of vectors).
        (define make-matrix
        (lambda (rows columns)
        (letrec ([loop (lambda (m i)
        (if (= i rows)
            (begin m)
            (begin
                (vector-set! m i (make-vector columns))
                (loop m (+ i 1)))))])
        (loop (make-vector rows) 0)))) 
    