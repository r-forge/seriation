\name{criterion}
\alias{criterion}
\alias{criterion.dist}
\alias{criterion.matrix}
\title{Criterion for the quality of a permutation of a dissimilarity 
or general matrix}
\description{
  Compute different criteria to judge the quality of a permutation
  of a dissimilarity or general matrix. 
}
\usage{
criterion(x, order = NULL, method = NULL)

%\method{criterion}{dist}(x, order, method = NULL)
%\method{criterion}{matrix}(x, order, method = NULL)
}
\arguments{
  \item{x}{an object of class \code{dist} or a matrix.}
  \item{order}{
      an object of class \code{Order} suitable to rearrange \code{x}.
      If \code{NULL}, the identity permutation is used.
    }
  \item{method}{a vector of character strings with names of the criteria
      (default: \code{"path\_length"} for \code{dist} and
      \code{"bond\_energy"} for matrix).  The dummy method \code{"all"}
      can be used to calculate all available criteria.}
}
\details{
Permutations of rows and columns of a data  matrix such that large values are
closer together may help to uncover structure (blocks).  Currently, the
following criteria to judge the quality of a certain permutations of a matrix
are implemented:

\describe{
\item{\code{"bond\_energy"}, \code{"me"}}{Bond Energy and Measure of
    Effectiveness (McCormick 1972). 

    The bond energy for matrix \eqn{A = (a_{ij})}, \eqn{i=1\ldots M} 
    and  \eqn{j=1\ldots N}, is defined as 
   
    
    \deqn{\sum_{i=1}^{M} \sum_{j=1}^{N} a_{i,j}(a_{i,j-1}+a_{i,j+1}+a_{i-1,j}+a_{i+1,j})}

    with, by convention

    \deqn{a_{0,j}=a_{M+1,j}=a_{i,0}=a_{i,N+1}=0.}
    
    A higher bond energy indicates a better arrangement.
    Maximizing the bond energy is the objective of the bond energy algorithm 
    (BEA).
    
    The measure of effectiveness (ME) is defined as \eqn{1/2 * bond\ energy}.
}

\item{\code{"moore_stress"}, \code{"neumann_stress"}}{ Stress (Niermann 2005).

Stress measures the conciseness of the presentation of a matrix/table and can
be seen as a purity function which compares the values in a matrix/table with
its neighbors. The stress measure used here is computed as the sum of squared
distances of each matrix entry from its adjacent entries. The following types
of neighborhoods are available:

  \describe{
    \item{\code{moore}:}{comprises the eight adjacent entries.}
    \item{\code{neumann}:}{comprises the four adjacent entries.}
  }
  }
}

For a symmetric dissimilarity matrix 
\eqn{D} with elements \eqn{d(i,j)} where \eqn{i, j = 1 \ldots p}, 
the aim is generally to place low distance values close to the diagonal.
The following criteria to judge the quality of a
certain permutation of the objects in a dissimilarity matrix 
are currently implemented:
\describe{
\item{\code{"path\_length"}}{Hamiltonian path length (Caraux and Pinloche 2005).
    
    The order of the objects in a dissimilarity matrix corresponds to a path
    through a graph where each node represents an object and is visited exactly
    once, i.e., a Hamilton path. The length of the path is defined as the sum
    of the edge weights, i.e., dissimilarities.
    
    The length of the Hamiltonian path is equal to the 
    value of the minimal span loss function (as used by Chen 2002).
    Both notions are related to the \emph{traveling salesperson problem.}
  
    If \code{order} is not unique or
    there are non-finite distance values \code{NA} is returned.}

\item{\code{"least\_squares"}}{Least squares criterion (Caraux and Pinloche 2005). 
    
    The sum of squares of deviations between the
    dissimilarities and rank differences (in the matrix) between two
    elements: 
    \deqn{\sum_i \sum_j (d(i,j) - |i-j|)^2,}
    where \eqn{d(i,j)} is an element of the dissimilarity matrix \eqn{D} and
    \eqn{|i-j|} is the rank difference between the objects.
   
    Note that if Euclidean distance is used to calculate \eqn{D} from
    a data matrix \eqn{X}, the order of the elements in \eqn{X} by projecting 
    them on the first principal component of \eqn{X} minimizes this criterion.
    The least squares criterion is related to 
    \emph{unidimensional scaling.}
    }

\item{\code{"inertia"}}{Inertia criterion (Caraux and Pinloche 2005). 
    
    Measures the moment of the inertia of dissimilarity values 
    around the diagonal as
    
    \deqn{\sum_i \sum_j d(i,j)|i-j|^2.}
    
    \eqn{|i-j|} is used as a measure for the distance to the diagonal and
    \eqn{d(i,j)} gives the weight. This criterion gives higher weight
    to values farther away from the diagonal. It increases with quality.}
  
\item{\code{"ar\_i", "ar\_s", "ar\_w"}}{Anti-Robinson events (Chen 2002).
    
    A Robinson matrix (Robinson 1951) has its columns arranged such that the
    values of the cells always decrease when moving away from the diagonal. In
    practice matrices rarely are Robinson matrices. The three criteria measure
    the differences of a matrix to a Robinson matrix.  All three criteria
    use the anti-Robinson events, but weight them differently:

    \deqn{\sum_{i=1}^p (\sum_{j<k<i} I(d(i,j)<d(i,k)) w(i,j,k)%
    + \sum_{i<j<k} I(d(i,j) > d(i,k)) w(i,j,k)),}
    
    where \eqn{I} is an indicator function and \eqn{w(i,j,k)} is a weight.

    For the raw number of events (\code{"ar\_i"}), the weight is 
    \deqn{w(i,j,k) = 1.}

    For the sum of absolute anti-Robinson deviations (\code{"ar\_s"}), the
    deviations are used as the weight, i.e.,  
    \deqn{w(i,j,k) = |d(i,j) - d(i,k)|.}

    For the weighted sum of absolute anti-Robinson deviations
    (\code{"ar\_w"}), the deviations are
    weighted by the difference of column indices, i.e., 
    \deqn{w(i,j,k) = |j-k||d(i,j) - d(i,k)|.}
}
}}
\value{
  A named vector of real values.
}
\references{
Caraux, G., and Pinloche, S. (2005): Permutmatrix: A Graphical Environment
to Arrange Gene Expression Profiles in Optimal Linear Order, 
\emph{Bioinformatics,}
\bold{21}(7), 1280--1281.

Chun-Houh Chen (2002): Generalized association plots:
Information visualization via iteratively generated correlation matrices,
\emph{Statistica Sinica,} \bold{12}(1), 7--29.

Niermann Stefan (2005): Optimizing the Ordering of Tables 
With Evolutionary Computation, \emph{The American Statistician,}
\bold{59}(1), 41--46.

W.S. Robinson (1951): A method for chronologically ordering archaeological 
deposits, 
\emph{American Antiquity,} \bold{16}, 293--301.

W.T. McCormick, P.J. Schweitzer and T.W. White (1972): 
Problem decomposition and data reorganization by a clustering technique, 
\emph{Operations Research,}
\bold{20}(5), 993-1009.

}
%\author{Christian Buchta and Michael Hahsler}
\examples{
## create random data and calculate distances
m <- matrix(runif(10),ncol=2)
d <- dist(m)

## get an order for rows (optimal for the least squares criterion)
o <- Order(reorder(m, method = "fpc")$row)
o

## compare the values for all available criteria
rbind(
    unordered = criterion(d, method = "all"),
    ordered = criterion(d, o, method = "all")
)
}
\keyword{cluster}
