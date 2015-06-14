\name{ser_permutation_vector}
\alias{ser_permutation_vector}
\alias{permutation_vector}
\alias{print.ser_permutation_vector}
\alias{rev.ser_permutation_vector}
\alias{get_method}
\alias{length.ser_permutation_vector}
\title{Class ser\_permutation\_vector -- 
A Single Permutation Vector for Seriation}
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
      integer vector or an object of class \code{hclust}). The value \code{NA}
      creates an identity permutation. }
  \item{method}{ a string representing the method used to obtain the
      permutation vector}
    }
\details{
A permutation vector is a permutation of the integer vector 
\eqn{<1, 2, ..., n>}, were \eqn{n} is the number of objects. For example,
the permutation vector \eqn{<3, 1, 2>} indicates that in first position is the
object with index 3 then the object with index 1 and finally the object
with index 2.

\code{ser_permutation_vector} objects are usually packed into 
a \code{ser_permutation} object
which is a collection of \eqn{k} permutation vectors for \eqn{k}-mode data.

The constructor \code{ser_permutation_vector} 
checks if the permutation vector is valid 
(i.e. if all integers occur exactly once).

The following functions are implemented: \code{print}, \code{rev},
\code{length}, \code{get_order}, \code{get_rank}, \code{get_method}.
}
\value{
An object of class \code{ser_permutation_vector}.
}
\seealso{
\code{\link{ser_permutation}},
\code{\link{get_order}},
\code{\link{get_permutation_matrix}},
\code{\link{permutation_vector2matrix}}.
}
\author{Michael Hahsler}
\examples{
p <- ser_permutation_vector(sample(10), "random")
p

## some methods
length(p)
get_method(p)
get_order(p)
get_permutation_matrix(p)

r <- rev(p)
r
get_order(r)

## create a indentity permutation vector (with unknown length)
i <- ser_permutation_vector(NA)
i 
}
\keyword{classes}% at least one, from doc/KEYWORDS
