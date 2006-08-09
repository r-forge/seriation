# wrapper to computing the lenght of the order
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
    if (!inherits(dist,"dist"))
       stop(paste(sQuote("dist"),"not of class dist"))
    if (missing(order))
       order <- 1:attr(dist, "Size")
    else {
       if (length(order) != attr(dist,"Size"))
          stop(paste(sQuote("order"),"invalid lenght"))
    }
    if (!is.real(dist))
       storage.mode(dist) <- "real"
    if (!is.integer(order))
       storage.mode(order) <- "integer"
    x <- .Call("path_length", dist, order)
    x
}

###
