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
function(kind, name, definition, description = NULL, ...){

    ## check formals
    if(!identical(names(formals(definition)),
                  c("x", "control")))
        stop("Seriation methods must have formals 'x' and 'control'.")

    put_method_into_db(seriation_methods_db, kind, name,
        structure(c(list(name = name,
                    definition = definition,
                    description = description),
                list(...)),
            class = "seriation_method"))
}

list_seriation_methods <-
function(kind)
    list_methods_in_db(seriation_methods_db, kind)

show_seriation_methods <-
function(kind)
{
    methods <- list_seriation_methods(kind)
    descriptions <-
        sapply(methods, 
               function(m) get_seriation_method(kind, m)$description)
    writeLines(formatDL(methods, descriptions, style = "list"))
}

print.seriation_method <-
function(x, ...)
{
    writeLines(c(gettextf("object of class '%s'", class(x)),
            gettextf("name:        %s", x$name),
            gettextf("description: %s", x$description)))
    invisible(x)
}

