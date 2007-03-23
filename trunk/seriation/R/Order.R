## S3 Class order

## Order_vector order has order 
## Order_matrix has row and col 
## NULL means a identity permutation 

Order <- function(order = NULL, row = NULL, col = NULL, 
    method = NULL){
   
    if(!is.null(order)) {
        if(inherits(order, "Order")) return(order)

        if(inherits(order, "hclust")) {
            class(order) <- c("Order", "Order_vector", class(order))
            if(!is.null(method)) attr(order, "method") <- as.character(method)
            return(order)
        }

        if(is.vector(order)) {
            if(!is.integer(order)) order <- as.integer(order)
            order <- list(order = order)
            class(order) <- c("Order", "Order_vector")
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
    class(x) <- c("Order", "Order_matrix")
    x
}

print.Order <- function(x, ...) {
    cat("object of class", sQuote(class(x)), "\n")
    
    if(inherits(x, "Order_vector")) 
    cat("contains order for", length(x$order), "objects", "\n")

    else if(inherits(x, "Order_matrix")) {
    cat("contains order for", length(x$row), "rows",
        "and", length(x$col), "columns", "\n")
    }
    
    method <- attr(x, "method")
    if(is.null(method)) method <- "unknown"
    cat("used method:", sQuote(method), "\n") 
}

.check_order <- function(order, x) {
    if(!inherits(order, "Order")) return(paste(sQuote("order"), 
            "not of class", sQuote("Order")))

    if(inherits(order, "Order_vector")) {
        if(inherits(x, "dist")) {
            if(length(order$order) > attr(x, "Size")
                || any(order$order > attr(x, "Size")))
            return(paste(sQuote("order"), "does not match size of", 
                    sQuote("x")))

        }
        else if(is.matrix(x) && isSymmetric(x)) {
            if(length(order$order) > nrow(x)
                || any(order$order > nrow(x)))
            return(paste(sQuote("order"), "does not match dimensions of", 
                sQuote("x")))
        }
        else return(paste(sQuote("order"), "not suitable for", sQuote("x"))) 
    }

    else if(inherits(order, "Order_matrix")) {
        if(!is.matrix(x)) return(paste(sQuote("order"), 
            "requires a matrix as", sQuote("x")))

        if(length(order$row) > nrow(x) 
            || any(order$row > nrow(x)))
        return(paste("length of row order does not match", sQuote("x")))

        if(length(order$col) > ncol(x) 
            || any(order$col > ncol(x))) 
        return(paste("length of row order does not match", sQuote("x")))

    }

    else return(paste(sQuote("order"), "contains an unknown subclass"))

    return(TRUE)

}
