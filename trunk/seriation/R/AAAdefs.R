.choose_method <-
function(method, methods, default = NULL)
{
    if(is.null(method)) {
        if(is.null(default)) return(names(methods)[1])
        else return(default)
    }

    nr <- pmatch(tolower(method), tolower(names(methods)))
    if(is.na(nr)) stop(gettextf("Unknown method '%s'.", method))

    names(methods)[nr]
}


.make_db_key <-
function(kind, name)
    paste(kind, name, sep = "_")

get_method_from_db <-
function(db, kind, name, msg)
{
    keys <- objects(db)
    ind <- pmatch(.make_db_key(kind, tolower(name)), tolower(keys))
    if(is.na(ind))
        stop(msg, call. = FALSE, domain = NA)
    
    db[[keys[ind]]]
}

put_method_into_db <-
function(db, kind, name, value)
{
    db[[.make_db_key(kind, name)]] <- value
}
