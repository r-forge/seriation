
## Kendall's similarity matrix for abundance and incidence matrices

S <- function(x, w = 1) {
    sij <- function(i , j) w * sum(pmin(x[i,], x[j,]))

    h <- nrow(x)
    r <- matrix(ncol = h, nrow =h)
    for(i in 1:h) for (j in 1:h)  r[i,j] <- sij(i,j)

    r
}

SoS <- function(x) S(S(x))




## example
library("seriation")

load("Munsingen.rda")
library("MASS")


horse_shoe <- function(d) { 
    #r <- cmdscale(d)
    r <- isoMDS(d)$points
    #r <- sammon(d)$points
    #plot(r)

    tour <- solve_TSP(insert_dummy(TSP(dist(r)), label = "cut"), 
        method = "farthest")
    tour <- cut_tour(tour, "cut")

    pl_TSP <- function(x, data) {
        plot(data)

        lines(data[x,])
    }
    pl_TSP(tour, r)
    x11()

    tour
}


s <- SoS(Munsingen)
#s <- SoS(Munsingen)
d <- 1/(1+s)
s_t <- SoS(t(Munsingen))
d_t <- 1/(1+s_t)


order <- Order(row = horse_shoe(d), col = horse_shoe(d_t))
bertinplot(Munsingen, order, options= list(panel=panel.circles, 
        spacing = 0, rev = TRUE))

###

data(Townships)

s <- S(Townships)
d <- 1/(1+s)
s_t <- S(t(Townships))
d_t <- 1/(1+s_t)

order <- Order(row = horse_shoe(d), col = horse_shoe(d_t))

bertinplot(Townships, order, options= list(panel=panel.squares, 
        frame = TRUE, spacing = 0))




