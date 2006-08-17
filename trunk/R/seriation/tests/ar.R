#library(seriation)

m <- matrix(c(
        1,1,0,0,0,
        1,1,1,0,0,
        0,0,1,1,1,
        1,0,1,1,1
    ), byrow=TRUE, ncol=5) 

d <- dist(m)
as.matrix(d)


criterion(d, method="ar_i")
criterion(d, method="ar_s")
criterion(d, method="ar_w")

