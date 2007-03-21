## rearrange a dist object
arrange.dist <- function(x, order) {
    
    if(is.null(order)) return(x)

    #if(!inherits(x,"dist"))
    #stop(paste(sQuote("dist"),"not of class dist"))

    if(attr(x, "Diag") || attr(x, "Upper"))
    stop(paste(Quote("dist"), 
            "with diagonal or upper triangle matrix not implemented"))

    
    if(!inherits(order, "order_1d")) order <- order_1d(order)
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

## arrange for matrix
arrange.matrix <- function(x, order) {
   
    if(is.null(order)) return(x)

    if(!inherits(order, "order_2d")) order <- order_2d(order)
    if(any(dim(x) != dim(order))) stop(paste("dimensions of ", sQuote("x"), 
            "and", sQuote("order"), "no not match"))
   
    if(is.null(order$row) && is.null(order$col)) return(x)
    if(is.null(order$row)) return(x[, order$col])
    if(is.null(order$col)) return(x[order$row,])
    x[order$row, order$col]
}

## create a generic function
arrange <- function(x, order) UseMethod("arrange")
arrange.default <- arrange.dist

