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

## image method that makes a proper image plot of a matrix.
## the rows and columns are swapped and the order of the
## columns (original rows) is reversed.


pimage.matrix <- function(x, order=NULL, col=NULL, main="", xlab="", ylab="", 
	axes=TRUE, range=NULL, colorkey=FALSE, ..., newpage=TRUE, pop=TRUE) {
    
    if(is.null(col)) {
        if(is.logical(x)) col <- c("white","black")
        else col <- rev(gray.colors(64))    
    }
    
    if(!is.null(order)) x <- permute(x, order)
     
    if(is.null(range)) range <- range(x, na.rm=TRUE)

    if(newpage) grid.newpage()
    
    
    if(colorkey) {
	.grid_basic_layout_with_colorkey(main=main)
	downViewport("colorkey")
	.grid_colorkey(range, col=col, horizontal=FALSE) 
	upViewport(1)

    } else .grid_basic_layout(main=main)
    
    downViewport("plot")
    .grid_image(x, col=col, zlim=range)
    
    ## axes and labs
    downViewport("image")
    if(axes && ncol(x)<10 && !is.null(colnames(x))) grid.text(colnames(x), y = unit(-1, "lines"), x=unit(1:ncol(x), "native"))
    #grid.xaxis(at=1:ncol(x), 
    #	    label=colnames(x))
    if(axes && nrow(x)<10 && !is.null(rownames(x))) grid.text(rownames(x), x = unit(-1, "lines"), y=unit(1:nrow(x), "native"), rot=90)
	#grid.yaxis(at=1:nrow(x), 
	#    label=rownames(x))

    if(xlab!="") grid.text(xlab, y = unit(-3, "lines"))
    if(ylab!="") grid.text(ylab, x = unit(-3, "lines"), rot=90)


    if(pop) popViewport(3) else upViewport(3)
}

## small values are dark
pimage.dist <- 
function(x, order=NULL, col=NULL, main="", xlab="", ylab="", 
	axes=TRUE, range=NULL, colorkey=FALSE, 
	upper.tri=TRUE, lower.tri=TRUE, ..., 
	newpage=TRUE, pop=TRUE) { 
    
    if(is.null(col)) col <- gray.colors(64)    
    
    if(!is.null(order)) x <- permute(x, order)
    
    #dim <- attr(x, "Size")
    labels <- labels(x)
    x <- as.matrix(x)

    if(!upper.tri) x[upper.tri(x)] <- NA
    if(!lower.tri) x[lower.tri(x)] <- NA

    pimage.matrix(x, main=main, xlab=xlab, ylab=ylab, col=col, axes = axes,
	    range=range, colorkey=colorkey, ...,
	    newpage=newpage, pop=pop)

}


pimage <-
function(x, order=NULL, col=NULL, main="", xlab="", ylab="",
	        axes=TRUE, range=NULL, colorkey=FALSE,... , 
		newpage=TRUE, pop=TRUE)
    UseMethod("pimage")

pimage.default <- pimage.matrix

