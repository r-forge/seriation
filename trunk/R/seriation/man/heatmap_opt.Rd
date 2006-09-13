\name{heatmap_opt}
\alias{heatmap_opt}
\title{Optimally reordered heat map}
\description{
Provides an optimally reordered version of \code{heatmap} in package 
\pkg{stats}.
}
\usage{
heatmap_opt(x, dist_row = NULL, dist_col = NULL, ...)
}
\arguments{
  \item{x}{a matrix.}
  \item{dist_row, dist_col}{an object of class \code{dist} containing the
      dissimilarities between rows/columns. If \code{NULL} euclidean distances
      are computed.}
  \item{\dots}{further arguments are passed on to \code{heatmap} in
      \pkg{stats}. Note that the following arguments cannot be used:
      \code{Rowv, Colv, distfun, hclustfun, reorderfun, scale}.}
}
\details{
Uses \code{reorder.hclust} with method \code{"optimal"} for arranging \code{x}.
See the example for \code{reorder.hclust} for more possibilities 
(e.g., using different methods for hierarchical clustering).

Note that unlike \code{heatmap} no scaling is automatically applied. The data
have to be scaled before using this function.
}
\value{
An invisible list with elements: 
\item{rowInd, colInd}{index permutation vectors.}
\item{Rowv, Colv}{dendrograms; only if \code{keep.dendro} was set \code{TRUE}
    (see \code{heatmap} for details).}
}
\author{Michael Hahsler}
\seealso{
\code{\link{reorder.hclust}},
\code{\link[stats]{heatmap}} in \pkg{stats}.}
\examples{
data("Zoo")
x <- as.matrix(Zoo[, -17])
x <- scale(x)   # center and scale the data

## optimally reordered heatmap
heatmap_opt(x)
}
\keyword{hplot}
