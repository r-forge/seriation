## permute 

## helper
.permute_kd <-
function(x, order)
{
    .check_matrix_perm(x, order)

    perm <- lapply(order, get_order)    
    do.call("[", c(list(x), perm))          #]
}

.permute_1d <-
function(x, order)
{
    if(!inherits(order, "ser_permutation_vector")) 
        order <- ser_permutation(order)
    
    if(length(order) != 1L)
        stop("dimensions do not match")
    
    perm <- get_order(order[[1L]])
    if(length(x) != length(perm))     
        stop("some permutation vectors do not fit dimension of data")

    x[perm]
}

## if we used proxy we would say:
#.rearrange_dist <- function (x, order) x[[order]]

.rearrange_dist <-
function (x, order)
{
    ## make C call
    mode(x) <- "double"
    mode(order) <- "integer"

    d <- .Call("reorder_dist", x, order)

    labels <- if(is.null(labels(x)))
        NULL
    else
        labels(x)[order]

    structure(d, 
              class   = "dist", 
              Size    = length(order), 
              Labels  = labels,
              Diag    = FALSE,
              Upper   = FALSE,
              method  = attr(x, "method")
              )
}

permute.dist <-
function(x, order)
{
    if(!inherits(order, "ser_permutation"))
        order <- ser_permutation(order)
    .check_dist_perm(x, order)

    order <- get_order(order, 1)
    .rearrange_dist(x, order)
}

## methods
permute.array     <- .permute_kd
permute.matrix    <- .permute_kd
permute.numeric   <- .permute_1d
permute.character <- .permute_1d
permute.list      <- .permute_1d
##permute.default <- function(x, order) 
##stop(paste("\npermute not implemented for class: ", class(x)))
permute.default   <- .permute_kd

## data.frame is weird
permute.data.frame <- 
function(x, order)
{
    if(!inherits(order, "ser_permutation_vector")) 
        order <- ser_permutation(order)
    
    if(length(order) != 1L)
        stop("dimensions do not match")
    
    perm <- get_order(order[[1L]])
    if(nrow(x) != length(perm))     
        stop("some permutation vectors do not fit dimension of data")

    x[perm,]
}

permute <-
function(x, order)
    UseMethod("permute")

## more helper
.check_dist_perm <-
function(x, order)
{
    if(length(order) != 1L)
        stop("dimensions do not match")

    if(attr(x, "Size") != length(get_order(order[[1L]])))
        stop("some permutation vectors do not fit dimension of data")
    
    ## check dist
    if(attr(x, "Diag") || attr(x, "Upper"))
        stop("'dist' with diagonal or upper triangle matrix not implemented")
}

.check_matrix_perm <-
function(x, order)
{
    if(length(dim(x)) != length(order))
        stop("dimensions do not match")
    if(any(dim(x) != sapply(order, length)))
        stop("some permutation vectors do not fit dimension of data")
}
