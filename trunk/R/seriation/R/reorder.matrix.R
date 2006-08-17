# Seriation heuristics for matrices
#
# Michael Hahsler


### wrapper for dist
reorder.dist <- function(x, method = NULL, ...) 
reorder.matrix(as.matrix(x), method = method, ...)

reorder.matrix <- function(x, method = NULL, row = TRUE, ...) {

    methods <- c(
        "murtagh", 
        "bea",
        "fpc",
        "chen") 

    # standard seriation is Murtagh
    if(is.null(method)) methodNr <- 1
    else methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))

    if(row == FALSE) x <- t(x)

    if(methodNr == 1) {
        order <- reorder_murtagh(x)
    }else if(methodNr == 2) {
        order <- reorder_bea(x,...)
    }else if(methodNr == 3) {
        order <- reorder_prcomp(x)
    }else if(methodNr == 4) {
        order <- reorder_chen(x)
    }else if(methodNr == 5) {
        order <- reorder_tsp(x)
    }

    #attr(order, "method") <- methods[methodNr]
    return(order)
}


# Algorithm B
#  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
#  in Computational Statistics, Physica Verlag, pp. 15.

reorder_murtagh <- function(x) {

    if(any(x < 0)) stop("Only usable for nonnegative matrices")
    # calculate the Murtagh criterion
    criterion <- as.dist(tcrossprod(x))
    hclust_greedy(-criterion)$order
}


# use the projection on the first pricipal component to determine the
# order

reorder_prcomp <- function(x) {
    pr <- prcomp(x) 
    scores <- pr$x[,1]
    order(scores)
}


# uses a sequence of correlation matrices and finds  the first matrix
# with rank 2. The elements are projected into the plane spanned by the 
# first two eigenvectors. All points are lying on a ellipse. The order
# of the elements on the ellipse is returned (see Chen 2002). 

reorder_chen <- function(x){
    if(!isSymmetric(x))
        stop(paste("Method",sQuote("chen"),"requires a symmetrical (dissimilarity or correlation) matrix"))
    
    x <- t(x)
    rank <- qr(x)$rank
    #l <- list()  
    #l$ranks <- rank

    # find the first correlation matrix of rank 2  
    n <- 0
    while(rank > 2){
        x <- cor(x)
        n <- n + 1
        rank <- qr(x)$rank
        #l[[paste("cor", n, sep = "")]] <- x
        #l$ranks <- c(l$ranks, rank)
    }

    # project the matrix on the first 2 eigenvectors
    e <- eigen(x)$vectors[,1:2]

    # extract the order
    # chen says that he uses the one of the two possible cuts
    # that separate the points at rank 1. Since the points just 
    # separate further towards right and left, cutting on the vertical
    # axis of the ellipse yields the same result.

    right <- which(e[,1] >= 0)
    right <- right[order(e[right,2], decreasing = TRUE)]
    left <- which(e[,1] < 0)
    left <- left[order(e[left,2])]
    o <- c(right,left)

    #l$order <- o
    #l
    o
}


# Bond Energy Algorithm (McCormick 1972)

reorder_bea <- function(x, start = 0){
    
    if(any(x < 0)) stop("Only usable for nonnegative matrices")
    
    n <- nrow(x)
    m <- ncol(x)

    b <- matrix(0.0, n, m)
    storage.mode(x) <- "single"
    storage.mode(b) <- "single"
    jb <- integer(n)
    jfin <- integer(n)
    #
    if (start == 0) start <- floor(runif(1,1,n))
    start <- as.integer(start)
    #

    bea <- .Fortran("rbea",
        n = n,
        m = m,
        a = x,                      # input data
        jstart = start, # 1st row placement
        b = b,                      # permuted array
        jb = jb,                    # permuted order of rows
        jfin = jfin)                # for book-keeping

    bea$jb
}

