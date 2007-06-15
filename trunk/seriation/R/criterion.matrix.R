## Criterion for the quality of a permutation of a matrix

criterion.matrix <- function(x, order = NULL, method = "all", ...) {

    ## methods
    methods <- c(
        "ME",
        "Moore_stress",
        "Neumann_stress"
    )

    ## do more than one criterion
    if(method == "all") method <- methods
    if(length(method) > 1) return(sapply(method,
            function(m) criterion(x, order, m), USE.NAMES = FALSE))

    methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))
    
    ## check order
    if(!is.null(order)){
        if(!inherits(order, "ser_permutations")) 
        stop("order has to be an object of class ", sQuote("ser_permutations"))

        .check_matrix_perm(x, order)
    }
    
    ## work horses
    if (methodNr == 1) {
        crit <- 0.5 * .bond_energy(x, order)
    }else if (methodNr == 2) {
        crit <- .stress(x, order, 
            type = "moore")
    }else if (methodNr == 3) {
        crit <- .stress(x, order, 
            type = "neumann")
    }

    names(crit) <- methods[methodNr]
    crit
}
    

## Bond energy (BEA)
.bond_energy <- function(x, order = NULL){
    
    if(any(x < 0)) stop("Bond energy is only defined for nonnegative matrices")
    
    n <- nrow(x)
    m <- ncol(x)
    
    if(!is.null(order)) x <- permute(x, order)
    
    mode(x) <- "single"

    energy <- .Fortran("energy",
        n = n,
        m = m,
        b = x,
        ener = as.single(0.0))
    
    as.numeric(energy$ener)
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


