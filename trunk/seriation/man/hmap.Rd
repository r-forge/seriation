\name{hmap}
\alias{hmap}
\title{Plot heat map reordered by different algorithms}
\description{
Provides several reordered versions of heat map including dendrogram based
reordering with optimal leaf order and matrix seriation based heat maps.
}
\usage{
hmap(x, distfun = dist, hclustfun = hclust,
    method = NULL, control = NULL, options = NULL, ...)
}
\arguments{
  \item{x}{a matrix.}
  \item{distfun}{function used to compute the distance (dissimilarity) between
      both rows and columns (default: \code{dist}). }
  \item{hclustfun}{function used for hierarchical clustering.
      If \code{hclustfun = NULL}, no hierarchical clustering in performed and
      matrix based seriation is performed to reorder rows and columns
      for the heat map.}
  \item{method}{a character strings indicating the used seriation algorithm 
      (see \code{seriate.dist} for dendrogram seriation and 
      for matrix based seriation).}
  \item{control}{a list of control options passed on to the seriation 
      algorithm.} 
  \item{options}{a list with arguments for plotting.
      The following arguments are possible:
      \describe{
  \item{\code{main}}{title for the plot.}
  \item{\code{col}}{colors used for the  plot (default: gray colors).}
      }
      For matrix based seriation (\code{hclustfun = NULL}), the following
      additional arguments are possible:
       \describe{
  \item{\code{gp}}{an object of class \code{gpar} containing graphical
      parameters (see \code{gpar} in package \pkg{grid}).}
  \item{\code{newpage}}{a logical indicating  whether to start plot on a new
      page (see \code{gpar} in package \pkg{grid}).} 
  \item{\code{prop}}{a logical indicating whether the height and width of
      \code{x} should be plotted proportional to its dimensions.}
      }
      }
  \item{\dots}{further arguments. For dendrogram based heat maps the 
      arguments are passed on to \code{heatmap} in
      \pkg{stats} (Note that the following arguments cannot be used:
      \code{Rowv, Colv, distfun, hclustfun, reorderfun, scale}).
      
      For \code{dendrogram = FALSE} further arguments are used as 
      \code{options} (see above).}
}
\details{
For \code{dendrogram = TRUE}, \code{seriate.hclust} 
with the default method \code{"optimal"} is used for arranging the
dendrogramms and \code{x}. \code{heatmap} is used for plotting.

For \code{dendrogram = FALSE}, \code{seriate.dist} 
with the default method \code{"tsp"}
(a traveling salesperson solver) for arranging \code{x} is used.
\pkg{grid} code implemented in this package 
is used to produce the plot.

Note that unlike the default behavior of \code{heatmap}, 
scaling is not automatically applied. The data
have to be scaled before using \code{hmap}.
}
\value{
An invisible list with elements: 
\item{rowInd, colInd}{index permutation vectors.}
\item{reorder_method}{name of the method used to reorder the matrix.}

For \code{dendrogram = TRUE} the list can contain additional elements 
(see \code{heatmap} for details).
    
    }
%\author{Michael Hahsler}
\seealso{
\code{\link{seriate.dist}} and
\code{\link[stats]{heatmap}} in \pkg{stats}.}
\examples{
data("Zoo")
x <- as.matrix(Zoo[, -17])
x <- scale(x, center = FALSE)

## optimally reordered heatmap
hmap(x)

## heatmap with seriated distance matrices
hmap(x, hclustfun = NULL)

## with proportional display
hmap(x, hclustfun = NULL, options = list(prop = TRUE, 
    main = "Zoo Data"))
}
\keyword{hplot}
