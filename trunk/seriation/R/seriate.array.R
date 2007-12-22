## seriate general arrays 

seriate.array <-
function(x, method = NULL, control = NULL, 
         margin = seq(length(dim(x))), ...)
{
    ## margin 1...rows, 2...cols, ...

    if(is.null(method))
        method <- NA # we have no implementation yet
    else if(!is.character(method) || (length(method) != 1L))
        stop("Argument 'method' must be a character string.")
    
    method <- get_seriation_method("array", method)
    order <- method$definition(x, control)

    perm <- ser_permutation(
        lapply(order, function (o) ser_permutation_vector(o, method$name))
        )
    
    perm[margin]
}

## methods
## no methods available right now 

## register methods
## no methods available right now 
