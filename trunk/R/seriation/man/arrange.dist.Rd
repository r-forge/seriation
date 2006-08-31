\name{arrange}
\alias{arrange}
\alias{arrange.dist}
\title{Arrange the observations in a dist object}
\description{
Provides a method for rearranging and subsetting 
the observations in a \code{dist} object. This is just a convenience 
method for \code{dist} object.
}
\usage{
arrange(x, order)
}
\arguments{
  \item{x}{an object of class \code{dist}.} 
  \item{order}{integer vector containing the indices of the selected object in
      the desired order.}
}
%\details{
%}
%\author{Michael Hahsler}
\seealso{
\code{\link{dist}} in package \pkg{stats}.
  }
\examples{
d <- dist(matrix(rnorm(10), 5, 2))
d

arrange(d, c(3,2,1))
}
\keyword{manip}
