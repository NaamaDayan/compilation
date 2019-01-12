 
            ; mat-sca-mul multiplies a matrix by a scalar.
            (define mat-sca-mul
            (lambda (x m)
                (let* ([nr (matrix-rows m)]
                    [nc (matrix-columns m)]
                    [r (make-matrix nr nc)])
                    (letrec ([loop (lambda (i)
                    (if (= i nr)
                        (begin r)
                        (begin
                            (letrec ([loop2 (lambda (j)
                            (if (= j nc)
                                #t
                                (begin
                                    (matrix-set! r i j (* x (matrix-ref m i j)))
                                    (loop2 (+ j 1)))))])
            (loop2 0))
                            (loop (+ i 1)))))])
            (loop 0)))))
    