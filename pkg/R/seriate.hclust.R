## wrapper for reorder.hclust in gclus
.seriate_gruvaeus <-
function(hclust, dist)
    gclus::reorder.hclust(hclust, dist)

## wrapper to the optimal leaf ordering algorithm
##
## ceeboo 2005
seriate_optimal <-
function(hclust, dist)
{
    ## check hclust
    merge <- hclust$merge
    if (!is.matrix(merge))
        stop("Component 'merge' of argument 'hclust' must be a matrix.")
    if (length(dim(merge)) != 2)
        stop("Component 'merge' of argument 'hclust' is invalid.")
    if (dim(merge)[1] != attr(dist,"Size")-1)
        stop("Argument 'dist' and component 'merge' of argument 'hclust' do not conform.")
    mode(merge) <- "integer"
    
    obj <- .Call("order_optimal", dist, merge)
    
    names(obj) <- c("merge","order","length")
    ##names(obj$order) <- attr(dist,"Labels")
    hclust$merge <- obj$merge
    hclust$order <- obj$order

    hclust
}
