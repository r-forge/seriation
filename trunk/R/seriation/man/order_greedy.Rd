\name{order_greedy}
\alias{order_greedy}
\title{Hierarchical Greedy Ordering}
\description{
  Compute a hierarchical greedy ordering of a data matrix.
}
\usage{
order_greedy(dist)
}
\arguments{
  \item{dist}{an object of class \code{dist}.}
}
\details{
  A single cluster is constructed by merging in each step the leaf 
  closest to one of the two endpoints of the cluster. The algorithm
  starts with a random leaf and uses tie-breaking.

  Clearly, the algorithm is more an ordering than a cluster algorithm. 
  However, it constructs a binary merge tree so that the linear ordering 
  of its leaves could be further improved.

  This algorithm is used to implement Algorithm B by Fionn Murtagh (1985).  
}
\value{
  A list with the following items:
  
  \item{merge}{a matrix containing the merge tree.}
  \item{order}{a vector containing the leaf ordering.}
  \item{height}{a vector containing the merge heights.}
}
\references{
  F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures in
  Computational Statistics, Physica Verlag, pp. 15.
}
\author{Christian Buchta}
\note{The merge heights may not be monotonic so we do not 
    return a \code{hclust} object.}
\seealso{
  \code{\link{hclust}} for hierarchical clustering.
}
\examples{
d <- dist(matrix(runif(20), ncol=2))
hc <- hclust(d)
o_h <- hc$order

d_m <- -as.dist(crossprod(as.matrix(d)))	# Murtagh's distances
o_m <- order_greedy(d_m)$order

### compare images
op <- par(mfrow=c(1,3), pty="s")
m <- as.matrix(d)
image_proper(m, main="original")
image_proper(m[o_h, o_h], main="hclust")
image_proper(m[o_m, o_m], main="greedy (Murthag)")
par(op)

# compare lenghts
criterion(d)
criterion(d, o_h)
criterion(d, o_m)
}
\keyword{hplot}
\keyword{cluster}
