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
  \item{col}{a list of colors used. If missing, a gray scale is used (for
      matrix larger values are displayed darker and for \code{dist} smaller
      distances are darker). }
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
x <- matrix(sample(c(FALSE, TRUE), 150, rep=TRUE), ncol=10)

pimage(x, col=c("white","black"))
axis(1, at = 1:ncol(x))				        # columns
axis(2, at = 1:nrow(x), labels= nrow(x):1)  # reversed rows
}
\keyword{hplot}
