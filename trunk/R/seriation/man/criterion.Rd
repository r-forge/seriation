\name{criterion}
\alias{criterion}
\alias{criterion.dist}
\alias{criterion.matrix}
\title{Criterion for the quality of a permutation of a dissimilarity 
or general matrix}
\description{
  Compute different criteria to judge the quality of a permuation
  of a dissimilarity or general matrix. 
}
\usage{
criterion(x, order, method = NULL, \ldots)
\method{criterion}{dist}(x, order, method = NULL, \ldots)
\method{criterion}{matrix}(x, order, method = NULL, \ldots)
}
\arguments{
  \item{x}{an object of class \code{dist} or, for certain methods, a 
      \code{matrix} (currently only for \code{bond\_energy}).}
  \item{order}{
      an optional permutation vector for rows and columns.
      For matrices with different row and column orderings 
      \code{order} can contain a \code{list} with components \code{row} and
      \code{col} with the permutation vectors.
      
      If no order is given, the identity order is used.
    }
  \item{\ldots}{further arguments (currently unused).}
  \item{method}{character string with the name of the criterion
      (default: \code{path\_length} for \code{dist} and
      \code{bond\_energy} for \code{matrix}.}
}
\details{
Ordering a matrix such that large values are closer together
may help to uncover structure (blocks) if it
is plotted as an image.
Currently, the following criteria to judge the quality of a
certain ordering of a matrix are implemented:

\describe{
\item{bond\_energy}{(McCormick 1972). 

    The bond energy for matrix \eqn{A = (a_{ij})}, \eqn{i=1\ldots M} 
    and  \eqn{j=1\ldots N}, is defined as 
   
    
    \deqn{\sum_{i=1}^{i=M} \sum_{j=1}^{j=N} a_{i,j}(a_{i,j-1}+a_{i,j+1}+a_{i-1,j}+a_{i+1,j})}

    with, by convention

    \deqn{a_{0,j}=a_{M+1,j}=a_{i,0}=a_{i,N+1}=0.}
    
    A higher bond energy indicates a better ordering.
    
    Maximizing the bond energy is the objective of the bond energy algorithm 
    (BEA).}
}

For the special case for a symmetric dissimilarity matrix 
\eqn{D} with elements \eqn{d(i,j)} where \eqn{i, j = 1 \ldots p}, 
the aim is generally to place low distance values close to the diagonal.
The following criteria to judge the quality of a
certain ordering of a dissimilarity matrix 
are currently implemented:
\describe{
  \item{path\_length}{Hamiltonian path length (Caraux and Pinloche 2005).
    
      The order of a dissimilarity matrix corresponds to a path through a 
    graph where each node is
    visited only once, i.e. a Hamilton path. The length of a path is defined 
    as the sum of the edge weights, i.e. disimilarities.
    
    The length of the Hamiltonian path is equal to the 
    value of the minimal span loss function (as used by Chen 2002).
    Both notions are related to the \emph{traveling salesman problem.}}
  
    If \code{order} is not unique \code{NA} is returned.
    If there are non-finite distance values \code{NA} is returned.
\item{least\_square}{Least square criterion (Caraux and Pinloche 2005). 
    
    The sum of squares of deviations between the
    dissimilarities and rank differences (distance in the matrix) between two
    elements: 
    
    \deqn{\sum_i \sum_j (d(i,j) - |i-j|)^2,}
    
    where \eqn{d(i,j)} 
    is an element of the dissimilarity matrix \eqn{D} and
    \eqn{|i-j|} is the rank difference.
   
    
    Note that if Euclidean distance is used to calculate \eqn{D} from
    a data matrix \eqn{X}, the order of the elements in \eqn{X} by projecting 
    them on the first principal component of \eqn{X} minimizes this criterion.
    The least square criterion is also related to unidimensional scaling.
    }
  \item{inertia}{Inertia criterion (Caraux and Pinloche 2005). 
    Measures the moment of the inertia of dissimilarity values 
    around the diagonal as
    
    \deqn{\sum_i \sum_j d(i,j)|i-j|^2.}
    
    \eqn{|i-j|} is used as a measure for the distance to the diagonal and
    \eqn{d(i,j)} gives the weight. This criterion gives higher weight
    to values farther away from the diagonal. It increases with quality.}
  
  \item{ar\_i}{Number of anti-Robinson events (Chen 2002).
    
      A Robinson matrix (Robinson 1951) has its columns arranged such that the
    values of the cells always decrease when moving from the diagonal. In
    practice matrices rarely are Robinson matrices. This and the following two
    criteria measure the differences to a Robinson matrix.  The number of
    anti-Robinsin events is calcualted by

    \deqn{\sum_{i=1}^p (\sum_{j<k<i} I(d(i,j)<d(i,k)) w(i,j,k)%
    + \sum_{i<j<k} I(d(i,j) > d(i,k)) w(i,j,k)),}
    
    where \eqn{I} is an indicator function and \eqn{w(i,j,k)} is a weight.
    For the raw number of events, the weight is \eqn{w(i,j,k) = 1}.
    }
  \item{ar\_s}{Sum of absolute anti-Robinson deviations (Chen 2002).
    
      The deviations are used as the weight, i.e. 
    \eqn{w(i,j,k) = |d(i,j) - d(i,k)|}.}
  \item{ar\_w}{Weighted sum of absolute anti-Robinson deviations (Chen 2002).
    
      Weights the deviations by the difference of column indices, i.e.
    \eqn{w(i,j,k) = |j-k| |d(i,j) - d(i,k)|}.}
}}
\value{
  A single real value.
}
\references{
Caraux, G., and Pinloche, S. (2005). Permutmatrix: A Graphical Environment
to Arrange Gene Expression Profiles in Optimal Linear Order, Bioinformatics,
21, 1280-1281.

Chun-Houh Chen (2002). Generalized association plots:
Information visualization via iteratively generated correlation matrices,
Statistica Sinica 12(2002), 7-29.

W.S. Robinson (1951). A method for chronologically ordering archaeological 
deposits, American Antiquity, 16, 293-301.

R. Sedgewick (2002). Algorithms in C. Part 5. Graph Algorithms.  3rd Edition,
Addison-Wesley.

W.T. McCormick, P.J. Schweitzer and T.W. White (1972). 
Problem decomposition and data reorganization by a clustering technique, 
Operations Research, 
Vol. 20, pp. 993-1009.

}
\author{Christian Buchta and Michael Hahsler}
\examples{
m <- matrix(runif(10),ncol=2)
d <- dist(m)

criterion(d, method = "least_square")

o <- reorder(m, method = "fpc")
o

criterion(d, o, method = "least_square")
}
\keyword{cluster}
