\name{reorder.matrix}
\alias{reorder.matrix}
\alias{reorder.dist}
\title{Reorder a matrix or dissimilarity object}
\description{
Seriation tries to move large values towards the main diagonal by reordering
columns and rows at the same time. Using a image plot of the reordered matrix
can show a structure in the data which was not visible in the original matrix.
}
\usage{
\method{reorder}{dist}(x, method = NULL, \ldots)
\method{reorder}{matrix}(x, method = NULL, col = TRUE, \ldots)
}
\arguments{
  \item{x}{ matrix or object of class \code{dist} to be seriated.}
  \item{method}{ a character string with the name of the seriation method
    (default: murtagh).}
  \item{col}{ if \code{col=TRUE} the order for columns is calculated, 
    otherwise for rows. }
  \item{\ldots}{ further arguments (currently unused).}
    }
\details{
    Currently the following methods are implemented:
\describe{
    \item{murtagh}{Algorithm B (Murtagh 1985). 
      A simple heuristic which uses the cross-product of the matrix
      (unnormalized form of the Pearson correlation) and \code{order_greedy} to
      obtain the ordering. For \code{order_greedy} in each step a single
      cluster is constructed by merging the leaf closest to one of the two
      endpoints of the cluster. The algorithm starts with a random leaf and
      uses tie-breaking.
      
      Note that the ordering can change from run to run since ties are broken
      randomly.}
    \item{first-pc}{First principal component. 
      Uses the projection of the data on its
      first principal component to determine the order. 
      
      Note that for a distance matrix calculated from \code{x} with 
      Euclidean distance, this methods minimizes the least square criterion.}  
    \item{chen}{Rank-two ellipse seriation (Chen 2002).
      This method starts with generating a sequence of correlation matrices
      \eqn{R^1, R^2, \ldots}. \eqn{R^1} is the correlation matrix
      of the original distance matrix \eqn{D} (supplied to the function as 
      \code{x}), 
      and \eqn{R^{n+1} = \phi R^n} where \eqn{\phi} calculates the
      correlation matrix. 
      
      The rank of the matrix \eqn{R^n} falls with increasing \eqn{n}. The 
      first \eqn{R^n} in the sequence is found which has a rank of 2. 
      Projecting all points in this matrix on the first two eigenvectors,
      all points fall on an ellipse. The order of the points on this ellipse
      is the resulting order. 
      
      The ellipse can be cut at the two interception points 
      (top or bottom) of the vertical axis with the ellipse. 
      In this implementation the top most cutting point is used.
      }  
      }}
\value{
Returns an integer vector containing the ordering of the rows or columns. 
}
\references{ 
Chen, C. H. (2002).  Generalized Association Plots: Information
Visualization via Iteratively Generated Correlation Matrices.  Statistica
Sinica 12, 7-29.

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
\keyword{cluster}
