## grid helpers

.grid_image <- function(x, name = "image", 
    col = gray.colors(12, 0, 1), threshold = NULL, gp = gpar()) {

    n <-  ncol(x)
    m <-  nrow(x)
    max_x <- max(x)

    if(!is.null(threshold)) x[x>threshold] <- NA

    div <- 1/length(col)

    ## create a viewport
    vp <- viewport(
        xscale = c(0,(n+1)), yscale = c((m+1),0),
        default.unit="native", name = name)
    pushViewport(vp)

    ## make sure we have a color for the maximal value (see floor +1)
    col[length(col)+1] <- col[length(col)]

    ## the highest value is lightest color!
    xs <- sapply(c(1:m), "rep.int", times = n)
    grid.rect(x = xs, y = c(1:n), 1, 1, 
        gp = gpar(fill = col[floor(x/max_x/div)+1], col=0), 
        default.units = "native")

    ## make border
    gp_border       <- gp
    gp_border$fill  <- "transparent"
    grid.rect(x = (n+1)/2, y = (m+1)/2, width = n, height = m, 
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
        xscale = lim , yscale = c((n+1),0), default.unit="native", name = name)
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

.grid_colorkey <- function(min_x, max_x, col, threshold = NULL, 
    name = "colorkey", gp = gpar()) {

    vp <- viewport(
        xscale = c(min_x, max_x), yscale = c(0,1), 
        default.unit="native", name = name)
    pushViewport(vp)

    range <- max_x - min_x
    n <- length(col) 
    width <- range/(n)
    xs <- seq(min_x + width/2, max_x - width/2, length.out = n)

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
