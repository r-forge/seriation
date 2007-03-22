## S3 Class order

## asymmetric order has row and col 
## symmetric order has order 
## NULL means keep original order 

Order <- function(order = NULL, row = NULL, col = NULL, 
    method = NULL, ...){
   
    if(!is.null(order)) {
        if(inherits(order, "Order")) return(order)

        if(inherits(order, "hclust")) {
            class(order) <- c("Order", "Order_symmetric", class(order))
            if(!is.null(method)) attr(order, "method") <- as.character(method)
            return(order)
        }

        if(is.vector(order)) {
            if(!is.integer(order)) order <- as.integer(order)
            order <- list(order = order)
            class(order) <- c("Order", "Order_symmetric")
            if(!is.null(method)) attr(order, "method") <- as.character(method)
            return(order)
        }

        stop(sQuote("order"), " contains invalid data")
    }

    ## asymmetric
    ## unlist just in case it is an order with order
    if(!is.null(row)) row <- as.integer(unlist(row))
    if(!is.null(col)) col <- as.integer(unlist(col))
   
    x <- list(row = row, col = col)
    if(!is.null(method)) attr(x, "method") <- as.character(method)
    class(x) <- c("Order", "Order_asymmetric")
    x
}

print.Order <- function(x, ...) {
    cat("object of class", sQuote(class(x)), "\n")
    
    if(inherits(x, "Order_symmetric")) 
    cat("contains order for", length(x$order), "objects", "\n")

    else if(inherits(x, "Order_asymmetric")) {
    cat("contains order for", length(x$row), "rows",
        "and ", length(x$col), "columns", "\n")
    }
    
    method <- attr(x, "method")
    if(is.null(method)) method <- "unknown"
    cat("used method:", sQuote(method), "\n") 
}

.check_order <- function(order, x) {
    if(!inherits(order, "Order")) stop(sQuote("order"), " not of class ", 
            sQuote("Order"))
    
    if(inherits(x, "dist")) {
        if(!inherits(order, "Order_symmetric")) stop(sQuote("order"), 
            " for ", sQuote("dist"), " not symmetric")

        if(length(order$order) > attr(x, "Size") 
            || any(order$order > attr(x, "Size"))) 
        stop(sQuote("order"), " does not match size of ", sQuote("x"))
    }else if(is.matrix(x)){
        if(inherits(order, "Order_symmetric") 
            && (!isSymmetric(x) 
                || length(order$order) > ncol(x) 
                || any(order$order) > ncol(x)))
        stop(sQuote("x") , " does not match the symmetric order")
        
        if(length(order$row) > nrow(x) 
            || any(order$row > nrow(x)))
        stop("row order does not match ", sQuote("x"))
    
        if(length(order$col) > ncol(x) 
            || any(order$col > ncol(x))) 
        stop("column order does not match ", sQuote("x"))
    }
}
