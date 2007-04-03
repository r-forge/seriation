## seriate existing hierarchical cluster solutions (hclust)

seriate.hclust <- function(x, dist, method = NULL, control = NULL, ...) {
    
    ## check arguments
    if (!inherits(dist, "dist"))
    stop(paste(sQuote("dist"),"not of class dist"))
    if (!is.real(dist)) storage.mode(dist) <- "real"

    ## methods
    methods <- c(
        "optimal",      # standard
        "gw")

    if(is.null(method)) methodNr <- 1
    else methodNr <- pmatch(tolower(method), tolower(methods))
    if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))

    ## work horses
    workhorse <-
    if(methodNr == 1) .seriate_optimal
    else if (methodNr == 2) .seriate_gruvaeus
    
    Order(workhorse(x, dist), method = methods[methodNr])
}


## wrapper for reorder.hclust in gclus
.seriate_gruvaeus <- function(hclust, dist) gclus::reorder.hclust(hclust, dist)



## wrapper to the optimal leaf ordering algorithm
##
## ceeboo 2005

.seriate_optimal <- function(hclust, dist) {
    
    ## check hclust
    merge <- hclust$merge
    if (!is.matrix(merge))
    stop(paste(sQuote("merge"),"in",sQuote("hclust"),"not a matrix"))
    if (length(dim(merge)) != 2)
    stop(paste(sQuote("merge"),"in",sQuote("hclust"),"invalid"))
    if (dim(merge)[1] != attr(dist,"Size")-1)
    stop(paste(sQuote("dist"),"and",sQuote("merge"),"in",sQuote("hclust"),
            "do not conform"))
    storage.mode(merge) <- "integer"
    
    obj <- .Call("order_optimal", dist, merge)
    
    names(obj) <- c("merge","order","length")
    ##names(obj$order) <- attr(dist,"Labels")
    hclust$merge <- obj$merge
    hclust$order <- obj$order

    hclust
}
