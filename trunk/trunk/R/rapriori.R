rapriori <-  function(data, parms = NULL, appearance = NULL, control = NULL)
  {
    call <- match.call()
    data <- as(data, "assMatrix")

    as.ASapp <- function(from) {
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
      new("ASapp", default = from$default, items = unlist(app),
          set = sapply(app, length), labels = labs)
    }
    if (is.list(appearance)) appearance <- as.ASapp(appearance)
    control <- as(control, "APcontrol")
    parms <- as(parms, "APparms")
    appearance <- as(appearance, "ASapp")   
    set <- .Call("rapriori", 
                 ## Transactions
                 as.integer(data@p),
                 as.integer(data@i),
                 ## parameter
                 parms, control,
                 ## appearance
                 appearance,
                 PACKAGE = "arules")                  
    for (i in c("levels", "attr", "assign", "labels")) slot(set, i) <- slot(data, i)
    set@quality <- as.data.frame(set@quality)
    new("arules", set = set, parms = parms, call = call, control = control)
  }

