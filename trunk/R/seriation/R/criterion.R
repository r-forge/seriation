
criterion <- function(x, order, method = NULL) {
    methods <- c(
        "path_length",
        "least_square",
        "inertia",
        "ar_i",
        "ar_s",
        "ar_w",
        "bond_energy"
    )

    if (!inherits(x,"dist")) stop(paste(sQuote("x"),"not of class dist"))
    
    if (!missing(order)){
        if (length(order) != attr(x,"Size"))
        stop(paste(sQuote("order"),"invalid length"))
        if (!is.integer(order)) storage.mode(order) <- "integer"
    }
    
    if (!is.real(x)) storage.mode(x) <- "real"

    if(is.null(method)) methodNr <- 1
    else methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))

    if(methodNr == 1) {
        crit <- path_length(x, order)
    }else if (methodNr == 2) {
        crit <- least_square(x, order)
    }else if (methodNr == 3) {
        crit <- inertia(x, order)
    }else if (methodNr == 4) {
        crit <- ar(x, order, method = 1)  # i
    }else if (methodNr == 5) {
        crit <- ar(x, order, method = 2)  # s
    }else if (methodNr == 6) {
        crit <- ar(x, order, method = 3)  # w
    }else if (methodNr == 7) {
        crit <- bond_energy(x, order)
    }

    #attr(crit, "method") <- methods[methodNr]
    return(crit)


}

# wrapper to computing the length of the order
# under a distance matrix, e.g. a tour where the
# leg between the first and last city is omitted.
# that this is a (Hamilton) path.
#
# note that this corresponds to the sum of distances 
# along the first off diagonal of the ordered distance
# matrix.
# 

# ceeboo 2005

path_length <- function(dist, order) {
    if (missing(order)) order <- 1:attr(dist, "Size")
    .Call("order_length", dist, order)
}



# least square criterion. measures the difference between the 
# dissimilarities between two elements and the rank distance
# see PermutMatrix

least_square <- function(dist, order) {
    if(missing(order)) order <- 1:attr(dist, "Size") 
    .Call("least_square_criterion", dist, order)
}

# inertia around the diagonal
# see PermutMatrix

inertia <- function(dist, order) {
    if(missing(order)) order <- 1:attr(dist, "Size") 
    .Call("inertia_criterion", dist, order)
}


# anti-Robinsin loss functions (Streng and Schönfelder 1978, Chen 2002)

# count the anti-Robinson events
ar <- function(dist, order, method = 1) {
    if(missing(order)) order <- 1:attr(dist, "Size") 
    .Call("ar", dist, order, as.integer(method))
}

# Energy from BEA
# this could be done with a regular matrix!
bond_energy <- function(dist, order){
    
    ener <- as.single(0.0)
    m <- as.matrix(dist)
    n <- ncol(m)

    if(!missing(order)) m <- m[order,order]
    storage.mode(m) <- "single"

    energy <- .Fortran("energy",
        n = n,
        m = n,
        b = m,
        ener = ener)
    
    as.numeric(energy$ener)
}
