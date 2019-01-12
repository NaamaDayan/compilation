 
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

              ; matrix? checks to see if its argument is a matrix.
              ; It isn't foolproof, but it's generally good enough.
              (define matrix?
                (lambda (x)
                  (and (vector? x)
                      (< 0 (vector-length x))
                      (vector? (vector-ref x 0)))))

              ; matrix-rows returns the number of rows in a matrix.
              (define matrix-rows
                (lambda (x)
                  (vector-length x)))

              ; matrix-columns returns the number of columns in a matrix.
              (define matrix-columns
                (lambda (x)
                  (vector-length (vector-ref x 0))))

              ; matrix-ref returns the jth element of the ith row.
              (define matrix-ref
                (lambda (m i j)
                  (vector-ref (vector-ref m i) j)))

              ; matrix-set! changes the jth element of the ith row.
              (define matrix-set!
                (lambda (m i j x)
                  (vector-set! (vector-ref m i) j x)))

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

              ; mat-mat-mul multiplies one matrix by another, after verifying
              ; that the first matrix has as many columns as the second
              ; matrix has rows.
              (define mat-mat-mul
                (lambda (m1 m2)
                  (let* ([nr1 (matrix-rows m1)]
                        [nr2 (matrix-rows m2)]
                        [nc2 (matrix-columns m2)]
                        [r (make-matrix nr1 nc2)])
                        (letrec ([loop (lambda (i)
                        (if (= i nr1)
                            (begin r)
                            (begin
                                (letrec ([loop (lambda (j)
                                (if (= j nc2)
                                    #t
                                    (begin
                                        (letrec ([loop (lambda (k a)
                                        (if (= k nr2)
                                            (begin (matrix-set! r i j a))
                                            (begin
                                              (loop
                                                (+ k 1)
                                                (+ a
                                                  (* (matrix-ref m1 i k)
                                                      (matrix-ref m2 k j)))))))])
                                            (loop 0 0))
                                      (loop (+ j 1)))))])
                                (loop 0))
                        (loop (+ i 1)))))])
              (loop 0))))) 


                ; mul is the generic matrix/scalar multiplication procedure
                (define mul
                  (lambda (x y)
                    (cond
                      [(number? x)
                      (cond
                        [(number? y) (* x y)]
                        [(matrix? y) (mat-sca-mul x y)]
                        [else "this should be an error, but you don't support exceptions"])]
                      [(matrix? x)
                      (cond
                        [(number? y) (mat-sca-mul y x)]
                        [(matrix? y) (mat-mat-mul x y)]
                        [else "this should be an error, but you don't support exceptions"])]
                      [else "this should be an error, but you don't support exceptions"])))


                (mul '#(#(2 3 4)
                #(3 4 5))
              '#(#(1) #(2) #(3)))

              (mul '#(#(1 2 3))
                  '#(#(2 3)
                      #(3 4)
                      #(4 5)))

              (mul '#(#(1 2 3)
                      #(4 5 6))
                  '#(#(1 2 3 4)
                      #(2 3 4 5)
                      #(3 4 5 6)))


              (mul -2
                '#(#(3 -2 -1)
                  #(-3 0 -5)
                  #(7 -1 -1))
                  )


                  (mul 0.5 '#(#(1 2 3)) )
                  (mul 1 0.5)
    