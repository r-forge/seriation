

order_1d <- function(x, method = NULL, ...){
    if(inherits(x, "order_1d")) return(x)
    
    if(!is.integer(x)) stop("x is not a integer vector")
    
    if(!is.null(method)) attr(x, "method") <- as.character(method)
    class(x) <- c("order", "order_1d")
    x
}

print.order_1d <- function(x, ...) {
    method <- attr(x, "method")
    if(is.null(method)) method <- "unknown"

    cat("object of class", sQuote(class(x)), "\n")
    cat("contains the order for", length(x), "objects", "\n")
    cat("used method:", sQuote(method), "\n") 
}


order_2d <- function(x = NULL, row = NULL, col = NULL, method = NULL, ...){
    if(is.null(x)) x <- list(row = row, col = col)
    else if(inherits(x, "order_2d")) return(x)
    
    if(is.null(x$row) || is.null(x$col)) 
        stop("x does not contain row and/or col element")
    if(!is.integer(x$row)) x$row <- as.integer(x$row)
    if(!is.integer(x$col)) x$col <- as.integer(x$col)
    
    if(!is.null(method)) attr(x, "method") <- as.character(method)
    class(x) <- c("order", "order_2d")
    x
}

print.order_2d <- function(x, ...) {
    method <- attr(x, "method")
    if(is.null(method)) method <- "unknown"

    cat("object of class", sQuote(class(x)), "\n")
    cat("contains the order for a matrix with", length(x$row), "rows and", 
        length(x$col), "columns", "\n")
    cat("used method:", sQuote(method), "\n") 
}

dim.order_2d <- function(x, ...) {
    c(length(x$row), length(x$col))
}
