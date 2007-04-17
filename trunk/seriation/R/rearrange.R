## rearrange a dist object
rearrange.dist <- function(x, order) {
    
    if(is.null(order)) return(x)
    
    if(!inherits(order, "Order_vector")) stop(sQuote("order"),
        " is not of class ", sQuote("Order_vector"))

    if(is.null(order$order)) return(x)

    ## check dist
    if(attr(x, "Diag") || attr(x, "Upper"))
    stop(paste(Quote("dist"), 
            "with diagonal or upper triangle matrix not implemented"))

    if((msg <- .check_order(order, x)) != TRUE) stop(msg)

    storage.mode(x) <- "double"
    order <- as.integer(order$order)
    
    d <- .Call("reorder_dist", x, order)

    labels <- if(is.null(labels(x))) NULL
    else labels(x)[order]
    
    structure(d, 
        class   = "dist", 
        Size    = length(order), 
        Labels  = labels,
        Diag    = FALSE,
        Upper   = FALSE,
        method  = attr(x, "method")
    )
}

## rearrange for matrix
rearrange.matrix <- function(x, order) {
   
    if(is.null(order)) return(x)
    
    if(!inherits(order, "Order")) stop(sQuote("order"),
        " is not of class ", sQuote("Order"))
    
    if((msg <- .check_order(order, x)) != TRUE) stop(msg)

    if(is.null(order$row)
        && is.null(order$col)
        && is.null(order$order)) return(x)
    
    if(!is.null(order$order)) {
        if(!isSymmetric(x)) stop("Order_vector can only be applied to a symmetric matrix")
        return(x[order$order, order$order])
    }
    if(is.null(order$row)) return(x[, order$col])
    if(is.null(order$col)) return(x[order$row,])
    x[order$row, order$col]
}

## create a generic function
rearrange <- function(x, order) UseMethod("rearrange")
rearrange.default <- rearrange.dist

