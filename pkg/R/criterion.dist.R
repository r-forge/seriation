## Criterion for the quality of a permutation of a dissimilarity
## matrix

criterion.dist <- function(x, order = NULL, method = NULL) {
    
    ## check order and x
    if(!is.null(order)) {
        if(!inherits(order, "ser_permutation"))
            order <- ser_permutation(order)
        .check_dist_perm(x, order)
    }
    
    ## check dist (most C code only works with lower-triangle version) 
    if(attr(x, "Diag") || attr(x, "Upper"))
        x <- as.dist(x, diag = FALSE, upper = FALSE)
    if(!is.double(x)) mode(x) <- "double"

    ## get methods
    if(is.null(method)) method <- list_criterion_methods("dist") 
    method <- lapply(method, function(m ) get_criterion_method("dist", m))
    
    sapply(method, 
        function(m) structure(m$definition(x, order), names=m$name))
}

criterion.default <- criterion.dist

## Wrapper to computing the length of the order under a distance matrix,
## e.g. a tour where the leg between the first and last city is omitted.
## that this is a (Hamilton) path.
##
## Note that this corresponds to the sum of distances along the first
## off diagonal of the ordered distance matrix.

criterion_path_length <- function(x, order = NULL, ...) {
    if (is.null(order)) order <- 1:attr(x, "Size")
    else order <- get_order(order)
    .Call("order_length", x, order)
}


## Least squares criterion. measures the difference between the 
## dissimilarities between two elements and the rank distance
## (PermutMatrix).

criterion_least_squares <- function(x, order = NULL, ...) {
    if(is.null(order)) order <- 1:attr(x, "Size") 
    else order <- get_order(order)
    .Call("least_squares_criterion", x, order)
}

## inertia around the diagonal (see PermutMatrix)
criterion_inertia <- function(x, order = NULL, ...) {
    if(is.null(order)) order <- 1:attr(x, "Size") 
    else order <- get_order(order)
    .Call("inertia_criterion", x, order)
}

## anti-Robinson loss functions (Streng and Schoenfelder 1978, Chen
## 2002)
## method: 1...i, 2...s, 3...w
.ar <- function(x, order = NULL, method = 1) {
    if(is.null(order)) order <- 1:attr(x, "Size") 
    else order <- get_order(order)
    .Call("ar", x, order, as.integer(method))
}

criterion_ar_events <- function(x, order, ...) .ar(x, order, 1L)
criterion_ar_deviations <- function(x, order, ...) .ar(x, order, 2L)
#criterion_ar_weighted <- function(x, order, ...) .ar(x, order, 3L)

criterion_gradient_raw <- function(x, order, ...) {
    if(is.null(order)) order <- 1:attr(x, "Size")
    else order <- get_order(order)
    .Call("gradient", x, order, 1L)
}

criterion_gradient_weighted <- function(x, order, ...) {
    if(is.null(order)) order <- 1:attr(x, "Size")
    else order <- get_order(order)
    .Call("gradient", x, order, 2L)
}

criterion_ME_dist <- function(x, order, ...)
    criterion(as.matrix(x), c(order, order), "ME")
criterion_Moore_stress_dist  <- function(x, order, ...)
    criterion(as.matrix(x), c(order, order), "Moore_stress")
criterion_Neumann_stress_dist  <- function(x, order, ...)
    criterion(as.matrix(x), c(order, order), "Neumann_stress")

set_criterion_method("dist", "AR_events" , criterion_ar_events, 
    "Anti-Robinson events", FALSE)
set_criterion_method("dist", "AR_deviations", criterion_ar_deviations,
    "Anti-Robinson deviations", FALSE)
## set_criterion_method("dist", "AR_weighted", criterion_ar_weighted)
set_criterion_method("dist", "Gradient_raw" , criterion_gradient_raw,
    "Gradient measure", TRUE)
set_criterion_method("dist", "Gradient_weighted", criterion_gradient_weighted,
    "Gradient measure (weighted)", TRUE)
set_criterion_method("dist", "Path_length", criterion_path_length,
    "Hamiltonian path length", FALSE)
set_criterion_method("dist", "Inertia", criterion_inertia,
    "Inertia criterion", TRUE)
set_criterion_method("dist", "Least_squares", criterion_least_squares,
    "Least squares criterion", FALSE)
set_criterion_method("dist", "ME", criterion_ME_dist,
    "Measure of effectiveness", TRUE)
set_criterion_method("dist", "Moore_stress", criterion_Moore_stress_dist,
    "Stress (Moore neighborhood)", FALSE)
set_criterion_method("dist", "Neumann_stress", criterion_Neumann_stress_dist,
    "Stress (Neumann neighborhood)", FALSE)