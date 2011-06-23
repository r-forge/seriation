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


## large values are dark
pimage.matrix <- 
function(x, order = NULL, col = NULL, xlab="", ylab="", axes = NULL, ...) {
    if(is.null(col)) {
        if(is.logical(x)) col <- c("white","black")
        else col <- rev(gray.colors(64))    
    }
    
    if(!is.null(order)) x <- permute(x, order)

    image.default(1:dim(x)[2], 1:dim(x)[1], t(x)[,dim(x)[1]:1], axes=FALSE,
        xlab=xlab, ylab=ylab, col=col, ...)
     


    ## add axes
    if(is.null(axes)) axes <- 32
    else if(axes) axes <- Inf
    else axes <- 0
    
    if(axes > 0) {
        if(dim(x)[1] < axes)
            axis(2, at = 1:dim(x)[1], labels = rev(labels(x)[[1]]))
        if(dim(x)[2] < axes)
            axis(1, at = 1:dim(x)[2], labels = labels(x)[[2]])
    }
}

## small values are dark
pimage.dist <- 
function(x, order = NULL, col = NULL, xlab="", ylab="", axes = NULL, 
    upper.tri = TRUE, lower.tri = TRUE, ...) { 
    if(is.null(col)) col <- gray.colors(64)    
    
    if(!is.null(order)) x <- permute(x, order)
    
    dim <- attr(x, "Size")
    labels <- labels(x)
    x <- as.matrix(x)

    if(!upper.tri) x[upper.tri(x)] <- NA
    if(!lower.tri) x[lower.tri(x)] <- NA

    pimage.matrix(x, xlab=xlab, ylab=ylab, col=col, axes = FALSE, ...)

    ## add axes
    if(is.null(axes)) axes <- 32
    else if(axes) axes <- Inf
    else axes <- 0

    ## show labels top and right if lower.tri is FALSE
    if(!lower.tri) loc <- c(4,3)
    else loc <- c(2,1)
    
    if(dim < axes){
        axis(loc[1], at = 1:dim, labels = rev(labels))
        axis(loc[2], at = 1:dim, labels = labels)
    }

}

pimage <-
function(x, order = NULL, col = NULL, 
         xlab="", ylab="", axes = NULL, ...) 
    UseMethod("pimage")

pimage.default <- pimage.matrix

