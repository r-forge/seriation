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





######################################################
## permutations

## constructor
ser_permutation <- function(x,...) {
    if(inherits(x, "ser_permutation")) {
        if(length(list(...)) != 0)
            warning("Argument 'x' already has class 'ser_permutation' ... ignored")
        return(x)
    }

    ## check if all elements are ser_permutation_vector
    #if(any(!sapply(x, inherits, "ser_permutation_vector")))
    #stop("some elements are not of class ", sQuote("ser_permutation_vector"))
    ## we make them ser_permutation_vector
    x <- lapply(list(x, ...), "ser_permutation_vector")

    class(x) <- c("ser_permutation", "list")
    x
}

## so we can say get_order to permutations
get_order.ser_permutation <- function(x, dim = 1, ...) get_order(x[[dim]])

## print et al
    print.ser_permutation <- function(x, ...) {
	writeLines(c(
		gettextf("object of class %s",
			paste(sQuote(class(x)), collapse = ", ")),
		gettextf("contains permutation vectors for %d-mode data\n",
			length(x))
		))

    print(data.frame("vector length" = sapply(x, length),
                     "seriation method" =
                     sapply(x, get_method, printable = TRUE),
                     check.names = FALSE))

    invisible(x)
}

## fake summary (we dont really provide a summary, 
## but summary produces now a reasonable result --- same as print)
summary.ser_permutation <- function(object, ...) 
    object


c.ser_permutation <- function(..., recursive = FALSE) 
    do.call("ser_permutation", 
        unlist(lapply(list(...), unclass), recursive = FALSE))

## fixme [[<- needs to check for ser_permutation_vector

"[.ser_permutation" <- function(object, i, ...) 
    do.call("ser_permutation", unclass(object)[i])
