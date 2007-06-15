\name{permute}
\alias{permute}
\alias{permute.dist}
\alias{permute.numeric}
\alias{permute.list}
\alias{permute.matrix}
\alias{permute.array}
\title{Permute a dist object, a matrix, an array, a list, or a numeric vector}
\description{
A convenience method for permuting 
%and/or subsetting 
various classes including 
the observations in a
\code{dist} object, the rows and columns of a matrix,
and all dimensions of an array-
}
\usage{
permute(x, order)
}
\arguments{
  \item{x}{an object (a list, a numeric vector, a \code{dist} object, a matrix
      or an array).} 
  \item{order}{an object of class \code{ser_permutations}
      which contains suitable permutation vectors for \code{x}.}
}
\details{
The permutation vectors in \code{ser_permutations} 
are suitable if the number of permutation vectors matches the number
of dimensions of \code{x} and if the length of each permutation vector
has the same length as the corresponding dimension of \code{x}.

For 1-dimensional/1-mode data (list, vector, \code{dist}), 
\code{order} can also be a single 
permutation vector of class \code{ser_permutation} or data which can be 
automatically coerced to this class
(e.g. a numeric vector).
}
%\author{Michael Hahsler}
\seealso{
\code{\link{permutations}},
\code{\link{dist}} in package \pkg{stats}.
  }
\examples{
m <- matrix(rnorm(10), 5, 2)
m

permute(m, permutations(5:1, 2:1))

d <- dist(m)
d

permute(d, permutations(c(3,2,1,4,5)))

## this also works for 1-mode data:
# permute(d, permutation(c(3,2,1,4,5)))
# permute(d, c(3,2,1,4,5))
}
\keyword{manip}
