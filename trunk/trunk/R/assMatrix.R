setClass("assMatrix",
         contains = c("cscMatrix", "attributes"))

setAs("matrix", "assMatrix", 
      function(from) {
        z <- as(from, "cscMatrix")
        v <- attributes(labels = 1:dim(z)[1])
        new("assMatrix", z, v)
      })
  
setAs("assMatrix", "matrix", 
      function(from) {
        from <- as(from, "cscMatrix")
        as(from, "matrix")
      })

setAs("data.frame", "assMatrix", function(from) {
  fdim <- dim(from)
  attr <- colnames(from)
  from <- lapply(from, as.factor)
  levels <- lapply(from, levels)
  attrib <- attributes(levels = levels)
  lev <- c(0, cumsum(attrib@assign))
  u <- sapply(from, as.integer) + rep(lev[-length(lev)], each = fdim[1])
  i <- as.integer(t(u)-1)
  ndim <- c(length(attrib@labels), fdim[1])
  len <- rep(fdim[2], ndim[2])
  if (any(is.na(u))) {
    i <- i[!is.na(i)]
    ind <- table(which(is.na(u), arr.ind = TRUE)[,1])
    rowsNA <- as.integer(names(ind))
    len[rowsNA] <- len[rowsNA] - ind
  }
  p <- as.integer(c(0, cumsum(len)))
  z <- new("cscMatrix", x = rep(as.integer(1), length(i)), i = i, p = p, Dim = ndim)
  new("assMatrix", z, attrib)
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


