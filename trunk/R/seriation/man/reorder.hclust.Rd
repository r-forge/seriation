\name{reorder.hclust}
\alias{reorder.hclust}
\title{Reorder the leaves of a hierarchical clustering}
\description{
  Find a good (or optimal) linear leaf ordering of a dendrogram as
  produced by a hierarchical cluster algorithm.
}
\usage{
\method{reorder}{hclust}(x, dist, method = NULL, options = NULL, \ldots)
}
\arguments{
  \item{x}{a hclust object (see \code{\link{hclust}}).}
  \item{dist}{the \code{dist} object used for clustering.}
  \item{method}{ a character string with the name of the reorder 
	method (default: \code{"optimal"}).}
  \item{options}{ options passed on to the algorithms.}
  \item{\ldots}{ further arguments (unused).}
}
\details{
A dendrogram (binary tree) has \eqn{2^{n-1}} internal nodes (subtrees) and the
same number of leaf orderings. That is, at each internal node the left and
right subtree (or leaves) can be swapped, or, in terms of a dendrogram, be
flipped.
  
Currently, the following methods are implemented:

\describe{
    \item{"optimal"}{Optimal leaf ordering (Bar-Joseph et al. 2001).
      
        Provides an interface to the optimal leaf ordering algorithm. 
      The used objective measure for leaf ordering is the
      sum of the distances along the (Hamiltonian) path connecting the leaves
      in the given order. This algorithm produces the ordering with a minimal
      path length. The time complexity of the algorithm is
      \eqn{o(n^3)}.

      Note that non-finite distance values are not allowed.}
    \item{"gw"}{Gruvaeus and Wainer (1972). 
      
        Uses the algorithm implemented in package \pkg{gclus} (Hurley 2004).
      The clusters are ordered at each level so that the objects at
      the edge of each cluster are adjacent to that object outside the cluster
      to which it is nearest. The method produces an unique order.}
}
}
\value{
The reordered object of class \code{hclust}.
}
\references{
Z. Bar-Joseph, E. D. Demaine, D. K. Gifford, and T. Jaakkola. (2001): Fast
Optimal Leaf Ordering for Hierarchical Clustering.  
\emph{Bioinformatics,} \bold{17}(1), 22--29. 

Gruvaeus, G. and Wainer, H. (1972): Two Additions to Hierarchical Cluster
Analysis, 
\emph{British Journal of Mathematical and Statistical Psychology,}
\bold{25}, 200--206.

Hurley, Catherine B. (2004): Clustering Visualizations of Multidimensional
Data.  
\emph{Journal of Computational and Graphical Statistics,} 
\bold{13}(4), 788--806.
}
\author{Christian Buchta and Michael Hahsler}
\seealso{
  \code{\link{dist}} and \code{\link{hclust}} for hierarchical clustering,
  \code{\link{criterion}} for computing the objective value of a 
  leaf ordering, and \code{link{heatmap_opt}} for optimally 
  reordered heat maps.
}
\examples{
## generate some random data
d <- dist(matrix(runif(30), ncol=2))
hc <- hclust(d)
hc_opt <- reorder(hc, d, method="optimal")
hc_gru <- reorder(hc, d, method="gw")

## compare dendrograms
op <- par(mfrow=c(2,3), pty="s")
plot(hc, main="hclust")
plot(hc_gru, main="Gruvaeus-Wainer")
plot(hc_opt, main="Optimal leaf ordering")

## compare images
m <- as.matrix(d)
pimage(m[hc$order, hc$order])
pimage(m[hc_gru$order, hc_gru$order])
pimage(m[hc_opt$order, hc_opt$order])
par(op)

## compare lengths
criterion(d)
criterion(d, hc$order)
criterion(d, hc_gru$order)
criterion(d, hc_opt$order)


## application: heatmap (see also heatmap_opt)
data("iris")
x <- as.matrix(iris[1:4])
d_c <- dist(t(x))
dend_c <- as.dendrogram(reorder(hclust(d_c), d_c))

d_r <- dist(x)
dend_r <- as.dendrogram(reorder(hclust(d_r), d_r))

## standard plot
## heatmap(x, col = rev(gray.colors(64)), main = "standard plot")

## optimal leaf ordering
heatmap(x, Colv = dend_c, Rowv = dend_r, col = rev(gray.colors(64)),
    margins = c(7,3), cexCol=1, labRow = "")
}
\keyword{optimize}
\keyword{cluster}
