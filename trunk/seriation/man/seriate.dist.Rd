\name{seriate.dist}
\alias{seriate.dist}
\alias{seriate}
\title{Seriation of objects in a dissimilarity matrix}
\description{
Unidimensional seriation ties to arrange objects in linear order given
available data.

Given a dissimilarity matrix seriation typically tries to
move small dissimilarity values as close as possible to the diagonal of the 
symmetric dissimilarity matrix or tries to minimize the
dissimilarites between neighboring objects.
}
\usage{
\method{seriate}{dist}(x, method = NULL, control = NULL, \ldots)
}
\arguments{
  \item{x}{ an object of class \code{dist}.}
  \item{method}{ a character string with the name of the seriation method
      (default: \code{"tsp"}).}
  \item{control}{ a list of control options passed on to the seriation
      algorithms.}
  \item{\ldots}{ further arguments (unused).}
    }
\details{
    Currently the following methods are implemented:
   
\describe{    
\item{\code{"tsp"}}{Traveling salesperson problem solver. 
      
      A solver in \pkg{tsp} can be used (see \code{solve_TSP} in
      package \pkg{tsp}). The solver method can be passed on via the
      \code{control} argument, e.g. \code{control = list(method = "insertion")}.

      Since a tour returned by a TSP solver is a connected circle and we are
      looking for a path representing a linear order, we need to find the best
      cutting point.  Climer and Zhang (2006) suggest to add a dummy city with
      equal distance to each other city before generating the tour. The place
      of this dummy city in an optimal tour with minimal length is the best
      cutting point (it lies between the most distant cities).} 

\item{\code{"chen"}}{Rank-two ellipse seriation (Chen 2002).
      
        This method starts with generating a sequence of correlation matrices
      \eqn{R^1, R^2, \ldots}. \eqn{R^1} is the correlation matrix
      of the original distance matrix \eqn{D} (supplied to the function as 
      \code{x}), 
      and 
        \deqn{R^{n+1} = \phi R^n,} 
      where \eqn{\phi} calculates the
      correlation matrix. 
      
      The rank of the matrix \eqn{R^n} falls with increasing \eqn{n}. The 
      first \eqn{R^n} in the sequence which has a rank of 2 is found. 
      Projecting all points in this matrix on the first two eigenvectors,
      all points fall on an ellipse. The order of the points on this ellipse
      is the resulting order. 
      
      The ellipse can be cut at the two interception points 
      (top or bottom) of the vertical axis with the ellipse. 
      In this implementation the top most cutting point is used.
      }  

\item{\code{"mds"}}{Multidimensional scaling (MDS).
    
    Use multidimensional scaling techniques to find an linear order. Note 
    that unidimensional scaling would be more appropriate but is very hard to 
    solve. Generally, MDS provides good results.

    By default, metric MDS (\code{cmdscale} in \pkg{stats}) is used. 
    In case of of general dissimilarities, non-metric MDS can be used.
    The choices are \code{isoMDS} and \code{sammon} from \pkg{MASS}.
    The method can be specified as the element \code{method} 
    (\code{"cmdscale"}, \code{"isoMDS"} or \code{"sammon"}) in \code{control}.
    }  
    }
}
\value{
Returns the order as an object of class \code{Order_symmetric} which is a list
containing the order (an integer vector) as element \code{order}.
}
\references{ 
Chen, C. H. (2002):  Generalized Association Plots: Information
Visualization via Iteratively Generated Correlation Matrices.  
\emph{Statistica Sinica,} \bold{12}(1), 7--29.

Sharlee Climer, Weixiong Zhang (2006): Rearrangement Clustering: Pitfalls,
Remedies, and Applications, 
\emph{Journal of Machine Learning Research,} \bold{7}(Jun), 
919--943.
}
\seealso{
\code{\link[tsp]{solve_TSP}} in \pkg{tsp},
\code{\link{criterion}},
\code{\link{seriate.matrix}} and
\code{\link{seriate.hclust}} for special seriation cases.
}
%\author{Michael Hahsler}
\examples{
data("iris")
x <- as.matrix(iris[-5])
d <- dist(x)

## compare the different methods
hc <- Order(hclust(d, method = "average"))

order <- list(
    orig_matrix = NULL,
    chen = seriate(d, method = "chen"),
    mds =  seriate(d, method = "mds"),
    tsp_nearest = seriate(d, method="tsp", 
        control = list(method = "nearest_insertion")),
    tsp_farthest = seriate(d, method="tsp", 
        control = list(method = "farthest_insertion")),
    tsp_two_opt =  seriate(d, method="tsp", 
        control = list(method = "2-opt")),
    hc = hc,
    hc_gw = seriate(hc, d, method = "gw"),
    hc_opt = seriate(hc, d, method = "optimal")
)


## plot
def.par <- par(no.readonly = TRUE)
layout(matrix(1:9, ncol = 3, byrow = TRUE))

tmp <- sapply(order, FUN = function(o) pimage(d, o, main = attr(o, "method")))

par(def.par)

## calculate criteria
crit <- sapply(order, FUN = function(o) criterion(d, o))
crit
}
\keyword{optimize}
\keyword{cluster}
