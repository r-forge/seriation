reclat <-  function(data, parameter = NULL, control = NULL)
  {
    call <- match.call()
    data <- as(data, "arMatrix")
    control <- as(control, "ECcontrol")
    parameter <- as(parameter, "ECparameter")
    sets <- .Call("reclat", 
                 ## Transactions
                 as.integer(data@p),
                 as.integer(data@i),
                 ## parameter
                 parameter, control,
                 PACKAGE = "arules")                  
    for (i in c("levels", "attr", "assign", "labels")) slot(sets, i) <- slot(data, i)
    sets@quality <- as.data.frame(sets@quality)
    new("arules", sets = sets, parameter = parameter, call = call, control = control)
  }

