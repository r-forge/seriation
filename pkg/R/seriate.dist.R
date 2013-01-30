#######################################################################
# seriation - Infrastructure for seriation
# Copyrigth (C) 2011 Michael Hahsler, Christian Buchta and Kurt Hornik
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.



## seriate dist objects

seriate.dist <-
function(x, method = NULL, control = NULL, ...)
{
    
    if(!all(x>=0)) stop("Non-negative distances not supported!")
    
    if(is.null(method))
        method <- "ARSA"
    else if(!is.character(method) || (length(method) != 1L))
        stop("Argument 'method' must be a character string.")

    method <- get_seriation_method("dist", method)

    order <- method$definition(x, control)
    
    ser_permutation(ser_permutation_vector(order, method = method$name))
}

## uses a sequence of correlation matrices and finds  the first matrix
## with rank 2. The elements are projected into the plane spanned by the 
## first two eigenvectors. All points are lying on a ellipse. The order
## of the elements on the ellipse is returned (see Chen 2002). 
seriate_dist_chen <- function(x, control = NULL){
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
    
    o <- c(right,left)
    names(o) <- labels(x)[o]
    o
}


## Bridge to package tsp 
seriate_dist_tsp <- function(x, control = NULL){
    ## add a dummy city for cutting
    tsp <- insert_dummy(TSP(x), n = 1, label = "cut_here")
   
    tour <- solve_TSP(tsp, method = control$method, 
        control = control$control)
    
    o <- cut_tour(tour, cut = "cut_here", exclude_cut = TRUE)
    names(o) <- labels(x)[o]
    o
}


## Multidimensional scaling
seriate_dist_mds <- function(x, control = NULL){
    if(is.null(control$method) || control$method == "cmdscale" ) {
        sc <- cmdscale(x, k=1)
        return(order(sc[,1]))
    
    }else if(control$method == "isoMDS"){
        if(require("MASS", quietly = TRUE)) {
            sc <- isoMDS(x+1e-6, trace = FALSE, k=1)
            return(order(sc$points[,1])) 
        } else stop("Please install package MASS for this method.")
    
    }else if(control$method == "sammon") {
        if(require("MASS", quietly = TRUE)) {
            sc <- sammon(x+1e-6, trace = FALSE, k=1)
            return(order(sc$points[,1]))
        } else stop("Please install package MASS for this method.")

    }else stop("unknown method")

}

## Hierarchical clustering related seriations

.hclust_helper <- function(d, control = NULL){
    if(!is.null(control$hclust)) return(control$hclust)
    
    if(is.null(control$method)) return(hclust(d)) 
    else return(hclust(d, method = control$method))
}

seriate_dist_hc <- function(x, control = NULL) .hclust_helper(x, control)

## workhorses are in seriation.hclust
seriate_dist_hc_gw <- function(x, control = NULL) 
    .seriate_gruvaeus(.hclust_helper(x, control), x)

seriate_dist_hc_optimal <- function(x, control = NULL)
    seriate_optimal(.hclust_helper(x, control), x)

## brusco: simulated annealing for anti-robinson
seriate_dist_arsa <- function(x, control = NULL) {
    param <- list(
        cool = 0.5,
        tmin = 0.1,
        nreps = 1L,
        verbose = FALSE
    )
    for(n in names(control)) {
        i <- pmatch(n, names(param))
        if(is.na(i))
            stop(gettextf("Unknown control parameter '%s'.", n))
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
        R1, R2, D, U, S, T, SB, param$verbose, PACKAGE="seriation")

    o <- ret[[6]]
    names(o) <- labels(x)[o]
    
    ### ARSA returns all 0's in some cases
    if(all(o == 0)) {
    o <- 1:N
    warning("ARSA has returned an invalid permutation vector! Check the supplied dissimilarity matrix.")
    }
    
    o
}


## brusco: branch-and-bound - unweighted row gradient 
seriate_dist_bburcg <- function(x, control = NULL) {
    param <- list(
        eps = 1e-7,
        verbose = FALSE
    )
    for(n in names(control)) {
        i <- pmatch(n, names(param))
        if(is.na(i))
            stop(gettextf("Unknown control parameter '%s'.", n))
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
    
    o <- ret[[4]]
    names(o) <- labels(x)[o]
    o
}


## brusco: branch-and-bound - weighted row gradient 
seriate_dist_bbwrcg <- function(x, control = NULL) {
    param <- list(
        eps = 1e-7,
        verbose = FALSE
    )
    for(n in names(control)) {
        i <- pmatch(n, names(param))
        if(is.na(i))
            stop(gettextf("Unknown control parameter '%s'.", n))
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
    
    o <- ret[[4]]
    names(o) <- labels(x)[o]
    o
}

set_seriation_method("dist", "ARSA", seriate_dist_arsa, 
    "Minimize Anti-Robinson events using simulated annealing")
set_seriation_method("dist", "BBURCG", seriate_dist_bburcg, 
    "Minimize the unweighted row/column gradient by branch-and-bound")
set_seriation_method("dist", "BBWRCG", seriate_dist_bbwrcg,
    "Minimize the weighted row/column gradient by branch-and-bound")
set_seriation_method("dist", "TSP", seriate_dist_tsp,
    "Minimize Hamiltonian path length with a TSP solver")
set_seriation_method("dist", "Chen", seriate_dist_chen,
    "Rank-two ellipse seriation")
set_seriation_method("dist", "MDS", seriate_dist_mds,
    "MDS - first dimension")
set_seriation_method("dist", "HC", seriate_dist_hc,
    "Hierarchical clustering")
set_seriation_method("dist", "GW", seriate_dist_hc_gw,
    "Hierarchical clustering reordered by Gruvaeus and Wainer heuristic")
set_seriation_method("dist", "OLO", seriate_dist_hc_optimal,
    "Hierarchical clustering with optimal leaf ordering")
