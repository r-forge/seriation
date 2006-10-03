\name{hmap}
\alias{hmap}
\title{Plot heat map reordered by different algorithms}
\description{
Provides several reordered version of a heat map.
}
\usage{
hmap(x, dist_row = NULL, dist_col = NULL, distfun = dist,
    dendrogram = TRUE, method = NULL, control = NULL, options = NULL, ...)
}
\arguments{
  \item{x}{a matrix.}
  \item{dist_row, dist_col}{objectis of class \code{dist} containing the
      dissimilarities between rows/columns. If \code{NULL} euclidean distances
      are computed for the matrix \code{x}.}
  \item{distfun}{function used to compute the distance (dissimilarity) between
      both rows and columns (default: \code{dist}). }
  \item{dendrogram}{a logical indicating whether to use dendrogram reordering 
      or distance matrix based reordering.}
  \item{method}{a character strings indicating the used reorder algorithm 
      (see \code{reorder.hclust} and \code{reorder.dist})}
  \item{control}{a list of control options passed on to the reorder algorithm.
      For \code{dendrogram = TRUE} an element named \code{hclustfun} can be
      used to specify a function for hierarchical clustering (default:
      \code{hclust}).} 
  \item{options}{a list with arguments for plotting (currently only used
      for \code{dendrogram = FALSE}) which used \pkg{grid}. 
      The following arguments are possible:
      \describe{
  \item{\code{main}}{title for the plot.}
  \item{\code{col}}{colors used for the  plot.}
  \item{\code{gp}}{an object of class \code{gpar} containing graphical
      parameters (see \code{gpar} in package \pkg{grid}).}
  \item{\code{newpage}}{a logical indicating  whether to start plot on a new
      page (see \code{gpar} in package \pkg{grid}).} 
  \item{\code{prop}}{a logical indicating whether the height and width of
      \code{x} should be plotted proportional to its dimensions.}
      }
      }
  \item{\dots}{further arguments. For \code{dendrogram = TRUE} the 
      arguments passed on to \code{heatmap} in
      \pkg{stats} (Note that the following arguments cannot be used:
      \code{Rowv, Colv, distfun, hclustfun, reorderfun, scale}).
      
      For \code{dendrogram = FALSE} see argument \code{options}.}
}
\details{
For \code{dendrogram = TRUE}, \code{reorder.hclust} 
with the default method \code{"optimal"} for arranging \code{x} is used.
Then \code{heatmap} is used for plotting.

For \code{dendrogram = FALSE}, \code{reorder.dist} 
with the default method \code{"tsp"}
(a traveling salesperson solver) for arranging \code{x} is used.
Then \pkg{grid} code implemented in this package 
is used to produce the plot.

Note that unlike \code{heatmap} scaling is not automatically applied. The data
have to be scaled before using this function.
}
\value{
An invisible list with elements: 
\item{rowInd, colInd}{index permutation vectors.}
\item{reorder_method}{name of the method used to reorder the matrix.}

For \code{dendrogram = TRUE} the list can contain additional elements 
(see \code{heatmap} for details).
    
    }
\author{Michael Hahsler}
\seealso{
\code{\link{reorder.hclust}},
\code{\link{reorder.dist}} and
\code{\link[stats]{heatmap}} in \pkg{stats}.}
\examples{
data("Zoo")
x <- as.matrix(Zoo[, -17])
x <- scale(x)   # center and scale the data

## optimally reordered heatmap
hmap(x)

## heatmap with seriated distance matrices
hmap(x, dendrogram = FALSE)

## without proportional display and a gray color palette
hmap(x, dendrogram = FALSE, options = list(prop = FALSE, 
    main = "Zoo Data", col = gray.colors(100)))
}
\keyword{hplot}
