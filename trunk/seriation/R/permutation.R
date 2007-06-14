## S3 permutation class

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
get_permutation <- function(x) UseMethod("get_permutation")
get_permutation.default <- function(x) 
    stop(paste("\nNo permutation accessor implemented for class: ", class(x)))

get_permutation.hclust <- function(x) x$order
get_permutation.integer <- function(x) unclass(x)

## print et al
length.ser_permutation <- function(x) length(get_permutation(x)) 

print.ser_permutation <- function(x, ...) {
    cat("object of class", sQuote(class(x)), "\n")

    cat("contains a permutation vector of length", length(x), "\n")
    
    method <- attr(x, "method")
    if(is.null(method)) method <- "unknown"
    cat("used seriation method:", sQuote(method), "\n")
}

## helpers
.valid_permutation <- function(x) {
    perm <- get_permutation(x)
    if(max(perm) > length(perm)) stop("Invalid permutation vector")
    if(any(table(perm) != 1)) stop("Invalid permutation vector")
}


