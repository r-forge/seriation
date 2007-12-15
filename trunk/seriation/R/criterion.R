## Criterion generic.
criterion <-
function(x, order = NULL, method = NULL)
    UseMethod("criterion")

## Criterion method registry.

## <NOTE>
## For criterion() methods, argument 'method' really allows selecting
## *several* methods ... should perhaps be called 'methods'?
## We thus have a getter which returns a named list of methods from the
## registry, and a setter for single methods.
## </NOTE>

criterion_methods_db <- new.env()

set_criterion_method <-
function(kind, name, definition, description = NULL, merit = FALSE, ...)
{
    put_method_into_db(criterion_methods_db, kind, name,
                       structure(c(list(name = name,
                                        definition = definition,
                                        description = description,
                                        merit = merit),
                                   list(...)),
                                 class = "criterion_method"))
}

get_criterion_methods <-
function(kind, name)
{
    keys <- objects(criterion_methods_db)
    if(is.null(name)) {
        pattern <- sprintf("^%s_", kind)
        keys <- grep(pattern, keys, value = TRUE)
        name <- sub(pattern, "", keys)
    }
    else {
        ind <- pmatch(.make_db_key(kind, tolower(name)), tolower(keys))
        if(any(is.na(ind)))
            stop(gettextf("Invalid criterion method: '%s'.",
                          name[which(is.na(ind))[1L]]))
        keys <- keys[ind]
    }
    out <- mget(keys, criterion_methods_db)
    names(out) <- name
    out
}

