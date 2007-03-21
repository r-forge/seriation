## Criterion for the quality of a permutation of a matrix

criterion.matrix <- function(x, order = NULL, method = NULL, ...) {

    ## check order
    if(!is.null(order)){
        if(inherits(order, "order_2d")) {
            if(any(dim(x) != dim(order))) stop(paste("dimensions of", sQuote("x"),
                    "and", sQuote("order"), "no not match"))
        }else stop(paste("order must be of class", sQuote("order_2d")))
    }

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

    attr(crit, "method") <- methods[methodNr]
    crit
}
    

## Bond energy (BEA)
.bond_energy <- function(x, order = NULL){
    
    if(any(x < 0)) stop("Bond energy is only defined for nonnegative matrices!")
    
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
    if (is.null(order$rows)) rows <- as.integer(1:dim(x)[1])
    if (is.null(order$cols)) cols <- as.integer(1:dim(x)[2])
    type <- as.integer(TYPE[type])
    
    x <- .Call("stress", x, rows, cols, type)
    
    ## does only half of the matrix!
    2 * x
}


