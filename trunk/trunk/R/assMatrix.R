setClass("assMatrix",
         contains = c("cscMatrix", "attributes"))

setAs("matrix", "assMatrix", 
      function(from) {
        z <- as(from, "cscMatrix")
        v <- .attributes(labels = 1:dim(z)[1])
        new("assMatrix", z, v)
      })
  
setAs("assMatrix", "matrix", 
      function(from) {
        from <- as(from, "cscMatrix")
        as(from, "matrix")
      })

setAs("data.frame", "assMatrix", function(from) {
  if (!all(sapply(from, is.factor)))
    stop("Column ", names(which(!sapply(from, is.factor))), " is not a factor.") 
  fdim <- dim(from)
  attr <- colnames(from)
  levels <- sapply(from, levels, simplify = FALSE)
  attrib <- .attributes(levels = levels)
  lev <- c(0, cumsum(attrib@assign))
  ndim <- c(length(attrib@labels), fdim[1])
  len <- rep(fdim[2], ndim[2])
  v <- lapply(1:fdim[2], function(i) factor(from[[i]],
                                            levels = levels(from[[i]]),
                                            labels = lev[i]:(lev[i+1]-1)))
  v <- data.frame(v)
  i <- as.integer(t(v))
  if (any(is.na(v))) {
    i <- i[!is.na(i)]
    ind <- table(which(is.na(v), arr.ind = TRUE)[,1])
    rowsNA <- as.integer(names(ind))
    len[rowsNA] <- len[rowsNA] - ind
  }
  p <- as.integer(c(0, cumsum(len)))
  z <- new("cscMatrix", x = rep(as.integer(1), length(i)), i = i, p = p, Dim = ndim)
  new("assMatrix", z, attrib)
})

setAs("assMatrix", "data.frame", function(from) {
  variables <- from@attr
  to <- list()
  for (v in 1:length(variables)) {
    t <- .Call("assMatrix_var", from, as.integer(v), PACKAGE = "arules")
    var <- variables[v]
    to[[var]] <- factor(t, labels = from@levels[[var]])
  }
  to <- do.call("data.frame", to)
})
###**********************************************************

setMethod("as.character", signature(x = "assMatrix"), function(x) {
  names <- x@labels[x@i+1]
  names[is.na(names)] <- "<NA>"
  names
})

setMethod("as.list", signature(x = "cscMatrix"), function(x, ...) {
  z <- vector(length = x@Dim[2], mode = "list")
  l <- which(diff(x@p) != 0)
  sapply(l, function(i) z[[i]] <<- x@i[(x@p[i]+1):x@p[i+1]])
  return(z)
})

###**********************************************************

setMethod("show", signature(object = "assMatrix"), function(object) {
  cat("Transaction matrix in sparse format with dimension", object@Dim, "\n")
  invisible(object)
})

###**********************************************************

subsetcscMatrix <- function(x, i, j, ..., drop) {
  mdrop <- missing(drop)
  Narg <- nargs() - (!mdrop)
  if (!mdrop) 
    warning("drop argument will be ignored")
  if (Narg < 3) {
    stop("incorrect number of dimensions")
  }
  if (missing(i)) i <- 1:x@Dim[1]
  if (missing(j)) j <- 1:x@Dim[2]
  if (is.logical(i)) {
    i <- rep(i, length.out = x@Dim[1])
    i <- which(i)
  }
  if (is.logical(j)) {
    j <- rep(j, length.out = x@Dim[2])
    j <- which(j)
  }
  i <- as.integer(i - 1)
  j <- as.integer(j - 1)
  z <- .Call("csc_subset", x, i, j, PACKAGE = "arules")                  
  z
}

setMethod("[", signature(x = "cscMatrix"), subsetcscMatrix)

###**********************************************************

setMethod("%in%", signature(x = "assMatrix"), function(x, table) {
  w <- which(x@labels %in% table | rep(x@attr, x@assign) %in% table | unlist(x@levels, use.names = FALSE) %in% table)
  w <- w - 1
  h <- as.list(x)
  sapply(h, function(x) any(x %in% w))
})


