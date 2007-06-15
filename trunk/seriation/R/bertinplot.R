bertinplot  <- function(x, order = NULL, highlight = TRUE, options = NULL) {

    if(!is.matrix(x)) stop(paste(sQuote("x"), "has to be a matrix"))
    if(!is.logical(highlight)) 
    stop(paste(sQuote("highlight"), "has to be a logical"))

    ## order
    if(!is.null(order)) x <- permute(x, order)

    ## default plot options
    user_options <- options
    options <- list(
        panel.function     = panel.bars, 
        reverse     = FALSE,
        xlab        = NULL,
        ylab        = NULL,
        frame       = FALSE,
        spacing     = 0.2,
        mar         = c(5, 4, 8, 8),
        gp_labels   = gpar(),
        gp_panels   = gpar(),
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
    
    ## scale each variable in x for plotting (between 0 and 1)
    x <- x/ matrix(apply(x, 2, max, na.rm = TRUE), 
        byrow= TRUE, ncol=ncol(x), nrow= nrow(x))
    
    ## highlight
    if(length(highlight) == 1 && highlight) 
        highlight <- x > rowMeans(x, na.rm = TRUE)
    else if(length(highlight) == 1 && !highlight)
        highlight <- matrix(FALSE, ncol = ncol(x), nrow = nrow(x))
    else if(all(dim(x) != dim(highlight))) stop(sQuote("highlight"),
        "has incorrect dimensions")

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

    ## do frame
    #if(frame) {
        #    grid.rect(width = 1/ncol_x*(ncol_x-.52))
        ## why .52?
        #}

    for (variable in 1:ncol_x) { 
        value <- x[, variable]
        hl <- highlight[, variable]

        pushViewport(viewport(layout.pos.col = 1, layout.pos.row = variable,
                xscale = xlim, yscale = c(0, 1), 
                default.unit = "native", gp = gp_panels))

        ## call panel function
        panel.function(value, spacing, hl)

        ## do frame
        if(frame) grid.rect(x = 1:length(value), 
            width = 1,
            default.unit = "native")

        upViewport(1)
    }


    ## do labels
    rownames_x <- if(is.null(xlab)) rownames(x) else xlab
    colnames_x <- if(is.null(ylab)) colnames(x) else ylab

    spacing_corr <- if(spacing <= 0) spacing_corr <- -spacing+0.2 else 0

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
    ## do not plot zero circles
    value[value == 0] <- NA
    
    grid.circle(x = c(1:length(value)), 
        r = value/2*(1 - spacing),
        default.units = "native", 
        gp = gpar(fill = hl))
}

panel.squares <- function(value, spacing, hl) {
    ## do not plot zero squares
    value[value == 0] <- NA
    
    grid.rect(x = 1:length(value), 
        width = value*(1 - spacing), 
        height = value*(1 - spacing),
        default.units = "native",
        gp = gpar(fill = hl))
}

panel.lines <- function(value, spacing, hl) {
    grid.lines(x = c(1:length(value)), y = value*(1-spacing), 
        default.units = "native")
}
