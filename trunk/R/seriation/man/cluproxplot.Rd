\name{cluproxplot}
\alias{cluproxplot}
\alias{plot.cluster_proximity_matrix}
\title{Cluster Proximity Plot}
\description{
Visualizes cluster quality using shading of a rearranged proximity matrix (see
Ling, 1973). Objects belonging to the same cluster are displayed in consecutive
order. The placement of clusters and the within cluster order is done by
various seriation algorithms which try to place large similarities/small
dissimilarities close to the diagonal. Compact clusters are visible as dark
squares (low dissimilarity) on the diagonal of the plot.

Additionally a Silhouette plot (Rousseeuw, 1987) is added.

The visualization was also inspired by CLUSION (see Strehl and Ghosh, 2002).
  }
\usage{
cluproxplot(x, labels = NULL, method = NULL, options = NULL, 
  plot = TRUE, plot_options = NULL, \ldots)   
}
\arguments{
  \item{x}{ an object of class \code{dist}.}
  \item{labels}{ \code{NULL} or an integer vector of the same length as
      rows/columns in \code{x} indicating the membership for each element in
      \code{x} as consecutive integers starting with one. The labels are used
      to reorder the matrix.}
  \item{method}{ a single character strings indicating the used
      seriation algorithm (\code{NA} if to plot the matrix as is). The same
      algorithm is used to reorder the clusters (inter cluster seriation) as
      well as the objects within each cluster (intra cluster seriation). 
      
      If separate algorithms for inter and intra cluster seriation are
      required, \code{method} can be a \code{list} of two named elements
      (\code{inter_cluster} and \code{intra_cluster} each containing the name
      of the respective seriation method. See \code{reorder} for available
      reorder algorithms. 
      
      For intra cluster reordering the special
      method \code{silhouette width} is available. Objects in clusters are
      then ordered by silhouette width (the standard for silhouette plots).
      }
\item{options}{ a list of options passed on to the reorder algorithm.
    In case of two different reorder algorithms, \code{options} can
    contain a list of two named elements (\code{inter_cluster} 
    and \code{intra_cluster}) containing each a list with the options
    for the respective algorithm.}
  \item{plot}{a logical indicating  if a plot should be produced.  if
      \code{FALSE}, the returned object can be plotted later using the function
      \code{plot} which takes as the second argument a a list of plotting
      options (see \code{plot_options} below).}
  \item{\dots}{ further arguments (unused). }
  \item{plot_options}{a list with options for plotting the matrix. The
      list can contain the following elements:
    
  \describe{
\item{\code{cluster_labels}}{ a logical indicating whether to display cluster
      labels in the plot.}
\item{\code{averages}}{ a logical indicating whether to display the average
      pair-wise dissimilarity between clusters instead of the individual
      dissimilarities in the lower triangle of the plot.}
\item{\code{lines}}{ a logical indicating  whether to draw lines to separate
      clusters.} 
\item{\code{silhouettes}}{ a logical indicating  whether to include a
      silhouette plot (see Rousseeuw, 1987).} 
\item{\code{threshold}}{ a numeric. If used, only plot distances below the
    threshold are displayed.} 
\item{\code{main}}{ title for the plot.}
\item{\code{col}}{ colors used for the image plot (default: 100 shades of gray
    using the hcl colorspace with 
    \code{hcl(h = 0, c = 0, l = seq(20, 95, len = 100))}). }
\item{\code{colorkey}}{ a logical indicating  whether to place a color key
      below the plot. }
\item{\code{lines_col}}{ color used for the lines to separate clusters. }
\item{\code{newpage}}{ a logical indicating  whether to start plot on a new
    page (see \code{grid.newpage} in package \code{grid}). }
\item{\code{pop}}{a logical indicating  whether to  should the viewports
    created be popped (see package \code{grid})?  }
\item{\code{gp}}{an object of class \code{gpar} containing graphical parameters
    (see \code{gpar} in package \code{grid}). }
    }
}}
%\details{
%}
\value{
An invisible object of class \code{cluster_proximity_matrix} with the folowing
elements:
\item{order}{ \code{NULL} or integer vector giving the order 
used to plot \code{x}.}
\item{method}{ vector of character strings indicating the seriation methods 
	used for plotting  \code{x}.}
\item{k}{ \code{NULL} or integer scalar giving the number of clusters
generated.}
\item{description}{ a \code{data.frame}  
   containing information (label, size, average intra-cluster dissimilarity
   and the average silhouette) 
   for the clusters as displayed in the 
   plot (from top/left to bottom/right).}

This object can be used for plotting via
\code{plot(x, plot_options = NULL, ...)}
}
\references{
Ling, R.F. (1973):
A computer generated aid for cluster analysis. 
\emph{Communications of the ACM,} 
\bold{16}(6), pp. 355--361.

Rousseeuw, P.J. (1987): 
Silhouettes: A graphical aid to the interpretation and 
validation of cluster analysis. 
\emph{Journal of Computational and Applied Mathematics,}
\bold{20}(1), pp. 53--65.

Strehl, A. and Ghosh, J. (2003):
Relationship-based clustering and 
visualization for high-dimensional data mining. 
\emph{INFORMS Journal on Computing,} 
\bold{15}(2), pp. 208--230.

}
\seealso{
  \code{\link[stats]{dist}}
  (in package \code{stats}),
   package \code{grid} and
   \code{\link{reorder}}.
}
\author{Michael Hahsler}
\examples{
data("iris")
d <- dist(iris[1:4])

## plot original matrix
res <- cluproxplot(d, method = NA)

## plot reordered matrix using the farthest insertion algorithm (from tsp)
res <- cluproxplot(d, method = "tsp", options = list(method = "nearest"),
    plot_options = list(main = "Seriation (farthest insertion)"))

## cluster with pam (we know iris has 3 clusters)
library("cluster")
l <- pam(d, 3, cluster.only = TRUE)

## we use a grid.layout to place several plots on a page
grid.newpage()
pushViewport(viewport(layout=grid.layout(nrow = 2, ncol = 2), 
    gp = gpar(fontsize = 8)))
pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 1))

## visualize the clustering
res <- cluproxplot(d, l, method = "chen",  
    plot_options = list(main = "PAM + Seriation (Chen) - standard", 
    newpage = FALSE))

popViewport()
pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 2))

## more visualization options
## threshold
plot(res, plot_options = list(main = "PAM + Seriation (Chen) - threshold", 
    threshold=2, newpage = FALSE))

popViewport()
pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1))

## color: use 10 shades of blue
plot(res, plot_options = list(main = "PAM + Seriation (Chen) - blue", 
    col = hcl(h = 260, c = seq(75,0, length=10), l = seq(30,95, length=10)),
    gp = gpar(fill = hcl(h = 260, c=30, l = 80)), newpage = FALSE))

popViewport()
pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 2))

## supress average in lower triangle
plot(res, plot_options = list(main = "PAM + Seriation (Chen) - no avg.", 
    average = FALSE, newpage = FALSE))

popViewport(2)

## the cluster_proximity_matrix object
res 
names(res)
}
\keyword{hplot}
\keyword{cluster}
