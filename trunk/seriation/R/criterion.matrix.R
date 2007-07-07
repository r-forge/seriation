## Criterion for the quality of a permutation of a matrix

criterion.matrix <- function(x, order = NULL, method = "all", ...) {
    
    ## check order
    if(!is.null(order)){
        if(!inherits(order, "ser_permutation")) 
        stop("order has to be an object of class ", sQuote("ser_permutation"))
        .check_matrix_perm(x, order)
    }
    
    
    ## methods
    methods <- list(
        "ME"            = .ME,
        "Moore_stress"  = .stress_moore,
        "Neumann_stress"= .stress_neumann
    )
    
    ## do more than one criterion
    if(method == "all") method <- names(methods)
    if(length(method) > 1) return(sapply(method,
            function(m) criterion(x, order, m), USE.NAMES = FALSE))

    method <- .choose_method(method, methods)
   
    crit <- methods[[method]](x, order)
    names(crit) <- method
    crit
}
    

## Bond energy (BEA)
.ME <- function(x, order = NULL){
    
    if(any(x < 0)) stop("Bond energy (ME) is only defined for nonnegative matrices")
    
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
    if (!is.matrix(x)) stop(paste(sQuote("x"),"not a matrix"))
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

.stress_moore <- .stress
.stress_neumann <- function(x, order) .stress(x, order, "neumann")



