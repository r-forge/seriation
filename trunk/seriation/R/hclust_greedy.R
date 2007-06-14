## wrapper to greedy ordering inspired by F. Murtagh
## actually a hierarchical cluster algorithm.

## ceeboo 2005

hclust_greedy <- function(dist) {
    if (!inherits(dist, "dist"))
    stop(paste(sQuote("dist"),"not of class dist"))
    if (!is.real(dist))
    mode(dist) <- "real"
    obj <- .Call("order_greedy", dist)
    names(obj) <- c("merge", "order", "height");
    class(obj) <- "hclust"
    obj
}

