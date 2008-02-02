## grid helpers

.grid_image <- function(x, y, z, zlim, col = gray.colors(12, 1, 0), 
    name = "image", gp = gpar()) {

    if(is.matrix(x)){ 
        z <- x
        x <- 1:ncol(z)
        y <- 1:nrow(z)
    }
    
    if(missing(zlim)) zlim <- range(z, na.rm = TRUE)
    else {# fix data for limits
        z[z < zlim[1]] <- NA
        z[z > zlim[2]] <- NA
    }
        
    offset <- if(zlim[1] < 0) -zlim[1] else 0
    range <- diff(zlim) 
    
    div <- 1/length(col)

    ## create a viewport
    vp <- viewport(
        xscale = c(0,(length(x)+1)), yscale = c((length(y)+1),0),
        default.units = "native", name = name)
    pushViewport(vp)

    ## make sure we have a color for the maximal value (see floor +1)
    col[length(col)+1] <- col[length(col)]

    ## the highest value is lightest color!
    xs <- sapply(x, "rep.int", times = length(y))
    grid.rect(x = xs, y = y, 1, 1, 
        gp = gpar(fill = col[floor((z + offset)/range/div)+1], col=0), 
        default.units = "native")

    ## make border
    gp_border       <- gp
    gp_border$fill  <- "transparent"
    grid.rect(x = (length(x)+1)/2, y = (length(y)+1)/2, 
        width = length(x), height = length(y), 
        default.units = "native", gp = gp_border)

    upViewport(1)
}



.grid_barplot_horiz <- function(height, name = "barplot", xlab="", 
    gp = gpar()) {

    n <-  length(height)

    ## these plots always start at x = 0 or below!
    lim <- c(min(c(height, 0)), max(height))

    ## create a viewport
    vp <- viewport(
        xscale = lim , yscale = c((n+1),0), default.units = "native", name = name)
    pushViewport(vp)

    ## make bars
    gp_bars     <- gp
    gp_bars$col <- 0
    if(is.null(gp_bars$fill) || gp_bars$fill == "transparent") 
    gp_bars$fill <- "lightgray"
    
    grid.rect(x = 0, y = 1:n, width = height, height = 1,
        just = c("left", "center"), default.units = "native",
        gp = gp_bars)

    ## hopefuly there is space outside for axes
    grid.xaxis(gp = gp)
    grid.text(xlab, y = unit(-3, "lines"), gp = gp)

    upViewport(1)
}

.grid_colorkey <- function(range, col, threshold = NULL, 
    name = "colorkey", gp = gpar()) {

    vp <- viewport(
        xscale = range, yscale = c(0,1), 
        default.units = "native", name = name)
    pushViewport(vp)

    n <- length(col) 
    width <- diff(range)/n
    xs <- seq(range[1] + width/2, range[2] - width/2, length.out = n)

    ## do not display the part above the threshold 
    col[xs > threshold] <- NA

    ## col
    gp_col      <- gp
    gp_col$col  <- 0
    gp_col$fill <- col
    grid.rect(x = xs, y = 0, width = width, height = 1,
        just = c("centre", "bottom"), default.units = "native",
        gp = gp_col)


    ## box
    gp_border       <- gp
    gp_border$fill  <- "transparent"
    grid.rect(x = 0, y = 0, width = 1, height = 1,
        just = c("left", "bottom"), default.units = "npc",
        gp = gp_border)

    grid.xaxis(gp = gp)

    upViewport(1)
}
