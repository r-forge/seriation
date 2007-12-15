## Criterion for the quality of a permutation of a dissimilarity
## matrix

criterion.dist <- function(x, order = NULL, method = NULL) {
    
    ## get and check order 
    if(!is.null(order)) {
        if(!inherits(order, "ser_permutation"))
            order <- ser_permutation(order)
        .check_dist_perm(x, order)
    }
    
    ## check dist (C code only works with lower-triangle version) 
    if(attr(x, "Diag") == TRUE || attr(x, "Upper") == TRUE)
        x <- as.dist(x, diag = FALSE, upper = FALSE)
    if(!is.real(x)) mode(x) <- "real"

    methods <- get_criterion_methods("dist", method)

    if(!is.null(order)) order <- get_order(order)

    out <- sapply(methods, function(m) m$definition(x, order))
    names(out) <- names(methods)

    out
}

criterion.default <- criterion.dist

## Wrapper to computing the length of the order under a distance matrix,
## e.g. a tour where the leg between the first and last city is omitted.
## that this is a (Hamilton) path.
##
## Note that this corresponds to the sum of distances along the first
## off diagonal of the ordered distance matrix.

.path_length <- function(dist, order = NULL, ...) {
    if (is.null(order)) order <- 1:attr(dist, "Size")
    .Call("order_length", dist, order)
}


## Least squares criterion. measures the difference between the 
## dissimilarities between two elements and the rank distance
## (PermutMatrix).

.least_squares <- function(dist, order = NULL, ...) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("least_squares_criterion", dist, order)
}

## inertia around the diagonal (see PermutMatrix)
.inertia <- function(dist, order = NULL, ...) {
    if(is.null(order)) order <- 1:attr(dist, "Size") 
    .Call("inertia_criterion", dist, order)
}

## anti-Robinson loss functions (Streng and Schoenfelder 1978, Chen
## 2002)
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

.crit_matrix_ME <- function(x, order, ...)
    .crit_matrix(x, order, "ME")
.crit_matrix_Moore_stress  <- function(x, order, ...)
    .crit_matrix(x, order, "Moore_stress")
.crit_matrix_Neumann_stress  <- function(x, order, ...)
    .crit_matrix(x, order, "Neumann_stress")

set_criterion_method("dist", "AR_events" , .ar_i)
set_criterion_method("dist", "AR_deviations", .ar_s)
## set_criterion_method("dist", "AR_weighted", .ar_w)
set_criterion_method("dist", "Gradient_raw" , .gradient_raw)
set_criterion_method("dist", "Gradient_weighted", .gradient_weighted)
set_criterion_method("dist", "Path_length", .path_length,
                     "Hamiltonian path length")
set_criterion_method("dist", "Inertia", .inertia)
set_criterion_method("dist", "Least_squares", .least_squares)
set_criterion_method("dist", "ME", .crit_matrix_ME,
                     "Measure of effectiveness")
set_criterion_method("dist", "Moore_stress", .crit_matrix_Moore_stress)
set_criterion_method("dist", "Neumann_stress", .crit_matrix_Neumann_stress)
