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


.dist_methods <- c("spearman", "kendall", "manhattan", "euclidean", "hamming",
  "ppc")

seriation_cor <- function(x, method="spearman") 
cor(t(.lget_rank(x)), method=method)

seriation_dist <- function(x, method="spearman", align=TRUE) {
  
  if(!is.list(x) || any(!sapply(x, is, "ser_permutation_vector"))) stop("x needs to be a list with elements of type 'ser_permutation_vector'")
  
  method <- match.arg(tolower(method), .dist_methods)
  
  #if(align) x <- seriation_align(x, method=method)
  
  if(!align) switch(method,
    spearman = as.dist(1-abs(seriation_cor(x, method="spearman"))),
    kendall = as.dist(1-abs(seriation_cor(x, method="kendal"))),
    
    ### Manhattan == Spearman's footrule  
    manhattan = dist(.lget_rank(x), method="manhattan"),
    euclidean = dist(.lget_rank(x), method="euclidean"),
    hamming   = .dist_hamming(.lget_rank(x)), 
    ppc = .ppc2(x)
  )
  
  else switch(method,
    spearman = .find_best(as.dist(1-abs(seriation_cor(.add_rev(x), 
      method="spearman")))),
    kendall = .find_best(as.dist(1-abs(seriation_cor(.add_rev(x), 
      method="kendal")))),
    
    ### Manhattan == Spearman's footrule  
    manhattan = .find_best(dist(.lget_rank(.add_rev(x)), method="manhattan")),
    euclidean = .find_best(dist(.lget_rank(.add_rev(x)), method="euclidean")),
    hamming   = .find_best(.dist_hamming(.lget_rank(.add_rev(x)))),
    
    ### positional proximity coefficient is direction invariant
    ppc = .ppc2(x)
  )
}

seriation_align <- function(x, method = "spearman") {
    if(!is.list(x) || any(!sapply(x, is, "ser_permutation_vector"))) stop("x needs to be a list with elements of type 'ser_permutation_vector'")  
  
    method <- match.arg(tolower(method), .dist_methods) 
    
    .do_rev(x, .alignment(x, method=method))
}


.dist_hamming <- function(x) {
  n <- nrow(x)
  m <- matrix(nrow=n, ncol=n)
  for(i in seq_len(n))
    for(j in seq(i, n))
      m[j, i] <- m[i, j] <- sum(x[i,] != x[j,])
  mode(m) <- "numeric"
  dimnames(m) <- list(rownames(x), rownames(x))
  as.dist(m)
}

### make a permutation list into a rank matrix
#.lget_rank <- function(x) t(sapply(x, get_rank))
#.lget_rank <- function(x) t(apply(t(sapply(x, get_order)), MARGIN=1, order))
.lget_rank <- function(x) t(sapply(x, get_order))

### add reversed permutations to a list of permutations
.add_rev <- function(x) {
  os <- append(x, lapply(x, rev))
  names(os) <- c(names(x), paste(names(x), "_rev", sep=""))
  os
}

### reverses permutations in the list given an logical indicator vector
.do_rev <- function(x, rev) {
  for(i in which(rev)) x[[i]] <- rev(x[[i]])
  x
}

### finds the smallest distance in lists with reversed orders present 
.find_best <- function(d) {
  ### find smallest values
  m <- as.matrix(d)
  n <- nrow(m)/2
  m1 <- m[1:n, 1:n]
  m2 <- m[(n+1):(2*n), (n+1):(2*n)]
  m3 <- m[1:n, (n+1):(2*n)]
  m4 <- m[(n+1):(2*n), 1:n]
  as.dist(pmin(m1,m2,m3,m4))
}

### returns TRUE for sequences which should be reversed
.alignment <- function(x, method="spearman") {
    if(!is.list(x) || any(!sapply(x, is, "ser_permutation_vector"))) stop("x needs to be a list with elements of type 'ser_permutation_vector'")  
  
    method <- match.arg(tolower(method), .dist_methods) 
  
    ### for corr. coefficients neg. means that the order should be reversed
    if(method %in% c("spearman", "kendall")) {
      cr <- cor(t(.lget_rank(x)), method=method)
      ## find the seed method which has the highers absolute 
      ## correlations with others and then reverse the neg. correlated ones
      cr2 <- cr; cr2[cr2<0] <- 0
      seed <- which.max(rowSums(abs(cr2)))
      return(cr[seed,]<0)
    }  
    
    ## add reverse orders
    os <- .add_rev(x)
  
    ## calculate dist   
    d <- seriation_dist(os, method=method, align=FALSE)
    m <- as.matrix(d)
    diag(m) <- NA
    
    ## find closest pair
    n <- length(x)
    take <- which(m == min(m, na.rm = TRUE), arr.ind = TRUE)[1,]
    
    ## mark taken
    m[, take] <- NA
    ## mark complements taken
    m[, (take+n) %% (2*n)] <- NA

    while(length(take) < n) {
      t2 <- which(m[take,] == min(m[take,], na.rm = TRUE), arr.ind = TRUE)[1, 2]
      take <- append(take, t2)
      m[, t2] <- NA
      m[, (t2+n) %% (2*n)] <- NA
    }
  
    ## create indicator vector for the orders which need to be reversed
    take_ind <- logical(n)
    take_ind[take[take>n]-n] <- TRUE
    names(take_ind) <- names(x)
    take_ind
}
   
## Propositional Proximity Coefficient
## Goulermas, Kostopoulos and Mu, A new measure for analyzing and fusing 
## sequences of objects, IEEE Transactions on Pattern Analysis and Machine
## Intelligence, forthcomming.
##
## x,y ... permutation vectors (ranks)
.ppc <- function(x, y) {
  x <- get_order(x)
  y <- get_order(y)
  n <- length(x)
  
  sum <- 0
  for(j in 2:n) for(i in 1:(j-1)) sum <- sum + (x[i]-x[j])^2 * (y[i]-y[j])^2
  1 - (2 * sum / (n^6/15 - n^4/6 + n^2/10)) 
}

.vppc <- Vectorize(.ppc)
.ppc2 <- function(x) as.dist(outer(x, x, .vppc))
