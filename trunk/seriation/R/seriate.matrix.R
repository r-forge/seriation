## seriate matrices 

seriate.matrix <- function(x, method = NULL, control = NULL, 
    margin = c(1,2), ...) {
    
    ## margin 1...rows, 2...cols

    ## build-in methods
    methods <- c(
        "murtagh",      # standard
        "bea",
        "pca",
        "ca"
    )
    
    methodNr <- if(is.null(method)) 1
    else pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:", sQuote(method)))

    ## work horses
    workhorse <-
    if(methodNr == 1) .seriate_murtagh
    else if(methodNr == 2) .seriate_bea
    else if(methodNr == 3) .seriate_fpc
    else if(methodNr == 4) .seriate_ca
    
    order <- workhorse(x, control)
    method <- methods[methodNr]

    ## this is inefficient since the workhorse does both
    if(length(margin) == 1) {
        if(margin == 1) return(Order(order = order$row, method = method))
        if(margin == 2) return(Order(order = order$col, method = method))
    }

    Order(row = order$row, col = order$col, method = methods[methodNr])
}


## Algorithm B
##  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
##  in Computational Statistics, Physica Verlag, pp. 15.

.seriate_murtagh <- function(x, control) {

    if(any(x < 0)) stop("Requires a nonnegative matrix")
    ## calculate the Murtagh criterion
    criterion <- as.dist(tcrossprod(x))
    row <- hclust_greedy(-criterion)$order
    criterion <- as.dist(crossprod(x))
    col <- hclust_greedy(-criterion)$order
    
    list(row = row, col = col)
}



## Bond Energy Algorithm (McCormick 1972)

.seriate_bea <- function(x, control = NULL){
    
    if(any(x < 0)) stop("Requires a nonnegative matrix")
    istart <- if(is.null(control$istart)) 0 else control$istart
    jstart <- if(is.null(control$jstart)) 0 else control$jstart
    
    res <- bea(x, istart = istart, jstart = jstart)

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


.seriate_ca <- function(x, control) {
    coa <- dudi.coa(as.data.frame(x), scannf=FALSE, nf=1)
    
    cat("correspondence analysis  explains", coa$eig[1] / sum(coa$eig) * 100, 
        "% of the eigen values\n")
    list(row = order(coa$li[,1]), col = order(coa$co[,1]))
}



