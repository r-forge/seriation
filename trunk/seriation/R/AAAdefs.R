

.choose_method <- function(method, methods, default = NULL) {
    
    if(is.null(method)) {
        if(is.null(default)) return(names(methods)[1])
        else return(default)
    }

    nr <- pmatch(tolower(method), tolower(names(methods)))
    if(is.na(nr)) stop (paste("Unknown method:", sQuote(method)))

    names(methods)[nr]
}

