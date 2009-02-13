\name{seriate}
\alias{seriate}
\alias{seriate.matrix}
\alias{seriate.dist}
\alias{seriate.array}
\title{Seriate objects in dissimilarity matrices, matrices or arrays}
\description{
Tries to find an linear order for objects using data in form of a dissimilarity 
matrix (two-way one mode data), a data matrix (two-way two-mode data) or a 
data array (k-way k-mode data).
}
\usage{
\method{seriate}{dist}(x, method = NULL, control = NULL, \ldots)
\method{seriate}{matrix}(x, method = NULL, control = NULL, 
    margin = c(1,2), \ldots)
\method{seriate}{array}(x, method = NULL, control = NULL, 
    margin = seq(length(dim(x))), \ldots)
}
\arguments{
  \item{x}{the data.}
  \item{method}{ a character string with the name of the seriation method
    (default: varies by data type).}
  \item{control}{ a list of control options passed on to the seriation
      algorithm.}
  \item{margin}{ a vector giving the margins to be seriated. For matrix,
        \code{1} indicates rows, \code{2} indicates columns, \code{c(1,2)} 
        indicates rows and columns. For array, margin gets a vector with 
        the dimensions to seriate.}
  \item{\ldots}{ further arguments (unused).}
}
\details{

Two-way two-mode data has to be provided as a dist object (not as a symmetric
matrix). Similarities have to be transformed in a suitable way into
dissimilarities. Currently the following methods are implemented for dist:
   
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

Two-way two mode data are general positive matrices.
Currently the following methods are implemented for matrix:
\describe{
\item{\code{"BEA"}}{Bond Energy Algorithm (BEA; McCormick 1972).
     
     The algorithm tries to maximize the measure of effectiveness
     (see \code{criterion}) of a non-negative matrix. Due to the definition
     of this measure, the tasks of ordering rows and columns is separable
     and can  be solved independently.

     A row is arbitrarily placed; then rows are positioned one by one. When
     this is completed, the columns are treated similarly. The overall
     procedure amounts to two approximate traveling salesperson problems (TSP),
     one on the rows and one on the columns. The so-called `best insertion
     strategy' is used: rows (or columns) are inserted into the current
     permuted list of rows (or columns). Several consecutive runs of the
     algorithm might improve the energy.  

     Note that Arabie and Hubert (1990) question its use with non-binary data
     if the objective is to find a seriation or one-dimensional orderings of
     rows and columns. 

     The BEA code used in this package was implemented by Fionn Murtagh.
     
     In \code{control} as element \code{"rep"} the number of runs can be 
     specified. The results of the best run will be returned.
     }

\item{\code{"BEA_TSP"}}{Use a TSP to optimize the measure of effectiveness 
    (Lenstra 1974). 
      
    Use a TSP solver to optimize ME. 
     
    In \code{control} as element \code{"method"} a TSP solver method can be
    specified (see package \pkg{TSP}).
    }

\item{\code{"PCA"}}{ Principal component analysis.
      
      Uses the projection of the data on its first principal component to
      determine the order. 
      
      Note that for a distance matrix calculated from \code{x} with Euclidean
      distance, this methods minimizes the least square criterion.
      }  
}

For array no built-in methods are currently available.

}
\value{
Returns an object of class \code{ser_permutation}.
}
\references{ 
P. Arabie and L.J. Hubert (1990): The bond energy algorithm revisited, 
\emph{IEEE Transactions on Systems, Man, and Cybernetics,}
\bold{20}(1), 268--274.

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

Sharlee Climer, Weixiong Zhang (2006): Rearrangement Clustering: Pitfalls,
Remedies, and Applications,
\emph{Journal of Machine Learning Research,} \bold{7}(Jun),
919--943.

Gruvaeus, G. and Wainer, H. (1972): Two Additions to Hierarchical Cluster
Analysis,
\emph{British Journal of Mathematical and Statistical Psychology,}
\bold{25}, 200--206.

Hurley, Catherine B. (2004): Clustering Visualizations of Multidimensional
Data.
\emph{Journal of Computational and Graphical Statistics,}
\bold{13}(4), 788--806.

J.K. Lenstra (1974): Clustering a Data Array and the Traveling-Salesman 
Problem, \emph{Operations Research,} \bold{22}(2) 413--414. 

W.T. McCormick, P.J. Schweitzer and T.W. White (1972): Problem decomposition
and data reorganization by a clustering technique, 
\emph{Operations Research,} 
\bold{20}(5), 993--1009.

}
\seealso{
\code{\link{criterion}},
\code{\link[TSP]{solve_TSP}} in \pkg{TSP},
\code{\link{hclust}} in \pkg{stats}
}
\examples{
##seriate dist
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


## seriate matrix
data("iris")
x <- as.matrix(iris[-5])

## to make the variables comparable, we scale the data
x <- scale(x, center = FALSE)

## try some methods
def.par <- par(no.readonly = TRUE)
layout(matrix(1:4, ncol = 2, byrow = TRUE), respect=TRUE)

pimage(x, main = "original data")
criterion(x)

order <- seriate(x, method = "BEA_TSP")
pimage(x, order, main = "TSP to optimize ME")
criterion(x, order)

order <- seriate(x, method="PCA")
pimage(x, order, main = "first principal component")
criterion(x, order)

## 2 TSPs
order <- c(
    seriate(dist(x), method = "TSP"),
    seriate(dist(t(x)), method = "TSP")
)
pimage(x, order, main = "2 TSPs")
criterion(x, order)

par(def.par)
}
\keyword{optimize}
\keyword{cluster}
