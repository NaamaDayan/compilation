 
            ; matrix-ref returns the jth element of the ith row.
            (define matrix-ref
            (lambda (m i j)
                (vector-ref (vector-ref m i) j)))
    