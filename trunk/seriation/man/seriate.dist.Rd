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
dissimilarities between neighboring objects.
}
\usage{
\method{seriate}{dist}(x, method = NULL, control = NULL, \ldots)
}
\arguments{
  \item{x}{ an object of class \code{dist}.}
  \item{method}{ a character string with the name of the seriation method
      (default: \code{"TSP"}).}
  \item{control}{ a list of control options passed on to the seriation
      algorithms.}
  \item{\ldots}{ further arguments (unused).}
}
\details{
    Currently the following methods are implemented:
   
\describe{    
\item{\code{"ARSA"}}{Anti-Robinson seriation by simulated annealing.
    
    A heuristic developed by Brusco et al (2007).
    } 
\item{\code{"BBURCG"}}{Anti-Robinson seriation (unweighted)
    
    A branch-and-bound implementation by Brusco and Stahl (2005).
    } 
\item{\code{"BBWRCG"}}{Anti-Robinson seriation (weighted)

    A branch-and-bound implementation by Brusco and Stahl (2005).
    }

\item{\code{"TSP"}}{Traveling salesperson problem solver. 
      
      A solver in \pkg{TSP} can be used (see \code{solve_TSP} in
      package \pkg{TSP}). The solver method can be passed on via the
      \code{control} argument, e.g. \code{control = list(method = "insertion")}.

      Since a tour returned by a TSP solver is a connected circle and we are
      looking for a path representing a linear order, we need to find the best
      cutting point.  Climer and Zhang (2006) suggest to add a dummy city with
      equal distance to each other city before generating the tour. The place
      of this dummy city in an optimal tour with minimal length is the best
      cutting point (it lies between the most distant cities).} 

\item{\code{"Chen"}}{Rank-two ellipse seriation (Chen 2002).
      
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

\item{\code{"MDS"}}{Multidimensional scaling (MDS).
    
    Use multidimensional scaling techniques to find an linear order. Note 
    that unidimensional scaling would be more appropriate but is very hard to 
    solve. Generally, MDS provides good results.

    By default, metric MDS (\code{cmdscale} in \pkg{stats}) is used. 
    In case of of general dissimilarities, non-metric MDS can be used.
    The choices are \code{isoMDS} and \code{sammon} from \pkg{MASS}.
    The method can be specified as the element \code{method} 
    (\code{"cmdscale"}, \code{"isoMDS"} or \code{"sammon"}) in \code{control}.
    }  
\item{\code{"HC"}}{Hierarchical clustering.
    
    Using the order of the leaf nodes in a dendrogram obtained by hierarchical
    clustering can be used as a very simple seriation technique.
    This method applies hierarchical clustering (\code{hclust}) to \code{x}. 
    The clustering method can be given using a \code{"method"} element in 
    the \code{control} list. If omitted, the default \code{"complete"} is
    used.
    }

\item{\code{"GW"}, \code{"OLO"}}{Hierarchical 
    clustering with optional reordering. 

    Uses also the order of the leaf nodes in a dendrogram (see method 
    \code{"HC"}), however, the leaf notes are reordered.

    A dendrogram (binary tree) has \eqn{2^{n-1}} internal nodes (subtrees) and
    the same number of leaf orderings. That is, at each internal node the left
    and right subtree (or leaves) can be swapped, or, in terms of a dendrogram,
    be flipped. 

    Method \code{"GW"} uses an algorithm developed by Gruvaeus and Wainer
(1972) and implemented in package \pkg{gclus} (Hurley 2004).  The clusters are
ordered at each level so that the objects at the edge of each cluster are
adjacent to that object outside the cluster to which it is nearest. The method
produces an unique order.

    Method \code{"OLO"} (Optimal leaf ordering, Bar-Joseph et al., 2001) 
produces an optimal leaf ordering with respect to the
minimizing the sum of the distances along the (Hamiltonian) path connecting the
leaves in the given order. The time complexity of the algorithm is \eqn{O(n^3)}.
Note that non-finite distance values are not allowed.

   Both methods start with a dendrogram created by \code{hclust}. As  the
\code{"method"} element in the \code{control} list a clustering method (default
\code{"complete"}) can be specified. Alternatively, a \code{hclust} object can
be supplied using an element named \code{"hclust"}.
    }
    }
}
\value{
Returns the order as an object of class \code{ser_permutation}.
}
\references{ 
Z. Bar-Joseph, E. D. Demaine, D. K. Gifford, and T. Jaakkola. (2001): Fast
Optimal Leaf Ordering for Hierarchical Clustering.
\emph{Bioinformatics,} \bold{17}(1), 22--29.

Brusco, M., Koehn, H.F., and Stahl, S. (2007): Heuristic Implementation of 
Dynamic Programming for Matrix Permutation Problems in Combinatorial 
Data Analysis. \emph{Psychometrika,} conditionally accepted.

Brusco, M., and Stahl, S. (2005): 
\emph{Branch-and-Bound Applications in Combinatorial Data Analysis.} 
New York: Springer.

Chen, C. H. (2002):  Generalized Association Plots: Information
Visualization via Iteratively Generated Correlation Matrices.  
\emph{Statistica Sinica,} \bold{12}(1), 7--29.

Gruvaeus, G. and Wainer, H. (1972): Two Additions to Hierarchical Cluster
Analysis,
\emph{British Journal of Mathematical and Statistical Psychology,}
\bold{25}, 200--206.

Hurley, Catherine B. (2004): Clustering Visualizations of Multidimensional
Data.
\emph{Journal of Computational and Graphical Statistics,}
\bold{13}(4), 788--806.

Sharlee Climer, Weixiong Zhang (2006): Rearrangement Clustering: Pitfalls,
Remedies, and Applications, 
\emph{Journal of Machine Learning Research,} \bold{7}(Jun), 
919--943.
}
\seealso{
\code{\link[TSP]{solve_TSP}} in \pkg{TSP},
\code{\link{hclust}} in \pkg{stats},
\code{\link{criterion}},
\code{\link{seriate.matrix}}.}
%\author{Michael Hahsler}
\examples{
data("iris")
x <- as.matrix(iris[-5])
x <- x[sample(1:nrow(x)),]
d <- dist(x)

## default seriation
order <- seriate(d)
order

## plot
def.par <- par(no.readonly = TRUE)
layout(cbind(1,2), respect = TRUE)

pimage(d, main = "Random")
pimage(d, order, main = "Reordered")

par(def.par)

## compare quality
rbind(
    random = criterion(d),
    reordered = criterion(d, order)
)

}
\keyword{optimize}
\keyword{cluster}
