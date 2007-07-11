## Criterion for the quality of a permutation of a dissimilarity
## matrix

criterion.dist <- function(x, order = NULL, method = "all") {
    
    ## get and check order 
    if (!is.null(order)){
        if(!inherits(order, "ser_permutation")) order <- ser_permutation(order)

        .check_dist_perm(x, order)
    }
    
    ## check dist (C code only works with lower-triangle version) 
    if(attr(x, "Diag") == TRUE || attr(x, "Upper") == TRUE)
        x <- as.dist(x, diag = FALSE, upper = FALSE)
    if (!is.real(x)) mode(x) <- "real"
    
    
    ## methods
    methods <- list(
        "AR_events"     = .ar_i,
        "AR_deviations" = .ar_s,
#        "AR_weighted"   = .ar_w,
        "Gradient_raw"  = .gradient_raw,
        "Gradient_weighted" = .gradient_weighted,
        "Path_length"   = .path_length,
        "Inertia"       = .inertia,
        "Least_squares" = .least_squares,
        "ME"            = .crit_matrix,
        "Moore_stress"  = .crit_matrix,
        "Neumann_stress"= .crit_matrix
    )
    
    ## do more than one criterion
    if(method == "all") method <- names(methods)
    if(length(method) > 1) return(sapply(method, 
            function(m) criterion(x, order, m), USE.NAMES = FALSE))
   
    if(!is.null(order)) order <- get_order(order)

    method <- .choose_method(method, methods)

    ## we need method for .crit_matrix
    crit <- methods[[method]](x, order, method = method)
    names(crit) <- method
    return(crit)
}


## wrapper to computing the length of the order
## under a distance matrix, e.g. a tour where the
## leg between the first and last city is omitted.
## that this is a (Hamilton) path.
##
## note that this corresponds to the sum of distances 
## along the first off diagonal of the ordered distance
## matrix.
## 
.path_length <- function(dist, order = NULL, ...) {
    if (is.null(order)) order <- 1:attr(dist, "Size")
    .Call("order_length", dist, order)
}


## least squares criterion. measures the difference between the 
## dissimilarities between two elements and the rank distance
## (PermutMatrix)
.least_squares <- function(dist, order = NULL, ...) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("least_squares_criterion", dist, order)
}


## inertia around the diagonal (see PermutMatrix)
.inertia <- function(dist, order = NULL, ...) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("inertia_criterion", dist, order)
}


## anti-Robinson loss functions (Streng and Schoenfelder 1978, Chen 2002)
## method: 1...i, 2...s, 3...w
.ar <- function(dist, order = NULL, method = 1) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("ar", dist, order, as.integer(method))
}

.ar_i <- function(dist, order, ...) .ar(dist, order, 1)
.ar_s <- function(dist, order, ...) .ar(dist, order, 2)
.ar_w <- function(dist, order, ...) .ar(dist, order, 3)

.gradient_raw <- function(dist, order, ...) {
    if(is.null(order)) order <- 1:attr(dist, "Size")
    .Call("gradient", dist, order, 1L)
}

.gradient_weighted <- function(dist, order, ...) {
    if(is.null(order)) order <- 1:attr(dist, "Size")
    .Call("gradient", dist, order, 2L)
}

## wrapper for criteria in matrix
.crit_matrix <- function(x, order, method) {
    ## uses method from the calling function

    if(!is.null(order)) 
    order <- ser_permutation(ser_permutation_vector(order), 
        ser_permutation(order))
    criterion.matrix(as.matrix(x), order, method) 
}


## generic for criterion
criterion <- function(x, order = NULL, method = "all") UseMethod("criterion")
criterion.default <- criterion.dist

