## rearrange a dist object
arrange.dist <- function(x, order) {

    if(!inherits(x,"dist"))
    stop(paste(sQuote("dist"),"not of class dist"))

    if(attr(x, "Diag") || attr(x, "Upper"))
    stop(paste(Quote("dist"), 
            "with diagonal or upper triangle matrix not implemented"))

    if(any(order > attr(x, "Size"))) stop(paste(sQuote("order"), 
            "contains indices too large for", sQuote("x")))
   
    storage.mode(x) <- "double"
    order <- as.integer(order)
    
    d <- .Call("reorder_dist", x, order)

    labels <- if(is.null(labels(x))) as.character(order) else labels(x)[order]
    
    structure(d, 
        class   = "dist", 
        Size    = length(order), 
        Labels  = labels,
        Diag    = FALSE,
        Upper   = FALSE,
        method  = attr(x, "method")
    )
}

## create a generic function
arrange <- function(x, order) UseMethod("arrange")
arrange.default <- arrange.dist

