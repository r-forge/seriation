## Criterion for the quality of a permutation of a dissimilarity
## matrix


criterion.dist <- function(x, order = NULL, method = NULL) {
    
   
    ## methods
    methods <- c(
        "path_length",
        "least_squares",
        "inertia",
        "ar_i",
        "ar_s",
        "ar_w",
        "me",
        "moore_stress",
        "neumann_stress"
    )

    if(is.null(method)) method <- methods[1]
    
    ## do more than one criterion
    if(method == "all") method <- methods
    if(length(method) > 1) return(sapply(method, 
            function(m) criterion(x, order, m), USE.NAMES = FALSE))

    methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))
    
    ## check dist (C code only works with lower-triangle version) 
    if(attr(x, "Diag") == TRUE || attr(x, "Upper") == TRUE)
        x <- as.dist(x, diag = FALSE, upper = FALSE)
    if (!is.real(x)) storage.mode(x) <- "real"
    
    ## get and check order 
    if (!is.null(order)){
        if((msg <- .check_order(order, x)) != TRUE) stop(msg)
        order <- order$order
    }

    
    ## work horses
    if(methodNr == 1) {
        crit <- .path_length(x, order)
    }else if (methodNr == 2) {
        crit <- .least_squares(x, order)
    }else if (methodNr == 3) {
        crit <- .inertia(x, order)
    }else if (methodNr == 4) {
        crit <- .ar(x, order, method = 1)  # i
    }else if (methodNr == 5) {
        crit <- .ar(x, order, method = 2)  # s
    }else if (methodNr == 6) {
        crit <- .ar(x, order, method = 3)  # w
    }else if (methodNr > 6) {
        crit <- criterion.matrix(as.matrix(x), order = Order(order), 
            method = method)
    }

    names(crit) <- methods[methodNr]
    return(crit)
}

## generic for criterion
criterion <- function(x, order = NULL, method = NULL) UseMethod("criterion")
criterion.default <- criterion.dist


## wrapper to computing the length of the order
## under a distance matrix, e.g. a tour where the
## leg between the first and last city is omitted.
## that this is a (Hamilton) path.
##
## note that this corresponds to the sum of distances 
## along the first off diagonal of the ordered distance
## matrix.
## 

## ceeboo 2005
.path_length <- function(dist, order = NULL) {
    if (is.null(order)) order <- 1:attr(dist, "Size")
    .Call("order_length", dist, order)
}


## least squares criterion. measures the difference between the 
## dissimilarities between two elements and the rank distance
## (PermutMatrix)
.least_squares <- function(dist, order = NULL) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("least_squares_criterion", dist, order)
}


## inertia around the diagonal (see PermutMatrix)
.inertia <- function(dist, order = NULL) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("inertia_criterion", dist, order)
}


## anti-Robinson loss functions (Streng and Schönfelder 1978, Chen 2002)
## method: 1...i, 2...s, 3...w
.ar <- function(dist, order = NULL, method = 1) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("ar", dist, order, as.integer(method))
}

