setClass("itemset",
         representation(rnb = "integer",
                        body = "cscMatrix",
                        trans = "cscMatrix",
                        quality = "data.frame"),
         contains = "attributes")

setClass("ruleset",
         representation(head = "cscMatrix"),
         contains = "itemset")

setClass("hyperedgeset",
         contains = "itemset")

setClassUnion("set", c("itemset", "ruleset", "hyperedgeset"))

###**********************************************************

setMethod("as.character", "set", function(x) {
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

setMethod("show", signature(object = "itemset"), function(object) {
  cat(class(object), " containing ", object@rnb, " sets\n", sep = "")
})

###**********************************************************

setClass("summary.set",
         representation(rnb = "integer",
                        tnb = "table",
                        body = "integer",
                        quality = "table"))

setClass("summary.ruleset",
         contains = "summary.set",
         representation(head = "integer"))

setMethod("summary", "set", function(object, maxsum = 7, ...) {
  chars <- as.character(object)
  for (i in names(chars)) assign(i, summary(as.factor(chars[[i]]), maxsum = maxsum, ...))
  if (length(chars) == 2) {
    return(new("summary.ruleset", rnb = object@rnb, quality = summary(object@quality), tnb = table(diff(object@body@p)),
               head = head, body = body))
  }
  else {
    return(new("summary.set", rnb = object@rnb, quality = summary(object@quality), tnb = table(diff(object@body@p)),
          body = body))
  }

})

###**********************************************************

setMethod("[", signature(x = "set"),
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
                body = new("assMatrix", x@body, labels = x@labels, levels = x@levels, attr = x@attr,
                  assign = x@assign),
                head = new("assMatrix", x@head, labels = x@labels, levels = x@levels, attr = x@attr,
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
                body = new("assMatrix", x@body, labels = x@labels, levels = x@levels, attr = x@attr,
                  assign = x@assign))))
  }
  x[i,]
}

setMethod("subset", signature(x = "set"), subsetSet)
setMethod("subset", signature(x = "ruleset"), subsetRuleSet)


###**********************************************************

setAs("set", "data.frame", function(from, to) {          
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

setMethod("as.data.frame", signature(x = "set"), function(x, row.names = NULL, optional = FALSE) {
  as(x, "data.frame")
})
