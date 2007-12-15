## Seriation generic and default method.

seriate <- function(x, ...)
    UseMethod("seriate")
seriate.default <- function(x, ...) 
    stop(gettextf("seriate not implemented for class '%s'.",
                  class(x)))

## Seriation methods db.

seriation_methods_db <- new.env()

get_seriation_method <-
function(kind, name)
    get_method_from_db(seriation_methods_db, kind, name,
                       gettextf("Invalid seriation method: '%s'.",
                                name))

set_seriation_method <-
function(kind, name, definition, description = NULL, ...)
    put_method_into_db(seriation_methods_db, kind, name,
                       structure(c(list(name = name,
                                        definition = definition,
                                        description = description),
                                   list(...)),
                                 class = "seriation_method"))
