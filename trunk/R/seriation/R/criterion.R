# Criterion for the quality of a permutation of a dissimilarity
# or general matrix


criterion.dist <- function(x, order, method = NULL, ...) {
    
    # get and check order 
    if (!missing(order)){
        if (length(order) != attr(x,"Size"))
        stop(paste(sQuote("order"),"invalid length"))
        if (!is.integer(order)) order <- as.integer(order)
    }
    
    # methods
    methods <- c(
        "path_length",
        "least_square",
        "inertia",
        "ar_i",
        "ar_s",
        "ar_w"
    )
    
    if(is.null(method)) methodNr <- 1
    else methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))
    
    # check dist (C code only works with lower-triangle version) 
    if(attr(x, "Diag") == TRUE || attr(x, "Upper") == TRUE)
        x <- as.dist(x, diag = FALSE, upper = FALSE)
    if (!is.real(x)) storage.mode(x) <- "real"

    
    # work horses
    if(methodNr == 1) {
        crit <- .path_length(x, order)
    }else if (methodNr == 2) {
        crit <- .least_square(x, order)
    }else if (methodNr == 3) {
        crit <- .inertia(x, order)
    }else if (methodNr == 4) {
        crit <- .ar(x, order, method = 1)  # i
    }else if (methodNr == 5) {
        crit <- .ar(x, order, method = 2)  # s
    }else if (methodNr == 6) {
        crit <- .ar(x, order, method = 3)  # w
    }

    attr(crit, "method") <- methods[methodNr]
    return(crit)
}

criterion.matrix <- function(x, order, method = NULL, ...) {

    # get order
    if(missing(order)) col_order <- row_order <- NULL
    else if(is.list(order)) {
        col_order <- order$c
        row_order <- order$r
    }else col_order <- row_order <- order
        
    # check dimensions
    if(!is.null(col_order) && ncol(x) != length(col_order))
    stop(paste("lengths of", sQuote("col_order"),
            "does not match dimensions of", sQuote("x")))
    if(!is.null(row_order) && nrow(x) != length(row_order))
    stop(paste("lengths of", sQuote("row_order"),
            "does not match dimensions of", sQuote("x")))

    # methods
    methods <- c(
        "bond_energy"
    )
   
    if(is.null(method)) methodNr <- 1
    else methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))
    
    # check matrix
    #if (!is.real(x)) storage.mode(x) <- "real"

    # work horses
    if (methodNr == 1) {
        crit <- .bond_energy(x, col_order, row_order)
    }

    attr(crit, "method") <- methods[methodNr]
    crit
}
    

# generic for criterion
criterion <- function(x, order, method = NULL, ...) UseMethod("criterion")
criterion.default <- criterion.dist


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
.path_length <- function(dist, order) {
    if (missing(order)) order <- 1:attr(dist, "Size")
    .Call("order_length", dist, order)
}


# least square criterion. measures the difference between the 
# dissimilarities between two elements and the rank distance
# (PermutMatrix)
.least_square <- function(dist, order) {
    if(missing(order)) order <- 1:attr(dist, "Size") 
    .Call("least_square_criterion", dist, order)
}


# inertia around the diagonal (see PermutMatrix)
.inertia <- function(dist, order) {
    if(missing(order)) order <- 1:attr(dist, "Size") 
    .Call("inertia_criterion", dist, order)
}


# anti-Robinson loss functions (Streng and Schönfelder 1978, Chen 2002)
# method: 1...i, 2...s, 3...w
.ar <- function(dist, order, method = 1) {
    if(missing(order)) order <- 1:attr(dist, "Size") 
    .Call("ar", dist, order, as.integer(method))
}

# Bond energy (BEA)
.bond_energy <- function(x, col_order = NULL, row_order = NULL){
    
    if(any(x < 0)) stop("Bond energy is only defined for nonnegative matrices!")
    
    n <- nrow(x)
    m <- ncol(x)

    if(is.null(col_order) && is.null(row_order)) 1 #do nothing
    else if(is.null(row_order)) x <- x[, col_order]
    else if(is.null(col_order)) x <- x[row_order, ]
    else x <- x[row_order, col_order]
    
    storage.mode(x) <- "single"

    energy <- .Fortran("energy",
        n = n,
        m = m,
        b = x,
        ener = as.single(0.0))
    
    as.numeric(energy$ener)
}
