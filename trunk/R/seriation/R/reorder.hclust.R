# reorder existing hierarchical cluster solutions (hclust)
# and dissimilarity objects (dist)

reorder.hclust <- function(x, dist, method = NULL, ...) {
  if (!inherits(x,"hclust"))
    stop(paste(sQuote("x"),"not of class hclust"))
  if (!inherits(dist,"dist"))
    stop(paste(sQuote("dist"),"not of class dist"))

  methods <- c("optimal",
          "gw")

  # standard seriation is Optimal Leaf Ordering
  if(is.null(method)) methodNr <- 1
  else methodNr <- pmatch(tolower(method), tolower(methods))
  if(is.na(methodNr)) stop (paste("Unknown method:",sQuote(method)))
		
  if(methodNr == 1) {
        res <- reorder_optimal(x, dist)
  }else if (methodNr == 2) {
        res <- reorder_gruvaeus(x, dist)
  }

  # fixme: reflection would be nice 
  return(res)
}


# wrapper for reorder.hclust in gclus
reorder_gruvaeus <- function(hclust, dist) {
    return(.reorder_gruvaeus_gclus(hclust, dist))
  }


# wrapper to the optimal leaf ordering algorithm
#
# ceeboo 2005

reorder_optimal <- function(hclust, dist) {
    merge <- hclust$merge
    if (!is.matrix(merge))
       stop(paste(sQuote("merge"),"in",sQuote("hclust"),"not a matrix"))
    if (length(dim(merge)) != 2)
       stop(paste(sQuote("merge"),"in",sQuote("hclust"),"invalid"))
    if (dim(merge)[1] != attr(dist,"Size")-1)
       stop(paste(sQuote("dist"),"and",sQuote("merge"),"in",sQuote("hclust"),
	   "do not conform"))
    if (!is.real(dist))
       storage.mode(dist) <- "real"
    storage.mode(merge) <- "integer"
    obj <- .Call("order_optimal", dist, merge)
    names(obj) <- c("merge","order","length")
    #names(obj$order) <- attr(dist,"Labels")
    hclust$merge <- obj$merge
    hclust$order <- obj$order
    
    return(hclust)
}
  
###
