\name{reorder.matrix}
\alias{reorder.matrix}
\title{Reorder a matrix}
\description{
Tries to find an order for the objects (rows or columns) by moving large values
closer together. Using a image plot of the reordered matrix can show a
structure in the data which was not visible in the original matrix.
}
\usage{
\method{reorder}{matrix}(x, method = NULL, options = NULL, \ldots)
}
\arguments{
  \item{x}{ a matrix.}
  \item{method}{ a character string with the name of the seriation method
    (default: \code{"murtagh"}).}
  \item{options}{ a list of options passed on to the reorder algorithms.}
  \item{\ldots}{ further arguments (unused).}
    }
\details{
    Currently the following methods are implemented:
\describe{
    \item{\code{"bea"}}{Bond Energy Algorithm (BEA; McCormick 1972).
     
The algorithm tries to maximize the summed bond energy (see bond energy
     in \code{criterion}) of a nonnegative matrix. Due to the definition
     of this measure, the tasks of ordering rows and columns is separable
     and can  be solved independently.
     
    A row is arbitrarily placed; then rows are positioned one by one. When this
    is completed, the columns are treated similarly. The overall procedure
    amounts to two approximate traveling salesman problems (TSP), one on the
    rows and one on the columns. The so-called `best insertion strategy' is
    used: rows (or columns) are inserted into the current permuted list of rows
    (or columns). Several consecutive runs of the algorithm might improve the
    energy.  
      
Note that Arabie and Hubert (1990)
recommend that it be used with ratio scale data and they question its use 
with non-binary data if the objective is to find a seriation or 
one-dimensional ordering of rows and columns. 
      
The BEA codes used in this package was implemented by Fionn Murtagh.
}

\item{\code{"murtagh"}}{Algorithm B (Murtagh 1985). 
      
    A simple heuristic which also tries to maximize the summed bond energy (see
    BEA) of a nonnegative matrix. It uses the cross-product of the matrix (an
    unnormalized form of the Pearson correlation) and a greedy hierarchical
    clustering scheme. In each step a single cluster is constructed by merging
    the leaf closest to one of the two endpoints of the cluster. The algorithm
    starts with a random leaf and uses tie-breaking.
      
    Note that the ordering can change from run to run since ties are broken
    randomly.}

\item{\code{"fpc"}}{First principal component. 
      
        Uses the projection of the data on its
      first principal component to determine the order. 
      
      Note that for a distance matrix calculated from \code{x} with 
      Euclidean distance, this methods minimizes the least square criterion.}  
}}
\value{
Returns a named list with two an integer vector containing the ordering of the rows (\code{row}) and columns (\code{col}). 
}
\references{ 
P. Arabie and L.J. Hubert (1990): The bond energy algorithm revisited, 
\emph{IEEE Transactions on Systems, Man, and Cybernetics,}
\bold{20}(1), pp. 268--274.

W.T. McCormick, P.J. Schweitzer and T.W. White (1972): Problem decomposition
and data reorganization by a clustering technique, 
\emph{Operations Research,} 
\bold{20}(5), pp. 993--1009.

F. Murtagh (1985): Multidimensional Cluster Algorithms. 
\emph{Lectures in Computational Statistics}, Chapter 1, 
Physica Verlag, pp. 9--31.
}
\seealso{
\code{\link{criterion}}
}
%\author{Michael Hahsler}
\examples{
data("iris")
x <- as.matrix(iris[,1:4])

## try some methods
def.par <- par(no.readonly = TRUE)
layout(rbind(1:2, 3:4), respect=TRUE)

pimage(x, main = "original data")
criterion(x)

order <- reorder(x)
pimage(x[order$row, order$col], main = "Murtagh")
criterion(x, order)

order <- reorder(x, method="fpc")
pimage(x[order$row, order$col], main = "first principal component")
criterion(x, order)

## 2 TSPs
order <- list(row = reorder(dist(x), method = "tsp"),
    col = reorder(dist(t(x)), method = "tsp"))
pimage(x[order$row, order$col], main = "2 TSPs")
criterion(x, order)

par(def.par)
}
\keyword{optimize}
\keyword{cluster}
