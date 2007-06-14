## S3 seriation class (a list of permutation vectors)

## constructor
seriation <- function(x,...) {
    ddd <- list(...)
    if(inherits(x, "ser_seriation")) {
        if(length(ddd) != 0) warning(sQuote("x"),
            " is already ser_seriation, ... ignorred")
        return(x)
    }

    x <- c(list(x), ddd)

    ## check if ser_permutations
    #if(any(!sapply(x, inherits, "ser_permutation")))
    #stop("some elements are not of class ", sQuote("ser_permutation"))
    ## we make them ser_permutation
    x <- lapply(x, "permutation")

    class(x) <- c("ser_seriation", "list")
    x
}

## print et al
print.ser_seriation <- function(x, ...) {
    cat("object of class", sQuote(class(x)), "\n")

    cat("contains permutation vectors for ", length(x), 
        "dimensional data\n")
}

c.seriation <- function(..., recursive = FALSE) {
    x <- c(..., recursive = recursive)
    class(x) <- c("ser_seriation", "list")
    x
}
