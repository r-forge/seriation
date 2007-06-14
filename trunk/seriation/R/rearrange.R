## rearrange 

## helper
.rearrange_kd <- function(x, order) {
    .check_matrix_perm(x, order)

    perm <- lapply(order, get_permutation)    
    do.call("[", c(list(x), perm))          #]
}

.rearrange_1d <- function(x, order) {
    if(!inherits(order, "ser_seriation")) order <- seriation(order)
    
    if(length(order) != 1) stop("dimensions do not match")
    
    perm <- get_permutation(order[[1]])
    if(length(x) != length(perm))     
    stop("some permutation vectors do not fit dimension of data")

    x[perm]
}


rearrange.dist <- function(x, order) {
    if(!inherits(order, "ser_seriation")) order <- seriation(order)
    .check_dist_perm(x, order)

    perm <- get_permutation(order[[1]])
    
    ## make C call
    mode(x) <- "double"
    mode(perm) <- "integer"
    
    d <- .Call("reorder_dist", x, perm)

    labels <- if(is.null(labels(x))) NULL
    else labels(x)[perm]
    
    structure(d, 
        class   = "dist", 
        Size    = length(perm), 
        Labels  = labels,
        Diag    = FALSE,
        Upper   = FALSE,
        method  = attr(x, "method")
    )
}

## methods
rearrange.array     <- .rearrange_kd
rearrange.matrix    <- .rearrange_kd
rearrange.numeric   <- .rearrange_1d
rearrange.list      <- .rearrange_1d
rearrange.default <- function(x, order) 
stop(paste("\nrearrange not implemented for class: ", class(x)))

rearrange <- function(x, order) UseMethod("rearrange")


## more helper
.check_dist_perm <- function(x, order) {
    if(length(order) != 1) stop("dimensions do not match")

    if(attr(x, "Size") != length(get_permutation(order[[1]])))
    stop("some permutation vectors do not fit dimension of data")
    
    ## check dist
    if(attr(x, "Diag") || attr(x, "Upper"))
    stop(paste(Quote("dist"), 
            "with diagonal or upper triangle matrix not implemented"))
}

.check_matrix_perm <- function(x, order) {
    if(length(dim(x)) != length(order)) stop("dimensions do not match")
    if(any(dim(x) != sapply(order, length)))
    stop("some permutation vectors do not fit dimension of data")
}




