\name{arrange}
\alias{arrange}
\alias{arrange.dist}
\title{Arrange the observations in a dist object}
\description{
Provides methods for arranging the observations in a \code{dist} object
given a specified order.
}
\usage{
arrange(x, order)
\method{arrange}{dist}(x, order)
}
\arguments{
  \item{x}{an object of class \code{dist}.}
  \item{order}{integer vector containing the new order.}
}
%\details{
%}
%\author{Michael Hahsler}
\seealso{
\code{\link{dist}} in package \pkg{stats}.
  }
\examples{
d <- dist(matrix(rnorm(6), 3, 2))
d

arrange(d, c(3,2,1))
}
\keyword{manip}
