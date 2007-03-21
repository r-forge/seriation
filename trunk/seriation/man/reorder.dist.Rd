\name{reorder.dist}
\alias{reorder.dist}
\title{Reorder a dissimilarity object}
\description{
Finds a linear order of the objects by moving small dissimilarity values
as close as possible to the diagonal of the symmetric dissimilarity matrix.
Using a image plot of the reordered dissimilarity matrix
can show a structure in the data which was not visible in the original matrix.
}
\usage{
\method{reorder}{dist}(x, method = NULL, control = NULL, \ldots)
}
\arguments{
  \item{x}{ an object of class \code{dist}.}
  \item{method}{ a character string with the name of the seriation method
      (default: \code{"tsp"}).}
  \item{control}{ a list of control options passed on to the reorder
      algorithms.}
  \item{\ldots}{ further arguments (unused).}
    }
\details{
    Currently the following methods are implemented:
   
\describe{    
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
      first \eqn{R^n} in the sequence is found which has a rank of 2. 
      Projecting all points in this matrix on the first two eigenvectors,
      all points fall on an ellipse. The order of the points on this ellipse
      is the resulting order. 
      
      The ellipse can be cut at the two interception points 
      (top or bottom) of the vertical axis with the ellipse. 
      In this implementation the top most cutting point is used.
      }  
    
\item{{"tsp"}}{Traveling salesman problem solver. 
      
      A solver in \pkg{tsp} can be used (see \code{solve_TSP} in
      package \pkg{tsp}). The solver method can be passed on via the
      \code{control} argument, e.g. \code{control = list(method = "insertion")}.

      Since a tour returned by a TSP solver is a connected circle and we are
looking for a path representing a linear order, we need to find the best
cutting point.  Climer and Zhang (2006) suggest to add a dummy city with equal
distance to each other city before generating the tour. The place of this dummy
city in an optimal tour with minimal length is the best cutting point (it lies
between the most distant cities). However, most heuristics normally
only find suboptimal tours and thus it is not guaranteed that the dummy city
would be the best place to cut. Therefore, we search the tour for the two most
distant cities and cut there.}
    }
}
\value{
Returns an integer vector containing the ordering of the objects in \code{x}. 
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
\code{\link{criterion}}.
}
%\author{Michael Hahsler}
\examples{
data("iris")
x <- as.matrix(iris[,1:4])
d <- dist(x)

## compare the different methods
def.par <- par(no.readonly = TRUE)
layout(rbind(1:3, 4:6, 7:9), respect = TRUE)

pimage(d, main = "original matrix")

chen <- reorder(d, method = "chen")
pimage(d, chen, main = "Chen")

## use the projection of the data on its first principal component to
## determine the order 
fpc <- reorder(x, method = "fpc")
pimage(d, fpc$row, main = "first principal component")

## using some tsp solvers from pkg tsp
nins <- reorder(d, method="tsp", control = list(method = "nearest_insertion"))
pimage(d, nins, main = "TSP: nearest insertion")

fins <- reorder(d, method="tsp", control = list(method = "farthest_insertion"))
pimage(d, fins, main = "TSP: farthest insertion")

two_opt <- reorder(d, method="tsp", control = list(method = "2-opt"))
pimage(d, two_opt, main = "TSP: 2-opt")

## using hclust and reorder.hclust
h <- hclust(d, method = "average")
pimage(d, h$order, main = "hclust: avg. linkage")

gw <- reorder(h, d, method = "gw") 
pimage(d, gw$order, main = "hclust: avg. linkage + Gruvaeus-Wainer")

ho <- reorder(h, d, method = "optimal")
pimage(d, ho$order, main = "hclust: avg. linkage + optimal")

par(def.par)
}
\keyword{optimize}
\keyword{cluster}
