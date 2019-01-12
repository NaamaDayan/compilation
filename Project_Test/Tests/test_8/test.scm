   
                  (define cons (lambda (x y) 
                  (lambda (f) 
                    (f x y))))
              (define car (lambda (c) (c (lambda (x y) x))))
              (define cdr (lambda (c) (c (lambda (x y) y))))

              (map cdr (map (lambda (x) (cons x (* x x))) '(1 2 3 4)))
    