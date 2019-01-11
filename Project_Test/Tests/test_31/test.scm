   
            (define foo5
            (lambda (x y)
                (lambda () 
                        "\n \r \f this is \n \r \f "
                        (set! x 5))
                (lambda () x)
            ))

        ((foo5 1 2))   
    