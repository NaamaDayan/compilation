 
            ; matrix-set! changes the jth element of the ith row.
            (define matrix-set!
            (lambda (m i j x)
                (vector-set! (vector-ref m i) j x)))
    