\name{reorder.matrix}
\alias{reorder.matrix}
\alias{reorder.dist}
\title{Reorder a matrix or dissimilarity object}
\description{
Seriation tries to move large values towards the main diagonal by reordering
columns and rows at the same time. Using a image plot of the reordered matrix
can show a structure in the data which was not visible in the original matrix.
}
\usage{
\method{reorder}{dist}(x, method = NULL, \ldots)
\method{reorder}{matrix}(x, method = NULL, row = TRUE, \ldots)
}
\arguments{
  \item{x}{ matrix or object of class \code{dist} to be seriated.}
  \item{method}{ a character string with the name of the seriation method
    (default: murtagh).}
  \item{row}{ if \code{row=TRUE} the order for rows is calculated, 
    otherwise for columns. }
  \item{\ldots}{ further arguments (currently unused).}
    }
\details{
    Currently the following methods are implemented:
\describe{
    \item{bea}{Bond Endergy Algorithm (BEA; McCormick 1972).
     The algorithm tries to maximize the summed bond energy (see bond energy
     in \code{criterion}) of a nonnegative matrix. 
     
    A row is arbitrarily placed; then rows are positioned one by one. When
this is completed, the columns are treated similarly. The overall procedure
amounts to two approximate traveling salesman problems (TSP), - one on the rows and
one on the columns. The so-called `best insertion strategy' is used: Rows (or
columns) are inserted into the current permuted list of rows (or columns).       
Note that
several runs of the algorithm on the previously reordered matrix might improve
the energy.  

    For symmetric matrices (one-mode data; e.g. dissimilarity matrices), only
one TSP has to be solved. The two TSPs (for rows and columns) for general
matrices (two-mode data) are separable and here only one problem is solved
(depending on the value of \code{row}). Therefore, to apply BEA for two-mode
data, \code{reorder} has to be used twice. 
      
Note that Arabie and Hubert (1990)
recommend that it be used with ratio scale data and they question its use 
with non-binary data if the objective is to find a seriation or 
one-dimensional ordering of rows and columns. 
      }
    \item{murtagh}{Algorithm B (Murtagh 1985). 
      A simple heuristic which also tries to maximize the summed bond energy
      (see BEA) of a nonnegative matrix.
      It uses the cross-product of the matrix (an unnormalized form
      of the Pearson correlation) and \code{hclust_greedy} to obtain the
      ordering. For \code{hclust_greedy} in each step a single cluster is
      constructed by merging the leaf closest to one of the two endpoints of
      the cluster. The algorithm starts with a random leaf and uses
      tie-breaking.
      
      Note that the ordering can change from run to run since ties are broken
      randomly.}
    \item{fpc}{First principal component. 
      Uses the projection of the data on its
      first principal component to determine the order. 
      
      Note that for a distance matrix calculated from \code{x} with 
      Euclidean distance, this methods minimizes the least square criterion.}  
    \item{chen}{Rank-two ellipse seriation (Chen 2002).
      This method starts with generating a sequence of correlation matrices
      \eqn{R^1, R^2, \ldots}. \eqn{R^1} is the correlation matrix
      of the original distance matrix \eqn{D} (supplied to the function as 
      \code{x}), 
      and \eqn{R^{n+1} = \phi R^n} where \eqn{\phi} calculates the
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
  \item{nearest\_insertion, farthest\_insertion}{Nearest and farthest insertion
      algorithms (Johnson and Papadimitriou 1985).
      The two algorithms are variants of the minimum spanning tree algorithm.
      Since it is a heuristic for the traveling salesman problem
      we will refer to observations here as cities and to the
      ordering as a tour. The distances between cities are stored
      in a dissimilarity matrix \eqn{D} with elements \eqn{d(i,j)}.
      
      The nearest insertion algorithm starts with a partial tour consisting of 
      a single, arbitrarily chosen observation. As long as not
      all observations are in the tour, find the city \eqn{k} which is
      \emph{nearest} to a city on the tour. Next insert city \eqn{k} into the
      tour between two consecutive cities \eqn{i} and \eqn{j}, 
      such that \eqn{d(i,k) + d(k,j) - d(i,j)} is minimized.
      Repeat till all cities are on the tour.

      The farthest insertion algorithm used the \emph{farthest} instead
      of the \emph{nearest} city. The idea behind this choice is to link cities
      far away into the tour fist to establish an outline of the whole tour 
      early.

      Since a tour is a connected circle and we are looking for a
      linear order, we have to cut the circle between the two
      cities which are farthest apart.
      }
      }}
\value{
Returns an integer vector containing the ordering of the rows or columns. 
}
\references{ 
Chen, C. H. (2002).  Generalized Association Plots: Information
Visualization via Iteratively Generated Correlation Matrices.  Statistica
Sinica 12, 7-29.

F. Murtagh (1985). Multidimensional Cluster Algorithms. Lectures in
Computational Statistics, Physica Verlag, pp. 15.

W.T. McCormick, P.J. Schweitzer and T.W. White (1972). 
Problem decomposition and data reorganization by a clustering technique,
Operations Research, 
Vol. 20, pp. 993-1009.

P. Arabie and L.J. Huber (1990). 
The bond energy algorithm revisited,
IEEE Transactions on Systems, Man, and Cybernetics, 
vol. 20, pp. 268-274.

D. S. Johnson, C. H. Papadimitriou (1985). Performance guarantees for 
heuristics (chapter 5). In: E. L. Lawler, J. K. Lenstra, A.H.G. Rinnooy Kan, 
D. B. Shmoys (eds.) 
The traveling salesman problem - A guided
tour of combinatorial optimization, Wiley \& Sons.
}
\seealso{
\code{\link{hclust_greedy}},
\code{\link{criterion}}
}
\author{Michael Hahsler}
\examples{
library("vcd")
data(iris)
x <- as.matrix(iris[,1:4])
d <- dist(x)

# compare the different methods
def.par <- par(no.readonly = TRUE)
layout(matrix(c(1,2,3,4,5,6,7,8,9), 3, 3, byrow=TRUE), respect=FALSE)

pimage(d, col=diverge_hcl(64), main = "original")

nins <- reorder(d, method="nearest_insertion")
pimage(arrange(d, nins), col=diverge_hcl(64), main = "nearest insertion alg.")

fins <- reorder(d, method="farthest_insertion")
pimage(arrange(d, fins), col=diverge_hcl(64), main = "farthest insertion alg.")

bea <- reorder(max(d)-d, method = "bea")
pimage(arrange(d, bea), col=diverge_hcl(64), main = "BEA")

# murtagh and bea look for blocks with large values
murtagh <- reorder(max(d)-d, method = "murtagh")
pimage(arrange(d, murtagh), col=diverge_hcl(64), main = "Murtagh")

h <- hclust(d, method = "average")
pimage(arrange(d, h$order), col=diverge_hcl(64), 
	main = "hclust (avg.) linkage")

ho <- reorder(hclust(d, method = "average"), d, method = "optimal")
pimage(arrange(d, ho$order), col=diverge_hcl(64), 
	main = "hclust (avg.) linkage + optimal")

fpc <- reorder(x, method = "fpc")
pimage(arrange(d, fpc), col=diverge_hcl(64), 
	main = "first principal comp.")
	
chen <- reorder(d, method = "chen")
pimage(arrange(d, chen), col=diverge_hcl(64), main = "Chen")

par(def.par)
}
\keyword{optimize}
\keyword{cluster}
