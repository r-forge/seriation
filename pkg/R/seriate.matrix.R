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



## seriate matrices 

seriate.matrix <-
function(x, method = NULL, control = NULL, 
         margin = c(1,2), ...)
    .seriate_array_helper(x, method, control, margin, 
        datatype = "matrix", defmethod = "BEA_TSP", ...)

## Algorithm B
##  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
##  in Computational Statistics, Physica Verlag, pp. 15.
#
# this is actually just the same as BEA
#    
#.seriate_matrix_murtagh <- function(x, control) {
#
#    if(any(x < 0)) stop("Requires a nonnegative matrix.")
#    
#    criterion <- as.dist(tcrossprod(x))
#    row <- hclust_greedy(-criterion)$order
#    criterion <- as.dist(crossprod(x))
#    col <- hclust_greedy(-criterion)$order
#    
#    list(row = row, col = col)
#}

seriate_matrix_bea_tsp <- function(x, control) {

    if(any(x < 0)) stop("Requires a nonnegative matrix.")
    
    criterion <- as.dist(tcrossprod(x))
    row <- seriate(max(criterion)-criterion, 
        method = "TSP", control = control)[[1]]

    criterion <- as.dist(crossprod(x))
    col <- seriate(max(criterion)-criterion, 
        method = "TSP", control = control)[[1]]
    
    list(row = row, col = col)
}


## Bond Energy Algorithm (McCormick 1972)

seriate_matrix_bea <- function(x, control = NULL){
    
    if(any(x < 0)) stop("Requires a nonnegative matrix.")
    istart <- if(is.null(control$istart)) 0 else control$istart
    jstart <- if(is.null(control$jstart)) 0 else control$jstart
    rep  <- if(!is.null(control$rep)) control$rep else 1
    
    res <- replicate(rep, bea(x, istart = istart, jstart = jstart), 
        simplify = FALSE)
    
    best <- which.max(sapply(res, "[[", "e"))
    res <- res[[best]]
    
    row <- res$ib
    col <- res$jb
    
    names(row) <- rownames(x)
    names(col) <- colnames(x)

    list(row = row, col = col)
    
}

## use the projection on the first pricipal component to determine the
## order
seriate_matrix_fpc <- function(x, control) {
    
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
    
    names(row) <- rownames(x)
    names(col) <- colnames(x)

    list(row = row, col = col)
}

## register methods
set_seriation_method("matrix", "BEA_TSP", seriate_matrix_bea_tsp,
    "TSP to maximize ME")
set_seriation_method("matrix", "BEA", seriate_matrix_bea,
    "Bond Energy Algorithm to maximize ME")
set_seriation_method("matrix", "PCA", seriate_matrix_fpc,
    "First principal component")
