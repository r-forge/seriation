hmap <- function(x, distfun = dist, hclustfun = hclust, 
    method = NULL, control = NULL, options = NULL, ...) {
    
    if(!is.matrix(x)) x <- as.matrix(x)

    dist_row <- distfun(x)
    dist_col <- distfun(t(x))

    hmap_workhorse <- if(is.function(hclustfun)) .hmap_opt else .hmap_dist
    
    hmap_workhorse(x, dist_row, dist_col, hclustfun, 
        method, control, options, ...)
}

## workhorses
    
## heatmap with optimal seriateed dendrogram
.hmap_opt <- function(x, dist_row, dist_col, hclustfun = hclust,
    method = NULL, control = NULL, options = NULL, ...){ 
   
    col     <- if(is.null(options$col)) gray.colors(256) else options$col
    main    <- options$main

    if(is.null(method)) method <- "OLO"
   
    control$hclust <- hclustfun(dist_col)
    dend_col <- as.dendrogram(
            seriate(dist_col, 
            method = method, control = control)[[1]])
    
    control$hclust <- hclustfun(dist_row)
    dend_row <- as.dendrogram(
            seriate(dist_row, 
            method = method, control = control)[[1]])

    ## heatmap by default scales rows: we don't want that!
    ## options are ignored for now: we use ... 
    ret <- heatmap(x, Colv = dend_col, Rowv = dend_row, 
        scale = "none", col = col, main = main, ...)
    ret$seriation_method <- method
    invisible(ret)
}


## dissimilarity plot with seriation
.hmap_dist <- function(x, dist_row, dist_col, hclustfun, 
    method = NULL, control = NULL, options = NULL, ...) {
    
    ## options
    options <- c(options, list(...))
    
    col     <- if(is.null(options$col)) gray.colors(256) else options$col
    prop    <- if(is.null(options$prop)) FALSE else options$prop
    newpage <- if(is.null(options$newpage)) TRUE else options$newpage
    gp      <- if(is.null(options$gp)) gpar() else options$gp
    main    <- options$main
    
    ## determine order
    if(is.null(method)) {
        method  <- "TSP"
        if(is.null(control)) control <- list(method = "farthest_insertion")  
    }
    
    ## seriate
    row_order <- NULL
    col_order <- NULL
    if(!is.na(method)) {
        row_order <- seriate(dist_row, method = method, 
            control = control)
        col_order <- seriate(dist_col, method = method, 
            control = control)

        x <- permute(x, c(row_order, col_order))
        dist_row <- permute(dist_row, row_order)
        dist_col <- permute(dist_col, col_order)
    }
    
   
    ## plot
    if(newpage) grid.newpage()

    ## surrounding viewport
    pushViewport(viewport(layout=grid.layout(nrow = 5 , ncol = 3, 
                widths = unit.c(
                 unit(2, "lines"),
                 unit(1, "snpc") - unit(8, "lines"),
                 unit(2, "lines")
                ), 
                heights = unit.c(
                 unit(3, "lines"),  # main
                 unit(1, "snpc") - unit(8, "lines"),
                 unit(1, "lines"),
                 unit(1, "lines"),  # colkey
                 unit(3, "lines")
                )), width = unit(1, "snpc"), height = unit(1, "snpc"),))


    ## main title
    if(!is.null(main)){
        pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 2))
        grid.text(main, gp = gpar(cex = 1.3))
        upViewport(1)
    }
    
    
    ## plots
    if(prop) {
        widths <- unit.c(
            unit(1-ncol(x)/sum(ncol(x), nrow(x)), "npc") - unit(.25, "lines"),
            unit(.5, "lines"),
            unit(ncol(x)/sum(ncol(x), nrow(x)), "npc") - unit(.25, "lines")
        )

        heights <- unit.c(
            unit(1-nrow(x)/sum(ncol(x), nrow(x)), "npc") - unit(.25, "lines"),
            unit(.5, "lines"),   #space
            unit(nrow(x)/sum(ncol(x), nrow(x)), "npc") - unit(.25, "lines")
        )
    }else{
        heights <- widths <- unit.c(
            unit(1, "null"), 
            unit(.5, "lines"),   # space
            unit(1, "null")
        )
    }
    
    pushViewport(viewport(layout=grid.layout(nrow = 3, ncol = 3, 
            widths = widths, heights = heights), 
            width = unit(1, "snpc"), height = unit(1, "snpc"), 
            layout.pos.row = 2, layout.pos.col = 2))

    # data
    pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 3))

    .grid_image(x, col = col, gp = gp)
    popViewport(1)

    # rows
    pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 1))

    .grid_image(as.matrix(dist_row), col = col, gp = gp)
    popViewport(1)

    # cols
    pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 3))

    .grid_image(as.matrix(dist_col), col = col, gp = gp)
    popViewport(2)
    
    # colorkey
    pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 2))
    pushViewport(viewport(width = unit(0.75, "npc")))
    .grid_colorkey(range(x, na.rm = TRUE), col = col, gp = gp) 
    popViewport(2)
    
    popViewport(1)

    ## return permutation indices
    invisible(list(rowInd = row_order, colInd = col_order, 
            seriation_method = method))
}
