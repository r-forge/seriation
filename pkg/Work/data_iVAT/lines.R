### lines data set from iVAT paper

n1 <- 100
n2 <- 50
n3 <- 100

x1 <- data.frame(x = runif(n1, -5, 5), y = rnorm(n1, mean = 2, sd = .1))
x2 <- data.frame(x = runif(n2, -3, 3), y = rnorm(n2, mean = 0, sd = .1))
x3 <- data.frame(x = runif(n3, -5, 5), y = rnorm(n3, mean = -2, sd = .1))

x <- rbind(x1, x2, x3)
x <- x[sample(nrow(x)),]


plot(x, xlim=c(-5,5), ylim=c(-4,4), cex=.2)

library(seriation)
d <- dist(x)
pimage(d)

pimage(d, seriate(d, "VAT"))
pimage(d, seriate(d, "ARSA"))
pimage(d, seriate(d, "TSP"))
pimage(d, seriate(d, "MDS"))
pimage(d, seriate(d, "Spectreal"))
pimage(d, seriate(d, "HC_single"))
pimage(d, seriate(d, "HC_complete"))
pimage(d, seriate(d, "HC_average"))
pimage(d, seriate(d, "OLO"))
pimage(d, seriate(d, "OLO", control=list(method="single")))
pimage(d, seriate(d, "GW", control=list(method="single")))
pimage(d, seriate(d, "SPIN_NH"))
