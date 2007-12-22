## Criterion for the quality of a permutation of a array

criterion.array <-
function(x, order = NULL, method = NULL)
{
    ## check order
    if(!is.null(order)){
        if(!inherits(order, "ser_permutation")) 
            stop("Argument 'order' has to be of class 'ser_permutation'")
        .check_matrix_perm(x, order)
    }

    ## get methods
    if(is.null(method)) method <- list_criterion_methods("array")
    method <- lapply(method, function(m ) get_criterion_method("array", m))

    sapply(method,
        function(m) structure(m$definition(x, order), names=m$name))
}


## methods

## register built-ins
