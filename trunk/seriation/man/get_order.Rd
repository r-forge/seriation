\name{get_order}
\alias{get_order}
\alias{get_order.integer}
\alias{get_order.hclust}
\alias{get_order.ser_permutation}
\alias{get_order.ser_permutations}
\title{Getting an integer permutation vector from a permutation(s) object}
\description{
Method to get an integer permutation vector from an object of class
\code{ser_permutations} or \code{ser_permutation}.
}
\usage{
get_order(x, \ldots)

\method{get_order}{ser_permutation}(x)
\method{get_order}{ser_permutations}(x, dim = 1)
}
\arguments{
  \item{x}{ an object of class \code{ser_permutations} or 
      \code{ser_permutation}}
  \item{dim}{ which dimension should be returned?}
  \item{\ldots}{further arguments.}
    }
%\details{
%}
\value{
Returns an integer vector.
}
%\references{}
%\author{}
\seealso{
\code{\link{ser_permutation}},
\code{\link{ser_permutations}}
}
\examples{
## permutation
o <- permutation(1:10)
o

get_order(o)

## permutations
o2 <- permutations(o, 5:1)
o2

get_order(o2, 2)
}
\keyword{manip}% at least one, from doc/KEYWORDS
