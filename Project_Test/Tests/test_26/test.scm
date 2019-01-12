 
            ; matrix? checks to see if its argument is a matrix.
            ; It isn't foolproof, but it's generally good enough.
            (define matrix?
            (lambda (x)
                (and (vector? x)
                    (< 0 (vector-length x))
                    (vector? (vector-ref x 0)))))
    