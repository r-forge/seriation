setClass("arules",
         representation(call = "call",
                        parms = "ASparms",
                        control = "AScontrol",
                        set = "set"))

###**********************************************************

setMethod("show", signature(object = "arules"), function(object) {
  print(object@set)
  if (inherits(object@parms, "APparms")) {
    if (object@parms@originalSupport) cat("derived using the original support\n")
  }
  cat("\nCall:\n", deparse(object@call, 0.75*getOption("width")),
      "\n\n", sep = "")
  for (i in c("parms", "control")) {
    assign(i, data.frame(sapply(slotNames(slot(object, i)), function(x) slot(slot(object, i), x), simplify = FALSE),
                         row.names = ""))
  }
  cat("Parameter specification:\n")
  print(parms)
  cat("\nAlgorithmic control specification:\n")
  print(control)
})

setMethod("summary", signature(object = "arules"), function(object, ...) {
  summary(object@set, ...)
})
                             
setMethod("as.data.frame", signature(x = "arules"), function(x, row.names = NULL, optional = FALSE) {
  as.data.frame(x@set)
})
