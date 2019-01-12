   
                  (define foo (lambda (n) 
                    (if (= n 0)
                        'finish
                        (foo (- n 1))
                    )
                  )
                  )

          (foo 1000000)
    