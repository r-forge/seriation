## helper to parse parameter lists with defaults

.get_parameters <- function(parameter, defaults) {
  defaults <- as.list(defaults)
  parameter <- as.list(parameter)
  
  ## add verbose
  if(is.null(defaults$verbose)) defaults$verbose <- FALSE
  
  if(length(parameter) != 0) {
    o <- pmatch(names(parameter), names(defaults))
    
    ## unknown parameter
    if(any(is.na(o))){
      cat("Available parameter (with default values):\n")
      #print(defaults)
      cat(rbind(names(defaults)," = ", gsub("\n"," ",as.character(defaults))), 
        sep=c("\t"," ","\n"))
      
      stop(sprintf(ngettext(length(is.na(o)),
        "Unknown parameter: %s",
        "Unknown parameters: %s"),
        paste(names(parameter)[is.na(o)],
          collapse = " ")), call. = FALSE)
    }
    
    defaults[o] <- parameter
  }

  if(defaults$verbose) {
    cat("Used parameters:\n")
    #print(defaults)
    cat(rbind(names(defaults)," = ", gsub("\n"," ",as.character(defaults))), 
      sep=c("\t"," ","\n"))
  }
  
  defaults
}
