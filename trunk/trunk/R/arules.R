setClass("arules",
         representation(call = "call",
                        parameter = "ASparameter",
                        control = "AScontrol",
                        sets = "sets"))

###**********************************************************

setMethod("show", signature(object = "arules"), function(object) {
  print(object@sets)
  if (inherits(object@parameter, "APparameter")) {
    if (object@parameter@originalSupport)
      cat("derived using a minimum original support of", object@parameter@support, "\n")
    else cat("derived using a minimum body support of", object@parameter@support, "\n")
  }
  cat("\nCall:\n", deparse(object@call, 0.75*getOption("width")),
      "\n\n", sep = "")
  cat("Parameter specification:\n")
  print(object@parameter)
  cat("\nAlgorithmic control specification:\n")
  print(object@control)
  invisible(object)
})

setMethod("summary", signature(object = "arules"), function(object, ...) {
 getMethod("summary", "sets")(object@sets, ...)
})
                             
setMethod("as.data.frame", signature(x = "arules"), function(x, row.names = NULL, optional = FALSE) {
  as.data.frame(x@sets)
})
