\name{seriate.matrix}
\alias{seriate.matrix}
\title{Seriation of rows and columns of a matrix}
\description{
Tries to find an order for the rows and columns of a matrix by moving large
values closer together creating a block structure.
}
\usage{
\method{seriate}{matrix}(x, method = NULL, control = NULL, 
    margin = c(1,2), \ldots)
}
\arguments{
  \item{x}{ a matrix.}
  \item{method}{ a character string with the name of the seriation method
    (default: \code{"ME\_TSP"}).}
  \item{control}{ a list of control options passed on to the seriation
      algorithm.}
  \item{margin}{ a vector giving the margins to be seriated. \code{1} 
      indicates rows, \code{2} indicates columns, \code{c(1,2)} indicates 
      rows and columns.}
  \item{\ldots}{ further arguments (unused).}
}
\details{
    Currently the following methods are implemented:
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

\item{\code{"BEA_TSP"}}{Use a TSP to optimize the measure od effectiveness 
    (Lenstra 1974). 
      
    Use a TSP solver to optimize ME. 
     
    In \code{control} as element \code{"method"} a TSP solver method can be
    specified (see package \pkg{TSP}).
    }



%\item{\code{"Murtagh"}}{Algorithm B (Murtagh 1985). 
%      
%    A simple heuristic which also tries to maximize the summed bond energy (see
%    BEA) of a nonnegative matrix. It uses the cross-product of the matrix (an
%    unnormalized form of the Pearson correlation) and a greedy hierarchical
%    clustering scheme. In each step a single cluster is constructed by merging
%    the leaf closest to one of the two endpoints of the cluster. The algorithm
%    starts with a random leaf and uses tie-breaking.
%      
%    Note that the ordering can change from run to run since ties are broken
%    randomly.
%    }

\item{\code{"PCA"}}{ Principal component analysis.
      
      Uses the projection of the data on its first principal component to
      determine the order. 
      
      Note that for a distance matrix calculated from \code{x} with Euclidean
      distance, this methods minimizes the least square criterion.
      }  

    }
}
\value{
Returns an object of class \code{ser_permutation}.
}
\references{ 
P. Arabie and L.J. Hubert (1990): The bond energy algorithm revisited, 
\emph{IEEE Transactions on Systems, Man, and Cybernetics,}
\bold{20}(1), 268--274.

J.K. Lenstra (1974): Clustering a Data Array and the Traveling-Salesman 
Problem, \emph{Operations Research,} \bold{22}(2) 413--414. 

W.T. McCormick, P.J. Schweitzer and T.W. White (1972): Problem decomposition
and data reorganization by a clustering technique, 
\emph{Operations Research,} 
\bold{20}(5), 993--1009.

%F. Murtagh (1985): Multidimensional Cluster Algorithms. 
%\emph{Lectures in Computational Statistics}, Chapter 1, 
%Physica Verlag, 9--31.
}
\seealso{
\code{\link{criterion}},
\code{\link{seriate}}.
}
\examples{
data("iris")
x <- as.matrix(iris[-5])

## to make the variables comparable, we scale the data
x <- scale(x, center = FALSE)

## try some methods
def.par <- par(no.readonly = TRUE)
layout(matrix(1:4, ncol = 2, byrow = TRUE), respect=TRUE)

pimage(x, main = "original data")
criterion(x)

order <- seriate(x)
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
