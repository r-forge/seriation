## seriate matrices 

seriate.matrix <- function(x, method = NULL, control = NULL, 
    margin = c(1,2), ...) {
    
    ## margin 1...rows, 2...cols

    ## build-in methods
    methods <- list(
        "BEA_TSP"   = .seriate_bea_tsp,
        "BEA"       = .seriate_bea,
        "PCA"       = .seriate_fpc
    )
    
    method <- .choose_method(method, methods, "BEA_TSP")
    
    order <- methods[[method]](x, control)

    row <- ser_permutation_vector(order$row, method)
    col <- ser_permutation_vector(order$col, method)

    ## this is inefficient since the workhorse does both
    if(length(margin) == 1) {
        if(margin == 1) return(ser_permutation(row))
        if(margin == 2) return(ser_permutation(col))
    }

    ser_permutation(row, col)
}


## Algorithm B
##  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
##  in Computational Statistics, Physica Verlag, pp. 15.
#
# this is actually just the same as BEA
#    
#.seriate_murtagh <- function(x, control) {
#
#    if(any(x < 0)) stop("Requires a nonnegative matrix")
#    
#    criterion <- as.dist(tcrossprod(x))
#    row <- hclust_greedy(-criterion)$order
#    criterion <- as.dist(crossprod(x))
#    col <- hclust_greedy(-criterion)$order
#    
#    list(row = row, col = col)
#}


.seriate_bea_tsp <- function(x, control) {

    if(any(x < 0)) stop("Requires a nonnegative matrix")
    
    criterion <- as.dist(tcrossprod(x))
    row <- seriate(max(criterion)-criterion, 
        method = "TSP", control = control)[[1]]

    criterion <- as.dist(crossprod(x))
    col <- seriate(max(criterion)-criterion, 
        method = "TSP", control = control)[[1]]
    
    list(row = row, col = col)
}


## Bond Energy Algorithm (McCormick 1972)

.seriate_bea <- function(x, control = NULL){
    
    if(any(x < 0)) stop("Requires a nonnegative matrix")
    istart <- if(is.null(control$istart)) 0 else control$istart
    jstart <- if(is.null(control$jstart)) 0 else control$jstart
    rep  <- if(!is.null(control$rep)) control$rep else 1
    
    res <- replicate(rep, bea(x, istart = istart, jstart = jstart), 
        simplify = FALSE)
    
    best <- which.max(sapply(res, "[[", "e"))
    res <- res[[best]]

    list(row = res$ib, col = res$jb)
    
}

## use the projection on the first pricipal component to determine the
## order
.seriate_fpc <- function(x, control) {
    
    center  <- if(!is.null(control$center)) control$center else TRUE
    scale.  <- if(!is.null(control$scale.)) control$scale. else FALSE
    tol     <- control$tol
    
    pr <- prcomp(x, center = center, scale. = scale., tol = tol)
    scores <- pr$x[,1]
    row <- order(scores)
    cat("row: first principal component explains", 
        pr$sdev[1] / sum(pr$sdev)* 100,"%\n")


    pr <- prcomp(t(x), center = center, scale. = scale., tol = tol)
    scores <- pr$x[,1]
    col <- order(scores)
    cat("col: first principal component explains", 
        pr$sdev[1] / sum(pr$sdev)* 100,"%\n")

    list(row = row, col = col)
}



