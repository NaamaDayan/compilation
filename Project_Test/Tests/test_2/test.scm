   
                (define append 
                  (let ((null? null?) (car car) (cdr cdr) (cons cons)) 5))
                
                  (define zero? 
                    (let ((= =))
                      (lambda (x) (= x 0))))
    