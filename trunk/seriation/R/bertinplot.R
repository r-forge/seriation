bertinplot  <- function(x, highlight = NULL, options = NULL) {

    if(!is.matrix(x)) stop(paste(sQuote("x"), "has to be a matrix"))

    ## default plot options
    user_options <- options
    options <- list(
        barwidth    = 0.8,
        mar         = c(5, 4, 8, 8),
        cex         = 0.9,
        newpage     = TRUE,
        pop         = TRUE
    )

    ## check and add the plot options
    if(!is.null(user_options) && length(user_options) != 0) {
        o <- pmatch(names(user_options), names(options))

        if(any(is.na(o))) stop(paste("Unknown plot option:",
                names(user_options)[is.na(o)], "\n\t"))

        for (i in 1:length(o)) {
            options[[o[i]]] <- user_options[[i]]
        }
    }

    ncases <- dim(x)[1]
    nvariables <- dim(x)[2]
    barwidth <- options$barwidth
    xlim <- c(1 - barwidth, ncases + barwidth)
    
    ## clear page
    if(options$newpage) grid.newpage()
 
    #c(bottom, left, top, right)
    pushViewport(plotViewport(margins = options$mar,
            layout = grid.layout(nvariables, 1), 
            xscale = xlim, yscale = c(1,nvariables), default.unit = "native"))

    for (variable in 1:nvariables) { 
        height <- x[, variable]

        hl <- if(is.null(highlight)) height > mean(height, na.rm = TRUE) 
        else highlight[, variable]

        pushViewport(viewport(layout.pos.col = 1, layout.pos.row = variable,
                xscale = xlim, yscale = c(0, max(height, na.rm = TRUE) * 1.1), 
                default.unit = "native"))

        grid.rect(x = 1:ncases, y = 0, width = barwidth, height = height,
            just = c("centre", "bottom"), default.units = "native", 
            gp = gpar(fill = hl))

        upViewport(1)
    }

    cases <- labels(x)[[1]]
    variables <- labels(x)[[2]]

    grid.text(cases, x = 1:ncases, y = nvariables, 
        rot = 90, just = "left",
        default.units= "native", gp = gpar(cex = options$cex))

    grid.text(rev(variables), x = 1, 
        y = 0.5:(nvariables-0.5)/nvariables,
        just = "left", 
        default.units= "npc", gp = gpar(cex = options$cex))

    if (options$pop == TRUE) popViewport(1)
    else upViewport(1)

}

