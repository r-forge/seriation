setClass("itemsets",
         representation(rnb = "integer",
                        body = "cscMatrix",
                        trans = "cscMatrix",
                        quality = "data.frame"),
         contains = "attributes")

setClass("hyperedges",
         representation(rnb = "integer",
                        body = "cscMatrix",
                        quality = "data.frame"),
         contains = "attributes")

setClass("rules",
         representation(head = "cscMatrix"),
         contains = "hyperedges")

setClassUnion("sets", c("itemsets", "rules", "hyperedges"))

###**********************************************************

setMethod("as.character", "sets", function(x) {
  slots <- intersect(slotNames(x), c("head", "body"))
  names <- list()
  if (length(x@labels)) {
    for (sl in slots) { 
      names[[sl]] <- x@labels[slot(x, sl)@i+1]
    }
    sapply(names, function(x) x[is.na(x)] <<- "<NA>")
  }
  else {
    for (sl in slots) { 
      names[[sl]] <- as.character(slot(x, sl)@i+1)
    }
  }
  names
})

setMethod("show", signature(object = "sets"), function(object) {
  cat(class(object), " containing ", object@rnb, " sets\n", sep = "")
  invisible(object)
})

###**********************************************************

setClass("summary.sets",
         representation(rnb = "integer",
                        tnb = "table",
                        body = "integer",
                        quality = "table"))

setClass("summary.rules",
         contains = "summary.sets",
         representation(head = "integer"))

setMethod("summary", "sets", function(object, maxsum = 7, ...) {
  chars <- as.character(object)
  for (i in names(chars)) assign(i, summary(as.factor(chars[[i]]), maxsum = maxsum, ...))
  if (length(chars) == 2) {
    return(new("summary.rules", rnb = object@rnb, quality = summary(object@quality), tnb = table(diff(object@body@p)),
               head = head, body = body))
  }
  else {
    return(new("summary.sets", rnb = object@rnb, quality = summary(object@quality), tnb = table(diff(object@body@p)),
          body = body))
  }

})

setMethod("show", signature(object = "summary.sets"), function(object) {
  cat("Object contains ", object@rnb, " ", strsplit(class(object), ".", fixed = TRUE)[[1]][2], ".\n\n", sep = "")
  cat("body lengths:\n")
  print(object@tnb)
  slots <- slotNames(object)
  slots <- slots[slots %in% c("head", "body")]
  for (s in slots) {
    cat("\n", s, ":\n", sep = "")
    print(slot(object, s))
  }
  cat("\nquality:\n")
  print(object@quality)
  invisible(object)
})
###**********************************************************

setMethod("[", signature(x = "sets"),
          function(x, i, j, ..., drop)
          {
            if (!missing(j)) stop("incorrect number of dimensions")
            if (missing(i)) i <- 1:x@rnb
            y <- x
            slots <- intersect(slotNames(x), c("head", "body"))
            for (sl in slots) slot(y, sl) <- slot(x, sl)[,i]
            y@quality <- x@quality[i, ]
            y@rnb <- NROW(y@quality)
            y
          })

subsetRuleSet <- function(x, subset, ...) {
  if (missing(subset)) i <- rep(TRUE, x@body@Dim[2])
  else {
    e <- substitute(subset)
    i <- eval(e,
              c(x@quality, list(
                body = new("arMatrix", x@body, labels = x@labels, levels = x@levels, attr = x@attr,
                  assign = x@assign),
                head = new("arMatrix", x@head, labels = x@labels, levels = x@levels, attr = x@attr,
                  assign = x@assign)
                                )))
  }
  x[i,]
}

subsetSet <- function(x, subset, ...) {
  if (missing(subset)) i <- rep(TRUE, x@body@Dim[2])
  else {
    e <- substitute(subset)
    i <- eval(e,
              c(x@quality, list(
                body = new("arMatrix", x@body, labels = x@labels, levels = x@levels, attr = x@attr,
                  assign = x@assign))))
  }
  x[i,]
}

setMethod("subset", signature(x = "sets"), subsetSet)
setMethod("subset", signature(x = "rules"), subsetRuleSet)


###**********************************************************

setAs("sets", "data.frame", function(from, to) {          
  if (from@rnb == 0) {
    warning("Empty set!")
    return(from)
  }
  else {
    slots <- intersect(slotNames(from), c("head", "body"))
    for (sl in slots) {
      ll <- as.list(slot(from, sl))
      assign(sl, sapply(ll, function(x) paste(from@labels[x+1], collapse = " ")))
    }
    if (length(slots) == 1) return(data.frame(body = body, from@quality))
    else return(data.frame(head = head, body = body, from@quality))
  }
})

setMethod("as.data.frame", signature(x = "sets"), function(x, row.names = NULL, optional = FALSE) {
  as(x, "data.frame")
})

