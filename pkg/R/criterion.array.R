## Criterion for the quality of a permutation of a array

.criterion_array_helper <-
function(x, order = NULL, method = NULL, datatype = "array")
{
    ## check order
    if(!is.null(order)){
        if(!inherits(order, "ser_permutation")) 
            stop("Argument 'order' has to be of class 'ser_permutation'.")
        .check_matrix_perm(x, order)
    }

    ## get methods
    if(is.null(method)) method <- list_criterion_methods(datatype)
    method <- lapply(method, function(m) get_criterion_method(datatype, m))

    sapply(method,
        function(m) structure(m$definition(x, order), names=m$name))
}

criterion.array <-
function(x, order = NULL, method = NULL)
    .criterion_array_helper(x, order, method, "array")

## methods

## register built-ins
