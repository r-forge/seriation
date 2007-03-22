## Criterion for the quality of a permutation of a matrix

criterion.matrix <- function(x, order = NULL, method = NULL, ...) {

    ## check order
    if(!is.null(order)){
        .check_order(order, x)
    }

    ## methods
    methods <- c(
        "bond_energy",      # default
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
    
    ## check matrix
    ##if (!is.real(x)) storage.mode(x) <- "real"

    ## work horses
    if (methodNr == 1) {
        crit <- .bond_energy(x, order)
    }else if (methodNr == 2) {
        crit <- 0.5 * .bond_energy(x, order)
    }else if (methodNr == 3) {
        crit <- .stress(x, order, 
            type = "moore")
    }else if (methodNr == 4) {
        crit <- .stress(x, order, 
            type = "neumann")
    }

    name(crit) <- methods[methodNr]
    crit
}
    

## Bond energy (BEA)
.bond_energy <- function(x, order = NULL){
    
    if(any(x < 0)) stop("Bond energy is only defined for nonnegative matrices")
    
    n <- nrow(x)
    m <- ncol(x)
    
    x <- arrange(x, order)
    
    storage.mode(x) <- "single"

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
    if (!is.double(x)) storage.mode(x) <- "double"
    rows <- order$row
    cols <- order$col
    if(!is.null(order$order)) rows <- cols <- order$order
    if (is.null(rows)) rows <- as.integer(1:dim(x)[1])
    if (is.null(cols)) cols <- as.integer(1:dim(x)[2])
    type <- as.integer(TYPE[type])
    
    x <- .Call("stress", x, rows, cols, type)
    
    ## does only half of the matrix!
    2 * x
}


