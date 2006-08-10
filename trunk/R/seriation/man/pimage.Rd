\name{pimage}
\alias{pimage}
\alias{pimage.matrix}
\alias{pimage.dist}
\title{Proper matrix image plots}
\description{
  Provides methods for plotting proper image plots for 
  objects of class \code{matrix} and \code{dist}.
}
\usage{
pimage(x, col, xlab = "", ylab = "", ...)
\method{pimage}{matrix}(x, col, xlab = "", ylab = "", ...)

\method{pimage}{dist}(x, col, xlab = "", ylab = "", ...)
}
\arguments{
  \item{x}{an object of class \code{matrix} or \code{dist}.}
  \item{col}{a list of colors used (if missing, a gray scale is used.}
  \item{xlab, ylab}{labels for the x and y axis.}
  \item{\dots}{further arguments passed on to \code{image} in \pkg{graphics}.}
}
\details{
  Plots an object of class \code{matrix} in its original row and column
  orientation. This means, in a plot the columns become the x-coordinates 
  and the reversed rows the y-coordinates.

  If \code{x} is of class \code{dist} it is converted to full-storage
  representation and dispatched to the matrix method.
}
\author{Christian Buchta}
\seealso{
  \code{\link{image}} for details.}
\examples{
x <- matrix(sample(c(FALSE, TRUE),100,rep=TRUE),ncol=10)
pimage(x)
pimage(x, col=c("white","black"))
axis(1)				# the columns
axis(2, at=c(1,3,5,7,9), labels=c(9,7,3,5,1))	# the reversed rows
}
\keyword{hplot}
