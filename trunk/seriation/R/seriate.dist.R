## seriate dist objects

seriate.dist <- function(x, method = NULL, control = NULL, ...){ 
    
    ## build-in methods
    methods <- list(
        "ARSA"  = .seriate_arsa,   
        "BBURCG"= .seriate_bburcg,
        "BBWRCG"= .seriate_bbwrcg,
        "TSP"   = .seriate_tsp,
        "Chen"  = .seriate_chen,
        "MDS"   = .seriate_mds,
        "HC"    = .seriate_hc,
        "GW"    = .seriate_hc_gw,
        "OLO"   = .seriate_hc_optimal
    )
    
    method <- .choose_method(method, methods, "ARSA")

    order <- methods[[method]](x, control)
    ser_permutation(ser_permutation_vector(order, method = method))
}



## uses a sequence of correlation matrices and finds  the first matrix
## with rank 2. The elements are projected into the plane spanned by the 
## first two eigenvectors. All points are lying on a ellipse. The order
## of the elements on the ellipse is returned (see Chen 2002). 
.seriate_chen <- function(x, control){
    x <- as.matrix(x)
    
    rank <- qr(x)$rank

    ## find the first correlation matrix of rank 2  
    n <- 0
    while(rank > 2){
        x <- cor(x)
        n <- n + 1
        rank <- qr(x)$rank
    }

    ## project the matrix on the first 2 eigenvectors
    e <- eigen(x)$vectors[,1:2]

    ## extract the order
    ## chen says that he uses the one of the two possible cuts
    ## that separate the points at rank 1. Since the points just 
    ## separate further towards right and left, cutting on the vertical
    ## axis of the ellipse yields the same result.

    right <- which(e[,1] >= 0)
    right <- right[order(e[right,2], decreasing = TRUE)]
    left <- which(e[,1] < 0)
    left <- left[order(e[left,2])]
    
    c(right,left)
}


## Bridge to package tsp 
.seriate_tsp <- function(x, control = NULL){
    ## add a dummy city for cutting
    tsp <- insert_dummy(TSP(x), n = 1, label = "cut_here")
   
    tour <- solve_TSP(tsp, method = control$method, 
        control = control$control)
    
    cut_tour(tour, cut = "cut_here", exclude_cut = TRUE)
}


## Multidimensional scaling
.seriate_mds <- function(x, control = NULL){
    if(is.null(control$method) || control$method == "cmdscale" ) {
        sc <- cmdscale(x, k=1)
        return(order(sc[,1]))
    
    }else if(control$method == "isoMDS"){
        if(require("MASS", quietly = TRUE)) {
            sc <- isoMDS(x+1e-6, trace = FALSE, k=1)
            return(order(sc$points[,1])) 
        } else stop("please install package MASS for this method.")
    
    }else if(control$method == "sammon") {
        if(require("MASS", quietly = TRUE)) {
            sc <- sammon(x+1e-6, trace = FALSE, k=1)
            return(order(sc$points[,1]))
        } else stop("please install package MASS for this method.")

    }else stop("unknown method")

}



## Hierarchical clustering related seriations

.hclust_helper <- function(d, control = NULL){
    if(!is.null(control$hclust)) return(control$hclust)
    
    if(is.null(control$method)) return(hclust(d)) 
    else return(hclust(d, method = control$method))
}

.seriate_hc <- function(x, control = NULL) .hclust_helper(x, control)$order

## workhorses are in seriation.hclust
.seriate_hc_gw <- function(x, control = NULL) 
    .seriate_gruvaeus(.hclust_helper(x, control), x)

.seriate_hc_optimal <- function(x, control = NULL)
    .seriate_optimal(.hclust_helper(x, control), x)

## brusco: simulated annealing for anti-robinson
.seriate_arsa <- function(x, control = NULL) {
    param <- list(
        cool = 0.5,
        tmin = 0.1,
        nreps = 1L,
        verbose = FALSE
    )
    for(n in names(control)) {
        i <- pmatch(n, names(param))
        if(is.na(i)) stop("unknown control parameter: ", n)
        param[i] <- control[[n]] 
    }

    A <- as.matrix(x)
    # SUBROUTINE arsa(N, A, COOL, TMIN, NREPS, IPERM, R1, R2, D, U,
        #      S, T, SB, verbose)
    N <- ncol(A)
    IPERM <- integer(N)
    R1 <- double(N*N/2)
    R2 <- double(N*N/2)
    D <- double(N*N)
    U <- integer(N)
    S <- integer(N)
    T <- integer(100*N)
    SB <- integer(N)

    ret <- .Fortran("arsa", N, A, param$cool, param$tmin, param$nreps, IPERM,
        R1, R2, D, U, S, T, SB, param$verbose)

    ret[[6]]
}


## brusco: branch-and-bound - unweighted row gradient 
.seriate_bburcg <- function(x, control = NULL) {
    param <- list(
        eps = 1e-7,
        verbose = FALSE
    )
    for(n in names(control)) {
        i <- pmatch(n, names(param))
        if(is.na(i)) stop("unknown control parameter: ", n)
        param[i] <- control[[n]] 
    }
    
    A <- as.matrix(x)
    N <- ncol(A)

    # SUBROUTINE bburcg(N, A, EPS, X, Q, D, DD, S, UNSEL, IVERB)
    X <- integer(N)
    Q <- integer(N)
    D <- integer(N*N*N)
    DD <- integer(N*N*N)
    S <- integer(N)
    UNSEL <- integer(N)

    ret <- .Fortran("bburcg", N, A, param$eps, X, Q, D, DD, S, UNSEL,
        param$verbose)
    
    ret[[4]]
}


## brusco: branch-and-bound - weighted row gradient 
.seriate_bbwrcg <- function(x, control = NULL) {
    param <- list(
        eps = 1e-7,
        verbose = FALSE
    )
    for(n in names(control)) {
        i <- pmatch(n, names(param))
        if(is.na(i)) stop("unknown control parameter: ", n)
        param[i] <- control[[n]] 
    }
    
    A <- as.matrix(x)
    N <- ncol(A)

    # SUBROUTINE bbwrcg(N, A, EPS, X, Q, D, DD, S, UNSEL, IVERB)
    X <- integer(N)
    Q <- integer(N)
    D <- double(N*N*N)
    DD <- double(N*N*N)
    S <- integer(N)
    UNSEL <- integer(N)

    ret <- .Fortran("bbwrcg", N, A, param$eps, X, Q, D, DD, S, UNSEL,
        param$verbose)
    
    ret[[4]]
}



## generic for criterion
seriate <- function(x, ...) UseMethod("seriate")
seriate.default <- function(x, ...) 
stop(paste("\nseriate not implemented for class: ", class(x)))


