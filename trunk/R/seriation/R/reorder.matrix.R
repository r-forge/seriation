## reorder matrices 

reorder.matrix <- function(x, method = NULL, options = NULL, ...) {
    
    
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
        order <- .reorder_murtagh(x, options)
    }else if(methodNr == 2) {
        order <- .reorder_bea(x, options)
    }else if(methodNr == 3) {
        order <- .reorder_fpc(x, options)
    }

    if(is.null(attr(order, "method"))) 
        attr(order, "method") <- methods[methodNr]
    
    ##class(order) <- "order"
    order
}


## Algorithm B
##  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
##  in Computational Statistics, Physica Verlag, pp. 15.

.reorder_murtagh <- function(x, options) {

    if(any(x < 0)) stop("Requires a nonnegative matrix")
    ## calculate the Murtagh criterion
    criterion <- as.dist(tcrossprod(x))
    row <- hclust_greedy(-criterion)$order
    criterion <- as.dist(crossprod(x))
    col <- hclust_greedy(-criterion)$order
    
    list(row = row, col = col)
}



## Bond Energy Algorithm (McCormick 1972)

.reorder_bea <- function(x, options = NULL){
    
    if(any(x < 0)) stop("Requires a nonnegative matrix")
    istart <- if(is.null(options$istart)) 0 else options$istart
    jstart <- if(is.null(options$jstart)) 0 else options$jstart
    
    res <- bea(x, istart = istart, jstart = jstart)

    list(row = res$ib, col = res$jb)
    
}

## use the projection on the first pricipal component to determine the
## order
.reorder_fpc <- function(x, options) {
    pr <- prcomp(x)
    scores <- pr$x[,1]
    row <- order(scores)

    pr <- prcomp(t(x))
    scores <- pr$x[,1]
    col <- order(scores)

    list(row = row, col = col)

}


