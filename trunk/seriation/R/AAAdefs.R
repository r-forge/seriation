## registry helpers
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

list_methods_in_db <-
function(db, kind)
{
    pattern <- sprintf("^%s_", kind)
    sub(pattern, "",
        grep(pattern, objects(db), value = TRUE))
}
    
