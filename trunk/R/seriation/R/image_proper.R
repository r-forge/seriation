# image method that makes a proper image plot of a matrix.
# the rows and columns are swapped and the order of the
# columns (original rows) is reversed.


    
image_proper.matrix <- 
  function(x, xlab="", ylab="", col=rev(gray.colors(64)), ...)
  image.default(1:dim(x)[2], 1:dim(x)[1], t(x)[,dim(x)[1]:1], axes=FALSE,
  xlab=xlab, ylab=ylab, col=col, ...)

image_proper.dist <- 
    function(x, xlab="", ylab="", col=rev(gray.colors(64)), ...) 
    image_proper.matrix(as.matrix(x), xlab=xlab, ylab=ylab, col=col, ...)
			  
image_proper <- function(x, xlab="", ylab="", 
  col=rev(gray.colors(64)), ...) UseMethod("image_proper")
foo.default <- image_proper.matrix

