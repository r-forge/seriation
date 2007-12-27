## seriate general arrays 

.seriate_array_helper <-
function(x, method = NULL, control = NULL, 
         margin = seq(length(dim(x))), datatype = "array", defmethod, ...)
{
    ## margin 1...rows, 2...cols, ...
    if(is.null(method))
        method <- defmethod
    else if(!is.character(method) || (length(method) != 1L))
        stop("Argument 'method' must be a character string.")
    
    method <- get_seriation_method(datatype, method)
    order <- method$definition(x, control)

    perm <- do.call("ser_permutation",
        unname(lapply(order, "ser_permutation_vector", method$name))
    )
    
    perm[margin]
}

seriate.array <-
function(x, method = NULL, control = NULL, 
         margin = seq(length(dim(x))), ...)
    .seriate_array_helper(x, method, control, margin, 
        datatype = "array", defmethod = NA,...)
    ## we currently have no method and therefore also no default method!


## methods
## no methods available right now 

## register methods
## no methods available right now 
