\name{criterion}
\alias{criterion}
\title{Criterion for the quality of a dissimilarity matrix order}
\description{
  Compute different criteria to judge the quality of a certain order
  of a dissimilarity matrix.
}
\usage{
criterion(dist, order, method = NULL)
}
\arguments{
  \item{dist}{an object of class \code{dist}.}
  \item{order}{an optional permutation of the row (column) indexes.
  If \code{order} is missing the identity order is used.
    }
  \item{method}{character string with the name of the criterion 
    (default: path-length).}
}
\details{
Ordering a distance matrix 
\eqn{D} with elements \eqn{d(i,j)} where \eqn{i, j = 1 \ldots p}, 
such that low distance values are placed 
close to the diagonal may improve its presentation if it
is plotted as an image. 

The following criteria are implemented:
\describe{
  \item{path-length}{Hamiltonian path length (Caraux and Pinloche 2005).
    The order of a dissimilarity matrix corresponds to a path through a 
    graph where each node is
    visited only once, i.e. a Hamilton path. The length of a path is defined 
    as the sum of the edge weights, i.e. disimilarities.
    
    The length of the Hamiltonian path is equal to the 
    value of the minimal span loss function (as used by Chen 2002).
    Both notions are related to the \emph{traveling salesman problem.}}
  \item{least-square}{Least square criterion (Caraux and Pinloche 2005). 
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
    The least square criterion is also related unidimensional scaling.
    }
  \item{inertia}{Inertia criterion (Caraux and Pinloche 2005). 
    Measures the moment of the inertia of dissimilarity values 
    around the diagonal as
    
    \deqn{\sum_i \sum_j d(i,j)|i-j|^2.}
    
    \eqn{|i-j|} is used as a measure for the distance to the diagonal and
    \eqn{d(i,j)} gives the weight. This criterion gives higher weight
    to values farther away from the diagonal. It increases with quality.}
  
  \item{ar-i}{Number of anti-Robinson events (Chen 2002).
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
  \item{ar-s}{Sum of absolute anti-Robinson deviations (Chen 2002).
    The deviations are used as the weight, i.e. 
    \eqn{w(i,j,k) = |d(i,j) - d(i,k)|}.}
  \item{ar-w}{Weighted sum of absolute anti-Robinson deviations (Chen 2002).
    Weights the deviations by the difference of column indices, i.e.
    \eqn{w(i,j,k) = |j-k| |d(i,j) - d(i,k)|}.}
}
}
\value{
  A single real value.
  If \code{order} is not unique \code{NA} is returned.
  If there are non-finite distance values \code{NA} is returned.
}
\references{
Caraux, G., and Pinloche, S. (2005), Permutmatrix: A Graphical Environment
to Arrange Gene Expression Profiles in Optimal Linear Order, Bioinformatics,
21, 1280-1281.

Chun-Houh Chen (2002), Generalized association plots:
Information visualization via iteratively generated correlation matrices,
Statistica Sinica 12(2002), 7-29.

W.S. Robinson (1951), A method for chronologically ordering archaeological 
deposits, American Antiquity, 16, 293-301.

R. Sedgewick (2002), Algorithms in C. Part 5. Graph Algorithms.  3rd Edition,
Addison-Wesley.

}
\author{Christian Buchta and Michael Hahsler}
\examples{
m <- matrix(runif(10),ncol=2)
d <- dist(m)

criterion(d, method = "least-square")

o <- reorder(d, method = "first-pc")
o

criterion(d, o, method = "least-square")
}
\keyword{cluster}
