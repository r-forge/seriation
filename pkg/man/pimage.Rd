\name{pimage}
\alias{pimage}
\alias{pimage.matrix}
\alias{pimage.dist}
\title{Permutation image plot}
\description{
  Provides methods for plotting image plots for 
  matrix and \code{dist} objects given a permutation.
}
\usage{
pimage(x, order = NULL, col = NULL, main ="", xlab = "", ylab = "", 
    axes = TRUE, range=NULL, colorkey=FALSE, ..., newpage=TRUE, pop=TRUE)

\method{pimage}{matrix}(x, order=NULL, col=NULL, main="", xlab="", ylab="",
    axes=TRUE, range=NULL, colorkey=FALSE, ..., newpage=TRUE, pop=TRUE)
\method{pimage}{dist}(x, order = NULL, col = NULL, main="", xlab="", ylab="",
    axes = TRUE, range=NULL, colorkey=FALSE, 
    upper.tri = TRUE, lower.tri = TRUE, ..., newpage=TRUE, pop=TRUE)
}
\arguments{
  \item{x}{a matrix or an object of class \code{dist}.}
  \item{order}{an object of class \code{ser_permutation}. If \code{NULL} the order 
      in \code{x} is plotted.}
  \item{col}{a list of colors used. If \code{NULL}, a gray scale is used (for
      matrix larger values are displayed darker and for \code{dist} smaller
      distances are darker). For matrices containing logical data, black and
      white is used. }
  \item{main}{Plot title.}
  \item{xlab, ylab}{labels for the x and y axes.}
  \item{axes}{ a logical indicating whether to add axes using the
      labels of \code{x}. The default value (\code{TRUE}) shows only axes
      if the dimension is below 10 (so it is reasonable to show labels).}
  \item{range}{ vector with two elements giving the range (min, max) for 
      representing the values in the matrix. }
  \item{colorkey}{ logical; add a colorkey?}
  \item{upper.tri, lower.tri}{ a logical indicating whether to show the
      upper or lower triangle of the distance matrix. }
  \item{\dots}{further arguments passed on to \code{image} in \pkg{graphics}.}
  \item{newpage, pop}{two logical. Start plot on a new page and pop the viewports after plotting (see Grid).}
}
\details{
  Plots a matrix in its original row and column orientation. This means, in a
  plot the columns become the x-coordinates and the reversed rows the
  y-coordinates.

  If \code{x} is of class \code{dist} it is converted to full-storage
  representation before plotting.
}
\author{Christian Buchta and Michael Hahsler}
%\seealso{}
\examples{
x <- matrix(sample(c(FALSE, TRUE), 150, rep=TRUE), ncol=10)

## matrix
pimage(x, main = "random data")

## plot seriated matrix
pimage(x, seriate(x), col = c("white", "green"), main = "reordered data")

## distances
d <- dist(x, method = "binary")
pimage(d, upper.tri = FALSE, main = "Distances", colorkey = TRUE)

pimage(d, seriate(d), upper.tri = FALSE, main = "Distances", colorkey = TRUE)
}
\keyword{hplot}
