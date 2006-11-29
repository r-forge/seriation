## Criterion for the quality of a permutation of a matrix

criterion.matrix <- function(x, order, method = NULL, ...) {

    ## get order
    if(missing(order)) col_order <- row_order <- NULL
    else if(is.list(order)) {
        col_order <- order$c
        row_order <- order$r
    }else col_order <- row_order <- order
        
    ## check dimensions
    if(!is.null(col_order) && ncol(x) != length(col_order))
    stop(paste("lengths of", sQuote("col_order"),
            "does not match dimensions of", sQuote("x")))
    if(!is.null(row_order) && nrow(x) != length(row_order))
    stop(paste("lengths of", sQuote("row_order"),
            "does not match dimensions of", sQuote("x")))

    ## methods
    methods <- c(
        "bond_energy",      # default
        "me",
        "moore_stress",
        "neumann_stress"
    )
   
    if(is.null(method)) methodNr <- 1
    else methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))
    
    ## check matrix
    ##if (!is.real(x)) storage.mode(x) <- "real"

    ## work horses
    if (methodNr == 1) {
        crit <- .bond_energy(x, col_order, row_order)
    }else if (methodNr == 2) {
        crit <- 0.5 * .bond_energy(x, col_order, row_order)
    }else if (methodNr == 3) {
        crit <- .stress(x, cols = col_order, rows = row_order, 
            type = "moore")
    }else if (methodNr == 4) {
        crit <- .stress(x, cols = col_order, rows = row_order, 
            type = "neumann")
    }

    attr(crit, "method") <- methods[methodNr]
    crit
}
    

## Bond energy (BEA)
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


## the interface to the stress functions allows for
## arbitrary subsetting (see the wrapper in C).
## (C) ceeboo 2005, 2006

.stress <- function(x, rows=NULL, cols=NULL, type="moore") {
    TYPE <- c(1,2,3)
    names(TYPE) <- c("moore", "neumann")
    if (inherits(x, "dist"))
    x <- as.matrix(x)
    if (!is.matrix(x))
    stop(paste(sQuote("x"),"not a matrix"))
    if (!is.double(x))
    storage.mode(x) <- "double"
    if (is.null(rows))
    rows <- as.integer(1:dim(x)[1])
    if (is.null(cols))
    cols <- as.integer(1:dim(x)[2])
    type <- as.integer(TYPE[type])
    x <- .Call("stress", x, rows, cols, type)
    
    ## does only half of the matrix!
    2 * x
}


