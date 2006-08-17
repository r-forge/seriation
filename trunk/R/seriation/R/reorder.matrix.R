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
        "chen",
        "nearest_insertion",
        "farthest_insertion") 

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
        order <- reorder_insertion(x, nearest = TRUE)
    }else if(methodNr == 6) {
        order <- reorder_insertion(x, nearest = FALSE)
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

reorder_insertion <- function(x, start = 0, nearest = TRUE){
    n <- nrow(x)
    m <- ncol(x)

    if (start == 0) start <- sample(1:n, 1)

    placed <- logical(n)
    placed[start] <- TRUE
    order <- c(start)
   
    while(any(placed == FALSE)) {
        # find city j (in tour) and city k (not jet used) which are closest
        js <- which(placed)
        ks <- which(!placed)

        # which.min does not break ties by random!
        if(nearest == TRUE) mx <- which.min(x[js,ks, drop = FALSE])
        else mx <- which.max(x[js,ks, drop = FALSE])
        k <- ks[(mx-1) %/% length(js) + 1]
        j <- js[(mx-1) %% length(js) + 1]

        # now place k (we always place it after j)
        #placed[k] <- TRUE
        #j_index <- which(order == j)
        #if(length(order) > j_index) order <- c(order[1:j_index], k, order[(j_index+1):length(order)]) else order <- c(order[1:j_index], k)
    
        # now we do nearest insertion
        placed[k] <- TRUE
        if(length(order) == 1) order <- c(order, k)
        else {
            bestVal <- Inf
            insert <- 0
            for(i in 1:(length(order)-1)) {
                val <- x[order[i], k] + x[k, order[i+1]] - x[order[i], order[i+1]]
                if(val < bestVal) {
                    bestVal <- val
                    insert <- i
                }
            }
            
            # now between the last an first city
            val <- x[order[length(order)], k] + x[k,order[1]] 
                - x[order[length(order)],order[1]]
            if(val < bestVal) {
                bestVal <- val
                insert <- 0     # we just append k
            }

            if(insert == 0) order <- c(order, k)
            else order <- c(order[1:insert], k, order[(insert+1):length(order)]) 
        }
    }

    # finally, we cut the tour between the most distant cities
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
