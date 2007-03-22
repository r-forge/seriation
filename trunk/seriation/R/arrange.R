## rearrange a dist object
arrange.dist <- function(x, order) {
    
    if(is.null(order)) return(x)
    
    if(!inherits(order, "Order_symmetric")) stop(sQuote("order"),
        " is not of class ", sQuote("Order_symmetric"))

    if(is.null(order$order)) return(x)

    ## check dist
    if(attr(x, "Diag") || attr(x, "Upper"))
    stop(paste(Quote("dist"), 
            "with diagonal or upper triangle matrix not implemented"))

    .check_order(order, x)

    storage.mode(x) <- "double"
    order <- as.integer(order$order)
    
    d <- .Call("reorder_dist", x, order)

    ## dist never had Labels!
    #labels <- if(is.null(labels(x))) as.character(order$both) 
    #else labels(x)[order$both]
    
    structure(d, 
        class   = "dist", 
        Size    = length(order), 
        #Labels  = labels,
        Diag    = FALSE,
        Upper   = FALSE,
        method  = attr(x, "method")
    )
}

## arrange for matrix
arrange.matrix <- function(x, order) {
   
    if(is.null(order)) return(x)
    
    if(!inherits(order, "Order")) stop(sQuote("order"),
        " is not of class ", sQuote("Order"))
    
    .check_order(order, x)

    if(is.null(order$row)
        && is.null(order$col)
        && is.null(order$order)) return(x)
    
    if(!is.null(order$order)) return(x[order$order, order$order])
    if(is.null(order$row)) return(x[, order$col])
    if(is.null(order$col)) return(x[order$row,])
    x[order$row, order$col]
}

## create a generic function
arrange <- function(x, order) UseMethod("arrange")
arrange.default <- arrange.dist

