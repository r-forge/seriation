\name{ser_permutation}
\alias{ser_permutation}
\alias{permutation}
\alias{print.ser_permutation}
\alias{c.ser_permutation}
\alias{"[.ser_permutation"}
\title{Class ser\_permutation -- A collection of 
permutation vectors for seriation}
\description{
The class \code{ser_permutation} is a collection of permutation vectors
(see class \code{ser_permutation_vector}), one for each dimension (mode) 
of the data to be permuted.
}
\usage{
## constructor
ser_permutation(x, \ldots)
}
\arguments{
  \item{x}{an object of class \code{ser_permutation_vector} or
      any object which can be converted into
      a object of class \code{ser_permutation} (e.g. an integer
      vector).}
  \item{\ldots}{permutation vectors for further dimensions}
    }
%\details{
%}
%\value{
%}
%\references{}
%\author{}
\seealso{
\code{\link{ser_permutation_vector}}
}
\examples{
o <- ser_permutation(1:5, 10:1)
o

## length (number of dimensions)
length(o)

## get permutation vector for 2nd dimension
get_order(o, 2)

## reverse dimensions
o[2:1]

## combine
o <- c(o, ser_permutation(1:15))
o

## get an individual permutation
o[[2]]
}
\keyword{classes}% at least one, from doc/KEYWORDS
