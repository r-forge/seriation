#######################################################################
# seriation - Infrastructure for seriation
# Copyrigth (C) 2011 Michael Hahsler, Christian Buchta and Kurt Hornik
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.



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
function(kind, name, definition, description = NULL, merit = NA, ...)
{
    ## check formals
    if(!identical(names(formals(definition)),
                  c("x", "order", "...")))
        stop("Criterion methods must have formals 'x', 'order', and '...'.")
    
    put_method_into_db(criterion_methods_db, kind, name,
                       structure(c(list(name = name,
                                        definition = definition,
                                        description = description,
                                        merit = merit),
                                   list(...)),
                                 class = "criterion_method"))
}

## get_criterion_methods <-
## function(kind, name)
## {
##     keys <- objects(criterion_methods_db)
##     if(is.null(name)) {
##         pattern <- sprintf("^%s_", kind)
##         keys <- grep(pattern, keys, value = TRUE)
##         name <- sub(pattern, "", keys)
##     }
##     else {
##         ind <- pmatch(.make_db_key(kind, tolower(name)), tolower(keys))
##         if(any(is.na(ind)))
##             stop(gettextf("Invalid criterion method: '%s'.",
##                           name[which(is.na(ind))[1L]]))
##         keys <- keys[ind]
##     }
##     out <- mget(keys, criterion_methods_db)
##     names(out) <- name
##     out
## }

get_criterion_method <-
function(kind, name)
    get_method_from_db(criterion_methods_db, kind, name,
                       gettextf("Invalid criterion method: '%s'.", name))

list_criterion_methods <-
function(kind)
    list_methods_in_db(criterion_methods_db, kind)

show_criterion_methods <-
function(kind)
{
    methods <- list_criterion_methods(kind)
    descriptions <-
            sapply(methods, 
                function(m) {
                    cm <- get_criterion_method(kind, m)
                    paste(cm$description,
                        if(cm$merit) "(merit function)"
                        else "(loss function)")
                })
    writeLines(formatDL(methods, descriptions, style = "list"))
}

print.criterion_method <-
function(x, ...)
{
    writeLines(c(gettextf("object of class '%s'", class(x)),
            gettextf("name:        %s", x$name),
            gettextf("description: %s", x$description),
            gettextf("merit:       %s", x$merit)))
    invisible(x)
}
