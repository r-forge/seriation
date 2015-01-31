#######################################################################
# seriation - Infrastructure for seriation
# Copyrigth (C) 2011 Michael Hahsler, Christian Buchta and Kurt Hornik
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

hmap <- function(x, distfun = dist, method = "OLO", control = NULL, ...) {
  
  ## dist or matrix 
  if(is(x, "dist")) {
    dist_row <- dist_col <- x
    x <- as.matrix(x)
  } else {
    if(!is.matrix(x)) x <- as.matrix(x)
    
    dist_row <- distfun(x)
    dist_col <- distfun(t(x))
  }
  
  o_col <- seriate(dist_col, 
    method = method, control = control)[[1]]
  
  o_row <- seriate(dist_row, 
    method = method, control = control)[[1]]
  
  ### is hierarchical? then let's do heatmap in stats
  if(is(o_col, "hclust")) {
    ## heatmap by default scales rows: we don't want that!
    ## options are ignored for now: we use ... 
    
    args <- list(...)
    if(is.null(args$col)) args$col <- gray.colors(256)
    if(is.null(args$scale)) args$scale <- "none"
    args <- c(list( 
      x=x, 
      Colv = as.dendrogram(o_col), 
      Rowv = as.dendrogram(o_row)), 
      args
    )
    ret <- do.call(heatmap, args)
    
    ret$seriation_method <- method
    return(invisible(ret))
  } else {
    ### we plot seriated distance matrices
    .hmap_dist(x, method, dist_row, dist_col, o_row, o_col, ...)    
  }
  
}

## workhorse

## dissimilarity plot with seriation
.hmap_dist <- function(x, method, dist_row, dist_col, o_row, o_col, ...) {
  
  ## options
  options <- list(...)
  col     <- if(is.null(options$col)) gray.colors(256) else options$col
  prop    <- if(is.null(options$prop)) FALSE else options$prop
  newpage <- if(is.null(options$newpage)) TRUE else options$newpage
  gp      <- if(is.null(options$gp)) gpar() else options$gp
  main    <- options$main
  dist    <- if(is.null(options$showdist)) TRUE else options$showdist
  
  x <- permute(x, ser_permutation(o_row, o_col))
  dist_row <- permute(dist_row, o_row)
  dist_col <- permute(dist_col, o_col)
  
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
  if(dist) {
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
  }
  
  # data
  if(dist) { 
    pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 3))
  } else {
    pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 2))
  }
    
  .grid_image(x, col = col, gp = gp)
  popViewport(1)
  
  if(dist){
    # rows
    pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 1))
    
    .grid_image(as.matrix(dist_row), col = col, gp = gp)
    popViewport(1)
    
    # cols
    pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 3))
    
    .grid_image(as.matrix(dist_col), col = col, gp = gp)
    popViewport(2)
  }
  
  # colorkey
  pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 2))
  pushViewport(viewport(width = unit(0.75, "npc")))
  .grid_colorkey(range(x, na.rm = TRUE), col = col, gp = gp) 
  popViewport(2)
  
  popViewport(1)
  
  ## return permutation indices
  invisible(list(rowInd = o_row, colInd = o_col, 
    seriation_method = method))
}
