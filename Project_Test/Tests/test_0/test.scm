   
                ; Checking env working properly
                (define x (lambda (x1 x2) 
                              (lambda () 
                                    `(,x1 ,x2)
                                )   
                 
                 ))
                ((x 1 2))
    