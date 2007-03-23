\name{rearrange}
\alias{rearrange}
\alias{rearrange.dist}
\alias{rearrange.matrix}
\title{Rearrange a dist object or a matrix}
\description{
A convenience method for rearranging (including subsetting) 
the observations in a \code{dist} object or the rows and
columns of a matrix. 
}
\usage{
rearrange(x, order)
}
\arguments{
  \item{x}{an object of class \code{dist} or a matrix.} 
  \item{order}{an object of class \code{Order} 
      which is suitable for rearrangeing \code{x}.}
}
\details{
An order is suitable to rearrange an object of class \code{dist} 
or an symmetric matrix, if it is of class \code{Order\_vector}.

An order of class \code{Order\_matrix} can only be used to 
rearrange a matrix.
}
%\author{Michael Hahsler}
\seealso{
\code{\link{Order}},
\code{\link{dist}} in package \pkg{stats}.
  }
\examples{
m <- matrix(rnorm(10), 5, 2)
m

rearrange(m, Order(row = 5:1, col = 2:1))

d <- dist(m)
d

rearrange(d, Order(c(3,2,1)))
}
\keyword{manip}
