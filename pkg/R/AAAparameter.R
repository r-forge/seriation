## helper to parse parameter lists with defaults

.get_parameters <- function(parameter, defaults) {
  defaults <- as.list(defaults)
  
  if(!is.null(parameter) && length(parameter) != 0) {
    parameter <- as.list(parameter)
    o <- pmatch(names(parameter), names(defaults))
    
    if(any(is.na(o))){
      cat("Available options (with default values):\n")
      print(defaults)
      
      stop(sprintf(ngettext(length(is.na(o)),
        "Unknown option: %s",
        "Unknown options: %s"),
        paste(names(parameter)[is.na(o)],
          collapse = " ")), call. = FALSE)
    }
    
    defaults[o] <- parameter
  }
  
  defaults
}
