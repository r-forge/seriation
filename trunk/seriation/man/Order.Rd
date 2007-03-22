\name{Order}
\alias{Order}
\alias{Order_symmetric}
\alias{Order_asymmetric}
\alias{print.Order}
\title{Class Order -- Order for arranging matrices and dissimilarity objects}
\description{
  This class represents a order (permtation) to rearrange matrices.
  For symmetric matrices and objects of class \code{dist} the subclass 
  \code{Order_symmetric} exists. For asymmetric matrices a subclass
  \code{Order_symmetric} containing a row and a column permutation is provided.
}
\usage{
## constructor
Order(order = NULL, row = NULL, col = NULL,
    method = NULL)


## methods
\method{print}{Order}(x, \ldots)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ an object of class \code{Order}.}
  \item{order}{an integer permutation vector for symmetric 
      matrices and \code{dist} objects. As a special case, \code{order}
      can be an object of class \code{hclust}. In this case, the order in the 
      \code{hclust} is used. }
  \item{row, col}{an integer permutation vector for rows and columns
      for a asymmetric matrix. \code{NULL} indicates to keep the original
      ordering of the matrix.}
  \item{method}{an optional string with the method which generated the 
      ordering.} 
  }
\details{
}
\value{
\code{Order()} returns an object of class \code{Order}. The subclass depends
on the parameters used for the constructor.
}
%\references{}
%\author{}
%\seealso{
%}
\examples{
o <- Order(c(1:10))
o
o$order

o <- Order(row = 1:10, col = 1:5, method = "Foo")
o
o$row
o$col
}
\keyword{classes}% at least one, from doc/KEYWORDS
