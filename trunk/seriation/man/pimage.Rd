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
pimage(x, order = NULL, col = NULL, xlab = "", ylab = "", axes = NULL, ...)

\method{pimage}{matrix}(x, order = NULL, col = NULL, 
        xlab = "", ylab = "", axes = NULL, ...)
\method{pimage}{dist}(x, order = NULL, col = NULL, 
        xlab = "", ylab = "", axes = NULL,
       upper.tri = TRUE, lower.tri = TRUE, ...)
}
\arguments{
  \item{x}{a matrix or an object of class \code{dist}.}
  \item{order}{an object of class \code{ser_permutation}. If \code{NULL} the order 
      in \code{x} is plotted.}
  \item{col}{a list of colors used. If \code{NULL}, a gray scale is used (for
      matrix larger values are displayed darker and for \code{dist} smaller
      distances are darker). For matrices containing logical data, black and
      white is used. }
  \item{xlab, ylab}{labels for the x and y axes.}
  \item{axes}{ a logical indicating whether to add axes using the
      labels of \code{x}. The default value (\code{NULL}) shows only axes
      if the dimension is below 32 (so it is reasonable to show labels).}
  \item{upper.tri, lower.tri}{ a logical indicating whether to show the
      upper or lower triangle of the distance matrix. }
  \item{\dots}{further arguments passed on to \code{image} in \pkg{graphics}.}
}
\details{
  Plots a matrix in its original row and column orientation. This means, in a
  plot the columns become the x-coordinates and the reversed rows the
  y-coordinates.

  If \code{x} is of class \code{dist} it is converted to full-storage
  representation before plotting.
}
\author{Christian Buchta and Michael Hahsler}
\seealso{
  \code{\link{image}} for details.}
\examples{
x <- matrix(sample(c(FALSE, TRUE), 150, rep=TRUE), ncol=10)

## matrix
pimage(x, main = "random data")

## plot seriated matrix and axis separately
pimage(x, seriate(x), col = c("white", "green"), axes = FALSE,
    main = "reordered data")
axis(1, at = 1:ncol(x))                         # columns
axis(2, at = 1:nrow(x), labels= rev(1:nrow(x))) # reversed rows

## distances
d <- dist(x, method = "binary")
pimage(d, lower.tri = FALSE)

pimage(d, seriate(d), lower.tri = FALSE)
}
\keyword{hplot}
