# rearrange a dist object
arrange.dist <- function(x, order) {

    if(class(x) != "dist")
    stop(paste(sQuote("dist"),"not of class dist"))

    if(attr(x, "Diag") || attr(x, "Upper"))
    stop(paste(Quote("dist"), 
            "with diagonal or upper triangle matrix not implemented"))

    order <- as.integer(order)
    d <- .Call("reorder_dist", x, order)

    attributes(d) <- attributes(x)
    attr(d, "Labels") <- labels(x)[order]
    d
}

# create a generic function
arrange <- function(x, order) UseMethod("arrange")
arrange.default <- arrange.dist

