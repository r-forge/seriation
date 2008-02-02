\name{ser_permutation_vector}
\alias{ser_permutation_vector}
\alias{permutation_vector}
\alias{print.ser_permutation_vector}
\alias{get_method}
\alias{length.ser_permutation_vector}
\title{Class ser\_permutation\_vector -- 
A single permutation vector for seriation}
\description{
The class \code{ser_permutation_vector} 
represents a single permutation vector. 
}
\usage{
## constructor
ser_permutation_vector(x, method = NULL)
}
\arguments{
  \item{x}{ an object which contains a permutation vector (currently an
      integer vector or an object of class \code{hclust})}
  \item{method}{ a string representing the method used to obtain the
      permutation vector}
    }
\details{
\code{ser_permutation_vector} objects are usually packed into 
a \code{ser_permutation} object
which is a collection of \eqn{k} permutation vectors for \eqn{k}-mode data.

The constructor \code{ser_permutation_vector} 
checks if the permutation vector is valid 
(i.e. if all integers occur exactly once).
}
%\value{
%}
%\references{}
%\author{}
\seealso{
\code{\link{ser_permutation}}
}
\examples{
p <- ser_permutation_vector(1:10, "identity")
p

## some methods
length(p)
get_order(p)
get_method(p)
}
\keyword{classes}% at least one, from doc/KEYWORDS
