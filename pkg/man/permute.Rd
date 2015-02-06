\name{permute}
\alias{permute}
\alias{permute.dist}
\alias{permute.numeric}
\alias{permute.list}
\alias{permute.matrix}
\alias{permute.array}
\alias{permute.data.frame}
\title{Permute a dist Object, a Matrix, an Array, a List, or a Vector}
\description{
A method for permuting 
various classes including 
the observations in a
\code{dist} object, the rows and columns of a matrix,
and all dimensions of an array given a suitable \code{ser_permutation}
object.
}
\usage{
permute(x, order)
}
\arguments{
  \item{x}{an object (a list, a vector, a \code{dist} object, a matrix,
      an array or any other object which provides \code{dim} and standard 
      subsetting with \code{"["}).} 
  \item{order}{an object of class \code{ser_permutation}
      which contains suitable permutation vectors for \code{x}.}
}
\details{
The permutation vectors in \code{ser_permutation} 
are suitable if the number of permutation vectors matches the number
of dimensions of \code{x} and if the length of each permutation vector
has the same length as the corresponding dimension of \code{x}.

For 1-dimensional/1-mode data (list, vector, \code{dist}), 
\code{order} can also be a single 
permutation vector of class \code{ser_permutation_vector} or data which can be 
automatically coerced to this class
(e.g. a numeric vector).
}
\seealso{
\code{\link{ser_permutation}},
\code{\link{dist}} in package \pkg{stats}.
  }
\author{Michael Hahsler}
\examples{
## permute matrix
m <- matrix(rnorm(10), 5, 2, dimnames = list(1:5, 1:2))
m

## permute rows and columns
permute(m, ser_permutation(5:1, 2:1))
## permute only columns
permute(m, ser_permutation(NA, 2:1))
  
## permute dist
d <- dist(m)
d

permute(d, ser_permutation(c(3,2,1,4,5)))

## permute list
l <- list(a=1:5, b=letters[1:3], c=0)
l
  
permute(l, c(2,3,1))    
}
\keyword{manip}
