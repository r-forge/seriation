rapriori <-  function(data, parameter = NULL, appearance = NULL, control = NULL)
  {
    call <- match.call()
    data <- as(data, "assMatrix")
    as.ASappearance <- function(from) {
      if (!length(from)) return(new("ASappearance"))
      prv <- names(from)
      warn <- NULL
      args = c("default", "body", "head", "both", "none")
      p <- pmatch(prv, args)
      names(from) <- args[p]
      if (is.null(from$default)) from[["default"]] = "both"
      labs <- data@labels
      for (i in args) assign(i, NULL)
      for (i in names(from)){
        if (i != "default") {
          if (is.character(from[[i]])) {
            which.labels <- function(x) {
              u <- which(data@labels %in% x | rep(data@attr, data@assign) %in% x |
                         unlist(data@levels, use.names = FALSE) %in% x)
              if (!length(u)) {
                warn <<- c(warn, paste(x, " is not a valid attribute, label or level."))
                return(NULL)
              }
              u - 1
            }
            assign(i, as.integer(unlist(sapply(from[[i]], which.labels))))
          }
          else assign(i, as.integer(from[[i]]))
        }
      }
      app <- list(body, head, both, none)
      if (!is.null(warn)) warning(warn)
      if (length(unlist(app))) 
        return(new("ASappearance", default = from$default, items = unlist(app),
            set = sapply(app, length), labels = labs))
      else return(new("ASappearance", default = from$default))
    }

    if (is.list(appearance)) appearance <- as.ASappearance(appearance)
    control <- as(control, "APcontrol")
    parameter <- as(parameter, "APparameter")
    appearance <- as(appearance, "ASappearance")   
    sets <- .Call("rapriori", 
                 ## Transactions
                 as.integer(data@p),
                 as.integer(data@i),
                 ## parameter
                 parameter, control,
                 ## appearance
                 appearance,
                 PACKAGE = "arules")                  
    for (i in c("levels", "attr", "assign", "labels")) slot(sets, i) <- slot(data, i)
    sets@quality <- as.data.frame(sets@quality)
    new("arules", sets = sets, parameter = parameter, call = call, control = control)
  }

