require(methods)
require(stats)
require(stats4)
require(Matrix)
setGeneric("as.list")
setGeneric("as.data.frame")
setGeneric("%in%")
setGeneric("subset")

types <- function(method = "apriori") {
  targets <- c("frequent item sets", "maximally frequent item sets", "closed item sets", "rules", "hyperedgesets")
  methods <- c("apriori", "eclat")
  method <- match.arg(tolower(method), methods)
  if (method == "eclat") return(targets[1:3])
  else return(targets)
}
aremtypes <- function() {
  c("none",      ## no additional evaluation measure 
    "diff",      ## absolute confidence difference 
    "quot",      ## difference of conf. quotient to 1 
    "aimp",      ## abs. diff. of improvement to 1 
    "info",      ## information difference to prior 
    "chi2")      ## normalized chi^2 measure 
}

###**********************************************************

setClass("attributes",
         representation(levels = "list",
                        attr = "character",
                        assign = "integer",
                        labels = "character"))

attributes <- function(levels, labels) {
  if (!missing(levels)) {
    attr <- names(levels)
    assign <- sapply(levels, length, USE.NAMES = FALSE)
    labels <- paste(unlist(levels, use.names = FALSE), rep(attr, assign), sep = ".")
  }
  else if (!missing(labels)) {
    labels <- as.character(labels)
    levels <- list(labels)
    attr <- ""
    assign <- length(labels)
  }
  return(new("attributes", levels = levels, attr = attr, assign = assign, labels = labels))
}
  
