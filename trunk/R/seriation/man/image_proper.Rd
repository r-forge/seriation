\name{image_proper}
\alias{image_proper}
\alias{image_proper.matrix}
\alias{image_proper.dist}
\title{Proper matrix image plots}
\description{
  Provides methods for plotting proper image plots for 
  objects of class \code{matrix} and \code{dist}.
}
\usage{
image_proper(x, xlab = "", ylab = "", col=rev(gray.colors(64)), ...)
\method{image_proper}{matrix}(x, xlab = "", ylab = "", col=rev(gray.colors(64)), ...)

\method{image_proper}{dist}(x, xlab = "", ylab = "", col=rev(gray.colors(64)), ...)
}
\arguments{
  \item{x}{an object of class \code{matrix} or \code{dist}.}
  \item{xlab, ylab}{labels for the x and y axis.}
  \item{col}{a list of colors used.}
  \item{\dots}{further arguments to \code{image}.}
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
image_proper(x)
image_proper(x, col=c("white","black"))
axis(1)				# the columns
axis(2, at=c(1,3,5,7,9), labels=c(9,7,3,5,1))	# the reversed rows
}
\keyword{hplot}
