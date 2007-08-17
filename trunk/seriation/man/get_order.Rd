\name{get_order}
\alias{get_order}
\alias{get_order.integer}
\alias{get_order.hclust}
\alias{get_order.ser_permutation_vector}
\alias{get_order.ser_permutation}
\title{Getting an integer permutation vector from a permutation object}
\description{
Method to get an integer permutation vector from an object of class
\code{ser_permutation} or \code{ser_permutation_vector}.
}
\usage{
get_order(x, \ldots)

\method{get_order}{ser_permutation_vector}(x, \ldots)
\method{get_order}{ser_permutation}(x, dim = 1, \ldots)
}
\arguments{
  \item{x}{ an object of class \code{ser_permutation} or 
      \code{ser_permutation_vector}}
  \item{dim}{ which dimension should be returned?}
  \item{\ldots}{further arguments (unused).}
    }
%\details{
%}
\value{
Returns an integer vector.
}
%\references{}
%\author{}
\seealso{
\code{\link{ser_permutation_vector}},
\code{\link{ser_permutation}}
}
\examples{
## permutation_vector
o <- ser_permutation_vector(1:10)
o

get_order(o)

## permutation
o2 <- ser_permutation(o, 5:1)
o2

get_order(o2, 2)
}
\keyword{manip}% at least one, from doc/KEYWORDS
