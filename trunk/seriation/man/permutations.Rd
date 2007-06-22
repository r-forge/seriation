\name{ser_permutations}
\alias{ser_permutations}
\alias{permutations}
\alias{print.ser_permutations}
\alias{c.ser_permutations}
\alias{"[.ser_permutations"}
\title{Class ser\_permutations -- A collection of 
permutation vectors for seriation}
\description{
The class \code{ser\_permutations} is a collection of permutation vectors
(see class \code{ser\_permutation}), one for each dimenstion of the data to be
permutated.
}
\usage{
## constructor
permutations(x, \ldots)
}
\arguments{
  \item{x}{an object of class \code{ser_permutation} or
      any object which can be converted into
      a permutations vector of class \code{ser_permutation} (e.g. an integer
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
\code{\link{ser_permutation}}
}
\examples{
o <- permutations(1:5, 10:1)
o

## length (number of dimensions)
length(o)

## get permutation vector for 2nd dimension
get_order(o, 2)

## reverse dimensions
o[2:1]

## combine
o <- c(o, permutations(1:15))
o

## get an individual permutation
o[[2]]
}
\keyword{classes}% at least one, from doc/KEYWORDS
