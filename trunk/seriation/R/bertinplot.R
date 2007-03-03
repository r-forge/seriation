bertinplot  <- function(x, highlight = NULL, options = NULL) {

    if(!is.matrix(x)) stop(paste(sQuote("x"), "has to be a matrix"))

    ## default plot options
    user_options <- options
    options <- list(
        panel_function     = panel.bars, 
        reverse     = FALSE,
        xlab        = NULL,
        ylab        = NULL,
        spacing     = 0.2,
        mar         = c(5, 4, 8, 8),
        gp_labels   = gpar(cex = 0.9),
        #        gp_panel    = gpar(),
        newpage     = TRUE,
        pop         = TRUE
    )

    ## check and add the plot options
    if(!is.null(user_options) && length(user_options) != 0) {
        o <- pmatch(names(user_options), names(options))

        if(any(is.na(o))) stop(paste("Unknown plot option:",
                names(user_options)[is.na(o)], "\n\t"))

        for (i in 1:length(o)) options[[o[i]]] <- user_options[[i]]
    }
    
    attach(options)
    on.exit(detach("options"))
    
    do_hl <- if(is.null(highlight)) TRUE else FALSE
    if(do_hl) highlight <- matrix(NA, ncol = ncol(x), nrow = nrow(x))

    for (variable in 1:ncol(x)) { 
        ## scaling
        x[,variable] <- x[,variable]/max(x[,variable], na.rm = TRUE)

        ## highlight
        if(do_hl) 
        highlight[,variable] <- x[,variable] > mean(x[,variable], na.rm = TRUE)
    }


    ## note: Bertin switched cols and rows for his display!
    if(reverse) {
        x <- t(x)
        highlight <- t(highlight)
    }

    ncol_x  <- ncol(x)
   
    ## clear page
    if(newpage) grid.newpage()
 
    ## create outer viewport
    xlim <- c(1 - (1 - spacing), nrow(x) + (1 - spacing))
    pushViewport(plotViewport(margins = mar,
            layout = grid.layout(ncol_x, 1), 
            xscale = xlim, 
            yscale = c(1, ncol_x), default.unit = "native"))

    for (variable in 1:ncol_x) { 
        value <- x[, variable]
        hl <- highlight[, variable]

        pushViewport(viewport(layout.pos.col = 1, layout.pos.row = variable,
                xscale = xlim, 
                yscale = c(0, 1), 
                default.unit = "native"))

        ## call panel function
        panel_function(value, spacing, hl)

        upViewport(1)
    }

    ## do labels
    rownames_x <- if(is.null(xlab)) rownames(x) else xlab
    colnames_x <- if(is.null(ylab)) colnames(x) else ylab

    spacing_corr <- if(spacing < 0) spacing_corr <- -spacing else 0

    grid.text(rownames_x, x = 1:nrow(x), y = ncol_x + spacing_corr, 
        rot = 90, just = "left",
        default.units= "native", gp = gp_labels)

    grid.text(rev(colnames_x), x = 1 + spacing_corr / nrow(x) / 4, 
        y = 0.5:(ncol_x-0.5)/ncol_x,
        just = "left", 
        default.units= "npc", gp = gp_labels)

    if (pop == TRUE) popViewport(1)
    else upViewport(1)

}

## panel functions
panel.bars <- function(value, spacing, hl) {
    grid.rect(x = 1:length(value), y = 0, 
        width = 1 - spacing, 
        height = value*(1 - spacing),
        just = c("centre", "bottom"), default.units = "native", 
        gp = gpar(fill = hl))
}

panel.circles <- function(value, spacing, hl) {
    grid.circle(x = c(1:length(value)), y = unit(0.5, "npc"), 
        r = value/2*(1 - spacing),
        default.units = "native", 
        gp = gpar(fill = hl))
}

panel.squares <- function(value, spacing, hl) {
    grid.rect(x = 1:length(value), y = unit(0.5, "npc"), 
        width = value*(1 - spacing), 
        height = value*(1 - spacing),
        just = c("centre", "center"), default.units = "native", 
        gp = gpar(fill = hl))
}

panel.lines <- function(value, spacing, hl) {
    grid.lines(x = c(1:length(value)), y = value*(1-spacing), 
        default.units = "native")
}
