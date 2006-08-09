\name{reorder.matrix}
\alias{reorder.matrix}
\title{Reorder a matrix or dissimilarity object}
\description{
Seriation tries to move large values towards the main diagonal by reordering
columns and rows at the same time. Using a image plot of the reordered matrix
can show a structure in the data which was not visible in the original matrix.
}
\usage{
reorder(x, method = NULL, col = TRUE)
}
\arguments{
  \item{x}{ matrix or object of class \code{dist} to be seriated.}
  \item{method}{ a character string with the name of the seriation method
    (default: murtagh).}
  \item{col}{ if \code{col=TRUE} the columns are reordered, 
    otherwise the rows. }
}
\details{
    Currently the following methods are implemented:
\describe{
    \item{murtagh}{Murtagh (1985), Algorithm B. 
      A simple heuristic
      which uses the cross-product of the matrix (unnormalized form 
      of the Pearson correlation) and \code{order_greedy}
      to obtain the ordering. Note that the ordering can change from run
      to run since ties are broken randomly.}
    \item{first-pc}{First principal component. 
      Uses the projection of the data on its
      first principal component to determine the order. 
      
      Note that for Euclidean distance, this methods minimizes
      the least square criterion.}  
      }}
\value{
Returns an integer vector containing the ordering of the rows or columns. 
The attribute
\code{"method"} contains the method as a character string.
}
\references{
F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures in
Computational Statistics, Physica Verlag, pp. 15.

}
\seealso{
\code{\link{order_greedy}},
\code{\link{criterion}}
}
\author{Michael Hahsler}
\examples{

# generate random data
x <- rbind(cbind(matrix(rnorm(10*5, mean = 2), nrow=5),
	    matrix(rnorm(4*5, mean = 8), nrow=5)),
	cbind(matrix(rnorm(10*10, mean = 6), nrow=10),
	    matrix(rnorm(4*10, mean = 1), nrow=10)))

x <- x[sample(1:nrow(x)), sample(1:ncol(x))]

# do seriation of columns
o <- reorder(x) 
o

op <- par(mfrow = c(1,2))
image_proper(x, main = "original")
image_proper(x[o, reorder(x, col = FALSE)], main = "after seriation")
par(op)

}
\keyword{optimize}
