\name{arrange}
\alias{arrange}
\alias{arrange.dist}
\alias{arrange.matrix}
\title{Arrange the observations in a dist object or matrix}
\description{
A convenience method for rearranging and subsetting the observations in a
\code{dist} object or a matrix. 
}
\usage{
arrange(x, order)
}
\arguments{
  \item{x}{an object of class \code{dist} or a matrix.} 
  \item{order}{an object of class \code{Order} which is suitable for
      arrangeing \code{x}.}
}
\details{
An order is suitable to arrange an object of class \code{dist} 
or an symmetric matrix, if it is of class \code{Order\_symmetric}.

An order of class \code{Order\_asymmetric} can only be used to arrange
a matrix.
}
%\author{Michael Hahsler}
\seealso{
\code{\link{Order}},
\code{\link{dist}} in package \pkg{stats}.
  }
\examples{
m <- matrix(rnorm(10), 5, 2)
m

arrange(m, Order(row = 5:1, col = 2:1))

d <- dist(m)
d

arrange(d, Order(c(3,2,1)))
}
\keyword{manip}
