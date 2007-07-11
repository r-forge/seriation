library(seriation)

m <- matrix(c(
        1,1,0,0,0,
        1,1,1,0,0,
        0,0,1,1,1,
        1,0,1,1,1
    ), byrow=TRUE, ncol=5) 

d <- dist(m)
as.matrix(d)


criterion(d, method="AR_events") 
## 2

criterion(d, method="AR_deviations")
## 2.000000 - 1.732051 +  2.236068 - 2.000000 
## = 0.504017

criterion(d, method="Gradient_raw")
## 6 - 2 = 4

criterion(d, method="Gradient_weighted")
## -1 *(1.000000 - 2.236068 + 1.000000 - 2.000000 + 2.236068 - 2.000000 + 2.000000 - 1.732051 + 1.000000 - 1.732051 + 1.000000 - 2.000000 + 1.732051 - 2.000000 + 2.000000 - 2.236068) 
## = 3.968119


