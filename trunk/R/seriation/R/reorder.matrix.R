## reorder matrices 

reorder.matrix <- function(x, method = NULL, row = TRUE, options = NULL, ...) {
    
    ## do columns?
    if(row == FALSE) x <- t(x)

    ## methods is a function with interface (x, method, options)
    if(is.function(method)) {
      order <- method(x, method = options$method, options = options$options)
      return(order)  
  }
    
    ## build-in methods
    methods <- c(
        "murtagh",      # standard
        "bea",
        "fpc"
    )

    
    methodNr <- if(is.null(method)) 1
    else pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:", sQuote(method)))


    ## work horses
    if(methodNr == 1) {
        order <- .reorder_murtagh(x)
    }else if(methodNr == 2) {
        order <- .reorder_bea(x, options)
    }else if(methodNr == 3) {
        order <- .reorder_fpc(x)
    }

    if(is.null(attr(order, "method"))) 
        attr(order, "method") <- methods[methodNr]
    
    ##class(order) <- "order"
    order
}


## Algorithm B
##  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
##  in Computational Statistics, Physica Verlag, pp. 15.

.reorder_murtagh <- function(x) {

    if(any(x < 0)) stop("Requires a nonnegative matrix")
    ## calculate the Murtagh criterion
    criterion <- as.dist(tcrossprod(x))
    hclust_greedy(-criterion)$order
}



## Bond Energy Algorithm (McCormick 1972)

.reorder_bea <- function(x, options = NULL){
    
    if(any(x < 0)) stop("Requires a nonnegative matrix")
    
    n <- nrow(x)
    m <- ncol(x)

    b <- matrix(0.0, n, m)
    storage.mode(x) <- "single"
    storage.mode(b) <- "single"
    jb <- integer(n)
    jfin <- integer(n)
    
    start <- options$start
    start <- as.integer(if (is.null(start)) sample(1:n, 1) else start)

    bea <- .Fortran("rbea",
        n = n,
        m = m,
        a = x,                      # input data
        jstart = start,             # 1st row placement
        b = b,                      # permuted array
        jb = jb,                    # permuted order of rows
        jfin = jfin)                # for book-keeping

    bea$jb
}

## use the projection on the first pricipal component to determine the
## order
.reorder_fpc <- function(x) {
    pr <- prcomp(x)
    scores <- pr$x[,1]
    order(scores)
}


