## Criterion for the quality of a permutation of a matrix

criterion.matrix <-
function(x, order = NULL, method = NULL)
{
    ## check order
    if(!is.null(order)){
        if(!inherits(order, "ser_permutation")) 
            stop("Argument 'order' has to be of class 'ser_permutation'")
        .check_matrix_perm(x, order)
    }

    ## get methods
    if(is.null(method)) method <- list_criterion_methods("matrix")
    method <- lapply(method, function(m ) get_criterion_method("matrix", m))

    sapply(method,
        function(m) structure(m$definition(x, order), names=m$name))
}



## Bond energy (BEA)
criterion_ME <- function(x, order = NULL) {
    
    if(any(x < 0))
        stop("Bond energy (ME) is only defined for nonnegative matrices")
    
    n <- nrow(x)
    m <- ncol(x)
    
    if(!is.null(order)) x <- permute(x, order)
    
    mode(x) <- "single"

    energy <- .Fortran("energy",
                       n = n,
                       m = m,
                       b = x,
                       ener = as.single(0.0))
    
    0.5 * as.numeric(energy$ener)
}


## the interface to the stress functions allows for
## arbitrary subsetting (see the wrapper in C).
## (C) ceeboo 2005, 2006

.stress <- function(x, order, type="moore") {
    TYPE <- c(1,2,3)
    names(TYPE) <- c("moore", "neumann")
    if (inherits(x, "dist")) x <- as.matrix(x)
    if (!is.matrix(x))
        stop("Argument 'x' must be a matrix.")
    if (!is.double(x)) mode(x) <- "double"
    
    if(is.null(order)) {
        rows <- as.integer(1:dim(x)[1])
        cols <- as.integer(1:dim(x)[2])
    }else{
        rows <- get_order(order, 1)
        cols <- get_order(order, 2)
    }
    
    type <- as.integer(TYPE[type])
    
    x <- .Call("stress", x, rows, cols, type)
    
    ## does only half of the matrix!
    2 * x
}

criterion_stress_moore <- .stress
criterion_stress_neumann <- function(x, order) .stress(x, order, "neumann")

## register built-ins
set_criterion_method("matrix", "ME", criterion_ME, 
    "Measure of effectiveness", TRUE)
set_criterion_method("matrix", "Moore_stress", criterion_stress_moore,
    "Stress (Moore neighborhood)", FALSE)
set_criterion_method("matrix", "Neumann_stress", criterion_stress_neumann,
    "Stress (Neumann neighborhood)", FALSE)
