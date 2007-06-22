## S3 permutation and permutations classes
## permutations consists of instances of permutation

## permutation

## constructor
permutation <- function(x, method = NULL) {
    if(!is.null(method)) attr(x, "method") <- method
    
    if(inherits(x, "ser_permutation")) return(x)
   
    ## make sure it's an integer vector
    if(is.vector(x) && !is.integer(x)) x <- as.integer(x)

    class(x) <- c("ser_permutation", class(x))
    .valid_permutation(x)
    x
}

## accessors
get_order <- function(x, ...) UseMethod("get_order")
get_order.ser_permutation <- function(x) NextMethod()
get_order.default <- function(x) 
    stop(paste("\nNo permutation accessor implemented for class: ", class(x)))

get_order.hclust <- function(x) x$order
get_order.integer <- function(x) as.integer(x)

## currently method is an attribute of permutation
get_method <- function(x, printable = FALSE) {
    method <- attr(x, "method")

    if(printable && is.null(method)) method <- "unknown"
    method
}


## print et al
length.ser_permutation <- function(x) length(get_order(x)) 

print.ser_permutation <- function(x, ...) {
    cat("object of class", sQuote(class(x)), "\n")

    cat("contains a permutation vector of length", length(x), "\n")
    
    cat("used seriation method:", sQuote(get_method(x, printable = TRUE)), "\n")
}

## helpers
.valid_permutation <- function(x) {
    perm <- get_order(x)
    if(max(perm) > length(perm)) stop("Invalid permutation vector")
    if(any(table(perm) != 1)) stop("Invalid permutation vector")
}


######################################################
## permutations

## constructor
permutations <- function(x,...) {
    ddd <- list(...)
    if(inherits(x, "ser_permutations")) {
        if(length(ddd) != 0) warning(sQuote("x"),
            " is already ser_permutations, ... ignorred")
        return(x)
    }

    x <- c(list(x), ddd)

    ## check if all elements are ser_permutation
    #if(any(!sapply(x, inherits, "ser_permutation")))
    #stop("some elements are not of class ", sQuote("ser_permutation"))
    ## we make them ser_permutation
    x <- lapply(x, "permutation")

    class(x) <- c("ser_permutations", "list")
    x
}

## so we can say get_order to permutations
get_order.ser_permutations <- function(x, dim = 1) get_order(x[[dim]])

## print et al
print.ser_permutations <- function(x, ...) {
    cat("object of class", sQuote(class(x)), "\n")

    cat("contains permutation vectors for", length(x), 
        "dimensional data\n\n")
   
    print(data.frame(
        "vector length" = sapply(x, length),
        "seriation method" = sapply(x, get_method, printable = TRUE)
    ))
}

c.ser_permutations <- function(..., recursive = FALSE) 
    do.call("permutations", 
        unlist(lapply(list(...), unclass), recursive = FALSE))

## fixme [[<- needs to check for permutations

"[.ser_permutations" <- function(object, i, ...) 
    do.call("permutations", unclass(object)[i])
