###**********************************************************
setClass("ASappearance",
         representation(set = "integer",
                        items = "integer",
                        labels = "character",
                        default = "character"),
         prototype(set = as.integer(rep(0, 4)),
                   items = integer(),
                   labels = "",
                   default = "both"),
         validity = function(object) {
           appearance <- c("i",  "in",  "a", "ante", "antecedent", "b", "body",
                    "o",  "out", "c", "cons", "consequent", "h", "head",
                    "io", "inout", "ac", "bh", "both",          
                    "n", "neither", "none", "ign", "ignore", "-")
           ans <- NULL
           if (!object@default %in% appearance) ans <- c(NULL, "Default value not specified correctly!")
           if (!sum(object@set) == length(object@items)) ans <- c(NULL, "Slot 'set' and 'items' do not match!")
           if (length(ans)) ans else TRUE
         })

###**********************************************************

setClass("ASparameter",
         representation(support = "numeric",
                        minlen = "integer",
                        maxlen = "integer",
                        target = "character",
                        ext = "logical"),
         prototype(target = "frequent item sets",
                   support = 0.1,
                   minlen = as.integer(1),
                   maxlen = as.integer(5),
                   ext = TRUE),
         validity = function(object) {
           ans <- NULL
           if (!object@target %in% .types()) ans <- c(ans, paste("target =", object@target, "not supported."))
           if (object@support > 1) ans <- c(ans, paste("support =", object@support, "> 1"))
           if (object@minlen <= 0)  ans <- c(ans, paste("minlen =", object@minlen, "<= 0"))
           if (object@minlen > object@maxlen) ans <- c(ans, paste("minlen =", object@minlen,
                                                                  "> maxlen =", object@maxlen))
           ifelse(length(ans), ans, TRUE)
         })
        
setClass("APparameter",
         representation(confidence = "numeric",
                        minval = "numeric",
                        smax = "numeric",
                        arem = "character",
                        aval = "logical",
                        originalSupport = "logical"),
         contains = "ASparameter",
         prototype(new("ASparameter"),
                   target = "rules",
                   confidence = 0.8,
                   minval = 0.1,
                   smax = 1.0,
                   arem = "none",
                   originalSupport = TRUE,
                   aval = FALSE),
         validity = function(object) {
           ans <- NULL
           if (!object@arem %in% .aremtypes()) ans <- c(ans, paste("arem =", object@arem, "not supported."))
           if (object@confidence > 1) ans <- c(ans, paste("confidence =", object@confidene, "> 1"))
           if (object@smax < 0) ans <- c(ans, paste("smax =", object@smax, "< 0"))
           ifelse(length(ans), ans, TRUE)
         })

setClass("ECparameter",
         representation(trans = "logical"),
         contains = "ASparameter",
         prototype(new("ASparameter"),
                   trans = FALSE),
         validity = function(object) {
           if (object@target %in% .types(method = "eclat")) TRUE else paste(object@target, "not supported")
         })

setClass("AScontrol",
         representation(sort = "integer",
                        verbose = "logical"),
         prototype(verbose = TRUE,
                   sort = as.integer(2)),
         validity = function(object) {
           if (object@sort > 2 | object@sort < -2) paste("sort =", object@sort,"not one of 1: ascending,",
                                           "-1: descending, 0: do not sort, 2: ascending,",
                                           "-2: descending w.r.t. transaction size sum")
           else TRUE })

setClass("APcontrol",
         representation(filter = "numeric",
                        tree = "logical",
                        heap = "logical",
                        memopt = "logical",
                        load = "logical"),
         contains = "AScontrol",
         prototype(new("AScontrol"),
                   filter = 0.1,
                   sort = as.integer(2),
                   tree = TRUE,
                   heap = TRUE,
                   memopt = FALSE,
                   load = TRUE),
         validity = function(object) {
           if (object@filter > 1 | object@filter < -1) paste("filter =", object@filter, "is not in [-1,1]")
           else TRUE
         })

setClass("ECcontrol",
         representation(sparse = "numeric"),
         contains = "AScontrol",
         prototype(new("AScontrol"),
                   sparse = 7,
                   sort = as.integer(-2)))

###**********************************************************

setAs("NULL", "ASappearance",
function(from, to)
{
  new(to)
})

setAs("NULL", "APcontrol",
function(from, to)
{
  new(to)
})

setAs("NULL", "APparameter",
function(from, to)
{
  new(to)
})

setAs("NULL", "ECcontrol",
function(from, to)
{
  new(to)
})

setAs("NULL", "ECparameter",
function(from, to)
{
  new(to)
})

setAs("list", "ECcontrol", function(from, to) .list2object(from, to))
setAs("list", "ECparameter", function(from, to) .list2object(from, to))
setAs("list", "APcontrol", function(from, to) .list2object(from, to))
setAs("list", "APparameter", function(from, to) .list2object(from, to))

###**********************************************************
setMethod("initialize", "ASparameter",
   function(.Object, minlen = 1, maxlen = 5, target = "frequent item sets", ...) {
     if (minlen - as.integer(minlen)) stop("minlen = ", minlen, " can not be coerced to integer without error.")
     if (maxlen - as.integer(maxlen)) stop("maxlen = ", maxlen, " can not be coerced to integer without error.")
     .Object@minlen <- as.integer(minlen)
     .Object@maxlen <- as.integer(maxlen)
     i <- pmatch(tolower(target), .types())
     if (!is.na(i)) .Object@target <- .types()[i] else .Object@target = target
     args = list(...)
     for (i in names(args)) slot(.Object, i, check = FALSE) <- args[[i]]
     validObject(.Object)
     .Object
   })

setMethod("initialize", "APparameter",
   function(.Object, minlen = 1, maxlen = 5, target = "rules", arem = "none", ...) {
     i <- pmatch(tolower(arem), .aremtypes())
     if (!is.na(i)) .Object@arem <- .aremtypes()[i] else .Object@arem = arem
     .Object <- callNextMethod(.Object, minlen = minlen, maxlen = maxlen, target = target, ...)
     .Object
   })

setMethod("initialize", "AScontrol",
   function(.Object, sort, ...) {
     if (!missing(sort)) {
     if (sort - as.integer(sort)) stop("sort = ", sort, " can not be coerced to integer without error.")
       sort = as.integer(sort)
       .Object <- callNextMethod(.Object, sort = sort, ...)
     }
     else .Object <- callNextMethod(.Object, ...)
     .Object
   })

###**********************************************************
setClassUnion(".parameter", c("ASparameter", "AScontrol"))

setMethod("show", ".parameter", function(object) {
  print(data.frame(sapply(slotNames(object), function(x) slot(object, x), simplify = FALSE), row.names = ""))
  invisible(object)
})


