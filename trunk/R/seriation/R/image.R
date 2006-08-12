# image method that makes a proper image plot of a matrix.
# the rows and columns are swapped and the order of the
# columns (original rows) is reversed.


pimage.matrix <- 
function(x, col, xlab="", ylab="", ...) {
    if(missing(col)) col <- rev(gray.colors(64))    
    image.default(1:dim(x)[2], 1:dim(x)[1], t(x)[,dim(x)[1]:1], axes=FALSE,
        xlab=xlab, ylab=ylab, col=col, ...)
}

pimage.dist <- 
function(x, col, xlab="", ylab="", ...) 
pimage.matrix(as.matrix(x), xlab=xlab, ylab=ylab, col=col, ...)

pimage <- function(x, col, xlab="", ylab="", ...) UseMethod("pimage")
pimage.default <- pimage.matrix

