## wrapper to greedy ordering inspired by F. Murtagh
## actually a hierarchical cluster algorithm.

## ceeboo 2005

hclust_greedy <- function(dist) {
    if (!inherits(dist, "dist"))
        stop("Argument 'dist' is not of class 'dist'.")
    if (!is.double(dist))
    mode(dist) <- "double"
    obj <- .Call("order_greedy", dist)
    names(obj) <- c("merge", "order", "height");
    class(obj) <- "hclust"
    obj
}

