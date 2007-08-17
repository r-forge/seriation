## S3 permutation and permutations classes
## permutations consists of instances of permutation

## permutation

## constructor
ser_permutation_vector <- function(x, method = NULL) {
    if(!is.null(method)) attr(x, "method") <- method
    
    if(inherits(x, "ser_permutation_vector")) return(x)
   
    ## make sure it's an integer vector
    if(is.vector(x) && !is.integer(x)) x <- as.integer(x)

    class(x) <- c("ser_permutation_vector", class(x))
    .valid_permutation_vector(x)
    x
}

## accessors
get_order <- function(x, ...) UseMethod("get_order")
get_order.ser_permutation_vector <- function(x, ...) NextMethod()
get_order.default <- function(x, ...) 
    stop(paste("\nNo permutation accessor implemented for class: ", class(x)))

get_order.hclust <- function(x, ...) x$order
get_order.integer <- function(x, ...) as.integer(x)

## currently method is an attribute of permutation
get_method <- function(x, printable = FALSE) {
    method <- attr(x, "method")

    if(printable && is.null(method)) method <- "unknown"
    method
}


## print et al
length.ser_permutation_vector <- function(x) length(get_order(x)) 

print.ser_permutation_vector <- function(x, ...) {
    cat("object of class", sQuote(class(x)), "\n")

    cat("contains a permutation vector of length", length(x), "\n")
    
    cat("used seriation method:", sQuote(get_method(x, printable = TRUE)), "\n")
}

## helpers
.valid_permutation_vector <- function(x) {
    perm <- get_order(x)
    valid <- TRUE
    if(max(perm) > length(perm)) valid <- FALSE 
    if(any(table(perm) != 1)) valid <- FALSE
    
    if(!valid) stop("Invalid permutation vector")
}


######################################################
## permutations

## constructor
ser_permutation <- function(x,...) {
    ddd <- list(...)
    if(inherits(x, "ser_permutation")) {
        if(length(ddd) != 0) warning(sQuote("x"),
            " is already ser_permutation, ... ignored")
        return(x)
    }

    x <- c(list(x), ddd)

    ## check if all elements are ser_permutation_vector
    #if(any(!sapply(x, inherits, "ser_permutation_vector")))
    #stop("some elements are not of class ", sQuote("ser_permutation_vector"))
    ## we make them ser_permutation_vector
    x <- lapply(x, "ser_permutation_vector")

    class(x) <- c("ser_permutation", "list")
    x
}

## so we can say get_order to permutations
get_order.ser_permutation <- function(x, dim = 1, ...) get_order(x[[dim]])

## print et al
print.ser_permutation <- function(x, ...) {
    cat(gettextf("object of class %s\n",
                 paste(sQuote(class(x)), collapse = ", ")))

    cat(gettextf("contains permutation vectors for %d-mode data\n\n",
                 length(x)))
   
    print(data.frame("vector length" = sapply(x, length),
                     "seriation method" =
                     sapply(x, get_method, printable = TRUE),
                     check.names = FALSE))

    invisible(x)
}

c.ser_permutation <- function(..., recursive = FALSE) 
    do.call("ser_permutation", 
        unlist(lapply(list(...), unclass), recursive = FALSE))

## fixme [[<- needs to check for ser_permutation_vector

"[.ser_permutation" <- function(object, i, ...) 
    do.call("ser_permutation", unclass(object)[i])
