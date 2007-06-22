\name{ser_permutation}
\alias{ser_permutation}
\alias{permutation}
\alias{print.ser_permutation}
\alias{get_method}
\alias{length.ser_permutation}
\title{Class ser\_permutation -- 
A single permutation vector for seriation}
\description{
The class \code{ser_permutation} 
represents a single permutation vector. 
}
\usage{
## constructor
permutation(x, method = NULL)
}
\arguments{
  \item{x}{ an object which contains a permutation vector (currently an
      integer vector or an object of class \code{hclust})}
  \item{method}{ a string representing the method used to obtain the
      permutation vector}
    }
\details{
\code{ser_permutation} objects are usually packed into \code{ser_permutations} 
(note the 's' at the ending) which is a collection of permutation vectors.

The constructor \code{permutation} checks if the permutation vector is valid 
(i.e. if all integers occur exactly once).
}
%\value{
%}
%\references{}
%\author{}
\seealso{
\code{\link{permutations}}
}
\examples{
p <- permutation(1:10, "identity")
p

## some methods
length(p)
get_order(p)
get_method(p)
}
\keyword{classes}% at least one, from doc/KEYWORDS
