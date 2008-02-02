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
get_order.hclust <- function(x, ...) {
    o <- x$order
    names(o) <- x$labels[o]
    o
}
get_order.integer <- function(x, ...) {
    o <- as.integer(x)
    names(o) <- names(x)
    o
}

get_order.default <- function(x, ...) 
    stop(gettextf("No permutation accessor implemented for class '%s'.",
                  class(x)))


## currently method is an attribute of permutation
get_method <- function(x, printable = FALSE) {
    method <- attr(x, "method")

    if(printable && is.null(method)) method <- "unknown"
    method
}


## print et al
length.ser_permutation_vector <- function(x) length(get_order(x)) 

print.ser_permutation_vector <-
function(x, ...)
{
    writeLines(c(gettextf("object of class '%s'\n", class(x)),
                 gettextf("contains a permutation vector of length %d",
                          length(x)),
                 gettextf("used seriation method: '%s'",
                          get_method(x, printable = TRUE))))
    invisible(x)
}

## fake summary (we dont really provide a summary, 
## but summary produces now a reasonable result --- same as print)
summary.ser_permutation_vector <- function(object, ...) {
    object
}
summary.ser_permutation <- function(object, ...) {
    object
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
    if(inherits(x, "ser_permutation")) {
        if(length(list(...)) != 0)
            warning("Argument 'x' already has class 'ser_permutation' ... ignored")
        return(x)
    }

    ## check if all elements are ser_permutation_vector
    #if(any(!sapply(x, inherits, "ser_permutation_vector")))
    #stop("some elements are not of class ", sQuote("ser_permutation_vector"))
    ## we make them ser_permutation_vector
    x <- lapply(list(x, ...), "ser_permutation_vector")

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
