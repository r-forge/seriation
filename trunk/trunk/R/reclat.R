reclat <-  function(data=list(), parms = NULL, control = NULL)
  {
    call <- match.call()
    data <- as(data, "assMatrix")
    control <- as(control, "ECcontrol")
    parms <- as(parms, "ECparms")
    set <- .Call("reclat", 
                 ## Transactions
                 as.integer(data@p),
                 as.integer(data@i),
                 ## parameter
                 parms, control,
                 PACKAGE = "arules")                  
    for (i in c("levels", "attr", "assign", "labels")) slot(set, i) <- slot(data, i)
    set@quality <- as.data.frame(set@quality)
    new("arules", set = set, parms = parms, call = call, control = control)
  }

