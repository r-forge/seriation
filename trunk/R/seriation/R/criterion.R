
criterion <- function(dist, order, method = NULL) {
  methods <- c(
    "path-length",
    "least-square",
    "inertia",
    "ar-i",
    "ar-s",
    "ar-w"
  )

    if (!inherits(dist,"dist"))
       stop(paste(sQuote("dist"),"not of class dist"))
    if (!missing(order) && length(order) != attr(dist,"Size"))
          stop(paste(sQuote("order"),"invalid length"))
    
  
   if(is.null(method)) methodNr <- 1
     else methodNr <- pmatch(tolower(method), tolower(methods))
   if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))

   if(methodNr == 1) {
     crit <- path_length(dist, order)
   }else if (methodNr == 2) {
     crit <- least_square(dist, order)
   }else if (methodNr == 3) {
     crit <- inertia(dist, order)
   }else if (methodNr == 4) {
     crit <- ar(dist, order, method = "i")
   }else if (methodNr == 5) {
     crit <- ar(dist, order, method = "s")
   }else if (methodNr == 6) {
     crit <- ar(dist, order, method = "w")
   }
     
   #attr(crit, "method") <- methods[methodNr]
   return(crit)
    
 
 }

# wrapper to computing the length of the order
# under a distance matrix, e.g. a tour where the
# leg between the first and last city is omitted.
# that this is a (Hamilton) path.
#
# note that this corresponds to the sum of distances 
# along the first off diagonal of the ordered distance
# matrix.
# 

# ceeboo 2005

path_length <- function(dist, order) {
    if (missing(order))
       order <- 1:attr(dist, "Size")
    
    if (!is.real(dist))
       storage.mode(dist) <- "real"
    if (!is.integer(order))
       storage.mode(order) <- "integer"
    x <- .Call("path_length", dist, order)
    x
}



# least square criterion. measures the difference between the 
# dissimilarities between two elements and the rank distance
# see PermutMatrix

least_square <- function(dist, order) {

  dist <- as.matrix(dist)
  if(!missing(order)) dist <- dist[order, order]
  p <- ncol(dist)

  # since d ist symmetric we only need to sum up half the matrix
  sum <- 0
  for (i in 1:p) {
    for (j in 1:i) {
       sum <- sum + (dist[i,j] - abs(i-j))^2
    }
  }
  sum * 2
}

# inertia around the diagonal
# see PermutMatrix

inertia <- function(dist, order) {

  dist <- as.matrix(dist)
  if(!missing(order)) dist <- dist[order, order]
  p <- ncol(dist)

  # since d ist symmetric we only need to sum up half the matrix
  sum <- 0
  for (i in 1:p) {
    for (j in 1:i) {
       sum <- sum + dist[i,j] * abs(i-j)^2
    }
  }
  sum * 2
}


# anti-Robinsin loss functions (Streng and Schönfelder 1978, Chen 2002)

# count the anti-Robinson events
ar <- function(dist, order, method = "i") {
  
  if(method=="i") weight <- expression(1)
  if(method=="s") weight <- expression(abs(dist[i,j] - dist[i,k]))
  if(method=="w") weight <- expression(abs(j - k) * abs(dist[i,j] - dist[i,k]))
  
  dist <- as.matrix(dist)
  if(!missing(order)) dist <- dist[order, order]
  p <- ncol(dist)

  sum <- 0
  for(i in 3:p){

    for(k in 2:(i-1)){
      for(j in 1:(k-1)){
	sum <- sum + (dist[i,j] < dist[i,k]) * eval(weight)
      }
    }
  }

  for(i in 1:(p-2)){
    for(j in (i+1):(p-1)){
      for(k in (j+1):p){
	sum <- sum + (dist[i,j] > dist[i,k]) * eval(weight)
      }
    }
  }

  sum 
}


