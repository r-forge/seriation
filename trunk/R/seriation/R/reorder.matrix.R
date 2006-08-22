# reorder matrices and dist objects

# wrapper for dist (matrix does all the work for now)
reorder.dist <- function(x, method = NULL, ...) 
reorder.matrix(as.matrix(x), method = method, ...)

# matrix
reorder.matrix <- function(x, method = NULL, row = TRUE, ...) {

    # methods
    methods <- c(
        "murtagh",      # standard
        "bea",
        "fpc",
        "chen",
        "nearest_insertion",
        "farthest_insertion") 

    if(is.null(method)) methodNr <- 1
    else methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))

    # do columns?
    if(row == FALSE) x <- t(x)

    # work horses
    if(methodNr == 1) {
        order <- .reorder_murtagh(x)
    }else if(methodNr == 2) {
        order <- .reorder_bea(x,...)
    }else if(methodNr == 3) {
        order <- .reorder_prcomp(x)
    }else if(methodNr == 4) {
        order <- .reorder_chen(x)
    }else if(methodNr == 5) {
        order <- .reorder_insertion(x, nearest = TRUE, ...)
    }else if(methodNr == 6) {
        order <- .reorder_insertion(x, nearest = FALSE, ...)
    }

    #attr(order, "method") <- methods[methodNr]
    return(order)
}


# Algorithm B
#  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
#  in Computational Statistics, Physica Verlag, pp. 15.

.reorder_murtagh <- function(x) {

    if(any(x < 0)) stop("Requires a nonnegative matrix")
    # calculate the Murtagh criterion
    criterion <- as.dist(tcrossprod(x))
    hclust_greedy(-criterion)$order
}


# use the projection on the first pricipal component to determine the
# order

.reorder_prcomp <- function(x) {
    pr <- prcomp(x) 
    scores <- pr$x[,1]
    order(scores)
}


# uses a sequence of correlation matrices and finds  the first matrix
# with rank 2. The elements are projected into the plane spanned by the 
# first two eigenvectors. All points are lying on a ellipse. The order
# of the elements on the ellipse is returned (see Chen 2002). 

.reorder_chen <- function(x){
    if(!isSymmetric(x))
        stop(paste("Method",sQuote("chen"),"requires a symmetrical (dissimilarity or correlation) matrix"))
    
    x <- t(x)
    rank <- qr(x)$rank

    # find the first correlation matrix of rank 2  
    n <- 0
    while(rank > 2){
        x <- cor(x)
        n <- n + 1
        rank <- qr(x)$rank
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

    o
}


# Bond Energy Algorithm (McCormick 1972)

.reorder_bea <- function(x, start = 0){
    
    if(any(x < 0)) stop("Only usable for nonnegative matrices")
    
    n <- nrow(x)
    m <- ncol(x)

    b <- matrix(0.0, n, m)
    storage.mode(x) <- "single"
    storage.mode(b) <- "single"
    jb <- integer(n)
    jfin <- integer(n)
    #
    if (start == 0) start <- sample(1:n, 1)
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


# Nearest/farthest insertion algorithm 
# (Johnson and Papadimitrou in Lawler et al. 1985)

.reorder_insertion <- function(x, nearest = TRUE, start = 0){
    if(!isSymmetric(x))
        stop(paste("Methods",sQuote("nearest/farthest insertion"),
                "require a symmetrical distance matrix"))
    
    order <- tsp_insertion(as.dist(x), nearest = nearest, start = start)

    # To find the cutting point in the tour, typically a dummy city with
    # equal distance to every other city is added. The dummy city is then
    # the optimal cutting place.
    # However, this would require to manipulate the distance matrix. 
    # Therefore, we just cut the tour between the most distant cities 
    # which should give the same result.
    maxDist <- 0.0
    cut <- 0
    for(i in 1:(length(order)-1)) {
        if(x[order[i], order[i+1]] > maxDist) {
            maxDist <- x[order[i], order[i+1]]
            cut <- i
        }
    }
    if(x[order[length(order)], order[1]] > maxDist) {
        cut <- 0
    }
    
    if(cut > 0) order <- c(order[(cut+1):length(order)], order[1:cut])
   
    order
}
