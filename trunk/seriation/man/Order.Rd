\name{Order}
\alias{Order}
\alias{Order_symmetric}
\alias{Order_asymmetric}
\alias{print.Order}
\title{Class Order -- Order for rearranging matrices and dissimilarity objects}
\description{
This class represents an order to rearrange \code{dist} objects and
matrices.

For symmetric matrices and objects of class \code{dist} the subclass 
\code{Order_vector} exists. For asymmetric matrices a subclass
\code{Order_matrix} containing a row and a column ordering is provided.

Note that an order represented by this class is not checked to be a
correct permutation (a bijection) for the original objects/rows/columns. 
It can als be used to arrange only a subset of the original 
objects/rows/columns and even duplicate some of them.
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
  \item{order}{an integer (permutation) vector suitable for symmetric
      matrices and \code{dist} objects. As a special case, \code{order}
      can be an object of class \code{hclust}. In this case, the order in the 
      \code{hclust} is used.}
  \item{row, col}{integer (permutation) vectors for rows and columns. 
      \code{NULL} indicates an identity permutation.}
  \item{method}{an optional string with the method which generated the 
      ordering.} 
  \item{\ldots}{further arguments.}
    }
%\details{
%}
\value{
\code{Order()} returns an object of class \code{Order}. The subclass depends
on the parameters used for the constructor. \code{order} leads to an
\code{Order\_vector} object and \code{row} and/or \code{col}
lead to an  \code{Order\_matrix} object.
}
%\references{}
%\author{}
\seealso{
\code{\link{rearrange}},
\code{\link{reorder.matrix}},
\code{\link{reorder.dist}},
\code{\link{reorder.hclust}}
}
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
