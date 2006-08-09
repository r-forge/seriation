# Seriation heuristics for matrices
#
# Michael Hahsler


### wrapper for dist
reorder.dist <- function(x, method = NULL) 
    reorder.matrix(as.matrix(x), method = method)

reorder.matrix <- function(x, method = NULL, col = TRUE) {

  methods <- c(
    "murtagh", 
    "first-pc") 

  # standard seriation is Murtagh
  if(is.null(method)) methodNr <- 1
  else methodNr <- pmatch(tolower(method), tolower(methods))
  if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))

  if(col == FALSE) x <- t(x)

  if(methodNr == 1) {
    order <- reorder_murtagh(x)
  }else if(methodNr == 2) {
    order <- reorder_prcomp(x)
  }
  
  attr(order, "method") <- methods[methodNr]
  return(order)
}
  


# Algorithm B
#  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures
#  in Computational Statistics, Physica Verlag, pp. 15.

reorder_murtagh <- function(x) {

  # pre-calculate criterion for column pairs in x 
  criterion <- as.dist(tcrossprod(x))
  order_greedy(-criterion)$order
}
 
# use the projection on the first pricipal component to determine the
# order

reorder_prcomp <- function(x) {
  pr <- prcomp(x) 
  scores <- pr$x[,1]
  order(scores)
}


