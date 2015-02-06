\name{get_order}
\alias{get_order}
\alias{get_order.integer}
\alias{get_order.hclust}
\alias{get_order.ser_permutation_vector}
\alias{get_order.ser_permutation}
\alias{get_rank}
\title{Getting an Integer Permutation Vector from a Permutation Object}
\description{
Method to get an integer permutation vector from an object of class
\code{ser_permutation} or \code{ser_permutation_vector}.
}
\usage{
get_order(x, \ldots)
\method{get_order}{ser_permutation_vector}(x, \ldots)
\method{get_order}{ser_permutation}(x, dim = 1, \ldots)

get_rank(x, \ldots)
}
\arguments{
  \item{x}{ an object of class \code{ser_permutation} or 
      \code{ser_permutation_vector}.}
  \item{dim}{ which dimension should be returned?}
  \item{\ldots}{further arguments (unused).}
    }
\details{
\code{get_order} returns the seriation order as a permutation vector
(index of 1st object, 2nd object, ... \eqn{n}th object).
\code{get_rank} returns the seriation as a vector indicating the 
rank of the objects \eqn{1, 2, \dots, n}.
}
\value{
Returns an integer vector.
}
\seealso{
\code{\link{ser_permutation_vector}},
\code{\link{ser_permutation}}
}
\author{Michael Hahsler}
\examples{
## permutation_vector
o <- ser_permutation_vector(sample(10))
o

get_order(o)
get_rank(o)

## permutation
o2 <- ser_permutation(o, sample(5))
o2

get_order(o2, 2)
get_rank(o2, 2)
}
\keyword{manip}% at least one, from doc/KEYWORDS
