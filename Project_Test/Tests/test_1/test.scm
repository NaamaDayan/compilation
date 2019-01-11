   
                    ; Checking env working properly
                  (define x (lambda (x1 x2 x3 x4 x5 x6 x7 x8 x9 . x10) 
                              (lambda (y1 y2 y3 y4 y5 y6 y7 y8 y9 . y10) 
                                    (lambda (z1 z2 z3 z4 z5 z6 z7 z8 z9 . z10) 
                                        (lambda (k1 k2 k3 k4 k5 k6 k7 k8 k9 . k10) 
                                            (lambda (l1 l2 l3 l4 l5 l6 l7 l8 l9 . l10) 
                                                 (lambda (h1 h2 h3 h4 h5 h6 h7 h8 h9 . h10) 
                                                    `(,x1 ,x2 ,x3 ,x4 ,x5 ,x6 ,x7 ,x8 ,x9 ,@x10 
                                                      ,y1 ,y2 ,y3 ,y4 ,y5 ,y6 ,y7 ,y8 ,y9 ,@y10
                                                      ,z1 ,z2 ,z3 ,z4 ,z5 ,z6 ,z7 ,z8 ,z9 ,@z10
                                                      ,k1 ,k2 ,k3 ,k4 ,k5 ,k6 ,k7 ,k8 ,k9 ,@k10
                                                      ,l1 ,l2 ,l3 ,l4 ,l5 ,l6 ,l7 ,l8 ,l9 ,@l10
                                                      ,h1 ,h2 ,h3 ,h4 ,h5 ,h6 ,h7 ,h8 ,h9 ,@h10
                                                  )
                                            )
                                
                                        ) 
                                
                                   ) 
                                
                             ) 
                          )   
                 )
)
                ((((((x 1 2 3 4 5 6 7 8 9 10) 11 12 13 14 15 16 17 18 19 20 -11) 21 22 23 24 25 26 27 28 29 30 -30 -31) 31 32 33 34 35 36 37 38 39 40 -40 -41 -42 -43) 41 42 43 44 45 46 47 48 49 50 -50 -51 -52 -53 -54 -55 -56) 51 52 53 54 55 56 57 58 59 60 -55 -66 -77 -88 -99 -100)     
    