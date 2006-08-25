\name{cluproxplot}
\alias{cluproxplot}
\alias{plot.cluster_proximity_matrix}
\title{Cluster Proximity Plot}
\description{
Visualizes cluster quality using shading of a rearranged proximity matrix (see
Ling, 1973). Objects belonging to the same cluster are displayed in consecutive
order. The placement of clusters and the within cluster order is done by
various seriation algorithms which try to place large similarities close to
the diagonal. Compact clusters are visible as dark squares (high similarity)
on the diagonal of the plot.

Additionally a Silhouette plot (Rousseeuw, 1987) is added.

The visualization was also inspired by CLUSION (see Strehl and Ghosh, 2002).
  }
\usage{
cluproxplot(x, labels = NULL, method = NULL, 
  plot = TRUE, plot_options = NULL, \ldots)   
}
\arguments{
  \item{x}{ an object of class \code{dist} or a matrix. }
  \item{labels}{ \code{NULL} or an integer vector of the same length as
      rows/columns in \code{x} indicating the membership for each element in
      \code{x} as consecutive integers starting with one.  The labels are used
      to reorder the matrix.}
  \item{method}{ a vector of character strings indicating the used
    seriation algorithms. The first element indicates the inter cluster
    and the second element the intra cluster seriation method. See 
    \code{reorder} for available reorder algorithms.}
  \item{plot}{\code{"logical"};  if \code{FALSE}, no plot is produced. The 
    returned object can be plotted later using the function \code{plot}
    which takes as the second argument a a list of plotting options (see
    \code{plot_options} below).}
  \item{\dots}{ further arguments passed on to \code{reorder}. }
  \item{plot_options}{\code{"list"}; options for plotting the matrix. The list
    can contain the following elements:
    
  \describe{
  \item{\code{cluster_labels}}{ \code{"logical"}; display cluster labels in the plot.}
  \item{\code{averages}}{ \code{"logical"}; display in the lower triangle of the plot
      the average pair-wise dissimilarity between clusters instead of the
      individual dissimilarities.}
  \item{\code{lines}}{ \code{"logical"}; draw lines to separate clusters.} 
  \item{\code{silhouettes}}{ \code{"logical"}; include a silhouette plot 
    (see Rousseeuw, 1987).} 
\item{\code{threshold}}{ \code{"numeric"}; only plot distances below the threshold.} 
\item{\code{main}}{ title for the plot.}
\item{\code{col}}{ colors used for the image plot (default: 100 shades of gray using
      the hcl colorspace with 
      \code{hcl(h = 0, c = 0, l = seq(20, 95, len = 100))}). }
  \item{\code{colorkey}}{ place a color key under the plot. }
  \item{\code{lines_col}}{ color used for the lines to separate clusters. }
  \item{\code{newpage}}{\code{"logical"}; start plot on a new page 
    (see package \code{grid}). }
\item{\code{pop}}{\code{"logical"};  should the viewports created be popped 
    (see package \code{grid})?  }
\item{\code{gp}}{an object of class \code{gpar} containing graphical parameters
    (see \code{gpar} in package \code{grid}). }
    }
}}
%\details{
%}
\value{
An invisible object of class \code{"cluster_proximity_matrix"} of the folowing
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
Ling, R.F. A computer generated aid for cluster analysis. Comm. of the ACM, 
16(6), 355-361, 1973.

Rousseeuw, P.J. Silhouettes: A graphical aid to the 
interpretation and validation of cluster analysis. J. Comput. Appl. Math., 
20, 53-65, 1987.

Strehl, A. and Ghosh, J. Relationship-based clustering and 
visualization for high-dimensional data mining. 
INFORMS Journal on Computing, 208-230, 2003.

}
\seealso{
  \code{\link[stats]{dist}}
  (in package \code{stats}),
   package \code{grid} and
   \code{\link{reorder}}.
}
%\author{Michael Hahsler (hahsler@ai.wu-wien.ac.at)}
\examples{
data("iris")
d <- dist(iris[1:4])

# plot original matrix
res <- cluproxplot(d, method = NA)

# plot reordered matrix using the farthest insertion algorithm (from tsp)
res <- cluproxplot(d, method = "tsp", tsp = solve_TSP, tsp_method = "nearest",
    plot_options = list(main = "Seriation (farthest insertion)"))



# cluster with pam (we know iris has 3 clusters)
library("cluster")
l <- pam(d, 3, cluster.only = TRUE)

# we use a grid.layout to place several plots on a page
grid.newpage()
pushViewport(viewport(layout=grid.layout(nrow = 2, ncol = 2), 
    gp = gpar(fontsize = 8)))
pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 1))

# visualize the clustering
res <- cluproxplot(d, l, method = "chen",  
    plot_options = list(main = "PAM + Seriation (Chen) - standard", 
    newpage = FALSE))

popViewport()
pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 2))

# more visualization options
# threshold
plot(res, plot_options = list(main = "PAM + Seriation (Chen) - threshold", 
    threshold=2, newpage = FALSE))

popViewport()
pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1))

# color: use 10 shades of blue
plot(res, plot_options = list(main = "PAM + Seriation (Chen) - blue", 
	col = hcl(h = 260, c = seq(75,0, length=10), l = seq(30,95, length=10)),
    gp = gpar(fill = hcl(h = 260, c=30, l = 80)), newpage = FALSE))

popViewport()
pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 2))

# supress average in lower triangle
plot(res, plot_options = list(main = "PAM + Seriation (Chen) - no avg.", 
	average = FALSE, newpage = FALSE))

popViewport(2)

# the cluster_proximity_matrix
res 
names(res)
}
\keyword{hplot}
\keyword{cluster}
