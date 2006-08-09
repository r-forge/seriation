least_square <- function(dist, order) {

  if (missing(order))
    order <- 1:attr(dist, "Size")
  else {
    if (length(order) != attr(dist,"Size"))
    stop(paste(sQuote("order"),"invalid lenght"))
  }

  dist <- as.matrix(dist)[order, order]
  p <- ncol(dist)

  ### since d ist symmetric we only need to sum up half the matrix
  sum <- 0
  for (i in 1:p) {
    for (j in 1:i) {
       sum <- sum + (dist[i,j] - abs(i-j))^2
    }
  }
  sum * 2
}
